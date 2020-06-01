//
//  RegPresenter.swift
//  Cycle Trip
//
//  Created by Гусейн Агаев on 05.05.2020.
//  Copyright © 2020 Прогеры. All rights reserved.
//

import Foundation
import Firebase

protocol RegScreenView: class {
    func processingResult(error: String?)
}

protocol RegScreenPresenter {
    init(view: RegScreenView, email: String, password: String, lastName: String, firstName: String)
    func dataProcessing()
}

class RegPresenter: RegScreenPresenter {
    
    let user: User
    let ref: DatabaseReference
    let password: String
    
    unowned let view: RegScreenView
    
    required init(view: RegScreenView, email: String, password: String, lastName: String, firstName: String) {
        let picture = Picture()
        
        self.user = User(email: email, lastName: lastName, firstName: firstName, picture: picture)
        self.ref = Database.database().reference().child("users")
        self.view = view
        self.password = password
    }
    
    func dataProcessing() {
        if self.password.count < 8 {
            self.view.processingResult(error: CauseOfError.shortPassword.localizedDescription)
            return
        }
        
        Auth.auth().createUser(withEmail: user.email, password: self.password) { [weak self] (user, error) in
            if let error = error {
                self?.view.processingResult(error: CauseOfError.invalidEmail.localizedDescription)
                print(error.localizedDescription)
                return
            }

            guard let uid = user?.user.uid, let data = self?.user.convertToDictionary() else {
                self?.view.processingResult(error: CauseOfError.serverError.localizedDescription)
                return
            }

            self?.ref.child(uid).updateChildValues(data) { (error, ref) in
                if let error = error {
                    self?.view.processingResult(error: CauseOfError.unknownError.localizedDescription)
                    print(error.localizedDescription)
                    return
                }

                self?.view.processingResult(error: nil)
            }
        }
    }
}

