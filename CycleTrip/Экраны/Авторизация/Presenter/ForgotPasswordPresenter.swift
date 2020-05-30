//
//  ForgotPasswordPresenter.swift
//  Cycle Trip
//
//  Created by Гусейн Агаев on 11.05.2020.
//  Copyright © 2020 Прогеры. All rights reserved.
//

import Foundation
import Firebase

protocol ForgotPasswordScreenView: class {
    func conclusion(title: String, message: String?)
}

protocol ForgotPasswordScreenPresenter {
    init(view: ForgotPasswordView, email: String)
    func checkForSending()
}

class ForgotPasswordPresenter: ForgotPasswordScreenPresenter {
    
    unowned let view: ForgotPasswordScreenView
    let email: String
    
    required init(view: ForgotPasswordView, email: String) {
        self.view = view
        self.email = email
    }
    
    func checkForSending() {
        Auth.auth().sendPasswordReset(withEmail: self.email) { [weak self] (error) in
            if error != nil {
                self?.view.conclusion(title: "Ошибка",message: CauseOfError.mailNotFound.localizedDescription)
                return
            }
            
            self?.view.conclusion(title: "Успешно",message: "На вашу почту отправление ссылка для изменения пароля")
        }
    }
}
