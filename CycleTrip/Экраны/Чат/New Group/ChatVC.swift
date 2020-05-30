//
//  ChatVC.swift
//  Cycle Trip
//
//  Created by Igor Lebedev on 21/04/2020.
//  Copyright © 2020 Прогеры. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
    let tableView = UITableView()
    let navigationBar = UINavigationBar()
    var safeArea: UILayoutGuide!
    let amiboList = ["Chat1", "Chat2", "Chat3", "Chat4"]
    let timeList = ["21.06.2020 at 2 pm", "23.06.2020 at 10 am", "01.05.2020 at 6 pm", "10.10.2020 at 5 pm"]
    
        override func viewDidLoad() {
            view.backgroundColor = .white
            safeArea=view.layoutMarginsGuide
            tableView.dataSource = self
            tableView.register(ChatVCCell.self, forCellReuseIdentifier: "cellid")
            setupNavigationView()
            setupTableView()
         //   ChatAPI.shared.fetchChatList() asd
        }
    // MARK: - Setup View
    func setupNavigationView(){
           view.addSubview(navigationBar)
           
           navigationBar.translatesAutoresizingMaskIntoConstraints = true
          
       }
        func setupTableView() {
            //always add the uiview first before setting constrains
            view.addSubview(tableView)
            
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            
        }
   

    }

    //MARK: - UITableViewDataSource

    extension ChatVC: UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return amiboList.count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath)
            guard let ChatVCCell = cell as? ChatVCCell else {
                return cell
            }
            let name = amiboList[indexPath.row]
            let time = timeList[indexPath.row]
            ChatVCCell.nameLable.text = name
            ChatVCCell.whenItBeLable.text = time
            
            return cell
        }
}
