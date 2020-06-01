//
//  ViewController.swift
//  Cycle Trip
//
//  Created by AVK on 04.05.2020.
//  Copyright © 2020 Прогеры. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

private let reuseIdentifier = "SettingsCell"
private let imagePicker = UIImagePickerController()
//@available(iOS 13.0, *)
class ViewController: UIViewController {
    
    
    var tableView: UITableView!
    var userInfoHeader: UserInfoHeader!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        configureUI()
    }
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        tableView.frame = view.frame
        
        let frame = CGRect(x: 0, y: 88, width: view.frame.width, height: 100)
        userInfoHeader = UserInfoHeader(frame: frame)
        tableView.tableHeaderView = userInfoHeader
        tableView.tableFooterView = UIView()
    }
    
    func configureUI() {
        configureTableView()
        
        navigationController?.navigationBar.barTintColor = CustomColor(0x4680C2)
        navigationItem.title = "Настройки"
    }
    func showMailComposer() {
        print("mail allert")
        guard MFMailComposeViewController.canSendMail() else {
            //Show alert informing the user
             print("allert")
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["serge2000k@gmail.com", "huseyn20@gmail.com"])
        composer.setSubject("HELP!")
        composer.setMessageBody("Мне действительно очень нравится ваше приложение, но произошла ошибка. Мне нужна ваша помощь..", isHTML: false)
        
        present(composer, animated: true)
    }
}
extension ViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if let _ = error {
            //Show error alert
            controller.dismiss(animated: true)
            return
        }
        
        switch result {
        case .cancelled:
            print("Cancelled")
        case .failed:
            print("Failed to send")
        case .saved:
            print("Saved")
        case .sent:
            print("Email Sent")
        @unknown default:
            break
        }
        
        controller.dismiss(animated: true)
    }
}
//@available(iOS 13.0, *)
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = SettingsSection(rawValue: section) else { return 0 }
            
        
        switch section {
        case .Social:
            return SocialOptions.allCases.count
        case .Communications:
            return CommunicationOptions.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = CustomColor(0x4680C2)
        
        print("Section is \(section)")
        
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = .white
        title.text = SettingsSection(rawValue: section)?.description
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsCell
        guard let section = SettingsSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .Social:
            let social = SocialOptions(rawValue: indexPath.row)
            cell.sectionType = social
        case .Communications:
            let communications = CommunicationOptions(rawValue: indexPath.row)
            cell.sectionType = communications
        }
        return cell
    }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                guard let section = SettingsSection(rawValue: indexPath.section) else { return }
                
                switch section {
                case .Social:
                    if SocialOptions(rawValue: indexPath.row)!.rawValue == 0
                    {
                        self.present(imagePicker, animated: true, completion: nil)
                        
                    }
                    if SocialOptions(rawValue: indexPath.row)!.rawValue == 1
                    {
                        self.editUserPassword()
                    }
                    if SocialOptions(rawValue: indexPath.row)!.rawValue == 2
                    {
                        let alert = UIAlertController(title: "Вы уверены, что хотите выйти?", message: "", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Продолжить", style: .default, handler:{(action) in
                                self.logout()
                            }))
                            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler:{ action in
                                alert.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true, completion: nil)

                    }
                case .Communications:
                    if  CommunicationOptions(rawValue: indexPath.row)!.rawValue == 0
                    {
                        
                    }
                    if  CommunicationOptions(rawValue: indexPath.row)!.rawValue == 1
                    {
                        showMailComposer()
                    }
                }
            }

        func logout() {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                self.dismiss(animated: true, completion: nil)
            } catch let signOutError as NSError {
              print ("Error signing out: %@", signOutError)
            }
        }
        func editUserPassword(){
            let editUserPassword = EditUserPassword()
                
            editUserPassword.modalTransitionStyle = .crossDissolve
            editUserPassword.modalPresentationStyle = .overCurrentContext
            self.present(editUserPassword, animated: true, completion: nil)
        }
       
        func checkForSending() {
            Auth.auth().sendPasswordReset(withEmail: userInfoHeader.emailLabel.text!) { [weak self] (error) in
            if error != nil {
                //print(self!.userInfoHeader.emailLabel.text as Any)
                self!.conclusion(title: "Ошибка",message: CauseOfError.mailNotFound.localizedDescription)
                return
            }
            print(self!.userInfoHeader.emailLabel.text as Any)
            self!.conclusion(title: "Успешно",message: "На вашу почту отправление ссылка для изменения пароля")
            }
        }
        func conclusion(title: String, message: String?) {
            let when = DispatchTime.now() + 1.2
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
            
            
            self.present(alert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: when) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }


extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            userInfoHeader.profileImageView.image = image
            userInfoHeader.saveImage(image: image)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
