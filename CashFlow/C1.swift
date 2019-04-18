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
    
    var datePickerVisible:Bool = false
    var sDate = "1970-01-01"
    var sIndex = 1
    var defaultArr = Array<String>() // ["添加一个新的人情往来事项"]
    var dateArr    = Array<String>() // ["1970-01-01"]
    var tempArr    = Array<String>() // 判断是否相同temp
    typealias swiftBlock = (_ str: Int) -> Void //1.0
    var callBack: swiftBlock?  //2.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.navigationController?.title = "C1"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "增加"), style: .plain, target: self, action: #selector(addRelations))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseID)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reDatePicker")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        readCoreDate_C1()
    }
    override func viewWillDisappear(_ animated: Bool) {
        saveDate_C1()
        
        // 返回传值
        let b = defaultArr.count
        if callBack != nil {
            callBack!(b)
        }
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
            hideDatePicker(inP: indexPath)
        }
    }
    
    // MARK: - Table view delegate
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
            return cellD!
        }else {
            var cell = tableView.dequeueReusableCell(withIdentifier: reuseID)!
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: reuseID)
            cell.textLabel?.text = defaultArr[indexPath.row]
            cell.detailTextLabel?.text = dateArr[indexPath.row]
            cell.textLabel?.numberOfLines = 0
            return cell
            
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleAction = UITableViewRowAction(style: .destructive, title: "清除") { (action, indexpath) in
            print("清除")
            self.defaultArr.remove(at: indexPath.row)
            self.dateArr.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        let editAction = UITableViewRowAction(style: .default, title: "日期") { (action, indexpath) in
            print("日期")
            self.showDatePicker(inP: indexPath)
        }
        let moreAction = UITableViewRowAction(style: .normal, title: "事件") { (action, indexpath) in
            print("事件")
            self.changeRelations(inP: indexPath)
        }
        editAction.backgroundColor = UIColor.gray
        if datePickerVisible == true {
            return []
        } else {
            return [moreAction, editAction, deleAction]
        }
        
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
            // 添加当前日期
            let nowDate = Date()
            let  nowStr = self.datetimeToString(date: nowDate)
            self.defaultArr.append("\(tfStr ?? "请填")")
            self.dateArr.append(nowStr)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        alterControl.addAction(sureAction)
        alterControl.addAction(cancelAction)
        self.present(alterControl, animated: true, completion: nil)
    }
    
    func changeRelations(inP:IndexPath) {
        let alterC = UIAlertController(title: "修改人情往来", message: nil, preferredStyle: .alert)
        alterC.addTextField { (textField) in
            textField.text = self.defaultArr[inP.row]
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let sureBtn = UIAlertAction(title: "确定", style: .default) { (action) in
            self.defaultArr[inP.row] =  alterC.textFields?.last!.text ?? "-- --"
            self.tableView.reloadData()
        }
        alterC.addAction(sureBtn)
        alterC.addAction(cancel)
        self.present(alterC, animated: true, completion: nil)
    }
    
    
    func showDatePicker(inP:IndexPath) {
        datePickerVisible = true
        sIndex = inP.row
        // datePicker 临时存储用数据
        let rowNum =  inP.row + 1
        defaultArr.insert("众亲平身", at: rowNum)
        dateArr.insert("1970-01-01", at: rowNum)
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
            dateArr.remove(at: rowNum)
            dateArr[inP.row] = sDate
            let indexPathDatePicker = IndexPath(row: rowNum , section: 0)
            self.tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
            self.tableView.reloadData()
        }
        
    }
    
    @objc func dateChanged(_ dateChanged:UIDatePicker) -> Void {
        //        let formatter = DateFormatter()
        //        //日期样式
        //        formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        let choseDate = dateChanged.date
        let dateStr = datetimeToString(date: choseDate)
        sDate = dateStr // 临时存储日期
    }
    
    func datetimeToString(date:Date) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat  = "YYYY-MM-dd"
        let str = dateFormater.string(from: date)
        print(str)
        return str
    }
    
    // MARK: - save  data
    
    func readCoreDate_C1() {
        getClass(modelname: "C1model") { (data) in
            let arr = data as! [C1model]
            if arr.count > 0 {
                for c1 in arr {
                    self.defaultArr.append(c1.relations ?? "")
                    self.dateArr.append(c1.dates ?? "")
                }
                self.tempArr = self.defaultArr
                self.tableView.reloadData()
            } else {
                print("warning：数据为空")
            }
        }
        
    }
    
    func saveDate_C1() {
        
        if self.defaultArr.count > 0 {
            deleteClass(modelname: "C1model")
            var i = 0
            for t in defaultArr {
                let arr = [t,dateArr[i]]
                insertClass(arrays: arr, keyArr: ["relations","dates"], modelname: "C1model")
                i = i + 1
            }
        } else {
            deleteClass(modelname: "C1model")
        }
    }
    
    func update_C1() {
        
    }
    // 3.0+
    func callBackBlock(_ block: @escaping swiftBlock) {
        callBack = block
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
    //"张三总送来53度飞天茅台一箱美元教育金券2ABCDEFG","张三总送来53度飞天茅台一箱美元教育金券3","张三总送来53度飞天茅台一箱美元教育金券4","张三总送来53度飞天茅台一箱美元教育金券5w","张三总送来53度飞天茅台一箱美元教育金券6","张三总送来53度飞天茅台一箱美元教育金券7","张三总送来53度飞天茅台一箱美元教育金券8"]
    
    // 左滑 操作
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
    // 右滑动操作
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
     // let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 300, height: 160))
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
