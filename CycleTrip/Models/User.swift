//
//  Person.swift
//  Cycle Trip
//
//  Created by Гусейн Агаев on 24.04.2020.
//  Copyright © 2020 Прогеры. All rights reserved.
//

import Foundation
import Firebase

struct User {
    let email: String
    let lastName: String
    let firstName: String
    let picture: Picture
    var eventNames: [String]
    
    init(email: String, lastName: String, firstName: String, picture: Picture) {
        self.email = email
        self.lastName = lastName
        self.firstName = firstName
        self.picture = picture
        self.eventNames = []
    }

    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        email = snapshotValue["email"] as! String
        lastName = snapshotValue["last_name"] as! String
        firstName = snapshotValue["first_name"] as! String
        picture = Picture(snapshot: snapshot)
        eventNames = snapshotValue["eventNames"] as! [String]
    }
    
    func convertToDictionary() -> [AnyHashable : Any] {
        return ["email": email, "last_name": lastName, "first_name": firstName, "/picture/data/": picture.convertToDictionary(), "eventNames": eventNames]
    }
    
}
