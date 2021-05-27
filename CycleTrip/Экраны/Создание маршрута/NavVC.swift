//
//  NavVC.swift
//  MapTesting
//
//  Created by Igor Lebedev on 19/05/2020.
//  Copyright © 2020 Прогеры. All rights reserved.
//

import UIKit

final class NavVC: UINavigationController {
    private var tableVC: TableVC!
    var presenter: MapPresenter!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableVC = TableVC(style: .grouped)
        viewControllers = [tableVC]
        tableVC.title = "Создать"
        tableVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped(sender:)))
        tableVC.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped(sender:)))
    }
	
    @objc private func cancelTapped(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
	
    @objc private func saveTapped(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        presenter.createEvent(name:tableVC.name, date:tableVC.date)
        tableVC.view.endEditing(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
