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
    var startPoint: CLLocationCoordinate2D
//    var creator: String
    var ref: DatabaseReference = Database.database().reference().child("events")
    init(name: String, date: Date, startPoint: CLLocationCoordinate2D) {
        self.name = name
        self.date = date
        self.startPoint = startPoint
//        self.creator = creator
    }
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String : AnyObject]
        name = snapshotValue["name"] as! String
        date = formatter.date(from: (snapshotValue["date"] as! String))!
        startPoint = CLLocationCoordinate2D(latitude: Double(snapshotValue["altitude"] as! String)!, longitude: Double(snapshotValue["longitude"] as! String)!)
//        creator = snapshotValue["creator"] as! String
        ref = snapshot.ref
    }
    func upload() {
        let dictionary = ["name":name,"date":formatter.string(from: date),"altitude":String(startPoint.latitude),"longitude":String(startPoint.longitude)]
        ref.child(name).setValue(dictionary)
    }
    
}
