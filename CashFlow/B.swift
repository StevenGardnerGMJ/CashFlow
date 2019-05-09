//
//  B.swift
//  CashFlow
//
//  Created by David on 2019/1/17.
//  Copyright © 2019年 葛茂菁. All rights reserved.
//
//  参考：三方库模仿Mail.app的SwipeCellKit

import UIKit


class B: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let total = ["总收入","总支出"]
    let income = ["总收入","主动收入","被动收入","工资收入","银行存款","股票红利","房产租金","商业现金","知识产权","其他收入"]
    let incomeOther = ["版权收入","专利收入","意外收入","小生意","演出","演讲","字画书法","视频博主"]
    let expenditure = ["总支出","税金","房贷","车贷","教育贷款","信用卡","维修费","医疗支出","花呗类","意外支出","小孩支出","银行贷款支出","取暖","物业","停车","加油","其他支出"]
    var incomeArr = Array<Double>()
    var expendArr = Array<Double>()
    var totalArr  = Array<Double>()
    
    override func viewWillAppear(_ animated: Bool) {
        readData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        saveData()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleAction = UITableViewRowAction(style: .destructive, title: "清除") { (action, indexpath) in
            print("A清除")
        }
        let editAction = UITableViewRowAction(style: .default, title: "编辑") { (action, indexpath) in
            self.showAlter()
            print("编辑")
        }
        let moreAction = UITableViewRowAction(style: .normal, title: "更多") { (action, indexpath) in
            print("更多")
        }
        editAction.backgroundColor = UIColor.gray
        return [editAction]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 200
        }
        return 40
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
      
        if section == 0 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerB") as! headerAView
            header.imagV.image = UIImage(named: "现金流headerV")
            header.titleLab.text = "现金流量报表"
            return header
            
        } else {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerC") as! headerBView
            if section == 1 {
                header.titleLab.text = "收入列表"
            } else {
                header.titleLab.text = "支出列表"
            }
            return header
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return default_row_H // 64
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return income.count
        } else if section == 2 {
           return expenditure.count
        } else {
            return 2 // section 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellR")
        cell = UITableViewCell(style: .value1, reuseIdentifier: "cellR")
        var detailValue = String()
        switch indexPath.section{
        case 0:
            cell?.textLabel?.text  = total[indexPath.row]
            cell?.imageView?.image = UIImage(named: "\(total[indexPath.row])")
            detailValue = currencyAccounting(num: totalArr[indexPath.row])
        case 1:
            cell?.textLabel?.text  = income[indexPath.row]
            cell?.imageView?.image = UIImage(named: "\(income[indexPath.row])")
            detailValue = currencyAccounting(num: incomeArr[indexPath.row])
        case 2:
            cell?.textLabel?.text  = expenditure[indexPath.row]
            cell?.imageView?.image = UIImage(named: "\(expenditure[indexPath.row])")
            detailValue = currencyAccounting(num: expendArr[indexPath.row])
        default:
             cell?.textLabel?.text = "B"
        }
        cell?.detailTextLabel?.text = detailValue
        return cell!
    }
    
    
    var tableV = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if incomeArr.count == 0 || expendArr.count == 0 {
            for _ in income {
                incomeArr.append(0.0)
                totalArr.append(incomeArr[0])
            }
            for _ in expenditure {
                expendArr.append(0.0)
                totalArr.append(expendArr[0])
            }
        }
        tableV = UITableView(frame: self.view.frame, style: .grouped)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.register(UITableViewCell.self, forCellReuseIdentifier: "cellR")
        tableV.register(headerAView.self, forHeaderFooterViewReuseIdentifier: "headerB")
        tableV.register(headerBView.self, forHeaderFooterViewReuseIdentifier: "headerC")
        view.addSubview(tableV)
    }
    
    func showAlter() {
        let altetCon = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        altetCon.addTextField { (textf) in
            <#code#>
        }
        let sureAction = UIAlertAction(title: "确定", style: .default) { (action) in
            <#code#>
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (action) in
            <#code#>
        }
        altetCon.addAction(cancel)
        altetCon.addAction(sureAction)
        self.present(altetCon, animated: true, completion: nil)
    }
    
    // 会计计数
    func currencyAccounting(num:Double) -> String {
        let num = NSNumber(value: num)
        let strNum = NumberFormatter.localizedString(from: num, number: .currencyAccounting)
        return strNum
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData(arr:Array<String>) -> Array<String> {
        PrintCCLog("得到数据")
        let str = arr[0]
        var arrBack = Array<String>()
        arrBack.append(str)
        return arrBack
    }
    
    func readData() {
//        getClass(modelname: "Bmodel") { (dataArr) in
//            let arr = dataArr as! [Bmodel]
//            for c in arr {
//                self.totalArr.append(c.income)
//                self.totalArr.append(c.outcome)
//            }
//        }
        getClass(modelname: "Bincome") { (dataArr) in
            let arr = dataArr as! [Bincome]
            if arr.count > 0 {
            for c in arr {
                self.incomeArr.append(c.value)
            }
                self.tableV.reloadData()
            }
        }
        getClass(modelname: "Bexpend") { (dataArr) in
            let arr = dataArr as! [Bexpend]
            if arr.count > 0 {
            for c in arr {
                self.expendArr.append(c.value)
            }
                self.tableV.reloadData()
        }
        }
        
    }
    
    func saveData() {
        print("保存数据===== B =====")
//        insertClass(arrays: <#T##Array<Any>#>, keyArr: <#T##Array<String>#>, modelname: "Bincome")
        if incomeArr.count > 0 {
            deleteClass(modelname: "Bincome")
            addCoreDataClass(arrs: [incomeArr], keyArr: ["value"], mName: "Bincome")
        }
        if expendArr.count > 0 {
            deleteClass(modelname: "Bexpend")
            addCoreDataClass(arrs: [expendArr], keyArr: ["value"], mName: "Bexpend")
        }
        
    }
    
    
    

}


class headerBView: UITableViewHeaderFooterView {
    
    let imagV     = UIImageView()
    let titleLab  = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(imagV)
        contentView.addSubview(titleLab)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLab.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        titleLab.textAlignment = .center
        titleLab.font = UIFont.systemFont(ofSize: 21.0)
    }
    
}



