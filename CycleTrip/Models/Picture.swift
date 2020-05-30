//
//  Picture.swift
//  Cycle Trip
//
//  Created by Гусейн Агаев on 27.05.2020.
//  Copyright © 2020 Прогеры. All rights reserved.
//

import Foundation
import Firebase

struct Picture {
    let height: Int
    let isSilhouette: Bool
    let url: String
    let width: Int
    
    init() {
        self.height = 50
        self.isSilhouette = true
        self.url = "https://scontent-frt3-1.xx.fbcdn.net/v/t1.30497-1/cp0/c15.0.50.50a/p50x50/84628273_176159830277856_972693363922829312_n.jpg?_nc_cat=1&_nc_sid=12b3be&_nc_ohc=WKiuEEx9BgoAX-rr15O&_nc_ht=scontent-frt3-1.xx&oh=008991d99aba7d24a958a96851619531&oe=5EE30438"
        self.width = 50
    }
    
    init(height: Int, isSilhouette: Bool, url: String, width: Int) {
        self.height = height
        self.isSilhouette = isSilhouette
        self.url = url
        self.width = width
    }

    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.childSnapshot(forPath: "picture")
                                    .childSnapshot(forPath: "data")
                                    .value as? [String: AnyObject]
        
        height = snapshotValue?["height"] as? Int ?? 50
        isSilhouette = snapshotValue?["is_silhouette"] as? Bool ?? true
        url = snapshotValue?["url"] as? String ?? "https://scontent-frt3-1.xx.fbcdn.net/v/t1.30497-1/cp0/c15.0.50.50a/p50x50/84628273_176159830277856_972693363922829312_n.jpg?_nc_cat=1&_nc_sid=12b3be&_nc_ohc=WKiuEEx9BgoAX-rr15O&_nc_ht=scontent-frt3-1.xx&oh=008991d99aba7d24a958a96851619531&oe=5EE30438"
        width = snapshotValue?["width"] as? Int ?? 50
    }
    
    func convertToDictionary() -> [AnyHashable : Any] {
        return ["height": height, "is_silhouette": isSilhouette, "url": url, "width": width]
    }
}
