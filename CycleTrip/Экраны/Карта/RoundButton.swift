//
//  RoundButton.swift
//  Cycle Trip
//
//  Created by Igor Lebedev on 25/05/2020.
//  Copyright © 2020 Прогеры. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    override init(frame:CGRect) {
        super.init(frame:frame)
        backgroundColor = UIColor(white: 0.5, alpha: 0.2)
        layer.cornerRadius = 25
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = UIColor(white: 100, alpha: 0.2)
        layer.cornerRadius = 25
    }
    func configure(iconName: String) {
        let image = UIImage(systemName: iconName)
        setImage(image, for: .normal)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
