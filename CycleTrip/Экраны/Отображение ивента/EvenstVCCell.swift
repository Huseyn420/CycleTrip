//
//  EvenstVCCell.swift
//  Table
//
//  Created by Vova on 01.06.2020.
//  Copyright © 2020 Vova. All rights reserved.
//

import UIKit

class EventsVCCell: UITableViewCell{
    var safeArea: UILayoutGuide!
     let imageIV = UIImageView()
   // let imageIV = CustomImageView()
    let nameLable = UILabel()
    let whenItBeLable = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDercoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        safeArea = layoutMarginsGuide
        setupImageView()
        setupNameLable()
        setupWhenItBe()
    }
    
    func setupImageView(){
        addSubview(imageIV)
        
        imageIV.translatesAutoresizingMaskIntoConstraints = false
        imageIV.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        imageIV.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageIV.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageIV.heightAnchor.constraint(equalToConstant: 40).isActive = true
       //  imageIV.backgroundColor = .red
    }
    
    func setupNameLable(){
        addSubview(nameLable)
        
        nameLable.translatesAutoresizingMaskIntoConstraints = false
        nameLable.leadingAnchor.constraint(equalTo: imageIV.trailingAnchor, constant: 5 ).isActive=true
        nameLable.topAnchor.constraint(equalTo: topAnchor, constant : 15).isActive = true
        
        nameLable.font = UIFont( name: "Verdana-Bold", size: 20)
    }
    func setupWhenItBe(){
    addSubview(whenItBeLable)
    
        whenItBeLable.translatesAutoresizingMaskIntoConstraints = false
        whenItBeLable.leadingAnchor.constraint(equalTo: nameLable.leadingAnchor).isActive = true
        whenItBeLable.topAnchor.constraint(equalTo: nameLable.bottomAnchor).isActive = true
        
        whenItBeLable.font = UIFont( name:"Verdana" , size: 14)
    
    }
}
