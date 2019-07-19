//
//  B.swift
//  CashFlow
//
//  Created by David on 2019/1/17.
//  Copyright © 2019年 葛茂菁. All rights reserved.
//
//  参考：三方库模仿Mail.app的SwipeCellKit

import UIKit
import GoogleMobileAds

class B: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let total = ["总收入","总支出"]
    let income = ["总收入","主动收入","被动收入","工资收入","银行存款","股票红利","房产租金","商业现金","知识产权","其他收入"]
    let incomeOther = ["版权收入","专利收入","意外收入","小生意","演出","演讲","字画书法","视频博主"]
    let expenditure = ["总支出","税金","房贷","车贷","教育贷款","信用卡","维修费","医疗支出","花呗类","意外支出","小孩支出","银行贷款支出","取暖","物业","停车","加油","其他支出"]
    var incomeArr = Array<Double>()
    var expendArr = Array<Double>()
    var totalArr  = Array<Double>()
    
    var interstitial: GADInterstitial!// Admob 1
    
    override func viewWillAppear(_ animated: Bool) {
        readData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        saveData() // 耗时操作
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleAction = UITableViewRowAction(style: .destructive, title: "清除") { (action, indexpath) in
            print("A清除")
        }
        let editAction = UITableViewRowAction(style: .default, title: "编辑") { (action, indexpath) in
            print("编辑=====\(indexPath.section),\(indexPath.row)")
            self.showAlter(indexP: indexPath)
        }
        let moreAction = UITableViewRowAction(style: .normal, title: "更多") { (action, indexpath) in
            print("更多")
        }
        editAction.backgroundColor = UIColor.init(red: 255/255.0, green: 204/255.0, blue: 0/255.0, alpha: 1.0)
        if indexPath.section == 0 {
            return []
        } else {
            return [editAction]
        }
        
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
            header.statisticsBtn.addTarget(self, action: #selector(showStatistics), for: .touchUpInside)
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
        
        // AdMob 2  //青蛙广告页A ca-app-pub-9319054953457119/9902763490
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
//        interstitial.delegate = self // Admob
        let request = GADRequest()
        interstitial.load(request)
        
        if incomeArr.count == 0 || expendArr.count == 0 ||  incomeArr.count != income.count {
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
    
    func showAlter(indexP:IndexPath) {
        let altetCon = UIAlertController(title: "修改项目的数值", message: nil, preferredStyle: .alert)
        altetCon.addTextField { (textf) in
            textf.keyboardType = .decimalPad
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (action) in
        }
        let sureAction = UIAlertAction(title: "确定", style: .default) { (action) in
            let strValue = altetCon.textFields?.last?.text ?? "0.0"
            let doubleValue = Double(strValue) ?? 0
            switch indexP.section {
            case 1:
                self.incomeArr[indexP.row] = doubleValue
            case 2:
                self.expendArr[indexP.row] = doubleValue
            default:
                print("第0号统计section")
            }
            self.totalArr[0] = self.incomeArr[0]
            self.totalArr[1] = self.expendArr[0]
            self.tableV.reloadData()
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
    
    @objc func showStatistics() {
        
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
            let chartVC = CFBarChartVC()//CFRadarVC()
            chartVC.assetsArr = self.income
            chartVC.assetsValue = self.incomeArr
            chartVC.liabilities = self.expenditure
            chartVC.liabilValue = self.expendArr
            
            self.navigationController?.pushViewController(chartVC, animated: true)
        }
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
            self.incomeArr = Array<Double>()
            for c in arr {
                self.incomeArr.append(c.value)
            }
                self.tableV.reloadData()
            }
        }
        getClass(modelname: "Bexpend") { (dataArr) in
            let arr = dataArr as! [Bexpend]
            if arr.count > 0 {
            self.expendArr = Array<Double>()
            for c in arr {
                self.expendArr.append(c.value)
            }
                self.tableV.reloadData()
        }
        }
        
    }
    
    func saveData() {
        print("保存数据===== B =====")
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



