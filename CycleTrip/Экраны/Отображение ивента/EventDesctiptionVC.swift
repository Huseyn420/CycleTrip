//
//  EventDesctiptionViewController.swift
//  Table
//
//  Created by Vova on 01.06.2020.
//  Copyright © 2020 Vova. All rights reserved.
//

import UIKit

class EventDesctiptionVC: UIViewController {
    var event : Event?
    let nameEvent = UILabel()
    let nameEvent2 = UILabel()
    let nameEvent3 = UILabel()
    let nameEvent4 = UILabel()
    let nameEvent5 = UILabel()
    let nameEvent6 = UILabel()
    var safeArea : UILayoutGuide!
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
        super.viewDidLoad()
        setupNameLable()
        setupDate()
    view.backgroundColor = .black
    
        // Do any additional setup after loading the view.
    }

    func setupNameLable(){
        view.addSubview(nameEvent)
        
        nameEvent.translatesAutoresizingMaskIntoConstraints = false
        nameEvent.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameEvent.topAnchor.constraint(equalTo: view.topAnchor ,constant: 50).isActive = true
        nameEvent.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        nameEvent.font = UIFont( name: "Verdana", size: 14)
        
        view.addSubview(nameEvent2)
        
        nameEvent2.translatesAutoresizingMaskIntoConstraints = false
        nameEvent2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameEvent2.topAnchor.constraint(equalTo: nameEvent.topAnchor ,constant: 15).isActive = true
        nameEvent2.font = UIFont( name: "Verdana-Bold", size: 40)
        
        
        view.addSubview(nameEvent3)
        
        nameEvent3.translatesAutoresizingMaskIntoConstraints = false
        nameEvent3.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameEvent3.topAnchor.constraint(equalTo: nameEvent2.topAnchor ,constant: 60).isActive = true
        nameEvent3.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        nameEvent3.font = UIFont( name: "Verdana", size: 14)
        
        view.addSubview(nameEvent4)
             
             nameEvent4.translatesAutoresizingMaskIntoConstraints = false
             nameEvent4.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
             nameEvent4.topAnchor.constraint(equalTo: nameEvent3.topAnchor ,constant: 15).isActive = true
             nameEvent4.font = UIFont( name: "Verdana-Bold", size: 26)
        
        view.addSubview(nameEvent5)
        
        nameEvent5.translatesAutoresizingMaskIntoConstraints = false
        nameEvent5.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameEvent5.topAnchor.constraint(equalTo: nameEvent4.topAnchor ,constant: 50).isActive = true
        nameEvent5.font = UIFont( name: "Verdana", size: 14)
        view.addSubview(nameEvent6)
        
        nameEvent6.translatesAutoresizingMaskIntoConstraints = false
        nameEvent6.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameEvent6.topAnchor.constraint(equalTo: nameEvent5.topAnchor ,constant: 15).isActive = true
        nameEvent6.font = UIFont( name: "Verdana-Bold", size: 26)
    }
    
    
    
    func setupDate(){
        nameEvent.text = "Маршрут:"
        nameEvent.textColor = CustomColor(0x4680C2)
        nameEvent2.text = event?.name
        nameEvent2.textColor = CustomColor(0x4680C2)
        nameEvent3.text = "Дата и время:"
        nameEvent3.textColor = CustomColor(0x4680C2)
        nameEvent4.text = "\(dateFormatter.string(from: event!.date)) \(timeFormatter.string(from: event!.date))"
        nameEvent4.textColor = CustomColor(0x4680C2)
        
        nameEvent5.text = "Количество контрольных точек:"
        nameEvent5.textColor = CustomColor(0x4680C2)
        let num = event!.points.count
        nameEvent6.text = "\(num)"
        nameEvent6.textColor = CustomColor(0x4680C2)
    }
}
