//
//  ViewController.swift
//  Cycle Trip
//
//  Created by AVK on 04.05.2020.
//  Copyright © 2020 Прогеры. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SettingsCell"

//@available(iOS 13.0, *)
class ViewController: UIViewController {
    
    
    var tableView: UITableView!
    var userInfoHeader: UserInfoHeader!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
    red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
    green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
    blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
    alpha: CGFloat(1.0)
    )
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
        
        navigationController?.navigationBar.barTintColor = UIColorFromRGB(rgbValue: 0x4680C2)
        navigationItem.title = "Настройки"
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
        case .Information:
            return InformationOptions.allCases.count
        case .Communications:
            return CommunicationOptions.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColorFromRGB(rgbValue: 0x4680C2)
        
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
        case .Information:
            let information = InformationOptions(rawValue: indexPath.row)
            cell.sectionType = information
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
            print(SocialOptions(rawValue: indexPath.row)?.description as Any)
         case .Information:
            print(InformationOptions(rawValue: indexPath.row)?.description as Any)
        case .Communications:
            print(CommunicationOptions(rawValue: indexPath.row)?.description as Any)
        }
    }
}
