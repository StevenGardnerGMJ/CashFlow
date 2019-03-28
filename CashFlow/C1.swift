//
//  C1.swift
//  CashFlow
//
//  Created by David on 2019/3/25.
//  Copyright © 2019 葛茂菁. All rights reserved.
//

import UIKit

class C1: UITableViewController {
    
    let reuseID = "cellC1"
    var arrC1   = Array<String>()
    var datePickerVisible:Bool = false
    var defaultArr = ["张三总送来53度飞天茅台一箱美元教育金券5w","张三总送来53度飞天茅台一箱美元教育金券5w","张三总送来53度飞天茅台一箱美元教育金券5w","张三总送来53度飞天茅台一箱美元教育金券5w","张三总送来53度飞天茅台一箱美元教育金券5w","张三总送来53度飞天茅台一箱美元教育金券5w","张三总送来53度飞天茅台一箱美元教育金券5w","张三总送来53度飞天茅台一箱美元教育金券5w"]

    override func viewDidLoad() {
        super.viewDidLoad()
        arrC1 = defaultArr
        self.navigationController?.title = "C1"
        self.navigationItem.rightBarButtonItem = 	UIBarButtonItem(image: UIImage(named: "增加"), style: .plain, target: self, action: #selector(addRelations))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseID)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reDatePicker")
        
    }

    @objc func addRelations() {
        print("----添加时间----")
//        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 300, height: 160))
//        datePicker.center = self.view.center
//        datePicker.backgroundColor = .white
//        datePicker.locale = Locale(identifier:"zh_CN")
//        datePicker.timeZone = NSTimeZone.system
//        datePicker.layer.borderWidth = 2
//        datePicker.layer.masksToBounds = true
//        datePicker.layer.borderColor = UIColor.lightGray.cgColor
//        datePicker.datePickerMode = .date
//        datePicker.addTarget(self, action: #selector(choseDate), for: .valueChanged)
//        self.view.addSubview(datePicker)
    
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 2 {
            return 216
        } else {
            return 64//super.tableView(tableView, heightForRowAt: indexPath)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && datePickerVisible {
            return 3
        } else {
            return arrC1.count//super.tableView(tableView, numberOfRowsInSection: section)
        }
       
    }
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        if indexPath.section == 0 && indexPath.row == 2 {
            let newIndexPath = IndexPath(row: 0, section: indexPath.section)
            return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
        } else {
            return super.tableView(tableView, indentationLevelForRowAt: indexPath)
            //indexPath.row
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            if !datePickerVisible {
                self.showDatePicker()
            } else {
                self.hideDatePicker()
            }
        }
    }
    func showDatePicker() {
        datePickerVisible = true
        let indexPathDatePicker = IndexPath(row: 2, section: 0)
        self.tableView.insertRows(at: [indexPathDatePicker],
                                  with: .automatic)
    }
    func hideDatePicker() {
        datePickerVisible = false
        let indexPathDatePicker = IndexPath(row: 2, section: 0)
        self.tableView.deleteRows(at: [indexPathDatePicker],
                                  with: .fade)
        
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1 {
            let cellD = tableView.dequeueReusableCell(withIdentifier: "reDatePicker")
            let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 216))
            datePicker.tag = 100
            datePicker.locale = Locale(identifier: "zh_CN")
            cellD?.contentView.addSubview(datePicker)
            datePicker.addTarget(self, action:#selector(dateChanged(_:)),
                                 for: .valueChanged)
            return cellD!
        }else {
            var cell = tableView.dequeueReusableCell(withIdentifier: reuseID)!
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: reuseID)
            cell.textLabel?.text = arrC1[indexPath.row]
            cell.detailTextLabel?.text = "2019-03-25"
            return cell
//            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    @objc func dateChanged(_ dateChanged:UIDatePicker) -> Void {
        let formatter = DateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        print(formatter.dateFormat)
    }
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        print("leadingSwipeActions")
        let action = UIContextualAction(style: .normal, title: "Mark") { (action, view, handler) in
            self.updateMarkState(indexP:indexPath)
            handler(true)
        }
        action.backgroundColor = UIColor.green
        
        if markState(for: indexPath) {
            action.title = "Unmark"
            action.backgroundColor = UIColor.green
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        print("trailingSwipeActions")
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            self.removeItem(at: indexPath)
            handler(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
        
    }
    func  updateMarkState(indexP: IndexPath) {
//        defaultArr.append("\(indexP.row)")
        defaultArr.insert("\(indexP.row)", at: indexP.row)
        tableView.reloadData()
    }
    
    func removeItem(at: IndexPath) {
        print("删除")
        defaultArr.remove(at: at.row)
        tableView.reloadData()
    }
    func markState(for: IndexPath) -> Bool {
        return true
    }
    @objc func choseDate(datePicker:UIDatePicker) {
        let choseDate = datePicker.date
        let dateFormater = DateFormatter.init()
        dateFormater.dateFormat = "YYYY-MM-dd HH-mm-ss"
        print(dateFormater.string(from: choseDate))
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
