//
//  MapPresenter.swift
//  MapTesting
//
//  Created by Igor Lebedev on 13/05/2020.
//  Copyright © 2020 Прогеры. All rights reserved.
//

import Foundation
import Firebase
import MapboxCoreNavigation
import MapboxDirections
import Mapbox

final class MapPresenter {
    let mapVC: MapViewController!
    let mapView: MGLMapView!
    var routeCreationView: RouteCreationView!
    var currentRoute: Route!
    var coordinates = [CLLocationCoordinate2D]()
    var newEventAnnotations = [MGLPointAnnotation]()
    var userEvents: [String : Event]!
    var eventIDs: [String]!
    var userEventAnnotations = [MGLPointAnnotation]()
    
    let uid = Auth.auth().currentUser!.uid
    let ref = Database.database().reference()
	
    var routeLayer: MGLLineStyleLayer!
    
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "E, d MMM yyyy"
        return df
    }()
    
    private let timeFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        return df
    }()
	
	init(mapVC: MapViewController, mapView: MGLMapView) {
		self.mapVC = mapVC
		self.mapView = mapView
	}
    
    func calculateRoute(coordinates: [CLLocationCoordinate2D],
                        completion: @escaping (Route?, Error?) -> ()) {
        
        // Coordinate accuracy is the maximum distance away from the waypoint that the route may still be considered viable, measured in meters. Negative values indicate that a indefinite number of meters away from the route and still be considered viable.
        var points = [Waypoint]()
        points.append(Waypoint(coordinate: coordinates[0], coordinateAccuracy: -1, name: "Start"))
        for i in 1..<coordinates.count-1 {
            points.append(Waypoint(coordinate: coordinates[i], coordinateAccuracy: -1, name: "Waypoint"))
        }
        points.append(Waypoint(coordinate: coordinates[coordinates.count-1], coordinateAccuracy: -1, name: "Finish"))
        
        // Specify that the route is intended for automobiles avoiding traffic
        let options = NavigationRouteOptions(waypoints: points, profileIdentifier: .walking)
        
        // Generate the route object and draw it on the map
        Directions.shared.calculate(options) { [unowned self] (waypoints, routes, error) in
            guard error == nil else { self.routeCreationView.makeCreateButtonActive(false); print(error!.localizedDescription); return}
            self.currentRoute = routes?.first
            // Draw the route on the map after creating it
            self.drawRoute(route: self.currentRoute)
            self.routeCreationView.numberOfPoints.text = "\(coordinates.count)/25"
            let distance = self.currentRoute?.distance ?? 0
            self.routeCreationView.distance.text = "\(Int(distance)/100*100) м"
        }
    }

    func addPoint(coordinate: CLLocationCoordinate2D) {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = ""
        newEventAnnotations.append(annotation)
        mapVC.mapView.addAnnotation(annotation)
        self.coordinates.append(coordinate)
        
        // Calculate the route from the user's location to the set destination
        let flag1 = !(coordinates.count > 0)
        routeCreationView.isHidden = false
        if routeLayer != nil {
            routeLayer.isVisible = flag1 }
        let flag2 = coordinates.count > 1
        routeCreationView.makeCreateButtonActive(flag2)
        if flag2 {
            calculateRoute(coordinates: self.coordinates) { (route, error) in
                if error != nil {
                    print("Error calculating route")
                }
            }
            
        }
        else { routeCreationView.numberOfPoints.text = "1/25"
            routeCreationView.distance.text = "0 м"
        }

    }
    
    func removePoint() {
        mapView.removeAnnotation(newEventAnnotations.last!)
        newEventAnnotations.removeLast()
        self.coordinates.removeLast()
        
        // Calculate the route from the user's location to the set destination
        routeCreationView.isHidden = true
        if routeLayer != nil {
            routeLayer.isVisible = !(coordinates.count > 0) }
        let flag2 = coordinates.count > 1
        routeCreationView.makeCreateButtonActive(flag2)
        if flag2 {
            calculateRoute(coordinates: self.coordinates) { (route, error) in
                if error != nil {
                    print("Error calculating route")
                }
            }
            
        }
        else { routeCreationView.numberOfPoints.text = "1/25"
            routeCreationView.distance.text = "0 м"
        }
    }
    
    func drawRoute(route: Route) {
        // Convert the route’s coordinates into a polyline
        var routeCoordinates = route.coordinates!
        let polyline = MGLPolylineFeature(coordinates: &routeCoordinates, count: route.coordinateCount)
        
        // If there's already a route line on the map, reset its shape to the new route
        if let source = mapView.style?.source(withIdentifier: "route-source") as? MGLShapeSource {
            source.shape = polyline
            routeLayer.isVisible = true
        } else {
            let source = MGLShapeSource(identifier: "route-source", features: [polyline], options: nil)

            
            // Customize the route line color and width
            let lineStyle = MGLLineStyleLayer(identifier: "route-style", source: source)
            lineStyle.lineColor = NSExpression(forConstantValue: #colorLiteral(red: 0.9333333333, green: 0.6431372549, blue: 0.6549019608, alpha: 1))
            lineStyle.lineWidth = NSExpression(forConstantValue: 3)
            self.routeLayer = lineStyle
            routeLayer.isVisible = true
            
            // Add the source and style layer of the route line to the map
            mapView.style?.addSource(source)
            mapView.style?.addLayer(routeLayer)
        }
    }
    
    func createEvent(name: String, date: Date) {
        let event = Event(name: name, date: date, points: coordinates, routeJSON: currentRoute.json!)
        guard let key = ref.child("events").childByAutoId().key else { return }
        eventIDs.append(key)
        userEvents[key] = event
        ref.child("events/\(key)").setValue(event.convertToDictionary())
        ref.child("users/\(uid)/eventIDs").setValue(eventIDs)
        mapVC.showSuccessAlert()
        cleanCash()
        routeCreationView.isHidden = true
        createUserEventAnnotation(event: event)
        routeLayer.isVisible = false
    }
    

    func getUserData() {
        self.ref.child("users").child(uid).observeSingleEvent(of: .value, with: {[weak self] (snapshot) in
            let snapshotValue = snapshot.value as! [String : Any]
            self?.eventIDs = snapshotValue["eventIDs"] as? [String] ?? []
            self?.getUserEvents()
        })
        
    }
    func getUserEvents() {
        self.ref.child("events").observeSingleEvent(of: .value, with: {[weak self] (snapshot) in
            var events = [String : Event]()
            for id in (self?.eventIDs)! {
                
                let event = Event(snapshot: snapshot.childSnapshot(forPath: id))
                events[id] = event
            }
            self?.userEvents = events
            self?.createUserEventAnnotations()
        })
    }
    
    func showEventRoute(event: Event) {
        var points = [Waypoint]()
        points.append(Waypoint(coordinate: event.points[0], coordinateAccuracy: -1, name: "Start"))
        for i in 1..<event.points.count-1 {
            points.append(Waypoint(coordinate: event.points[i], coordinateAccuracy: -1, name: "Waypoint"))
        }
        points.append(Waypoint(coordinate: event.points[event.points.count-1], coordinateAccuracy: -1, name: "Finish"))
        let options = NavigationRouteOptions(waypoints: points, profileIdentifier: .walking)
        currentRoute = Route(json: event.routeJSON, waypoints: points, options: options)
        drawRoute(route: currentRoute)
    }
    
    func createUserEventAnnotation(event: Event) {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = event.startPoint
        annotation.title = event.name
        annotation.subtitle = "\(dateFormatter.string(from: event.date)) \(timeFormatter.string(from: event.date))"
        userEventAnnotations.append(annotation)
        mapView.addAnnotation(annotation)
    }
    
    func createUserEventAnnotations() {
        var annotations = [MGLPointAnnotation]()
        for (_,event) in userEvents {
            let annotation = MGLPointAnnotation()
            annotation.coordinate = event.startPoint
            annotation.title = event.name
            annotation.subtitle = "\(dateFormatter.string(from: event.date)) \(timeFormatter.string(from: event.date))"
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
    }
    
    func cleanCash() {
        currentRoute = nil
        coordinates = []
        mapView.removeAnnotations(newEventAnnotations)
        newEventAnnotations = []
    }
    
    func removeUserEvent(startPoint coordinates: CLLocationCoordinate2D) {
        for (id,event) in userEvents {
            if event.startPoint == coordinates {
                for i in 0...eventIDs.count {
                    if eventIDs[i] == id {
                        eventIDs.remove(at: i)
                        ref.child("users/\(uid)/eventIDs").setValue(eventIDs)
                        break }
                }
                userEvents.removeValue(forKey: id)
                routeLayer.isVisible = false
                break
            }
        }
    }
    
}
