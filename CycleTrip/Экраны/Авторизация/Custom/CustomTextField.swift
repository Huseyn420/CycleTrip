//
//  CustomTextField.swift
//  Cycle Trip
//
//  Created by Гусейн Агаев on 23.04.2020.
//  Copyright © 2020 Прогеры. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    private var security = Bool()
    private var name = String()
    private var color = UInt()
    
    convenience init(name: String, color: UInt, security: Bool) {
        self.init()
        self.name = name
        self.color = color
        self.security = security
        entryField()
    }
  
    private func entryField() {
        self.textColor = .black
        self.placeholder = name
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 0.5
        self.autocorrectionType = .no
        self.clearButtonMode = .always
        self.isSecureTextEntry = security
        self.autocapitalizationType = .none
        self.font = UIFont.systemFont(ofSize: 20)
        self.backgroundColor = CustomColor(color)
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftViewMode = .always
    }
}
