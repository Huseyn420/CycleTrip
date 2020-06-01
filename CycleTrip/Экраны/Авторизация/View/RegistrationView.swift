//
//  RegistrationView.swift
//  Cycle Trip
//
//  Created by Гусейн Агаев on 25.04.2020.
//  Copyright © 2020 Прогеры. All rights reserved.
//

import UIKit
import PinLayout

class RegistrationView: UIViewController, UITextFieldDelegate, RegScreenView {

    private var presenter: RegScreenPresenter?

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleName = UILabel()

    private let backButton = CustomButton(color: 0x4680C2, background: 0xFFFFFF, title: "Вы уже зарегистрированы?")
    private let continueButton = CustomButton(color: 0xFFFFFF, background: 0x4680C2, title: "Продолжить")

    private let emailField = CustomTextField(name: "Email", color: 0xEBEBEB, security: false)
    private let passwordField = CustomTextField(name: "Password", color: 0xEBEBEB, security: true)
    private let lastNameField = CustomTextField(name: "Last name", color: 0xEBEBEB, security: false)
    private let firstNameField = CustomTextField(name: "First name", color: 0xEBEBEB, security: false)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.backgroundColor = .white
        contentView.backgroundColor = .white

        titleName.text = "Регистрация"
        titleName.font = UIFont(name: "Arial", size: 50)
        titleName.textColor = CustomColor(0x4680C2)
        titleName.adjustsFontSizeToFitWidth = true
        titleName.minimumScaleFactor = 0.5

        emailField.returnKeyType = .next
        lastNameField.returnKeyType = .next
        firstNameField.returnKeyType = .next
        passwordField.returnKeyType = .go
        
        emailField.delegate = self
        passwordField.delegate = self
        lastNameField.delegate = self
        firstNameField.delegate = self
        
        continueButton.isUserInteractionEnabled = false

        lastNameField.autocapitalizationType = .sentences
        firstNameField.autocapitalizationType = .sentences

        backButton.addTarget(self, action: #selector(didTapButtonBack), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(didTapButtonContinue), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapPiece))
        contentView.addGestureRecognizer(tapGesture)
                
        registerForKeyboardNotifications()

        [titleName, emailField, lastNameField, firstNameField, passwordField, continueButton, backButton].forEach {
            contentView.addSubview($0)
        }
    }

    deinit {
        removeKeyboardNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        scrollView.pin.all()
        contentView.pin.all()
        
        titleName.pin
            .top(contentView.pin.safeArea.top + 50)
            .hCenter()
            .sizeToFit()

        emailField.pin
            .vCenter(-100)
            .height(45)
            .horizontally(20)

        lastNameField.pin
            .vCenter(-50)
            .height(45)
            .horizontally(20)

        firstNameField.pin
            .vCenter()
            .height(45)
            .horizontally(20)

        passwordField.pin
            .vCenter(50)
            .height(45)
            .horizontally(20)

        continueButton.pin
            .vCenter(100)
            .height(40)
            .horizontally(20)

        backButton.pin
            .bottom(contentView.pin.safeArea.bottom + 30)
            .hCenter()
            .height(20)
            .sizeToFit(.height)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailField:
             lastNameField.becomeFirstResponder()
        case lastNameField:
             firstNameField.becomeFirstResponder()
        case firstNameField:
             passwordField.becomeFirstResponder()
        case passwordField:
             if continueButton.isUserInteractionEnabled {
                 didTapButtonContinue()
             }
        default:
             textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if continueButton.isUserInteractionEnabled != false {
            continueButton.isUserInteractionEnabled = false
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let recordField = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        let otherFields = [emailField, lastNameField, firstNameField, passwordField]
        var emptyFields = 0

        for (index, excess) in otherFields.enumerated() {
            if excess != textField {
                emptyFields += otherFields[index].text == "" ? 1 : 0
            }
        }
        
        if recordField?.count != 0 && emptyFields == 0 {
            continueButton.isUserInteractionEnabled = true
        } else {
            continueButton.isUserInteractionEnabled = false
        }

        return true
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func kbWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo

        guard let kbFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let result = kbFrameSize.origin.y - continueButton.frame.origin.y - continueButton.frame.height
        
        if result < 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: contentView.pin.safeArea.top + 110), animated: false)
        }
    }

    @objc func kbWillHide() {
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    @objc func tapPiece(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    func processingResult(error: String?) {
        backButton.isEnabled = true
        continueButton.isEnabled = true
        continueButton.loadingStop()

        if error == nil {
            let tabBar = TabBar()
            self.present(tabBar, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Ошибка", message: error, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            let when = DispatchTime.now() + 1.2
            DispatchQueue.main.asyncAfter(deadline: when) {
              alert.dismiss(animated: true, completion: nil)
            }
        }
    }

    @objc func didTapButtonContinue() {
        guard let email = emailField.text, let password = passwordField.text,
        let lastName = lastNameField.text, let firstName = firstNameField.text else {
            return
        }

        backButton.isEnabled = false
        continueButton.isEnabled = false
        continueButton.loadingStart()

        presenter = RegPresenter(view: self, email: email,
                                 password: password, lastName: lastName,
                                 firstName: firstName)

        self.presenter?.dataProcessing()
    }

    @objc func didTapButtonBack() {
        dismiss(animated: true, completion: nil)
    }
}
