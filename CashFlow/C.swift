//
//  C.swift
//  CashFlow
//
//  Created by David on 2019/1/17.
//  Copyright © 2019年 葛茂菁. All rights reserved.
//

import UIKit

class C: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let arrTotal = ["总资产","总负债","总人情"]
    var arrTotalValue = Array<Float>()
    
    /// 资产
    let assets = ["总资产","股票","基金","银行存款","银行存单","房地产","公寓","商铺","企业投资","其他C"]
    var assetsValue = Array<Float>()
    /// 负债
    let liabilities = ["总贷款","房贷","车贷","教育贷","信用卡","花呗类","额外负债","银行贷款","其他C"]
    var liabiValue = Array<Float>()
    // 人情往来 relations
    let relations:Float = 3
    let relatDate = Array<Date>()// 日期
    
    
    override func viewWillAppear(_ animated: Bool) {
        readData_C()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        deleteClass(modelname: "Cassets")
        deleteClass(modelname: "CLiabilities")
        saveData_C()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let tableC = UITableView(frame: self.view.frame, style: .grouped)
        tableC.delegate = self
        tableC.dataSource = self
        self.view.addSubview(tableC)
        tableC.register(UITableViewCell.self, forCellReuseIdentifier: "cellC")
        tableC.register(headerAView.self, forHeaderFooterViewReuseIdentifier: "headerA")
        tableC.register(headerCView.self, forHeaderFooterViewReuseIdentifier: "headerC")
        
        for _ in assets {
            assetsValue.append(1000)
        }
        for _ in liabilities {
            liabiValue.append(999)
        }
        arrTotalValue = [assetsValue[0],liabiValue[0], relations]
        
    }
    
    // MARK:UI Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 2 {
            let c1VC = C1.init()
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
        cell?.detailTextLabel?.text = "￥10000"
        if indexPath.section == 0 {
            cell?.textLabel?.text = arrTotal[indexPath.row]
        } else if indexPath.section == 1 {
            // 资产
            cell?.textLabel?.text = assets[indexPath.row]
        } else {
            // 负债
            cell?.textLabel?.text =   liabilities[indexPath.row]
        }
        let nameStr = cell?.textLabel?.text ?? ""
        cell?.imageView?.image = UIImage(named: nameStr)
        return cell!
    }
    

    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
      // MARK: 数据操作

    func saveData_C(){
        print("======CM=========")
        if arrTotalValue.count > 0 {
//            addCoreDataClass(arrs: [assetsValue[0], liabiValue[0], relations], keyArr:["assets","liabilities","relations"], mName: "Cmodel")
            insertClass(arrays: arrTotalValue, keyArr: ["assets","liabilities","relations"], modelname: "Cmodel")
        }
        if assetsValue.count > 0  {
            addCoreDataClass(arrs: [self.assets,self.assetsValue], keyArr: ["keyname","value"], mName: "Cassets")
        }
        if liabiValue.count > 0 {
            addCoreDataClass(arrs: [liabilities,liabiValue], keyArr:["keyname","value"], mName: "CLiabilities")
        }
    
        
    }
    func readData_C(){
        getClass(modelname: "Cmodel") { (dataModel) in
            let arr = dataModel as! [Cmodel]
            for c in arr {
                print(c.assets, c.liabilities, c.relations)
            }
            
        }
        
        getClass(modelname: "Cassets") { (data) in
            let arr = data as! [Cassets]
            for c in arr {
                print(c.keyname ?? "", c.value)
            }
        }
        
        getClass(modelname: "CLiabilities") { (dataArr) in
            let arr = dataArr as! [CLiabilities]
            for c in arr {
                print(c.keyname ?? "", c.value)
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






