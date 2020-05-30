//
//  AuthenticationView.swift
//  Cycle Trip
//
//  Created by Гусейн Агаев on 19.04.2020.
//  Copyright © 2020 Гусейн Агаев. All rights reserved.
//

import UIKit
import PinLayout
import FBSDKLoginKit

class AuthenticationView: UIViewController, UITextFieldDelegate, AuthScreenView {
    
    private var presenter: AuthScreenPresenter?
    
    private let labelProgramName = UILabel()
        
    private let emailField = CustomTextField(name: "Email", color: 0xEBEBEB, security: false)
    private let passwordField = CustomTextField(name: "Password", color: 0xEBEBEB, security: true)
        
    private let buttonSignIn = CustomButton(color: 0xFFFFFF, background: 0x4680C2, title: "Войти")
    private let buttonSignUp = CustomButton(color: 0x4680C2, background: 0xFFFFFF, title: "Зарегистрироваться")
    private let buttonRestore = CustomButton(color: 0x4680C2, background: 0xFFFFFF, title: "Забыл пароль?")
    private let buttonFB = CustomButton(color: 0x4680C2, background: 0xFFFFFF, title: " Войти через Facebook ")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        labelProgramName.text = "Cycle Trip"
        labelProgramName.font = UIFont(name: "Arial", size: 50)
        labelProgramName.textColor = CustomColor(0x4680C2)
        
        buttonSignIn.isUserInteractionEnabled = false
        
        emailField.returnKeyType = .next
        passwordField.returnKeyType = .go
        
        emailField.delegate = self
        passwordField.delegate = self
        
        buttonFB.setImage(UIImage(named: "Facebook"), for: .normal)
        buttonFB.addTarget(self, action: #selector(didTapButtonFB), for: .touchUpInside)
        buttonSignIn.addTarget(self, action: #selector(didTapButtonSignIn), for: .touchUpInside)
        buttonSignUp.addTarget(self, action: #selector(didTapButtonSignUp), for: .touchUpInside)
        buttonRestore.addTarget(self, action: #selector(didTapRestoreButton), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapPiece))
        self.view.addGestureRecognizer(tapGesture)
                
        [labelProgramName, emailField, passwordField, buttonSignIn, buttonSignUp, buttonRestore, buttonFB].forEach {
            view.addSubview($0)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            
        labelProgramName.pin
            .top(view.pin.safeArea.top + 50)
            .hCenter()
            .sizeToFit()
            
        emailField.pin
            .vCenter(-100)
            .horizontally(20)
            .height(45)
                
        passwordField.pin
            .vCenter(-50)
            .horizontally(20)
            .height(45)
                
        buttonSignIn.pin
            .vCenter()
            .height(40)
            .horizontally(20)
        
        buttonRestore.pin
            .vCenter(50)
            .hCenter()
            .height(20)
            .sizeToFit(.height)
        
        buttonFB.pin
            .vCenter(95)
            .hCenter()
            .height(26)
            .sizeToFit(.height)

        buttonSignUp.pin
            .bottom(view.pin.safeArea.bottom + 30)
            .hCenter()
            .height(20)
            .sizeToFit(.height)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        
        if buttonSignIn.isUserInteractionEnabled {
            if textField == passwordField {
                didTapButtonSignIn()
            }
        }
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if buttonSignIn.isUserInteractionEnabled != false {
            buttonSignIn.isUserInteractionEnabled = false
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let recordField = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        let secondField = (textField == passwordField) ? emailField.text : passwordField.text
        
        if recordField != "" && secondField != "" {
            buttonSignIn.isUserInteractionEnabled = true
        } else {
            buttonSignIn.isUserInteractionEnabled = false
        }

        return true
    }
    
    @objc func tapPiece(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func processingResult(error: String?) {
        let tabBar = TabBar()
        
        buttonSignIn.loadingStop()
        buttonSignIn.isEnabled = true
        buttonSignUp.isEnabled = true
        
        if error == nil {
            self.present(tabBar, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Ошибка", message: error, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            let when = DispatchTime.now() + 1.2
            DispatchQueue.main.asyncAfter(deadline: when){
              alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func didTapButtonFB() {
        presenter = AuthPresenter(view: self, email: nil, password: nil)
        self.presenter?.dataProcessingFB()
    }
    
    @objc func didTapButtonSignIn() {
        buttonSignIn.loadingStart()
        buttonSignIn.isEnabled = false
        buttonSignUp.isEnabled = false
        
        presenter = AuthPresenter(view: self, email: emailField.text, password: passwordField.text)
        self.presenter?.dataProcessing()
    }
        
    @objc func didTapButtonSignUp() {
        let regView = RegistrationView()
        
        regView.modalTransitionStyle = .crossDissolve
        regView.modalPresentationStyle = .overCurrentContext
        self.present(regView, animated: true, completion: nil)
    }
    
    @objc func didTapRestoreButton() {
        let forgotPasswordView = ForgotPasswordView()
        
        forgotPasswordView.modalTransitionStyle = .crossDissolve
        forgotPasswordView.modalPresentationStyle = .overCurrentContext
        self.present(forgotPasswordView, animated: true, completion: nil)
    }
}
    
