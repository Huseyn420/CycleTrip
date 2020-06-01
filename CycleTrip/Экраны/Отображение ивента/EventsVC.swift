//
//  eventsVC.swift
//  CycleTrip
//
//  Created by Vova on 01.06.2020.
//  Copyright © 2020 CycleTrip. All rights reserved.
//

import UIKit
import Firebase


class EventsVC: UIViewController {
    var eventIDs: [String]!
    var events = [Event]()
    let tableView = UITableView()
    let navigationBar = UINavigationBar()
    var safeArea: UILayoutGuide!
//    let amiboList = ["Chat1", "Chat2", "Chat3", "Chat4"]
//    let timeList = ["21.06.2020 at 2 pm", "23.06.2020 at 10 am", "01.05.2020 at 6 pm", "10.10.2020 at 5 pm"]
    let uid = Auth.auth().currentUser!.uid
    let ref = Database.database().reference()
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "E, d MMM yyyy"
        return df
    }()
    private let timeFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        return df
    }()
    
    
    
        override func viewDidLoad() {
            view.backgroundColor = .white
            safeArea=view.layoutMarginsGuide
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(EventsVCCell.self, forCellReuseIdentifier: "cellid")
           // setupNavigationView()
            setupTableView()
            getUserData()
            
           // print(self.events)
         //   ChatAPI.shared.fetchChatList() asd
            
            
            
        }
    
    // MARK: - Setup View
//    func setupNavigationView(){
//           view.addSubview(navigationBar)
//
//           navigationBar.translatesAutoresizingMaskIntoConstraints = false
//
//       }


//override func viewWillAppear(_ animated: Bool) {
//  super.viewWillAppear(animated)
//  navigationController?.isToolbarHidden = false
//}
//
//override func viewWillDisappear(_ animated: Bool) {
//  super.viewWillDisappear(animated)
//  navigationController?.isToolbarHidden = true
//}
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

//@available(iOS 13.0, *)
extension EventsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 80
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.events.count)
        return self.events.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath)
        guard let EventsVCCell = cell as? EventsVCCell else {
            return cell
        }
 //       cell.accessoryType = .disclosureIndicator
//        let name = amiboList[indexPath.row]
//        let time = timeList[indexPath.row]
//        EventsVCCell.nameLable.text = name
//        EventsVCCell.whenItBeLable.text = time
        let name = self.events[indexPath.row].name
       // let distance = self.events[indexPath.row].routeJSON["distance"] as? String
        EventsVCCell.nameLable.text = "Маршрут:\(name)"
        EventsVCCell.whenItBeLable.text = "Когда:\(dateFormatter.string(from: self.events[indexPath.row].date)) \(timeFormatter.string(from: self.events[indexPath.row].date))"
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("TEEEEEESTTEEEEEESTTEEEEEESTTEEEEEEST")
         let myEvent = events[indexPath.row]
         let vc = EventDesctiptionVC()
         vc.event = myEvent
        self.present(vc,animated: true)
         //navigationController?.pushViewController(vc, animated: true)
    }
    
    func getUserData() {
        self.ref.child("users").child(uid).observe(.value, with: {[weak self] (snapshot) in
            let snapshotValue = snapshot.value as! [String : Any]
            self?.eventIDs = snapshotValue["eventIDs"] as? [String] ?? []
            self?.getUserEvents()
        })
    }
    func getUserEvents() {
        self.ref.child("events").observe(.value, with: {[weak self] (snapshot) in
            var events = [Event]()
            for id in (self?.eventIDs)! {
                let event = Event(snapshot: snapshot.childSnapshot(forPath: id))
                events.append(event)
            }
          //  print(events)
            self?.events = events
        })
    }
}
