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
    var sIndex = 1
    var defaultArr = ["张三总送来53度飞天茅台一箱美元教育金券1","张三总送来53度飞天茅台一箱美元教育金券2ABCDEFG","张三总送来53度飞天茅台一箱美元教育金券3","张三总送来53度飞天茅台一箱美元教育金券4","张三总送来53度飞天茅台一箱美元教育金券5w","张三总送来53度飞天茅台一箱美元教育金券6","张三总送来53度飞天茅台一箱美元教育金券7","张三总送来53度飞天茅台一箱美元教育金券8"]

    override func viewDidLoad() {
        super.viewDidLoad()
        arrC1 = defaultArr
        self.navigationController?.title = "C1"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "增加"), style: .plain, target: self, action: #selector(addRelations))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseID)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reDatePicker")
        
    }

    @objc func addRelations() {
        print("----添加时间----")
        let alterControl = UIAlertController(title: "添加人情往来", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alterControl.addTextField { (tF) in
            tF.placeholder = "输入事件"
        }
        let sureAction = UIAlertAction(title: "确定", style: .default) { (action) in
            let tfStr = alterControl.textFields?.last?.text
            guard tfStr != nil  else {
                return
            }
            let date = TimeInterval()
            datetimeToString(dateTime: date)
            self.defaultArr.append("\(tfStr ?? "请填")")
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        alterControl.addAction(sureAction)
        alterControl.addAction(cancelAction)
        self.present(alterControl, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64 //预估高度
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if datePickerVisible && indexPath.row == sIndex + 1 {
            return 216
        } else {
           return UITableViewAutomaticDimension
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return defaultArr.count
       
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if datePickerVisible == true {
//            showDatePicker(inP: indexPath)
//        } else {
            hideDatePicker(inP: indexPath)
        }

    }
    
    func showDatePicker(inP:IndexPath) {
       datePickerVisible = true
       sIndex = inP.row
       let rowNum =  inP.row + 1
       defaultArr.insert("众亲平身", at: rowNum)
       let inPs = [inP]
       self.tableView.insertRows(at: inPs , with: .automatic)
        
       let inSec =  IndexSet(arrayLiteral: 0)
       tableView.reloadSections( inSec , with: .automatic)
    }
    
    func hideDatePicker(inP:IndexPath) {
        datePickerVisible = false
        if defaultArr.count == 1 || inP.row >= defaultArr.count - 1 {
            print("超过删除范围")
        } else {
    let rowNum = inP.row + 1
    defaultArr.remove(at: rowNum)
    let indexPathDatePicker = IndexPath(row: rowNum , section: 0)
    self.tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
        }
        
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if datePickerVisible && indexPath.row == sIndex + 1 {
        
            var cellD = tableView.dequeueReusableCell(withIdentifier: "reDatePicker")
//            if cellD == nil {
            cellD = UITableViewCell(style: .default, reuseIdentifier: "reDatePicker")
            cellD?.selectionStyle = .none
            let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 216))
            datePicker.tag = 100
            datePicker.locale = Locale(identifier: "zh_CN")
            datePicker.datePickerMode = .date
            cellD?.contentView.addSubview(datePicker)
            datePicker.addTarget(self, action:#selector(dateChanged(_:)),
                                 for: .valueChanged)
            
//            }
            return cellD!
        }else {
            var cell = tableView.dequeueReusableCell(withIdentifier: reuseID)!
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: reuseID)
            cell.textLabel?.text = defaultArr[indexPath.row]
            cell.textLabel?.numberOfLines = 2
            cell.detailTextLabel?.text = "2019-03-25"
            return cell
//            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    @objc func dateChanged(_ dateChanged:UIDatePicker) -> Void {
//        let formatter = DateFormatter()
//        //日期样式
//        formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
//        print(formatter.dateFormat)
        let choseDate = dateChanged.date
        let dateFormater = DateFormatter.init()
            dateFormater.dateFormat = "YYYY-MM-dd HH-mm-ss"
       print(dateFormater.string(from: choseDate))
    }
    func datetimeToString(dateTime:TimeInterval) -> String {
        let date = Date()
        let dateFormater = DateFormatter()
        dateFormater.dateFormat  = "YYYY-MM-dd"
        let str = dateFormater.string(from: date)
        print(str)
        return str
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleAction = UITableViewRowAction(style: .destructive, title: "清除") { (action, indexpath) in
            print("清除")
            self.defaultArr.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        let editAction = UITableViewRowAction(style: .default, title: "日期") { (action, indexpath) in
            print("日期")
            self.showDatePicker(inP: indexPath)
        }
        let moreAction = UITableViewRowAction(style: .normal, title: "事件") { (action, indexpath) in
            print("事件")
            
        }
        editAction.backgroundColor = UIColor.gray
        if datePickerVisible == true {
            return []
        } else {
            return [moreAction, editAction, deleAction]
        }
       
    }
    
    
    
    
//    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
//        if indexPath.section == 0 && indexPath.row == sIndex + 1 {
//            let newIndexPath = IndexPath(row: 0, section: indexPath.section)
//            print("newIndexPath->\(newIndexPath)")
//            return 3//super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
//        } else {
//            let i = super.tableView(tableView, indentationLevelForRowAt: indexPath)
//            print("i->\(i)")
//            return 2//super.tableView(tableView, indentationLevelForRowAt: indexPath)
//        }
//    }
    
    
//    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        print("leadingSwipeActions")
//        let action = UIContextualAction(style: .normal, title: "Mark") { (action, view, handler) in
//            self.updateMarkState(indexP:indexPath)
//            handler(true)
//        }
//        action.backgroundColor = UIColor.green
//
//        if markState(for: indexPath) {
//            action.title = "Unmark"
//            action.backgroundColor = UIColor.green
//        }
//
//        let configuration = UISwipeActionsConfiguration(actions: [action])
//        return configuration
//    }
//    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        print("trailingSwipeActions")
//        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
//            self.removeItem(at: indexPath)
//            handler(true)
//        }
//
//        let configuration = UISwipeActionsConfiguration(actions: [action])
//        return configuration
//
//    }
//    func  updateMarkState(indexP: IndexPath) {
////        defaultArr.append("\(indexP.row)")
//        defaultArr.insert("\(indexP.row)", at: indexP.row)
//        tableView.reloadData()
//    }
    
//    func removeItem(at: IndexPath) {
//        print("删除")
//        defaultArr.remove(at: at.row)
//        tableView.reloadData()
//    }
//    func markState(for: IndexPath) -> Bool {
//        return true
//    }
//    @objc func choseDate(datePicker:UIDatePicker) {
//        let choseDate = datePicker.date
//        let dateFormater = DateFormatter.init()
//        dateFormater.dateFormat = "YYYY-MM-dd HH-mm-ss"
//        print(dateFormater.string(from: choseDate))
//    }
    
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
    */

}
