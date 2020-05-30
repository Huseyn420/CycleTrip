//
//  Event.swift
//  MapTesting
//
//  Created by Igor Lebedev on 22/05/2020.
//  Copyright © 2020 Прогеры. All rights reserved.
//

import Foundation
import Firebase
import Mapbox
struct Event {
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mmZ"
        return formatter
    }()
    var name: String
    var date: Date
    var points: [CLLocationCoordinate2D]
    var startPoint: CLLocationCoordinate2D {
        return points.first!
    }
    var routeJSON: [String : Any]
    let creator: String = Auth.auth().currentUser!.uid
    let ref: DatabaseReference = Database.database().reference().child("events")
    init(name: String, date: Date, points: [CLLocationCoordinate2D], routeJSON: [String : Any]) {
        self.name = name
        self.date = date
        self.points = points
        self.routeJSON = routeJSON
    }
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String : Any]
        self.name = snapshotValue["name"] as! String
        print(name)
        self.date = formatter.date(from: (snapshotValue["date"] as! String))!
        self.routeJSON = snapshotValue["routeJSON"] as! [String : Any]
        func arrToPoints(arr: NSArray) -> [CLLocationCoordinate2D] {
            var points = [CLLocationCoordinate2D]()
            var point = CLLocationCoordinate2D()
            for item in arr {
                if item is NSNull { continue }
                let pointDic = item as! [String : NSNumber]
                point = CLLocationCoordinate2D(latitude: CLLocationDegrees(pointDic["latitude"]!.floatValue), longitude: CLLocationDegrees(pointDic["longitude"]!.floatValue))
                points.append(point)
            }
            return points
        }
        self.points = arrToPoints(arr: snapshotValue["points"] as! NSArray)
    }
    func uploadEvent() {
        let pointDic = ["latitude": startPoint.latitude, "longitude":startPoint.longitude]
        let dictionary = ["name":name,"date":formatter.string(from: date), "startPoint": pointDic, "creator": creator, "points" : pointsToDic(points), "routeJSON" : routeJSON] as [String : Any]
        ref.childByAutoId().setValue(dictionary)
    }
    func pointsToDic(_ points:[CLLocationCoordinate2D]) -> [String : Any] {
        var pointsDic = [String:Any]()
        var pointDic = [String:Any]()
        for i in 1...points.count {
            pointDic = ["latitude" : points[i-1].latitude, "longitude" : points[i-1].longitude]
            pointsDic[String(i)] = pointDic
        }
        return pointsDic
    }

    
}
