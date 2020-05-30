//
//  ChatVCwithConnection.swift
//  Cycle Trip
//
//  Created by Vladimir Ovsiannikov on 26.04.2020.
//  Copyright © 2020 Прогеры. All rights reserved.
//
/*
import UIKit

class ChatVC: UIViewController {
    let tableView = UITableView()
    let navBar = UINavigationBar()
    var safeArea: UILayoutGuide!
    let chatList = [Chat]()
    
        override func viewDidLoad() {
            view.backgroundColor = .white
            safeArea=view.layoutMarginsGuide
            tableView.dataSource = self
            tableView.register(ChatVCCell.self, forCellReuseIdentifier: "cellid")
         
            let anonymousFunction{(fetchedChatList: [Chat])
                DispatchQueue.main.async {
                    self.chatList = fetchedChatList
                    self.tableView.reloadData()
                }
            }
            setupTableView()
            ChatAPI.shared.fetchChatList(onCompletion: anonymousFunction)
        }
    // MARK: - Setup View
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
            return chatList.count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath)
            let chat = chatList[indexPath.row]
            guard let ChatVCCell = cell as? ChatVCCell else {
                return cell
            }
            
            ChatVCCell.nameLable.text = chat.name
            ChatVCCell.whenItBeLable.text = chat.time + date
        //    if let url = URL(string: <#T##String#>){}
            
            return cell
        }
}
*/
