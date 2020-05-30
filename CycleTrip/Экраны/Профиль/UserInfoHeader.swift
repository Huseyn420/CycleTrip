//
//  UserInfoHeader.swift
//  Cycle Trip
//
//  Created by AVK on 04.05.2020.
//  Copyright © 2020 Прогеры. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class UserInfoHeader: UIView {
    
    
    
    let profileImageView: UIImageView = {
        let uid = Auth.auth().currentUser!.uid
        let iv = UIImageView()
        Database.database().reference().child("users").child(uid).observe(.value, with: { (DataSnapshot) in
            let user = User(snapshot: DataSnapshot)
            let a = user.imageURL

        if a != nil {
            iv.image = UIImage(named: "avatar")
            }

            
        else
        {
            iv.image = UIImage(named: "avatar")
        }
        })
        func didTapImageView(){

            print("kzzkkzkzkkkkzkz")
        }
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
            return iv
        }()
        
    
 
    
    let usernameLabel: UILabel = {

        let uid = Auth.auth().currentUser!.uid
        let label = UILabel()
        Database.database().reference().child("users").child(uid).observe(.value, with: { (DataSnapshot) in
            let user = User(snapshot: DataSnapshot)
            let a = user.firstName
            let b = user.lastName
            let c = a + " " + b

            print("\n\n\n\n\n \(a) \(b) \n\n\n\n\n")
            label.text = c
        })
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    
    let emailLabel: UILabel = {
        let user = Auth.auth().currentUser
        let email = user?.email
        let label = UILabel()
        label.text = email
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let profileImageDimension: CGFloat = 60
        
        addSubview(profileImageView)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: profileImageDimension).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: profileImageDimension).isActive = true
        profileImageView.layer.cornerRadius = profileImageDimension / 2
        
        addSubview(usernameLabel)
        usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: -10).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        
        addSubview(emailLabel)
        emailLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 10).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
}

