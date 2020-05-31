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
    var mapView: MGLMapView!
    var mapVC: MapVC!
    
    var createdEvent: Event!
    var currentRoute: Route!
    var coordinates = [CLLocationCoordinate2D]()
    var newEventAnnotations = [MGLPointAnnotation]()
    
    var userEvents: [String : Event]! {
        didSet {
            createUserEventAnnotations()
        }
    }
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
    var eventIDs: [String]!
    var userEventAnnotations: [MGLPointAnnotation]!
    
    let uid = Auth.auth().currentUser!.uid
    let ref = Database.database().reference()
    
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
            guard error == nil else { print(error!.localizedDescription); return}
            self.currentRoute = routes?.first
            // Draw the route on the map after creating it
            self.drawRoute(route: self.currentRoute)
        }

    }
    init(mapVC: MapVC) {
        self.mapVC = mapVC
        mapView = mapVC.mapView
    }

    func longPress(coordinate: CLLocationCoordinate2D) {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(coordinate)"
        newEventAnnotations.append(annotation)
        mapView.addAnnotation(annotation)
        self.coordinates.append(coordinate)
        
        // Calculate the route from the user's location to the set destination
        if coordinates.count > 1 {
            mapVC.createButton.isHidden = false
            calculateRoute(coordinates: self.coordinates) { (route, error) in
                if error != nil {
                    print("Error calculating route") }
            }
        }
    }
    
    func drawRoute(route: Route) {
        guard route.coordinateCount > 1 else { return }
        // Convert the route’s coordinates into a polyline
        var routeCoordinates = route.coordinates!
        let polyline = MGLPolylineFeature(coordinates: &routeCoordinates, count: route.coordinateCount)
        
        // If there's already a route line on the map, reset its shape to the new route
        if let source = mapView.style?.source(withIdentifier: "route-source") as? MGLShapeSource {
            source.shape = polyline
        } else {
            let source = MGLShapeSource(identifier: "route-source", features: [polyline], options: nil)
            
            // Customize the route line color and width
            let lineStyle = MGLLineStyleLayer(identifier: "route-style", source: source)
            lineStyle.lineColor = NSExpression(forConstantValue: #colorLiteral(red: 0.9333333333, green: 0.6431372549, blue: 0.6549019608, alpha: 1))
            lineStyle.lineWidth = NSExpression(forConstantValue: 3)
            
            // Add the source and style layer of the route line to the map
            mapView.style?.addSource(source)
            mapView.style?.addLayer(lineStyle)
        }
    }
    
    
    
    func createEvent(name: String, date: Date) {
        createdEvent = Event(name: name, date: date, points: coordinates, routeJSON: currentRoute.json!)
        guard let key = ref.child("events").childByAutoId().key else { return }
        eventIDs.append(key)
        userEvents[key] = createdEvent
        ref.child("events/\(key)").setValue(createdEvent.convertToDictionary())
        ref.child("users/\(uid)/eventIDs").setValue(eventIDs)

        mapVC.createButton.isHidden = true
        mapVC.showSuccessAlert()
        cleanCash()
    }
    

    func getUserData() {
        self.ref.child("users").child(uid).observe(.value, with: {[weak self] (snapshot) in
            let snapshotValue = snapshot.value as! [String : Any]
            self?.eventIDs = snapshotValue["eventIDs"] as? [String] ?? []
            self?.getUserEvents()
        })
    }
    func getUserEvents() {
        self.ref.child("events").observe(.value, with: {[weak self] (snapshot) in
            var events = [String : Event]()
            for id in (self?.eventIDs)! {
                let event = Event(snapshot: snapshot.childSnapshot(forPath: id))
                events[id] = event
            }
            self?.userEvents = events
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
        createdEvent = nil
        currentRoute = nil
        coordinates = []
        mapView.removeAnnotations(newEventAnnotations)
        newEventAnnotations = []
    }
    func removeUserEvent(startPoint coordinates: CLLocationCoordinate2D) {
        for (id,event) in userEvents {
            if event.startPoint == coordinates {
                userEvents.removeValue(forKey: id)
                ref.child("events/\(id)").setValue(nil)
                for i in 0...eventIDs.count {
                    if eventIDs[i] == id {
                        eventIDs.remove(at: i)
                        ref.child("users/\(uid)/eventIDs").setValue(eventIDs)
                        break }
                }
                break
            }
        }
    }
    
}
