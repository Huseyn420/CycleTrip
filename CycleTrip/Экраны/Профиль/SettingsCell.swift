//
//  SettingsCell.swift
//  Cycle Trip
//
//  Created by AVK on 04.05.2020.
//  Copyright © 2020 Прогеры. All rights reserved.
//

import UIKit


class SettingsCell: UITableViewCell {
    
    var sectionType: SectionType? {
        didSet {
            guard let sectionType = sectionType else {return }
            textLabel?.text = sectionType.description
            switchControl.isHidden = !sectionType.containsSwitch
        }
    }
    
    lazy var switchControl: UISwitch = {
        let swithControl = UISwitch()
        let a = CustomColor(0x4680C2)
        var additionalVerification = UserDefaults.standard.bool(forKey: "additionalVerification")
        if additionalVerification == false
        {
        swithControl.isOn = false
        }
        else
        {
        swithControl.isOn = true
        }
        swithControl.onTintColor = a
        swithControl.translatesAutoresizingMaskIntoConstraints = false
        swithControl.addTarget(self, action: #selector(handleSwitchAction), for: .valueChanged)
        return swithControl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(switchControl)
        switchControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        switchControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleSwitchAction(sender: UISwitch){
        if sender.isOn{
            print("Turned on")
            UserDefaults.standard.set(true, forKey: "additionalVerification")
        }
        else {
            print("Turned off")
            UserDefaults.standard.set(false, forKey: "additionalVerification")
        }
}
}

