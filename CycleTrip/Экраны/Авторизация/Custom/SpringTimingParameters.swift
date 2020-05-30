//
//  SpringTimingParameters.swift
//  Cycle Trip
//
//  Created by Гусейн Агаев on 09.05.2020.
//  Copyright © 2020 Прогеры. All rights reserved.
//

import UIKit

class SpringTimingParameters: UISpringTimingParameters {

    convenience init(damping: CGFloat, response: CGFloat, initialVelocity: CGVector = .zero) {
        let stiffness = pow(2 * .pi / response, 2)
        let damp = 4 * .pi * damping / response
        self.init(mass: 1, stiffness: stiffness, damping: damp, initialVelocity: initialVelocity)
    }
}
