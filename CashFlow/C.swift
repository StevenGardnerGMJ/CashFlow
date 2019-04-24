//
//  C.swift
//  CashFlow
//
//  Created by David on 2019/1/17.
//  Copyright © 2019年 葛茂菁. All rights reserved.
//

import UIKit

class C: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let mName_C = "Cmodel"
    let mName_Ca = "Cassets"
    let mName_Cl = "CLiabilities"
    
    /// 总
    let arrTotal = ["总资产","总负债","总人情"]
    var arrTotalValue = Array<Any>()// 统计
    
    /// 资产
    var assets = ["总资产","股票","基金","银行存款","银行存单","房地产","公寓","商铺","企业投资","其他C"]
    var assetsValue = Array<Float>()
    /// 负债
    var liabilities = ["总负债","房贷","车贷","教育贷","信用卡","花呗类","额外负债","银行贷款","其他C"]
    var liabiValue = Array<Float>()
    // 人情往来 relations
    var relations = Int()
    let relatDate = Array<Date>()// 日期
    var isNeedReadCoreDare = true
    var tableC = UITableView()
    
    var tSaveData = 0
    
    override func viewWillAppear(_ animated: Bool) {
        if isNeedReadCoreDare == true {
            readData_C()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveData_C()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if assetsValue.count == 0 || liabiValue.count == 0 {
            isNoValue(t_f: true)
        }
        // Do any additional setup after loading the view.
        tableC = UITableView(frame: self.view.frame, style: .grouped)
        tableC.delegate = self
        tableC.dataSource = self
        self.view.addSubview(tableC)
        tableC.register(UITableViewCell.self, forCellReuseIdentifier: "cellC")
        tableC.register(headerAView.self, forHeaderFooterViewReuseIdentifier: "headerA")
        tableC.register(headerCView.self, forHeaderFooterViewReuseIdentifier: "headerC")
        
    }
    
    // MARK:UI Table View Delegate
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleAction = UITableViewRowAction(style: .destructive, title: "删除") { (action, indexpath) in
          
            switch indexPath.section {
            case 1 :
                self.assets.remove(at: indexPath.row)
                self.assetsValue.remove(at: indexPath.row)
                
            case 2 :
                self.liabilities.remove(at: indexPath.row)
                self.liabiValue.remove(at: indexPath.row)
                
            default:
                print("总计")
            }
            self.tableC.deleteRows(at: [indexPath], with: .fade)
            
        }
        let cleanAction = UITableViewRowAction(style: .normal, title: "清零") { (action, indexpath) in
            print("清零值数据")
        }
        let editAction = UITableViewRowAction(style: .default, title: "数值") { (action, indexpath) in
            let cell = self.tableC.cellForRow(at: indexPath)
            let str = cell?.detailTextLabel?.text ?? ""
            self.changeValue(inP: indexPath, text: str)
        }
        editAction.backgroundColor = UIColor.gray
        // 禁用 editActionsForRowAt
        switch indexPath.section {
        case 0:
            return []
        case 1:
            if indexPath.row < 10 {
                return [editAction]
            } else {
                return [editAction, deleAction]
            }
        case 2:
            if indexPath.row < 9 {
                return [editAction]
            } else {
                return [editAction, deleAction]
            }
        default:
            //
            return [editAction, cleanAction, deleAction]
        }
        

    }
    
    func changeValue(inP:IndexPath, text:String) {
        let alterC = UIAlertController(title: "修改人情往来", message: nil, preferredStyle: .alert)
        alterC.addTextField { (textField) in
        
            var valueStr = String()
            text == "0.0" ? (valueStr = "") : (valueStr = "\(text)")
            textField.text = valueStr
            textField.keyboardType = .decimalPad
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let sureBtn = UIAlertAction(title: "确定", style: .default) { (action) in
            // Str -> Float
            let value = alterC.textFields?.last!.text ?? "0"
            let double_str = Double(value)
            let valueToNum = Float(double_str ?? 0)

            switch inP.section {
            case 1 :
                self.assetsValue[inP.row] = valueToNum
            case 2 :
                self.liabiValue[inP.row]  = valueToNum
            default:
                print("总计")
            }
            self.tableC.reloadData()  
        }
        alterC.addAction(sureBtn)
        alterC.addAction(cancel)
        self.present(alterC, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 2 {
            let c1VC = C1.init()
            c1VC.callBackBlock { (num) in
                self.relations = num
                self.isNeedReadCoreDare = false
                tableView.reloadData()
            }
            self.navigationController?.pushViewController(c1VC, animated: true)
        } else {
            
        }
    }
    
   // MARK： UI Table View Data  Source
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64 
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 200
        } else {
            return 40
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerA") as! headerAView
            headerView.imagV.image = UIImage(named: "现金流headerV")
            headerView.titleLab.text = "资产与负债表"
            return headerView
            
        } else {
            let headView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerC") as! headerCView
            if section == 1 {
                headView.titleL.text = "资产列表"
            } else {
                headView.titleL.text = "负债列表"
            }
            return headView
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else if section == 1 {
            return assets.count
        } else {
            return liabilities.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellC")
        cell = UITableViewCell(style: .value1, reuseIdentifier: "cellC")
        cell?.selectionStyle = .none

        if indexPath.section == 0 {
            cell?.textLabel?.text = arrTotal[indexPath.row]
            switch indexPath.row {
            case 0:
            cell?.detailTextLabel?.text = currencyAccounting(num: assetsValue[0])//"\(assetsValue[0])"
            case 1:
            cell?.detailTextLabel?.text = currencyAccounting(num: liabiValue[0])//"\(liabiValue[0])"
            case 2:
            cell?.detailTextLabel?.text = "\(relations)" + "次"
            default:
            print("newRow")
            }
        } else if indexPath.section == 1 {
            // 资产
            cell?.textLabel?.text = assets[indexPath.row]
            let number = assetsValue[indexPath.row]
            cell?.detailTextLabel?.text = currencyAccounting(num: number)
        } else {
            // 负债
            cell?.textLabel?.text =   liabilities[indexPath.row]
            let number = liabiValue[indexPath.row]
            cell?.detailTextLabel?.text = currencyAccounting(num: number)
        }
        let nameStr = cell?.textLabel?.text ?? ""
        cell?.imageView?.image = UIImage(named: nameStr)
        return cell!
    }
    /// 财务标准显示---货币以会计形式:例子 ￥1000.23
    func currencyAccounting(num:Float) -> String {
        let number = NSNumber(value: num)
        let strNum = NumberFormatter.localizedString(from: number, number: .currencyAccounting)
        return strNum
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
      // MARK: 数据操作

    func saveData_C(){
        tSaveData = tSaveData + 1 // var 计数器
        print("======SaveData_C \(tSaveData)=========")
        
        isNeedReadCoreDare = true
        
        if assetsValue.count > 0  {
            deleteClass(modelname: mName_Ca)
            addCoreDataClass(arrs: [self.assets,self.assetsValue], keyArr: ["keyname","value"], mName: mName_Ca)
        }
        
        if liabiValue.count > 0 {
            deleteClass(modelname: mName_Cl)
            addCoreDataClass(arrs: [liabilities,liabiValue], keyArr:["keyname","value"], mName: mName_Cl)
        }
        
        arrTotalValue = [assetsValue[0],liabiValue[0], relations]
        if arrTotalValue.count > 0 {
            deleteClass(modelname: mName_C)
            insertClass(arrays: arrTotalValue, keyArr: ["assets","liabilities","relations"], modelname: mName_C)
        }
    
        
    }
    func readData_C(){
      
        getClass(modelname: mName_Ca) { (data) in
            let arr = data as! [Cassets]
            if arr.count > 0 {
                self.assets = Array<String>()
                self.assetsValue = Array<Float>()
                for c in arr {
                    print(c.keyname ?? "", c.value)
                    self.assets.append(c.keyname ?? "")
                    self.assetsValue.append(c.value)
                }
                self.tableC.reloadData()
            }
         
        }
        
        getClass(modelname: mName_Cl) { (dataArr) in
            
            let arr = dataArr as! [CLiabilities]
            if arr.count > 0 {
                self.liabilities = Array<String>()
                self.liabiValue  = Array<Float>()
                for c in arr {
                    self.liabilities.append(c.keyname ?? "")
                    self.liabiValue.append(c.value)
                }
                self.tableC.reloadData()
            }
        }
        
        getClass(modelname: mName_C) { (dataModel) in
            let arr = dataModel as! [Cmodel]
            if arr.count > 0 {
                for c in arr {
                    print(c.assets, c.liabilities, c.relations)
                    let de = Decimal(c.relations)
                    print(de)
                    self.relations = Int(c.relations)// 仅需
                }
                self.tableC.reloadData()
            }
            
        }
        
    }
    
    func isNoValue(t_f:Bool) {
        if t_f == true {
                for _ in assets {
                    assetsValue.append(0)
                }
                for _ in liabilities {
                    liabiValue.append(0)
                }
        }
    }
   
    
    
}


/// MARK: --- 自定义View

class headerCView: UITableViewHeaderFooterView {
    let imageV = UIImageView()
    let titleL = UILabel()
    let contentBtn = UIButton()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(imageV)
        contentView.addSubview(titleL)
        contentView.addSubview(contentBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageV.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height)
        titleL.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: 40)
        titleL.textAlignment = .center
        contentBtn.frame = CGRect(x: self.contentView.frame.size.width - 60, y: 0, width: 40, height: 30)
        contentBtn.setTitle("增加", for: .normal)
        contentBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        contentBtn.setTitleColor(UIColor.black, for: .normal)
        contentBtn.backgroundColor = UIColor.clear
        contentBtn.layer.cornerRadius = 8
        contentBtn.layer.masksToBounds = true
        contentBtn.layer.borderColor = UIColor.gray.cgColor
        contentBtn.layer.borderWidth = 1
    }
    
}






