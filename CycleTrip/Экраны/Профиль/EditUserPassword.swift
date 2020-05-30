//
//  Email.swift
//  Cycle Trip
//
//  Created by Sergey on 30.05.2020.
//  Copyright © 2020 Прогеры. All rights reserved.
//

import Foundation
import UIKit
import PinLayout

class EditUserPassword: UIViewController, UITextFieldDelegate, EditUserScreenView {

    private var presenter: EditUserScreenPresenter?
    
    private let sectionTitle = UILabel()
    private let emailField = CustomTextField(name: "Email", color: 0xEBEBEB, security: false)
    
    private let buttonThrowOff = CustomButton(color: 0xFFFFFF, background: 0x4680C2, title: "Сбросить пароль")
    private let buttonGoBack = CustomButton(color: 0x4680C2, background: 0xFFFFFF, title: "Назад")
    
    private let copyEmail = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        sectionTitle.text = "Изменить пароль?"
        sectionTitle.font = UIFont(name: "Arial", size: 45)
        sectionTitle.textColor = CustomColor(0x4680C2)

        emailField.returnKeyType = .go
        
        emailField.delegate = self
        
        buttonThrowOff.isUserInteractionEnabled = false
        
        buttonGoBack.addTarget(self, action: #selector(didTapButtonGoBack), for: .touchUpInside)
        buttonThrowOff.addTarget(self, action: #selector(didTapButtonThrowOff), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapPiece))
        self.view.addGestureRecognizer(tapGesture)

        [sectionTitle, emailField, buttonThrowOff, buttonGoBack].forEach {
            view.addSubview($0)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sectionTitle.pin
            .top(self.view.pin.safeArea.top + 50)
            .hCenter()
            .sizeToFit()

        emailField.pin
            .vCenter(-100)
            .height(45)
            .horizontally(20)

        buttonThrowOff.pin
            .vCenter(-50)
            .height(40)
            .horizontally(20)

        buttonGoBack.pin
            .bottom(self.view.pin.safeArea.bottom + 30)
            .height(20)
            .horizontally(40)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if buttonThrowOff.isUserInteractionEnabled {
            didTapButtonThrowOff()
        }
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if buttonThrowOff.isUserInteractionEnabled != false {
            buttonThrowOff.isUserInteractionEnabled = false
        }
        
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let recordField = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)

        if recordField?.count != 0 {
            buttonThrowOff.isUserInteractionEnabled = true
        } else {
            buttonThrowOff.isUserInteractionEnabled = false
        }

        return true
    }


    @objc func tapPiece(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    func conclusion(title: String, message: String?) {
        let when = DispatchTime.now() + 1.2
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        buttonGoBack.isEnabled = true
        buttonThrowOff.isEnabled = true
        buttonThrowOff.loadingStop()
        
        self.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: when) {
            alert.dismiss(animated: true, completion: nil)
        }
    }

    @objc func didTapButtonThrowOff() {
        guard let email = emailField.text else {
            return
        }

        buttonGoBack.isEnabled = false
        buttonThrowOff.isEnabled = false
        buttonThrowOff.loadingStart()

        presenter = EditUserPresenter(view: self, email: email)
        
        self.presenter?.checkForSending()
    }

    @objc func didTapButtonGoBack() {
        dismiss(animated: true, completion: nil)
    }
}

