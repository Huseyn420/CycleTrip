//
//  TabBar.swift
//  Cycle Trip
//
//  Created by Igor Lebedev on 21/04/2020.
//  Copyright © 2020 Прогеры. All rights reserved.
//

import UIKit
import Firebase
class TabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let eventsVC = EventsViewController()
        let mapVC = MapViewController()
        let profileVC = ProfileViewController()
        eventsVC.tabBarItem = UITabBarItem(title: "Маршруты", image: UIImage(systemName: "star") , selectedImage: UIImage(systemName: "star.fill"))
        mapVC.tabBarItem = UITabBarItem(title: "Карта", image: UIImage(systemName: "map") , selectedImage: UIImage(systemName: "map.fill"))
        profileVC.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person") , selectedImage: UIImage(systemName: "person.fill"))
        self.viewControllers = [eventsVC, mapVC, profileVC]
        self.selectedIndex = 1
        self.modalTransitionStyle = .coverVertical
        self.modalPresentationStyle = .fullScreen
    }
}
