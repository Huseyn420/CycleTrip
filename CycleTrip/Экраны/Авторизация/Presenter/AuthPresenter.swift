//
//  AuthPresenter.swift
//  Cycle Trip
//
//  Created by Гусейн Агаев on 24.04.2020.
//  Copyright © 2020 Прогеры. All rights reserved.
//

import Foundation
import Firebase
import FBSDKLoginKit

protocol AuthScreenView: class {
    func processingResult(error: String?)
}

protocol AuthScreenPresenter {
    init(view: AuthScreenView, email: String?, password: String?)
    func dataProcessingFB()
    func dataProcessing()
}

class AuthPresenter: AuthScreenPresenter {
    unowned let view: AuthScreenView
    let password: String?
    let email: String?
    
    required init(view: AuthScreenView, email: String?, password: String?) {
        self.password = password
        self.email = email
        self.view = view
    }
    
    func dataProcessingFB() {
        let login = LoginManager()
        let permissions = ["public_profile", "email"]

        if AccessToken.current != nil {
            login.logOut()
        }
        
        login.logIn(permissions: permissions, from: (self.view as? UIViewController)) { [weak self] (result, error) in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            
            GraphRequest(graphPath: "me", parameters: ["fields":"email,last_name,first_name,picture"], tokenString: AccessToken.current?.tokenString, version: nil, httpMethod: HTTPMethod(rawValue: "GET")).start { (connector, result, error) in
                guard error == nil, let values = result as? [String: AnyHashable], let token = AccessToken.current?.tokenString else {
                    print(error?.localizedDescription as Any)
                    self?.view.processingResult(error: CauseOfError.entranceFC.localizedDescription)
                    return
                }
                
                let credential = FacebookAuthProvider.credential(withAccessToken: token)
                Auth.auth().signIn(with: credential) { (user, error) in
                    guard error == nil else {
                        self?.view.processingResult(error: CauseOfError.entranceFC.localizedDescription)
                        return
                    }
                    
                    self?.fillingTheDatabase(data: values)
                    self?.view.processingResult(error: nil)
                }
            }
        }
    }
    
    func fillingTheDatabase(data: [String: AnyHashable]) {
        let ref = Database.database().reference().child("users")
        let user = Auth.auth().currentUser
        
        guard let uid = user?.uid else {
            return
        }
        ref.child(uid).updateChildValues(data, withCompletionBlock: { [weak self] (error, ref) in
             guard error == nil else {
                print(error as Any)
                 return
             }
             self?.view.processingResult(error: nil)
         })
    }
    
    func dataProcessing() {
        guard let email = self.email, let password = self.password else {
            self.view.processingResult(error: CauseOfError.loginOrPassword.localizedDescription)
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            if let error = error {
                self?.view.processingResult(error: CauseOfError.loginOrPassword.localizedDescription)
                print(error.localizedDescription)
                return
            }
            
            self?.view.processingResult(error: nil)
        }
    }
}
