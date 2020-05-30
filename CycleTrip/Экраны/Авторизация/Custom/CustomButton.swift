//
//  CustomButton.swift
//  Cycle Trip
//
//  Created by Гусейн Агаев on 23.04.2020.
//  Copyright © 2020 Прогеры. All rights reserved.
//

import UIKit
import PinLayout

class CustomButton: UIButton {

    private var color = UInt()
    private var title = String()
    private var background = UInt()
    
    private var loading = UIActivityIndicatorView()
    
    convenience init(color: UInt, background: UInt, title: String) {
        self.init(type: .custom)
        self.color = color
        self.title = title
        self.background = background
        setup()
    }
    
    private func setup() {
        self.isEnabled = true
        self.layer.cornerRadius = 8
        self.setTitle(title, for: .normal)
        self.backgroundColor  = CustomColor(background)
        self.setTitleColor(CustomColor(color), for: .normal)
    }
    
    override var isHighlighted: Bool {
        didSet {
            guard let background = backgroundColor, let color = titleColor(for: self.state) else { return }

            UIView.animate(withDuration: self.isHighlighted ? 0 : 0.4, delay: 0.0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                self.backgroundColor = background.withAlphaComponent(self.isHighlighted ? 0.3 : 1)
                self.setTitleColor(color.withAlphaComponent(self.isHighlighted ? 0.3 : 1), for: .normal)
            })
        }
    }
    
    override var isUserInteractionEnabled: Bool {
        didSet {
            guard let background = backgroundColor, let color = titleColor(for: self.state) else { return }

            UIView.animate(withDuration: self.isUserInteractionEnabled ? 0.0 : 0, delay: 0.0, options: [.beginFromCurrentState], animations: {
                self.backgroundColor = background.withAlphaComponent(self.isUserInteractionEnabled ? 1 : 0.3)
                self.setTitleColor(color.withAlphaComponent(self.isUserInteractionEnabled ? 1 : 0.3), for: .normal)
            })
        }
    }
    
    func loadingStart() {
        self.setTitle("", for: .normal)
        self.addSubview(loading)
        loading.startAnimating()
        loading.isHidden = false
        loading.pin.center()
    }
    
    func loadingStop() {
        self.setTitle(title, for: .normal)
        loading.removeFromSuperview()
        loading.stopAnimating()
        loading.isHidden = true
    }
}
