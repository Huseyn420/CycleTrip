//
//  editUserPasswordPresenter.swift
//  Cycle Trip
//
//  Created by Sergey on 30.05.2020.
//  Copyright © 2020 Прогеры. All rights reserved.
//

import Foundation
import Firebase

protocol EditUserScreenView: class {
    func conclusion(title: String, message: String?)
}

protocol EditUserScreenPresenter {
    init(view: EditUserPassword, email: String)
    func checkForSending()
}

class EditUserPresenter: EditUserScreenPresenter {
    
    unowned let view: EditUserScreenView
    let email: String
    
    required init(view: EditUserPassword, email: String) {
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

