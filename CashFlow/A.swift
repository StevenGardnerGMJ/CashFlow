//
//  A.swift
//  CashFlow
//
//  Created by David on 2019/1/17.
//  Copyright © 2019年 葛茂菁. All rights reserved.
//

import UIKit
import CoreData


class A: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let attributeName = ["status","value","myinfo"]
    let enteryName    = "Amodel"
    let arrA = ["职业","小孩","工资","持有现金","月收现金","自由进度"]// 主动收入，被动收入
    var arrAnumber = Array<Float>()
    var arrMyInfo  = Array<String>()
    
    let arrDefault = ["职业","E-mail","生活目标","常驻地","电话","昵称"]
    
    var myStateDic = Dictionary<String, Float>()
    var dic = Dictionary<String, String>()
    let headRUID:String = "headerRUID"
    
    var tableVC = UITableView()
    
    override func viewWillDisappear(_ animated: Bool) {
        print("====Savedata_A======")
        saveAdata()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        tableVC = UITableView(frame: self.view.frame, style: .grouped)
        tableVC.delegate = self
        tableVC.dataSource = self
        self.view.addSubview(tableVC)
        
        tableVC.register(headerAView.self, forHeaderFooterViewReuseIdentifier: "headerRUID")
        tableVC.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        getData()
    }
    
    func getData() {
        
        getClassA(modelname: "Amodel")
        if arrAnumber.count != arrA.count {
            for _ in arrA {
                arrAnumber.append(Float(1.00))// default
                arrMyInfo.append("苹果公司现任CEO")
            }
        }
        self.tableVC.reloadData()
    }
    
    func getClassA(modelname:String) { // -> Array<Float>
        print("getClass")
        let context = getContext()
        var arr = Array<Float>()
        var arr2 = Array<String>()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Amodel")
        
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result : NSAsynchronousFetchResult!) in
            
            let fetchObject = result.finalResult as! [Amodel] // arr数据
            for  c in fetchObject {
                arr.append(c.value) // BLock内延迟处理
                arr2.append(c.myinfo ?? "")
                print("\(c.status ?? "")--\(c.value)--\(c.myinfo ?? "")")
            }
            guard arr.count == 0, arr2.count == 0 else {
                self.arrAnumber = arr
                self.arrMyInfo  = arr2
                return
            }
            self.tableVC.reloadData()
        }
        // 执行异步请求调用execute
        do {
            try context.execute(asyncFetchRequest)
        } catch  {
            print("error")
        }
        
    }
    
    func saveAdata() {
        deleteClass(modelname: enteryName)
        var i = 0
        for key in arrA {
            let arrs = [key,arrAnumber[i],arrMyInfo[i]] as [Any]
            insertClass(arrays: arrs, keyArr: attributeName, modelname: enteryName)
            i = i + 1
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return default_row_H //64
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrA.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerRUID") as! headerAView
        header.imagV.image = UIImage(named: "现金流headerV")
        header.titleLab.text = arrMyInfo[1]
        return header
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    var cellA = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cellA = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        cellA.textLabel?.text  = arrA[indexPath.row]
        cellA.imageView?.image = UIImage(named: arrA[indexPath.row])
        
        
        switch indexPath.row {
        case 0:
            let detailtext = arrMyInfo[0]
            cellA.detailTextLabel?.text = "\(detailtext)"
        case 5:
            let number = NSNumber(value: arrAnumber[indexPath.row])
            let percent = NumberFormatter.localizedString(from: number, number: .percent)
            cellA.detailTextLabel?.text = percent
        default:
            let number = NSNumber(value: arrAnumber[indexPath.row])
            let detailtext = NumberFormatter.localizedString(from: number, number: .currencyAccounting)
            cellA.detailTextLabel?.text = "\(detailtext)"
        }
        return cellA
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteRowAction = UITableViewRowAction(style: .destructive, title: "清除") { (action, indexPath) in
            print("A清除")
        }
        let editRowAction = UITableViewRowAction(style: .default, title: "编辑") { (action, indexPath) in
            print("B编辑")
            let cell = tableView.cellForRow(at: indexPath)
            let title = cell?.textLabel?.text
            self.showView(title: title!, row: indexPath.row)
        }
        let topRowAction = UITableViewRowAction(style: .normal, title: "重要") { (action, indexPath) in
            print("C重要")
        }
        editRowAction.backgroundColor   = UIColor.gray
       
        return [deleteRowAction,editRowAction,topRowAction]
    }
    func destructive() {
    
    }
    
    
    
    func showView(title:String,row:Int) {
        let alterC = UIAlertController(title: "修改", message: nil, preferredStyle: .alert)
        alterC.title = "修改\(title)"
        alterC.addTextField { (textF:UITextField) in
            textF.placeholder = "请输入要修改的值"
            if row == 0 {
                textF.keyboardType =  .default
            } else {
                textF.keyboardType = .decimalPad
            }
        }
        
        let cancelBtn = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let sureBtn = UIAlertAction(title: "确定", style: .default, handler: { (action) in
            var textStr:String = (alterC.textFields?.last?.text)!
            if row == 0 {
                self.arrMyInfo[0] = textStr
                textStr = "0.01" } //0号位职业
            let str_double:Double = Double(textStr)!
            let value = Float(str_double)
            self.arrAnumber[row] = value
           self.tableVC.reloadData()
        })
        alterC.addAction(cancelBtn)
        alterC.addAction(sureBtn)
        
//        DispatchQueue.main.async {
       self.present(alterC, animated: true, completion: nil)

        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class headerAView: UITableViewHeaderFooterView {
    
    let imagV = UIImageView()
    let titleLab  = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.gray
        contentView.addSubview(imagV)
        contentView.addSubview(titleLab)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imagV.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height)
        titleLab.frame = CGRect(x: self.bounds.width*1/4, y: 0.75*imagV.frame.size.height, width: self.frame.width/2, height: 40)
        titleLab.textAlignment = .center
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

