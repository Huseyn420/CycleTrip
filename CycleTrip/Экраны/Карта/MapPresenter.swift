//
//  MapPresenter.swift
//  MapTesting
//
//  Created by Igor Lebedev on 13/05/2020.
//  Copyright © 2020 Прогеры. All rights reserved.
//

import Foundation
import MapboxCoreNavigation
import MapboxDirections
import Mapbox

final class MapPresenter {
    var mapView: MGLMapView!
    var mapVC: MapVC!
    var event: Event!
    var coordinates = [CLLocationCoordinate2D]()
    var directionsRoute: Route?
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
            self.directionsRoute = routes?.first
            // Draw the route on the map after creating it
            self.drawRoute(route: self.directionsRoute!)
        }

    }
    init(mapVC: MapVC) {
        self.mapVC = mapVC
        mapView = mapVC.mapView
    }

    func longPress(coordinate: CLLocationCoordinate2D) {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Start navigation"
        mapView.addAnnotation(annotation)
        self.coordinates.append(coordinate)
        
        // Calculate the route from the user's location to the set destination
        if coordinates.count > 1 {
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
        event = Event(name: name, date: date, startPoint: coordinates.first!)
        event.upload()

    }
    
    func annotationBuilder(title: String, imageName: String, coordinate: CLLocationCoordinate2D) {
//        // Create a basic point annotation and add it to the map
//        let annotation = MGLPointAnnotation()
//        var image = UIImage(named: imageName)!
//        image = image.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: image.size.height / 2, right: 0))
//        annotation.coordinate = coordinate
//        annotation.title = "Start navigation"
//        mapView.addAnnotation(annotation)
        
    }
}
