//
//  CustomCell.swift
//  MapTesting
//
//  Created by Igor Lebedev on 21/05/2020.
//  Copyright © 2020 Прогеры. All rights reserved.
//

import UIKit
import PinLayout
final class CustomCell: UITableViewCell {
    var icon: UIImageView = {
       let imgView = UIImageView()
       imgView.contentMode = .scaleAspectFit
       imgView.clipsToBounds = true
       return imgView
    }()
    
    var formatter: DateFormatter!
    
    var textField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        return tf
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(icon)
        contentView.addSubview(textField)
        icon.pin.centerLeft(10).size(30)
        textField.pin.after(of: icon, aligned: .center).right().height(40).marginHorizontal(10)
    }
    
    convenience init(iconName: String) {
        self.init(style: .default, reuseIdentifier: "Cell")
        icon.image = UIImage(systemName: iconName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func makeCell(picker: UIDatePicker, format: String) {
        formatter = DateFormatter()
        formatter.dateFormat = format
        textField.inputView = picker
        textField.placeholder = formatter.string(from: picker.date)
    }
        
}
