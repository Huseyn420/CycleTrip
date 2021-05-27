//
//  TableVC.swift
//  MapTesting
//
//  Created by Igor Lebedev on 19/05/2020.
//  Copyright © 2020 Прогеры. All rights reserved.
//

import UIKit

final class TableVC: UITableViewController {
    var name: String  {
        let name = nameCell.textField.text
        if name != "" {
            return name!
        }
        else {
            return "Название"
        }
    }
    
    var date: Date = NSDate.now
    private let nameCell = CustomCell(iconName: "pencil")
    private let dateCell = CustomCell(iconName: "calendar")
    private let timeCell = CustomCell(iconName: "clock")
    private let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.minimumDate = NSDate.now
        return dp
    }()
    private let timePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .time
        dp.minimumDate = NSDate.now
        return dp
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureDone))
        view.addGestureRecognizer(tapGesture)
        tableView.delegate = self
        tableView.dataSource = self
        configureCells()
    }

    @objc private func tapGestureDone() {
        view.endEditing(true)
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 2
        default: fatalError("Unknown section")
        }
    }
    
    override func tableView(_: UITableView, titleForHeaderInSection: Int) -> String?{
        switch(titleForHeaderInSection) {
        case 0: return "Чат"
        case 1: return "Дата и время"
        default: fatalError("Unknown section")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: CustomCell!
        switch(indexPath.section) {
        case 0:
            switch indexPath.row {
            case 0:
                cell = nameCell
            default: fatalError("Unknown row in section 0")
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell = dateCell
            case 1:
                cell = timeCell
            default: fatalError("Unknown row in section 0")
            }
        default:
            fatalError("Unknown row in section 0")
        }
        return cell
    }
    
    private func configureCells() {
        nameCell.textField.placeholder = "Название"
        datePicker.addTarget(self, action: #selector(dateChanged(sender:)), for: .valueChanged)
        timePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        dateCell.makeCell(picker: datePicker, format: "E, d MMM yyyy")
        timeCell.makeCell(picker: timePicker, format: "HH:mm")
    }
    
    @objc private func dateChanged(sender: UIDatePicker) {
        let date = sender.date
        dateCell.textField.text = dateCell.formatter.string(from: date)
        self.date = date
    }
    
    @objc private func timeChanged(sender: UIDatePicker) {
        let date = sender.date
        timeCell.textField.text = timeCell.formatter.string(from: date)
        self.date = date
    }
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
