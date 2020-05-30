//
//  AnimatedPresenter.swift
//  Cycle Trip
//
//  Created by Гусейн Агаев on 28.05.2020.
//  Copyright © 2020 Прогеры. All rights reserved.
//

import Foundation
import LocalAuthentication

protocol AnimatedScreenView: class {
    func authorizationСheck(loggedIn: Bool)
}

protocol AnimatedScreenPresenter {
    init(view: AnimatedScreenView)
    func dataProcessing()
}

class AnimatedPresenter: AnimatedScreenPresenter {

    unowned let view: AnimatedScreenView
    var loggedIn = false
    
    required init(view: AnimatedScreenView) {
        self.view = view
    }

    func dataProcessing() {
        let addVerification = UserDefaults.standard.bool(forKey: "additionalVerification")

        if addVerification == true {
            self.extraProtection()
        } else {
            self.view.authorizationСheck(loggedIn: true)
        }
    }
    
    private func extraProtection() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Аудентификацию"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.view.authorizationСheck(loggedIn: true)
                    } else {
                        self.view.authorizationСheck(loggedIn: false)
                    }
                }
            }
        } else {
            self.view.authorizationСheck(loggedIn: true)
        }
    }
}
