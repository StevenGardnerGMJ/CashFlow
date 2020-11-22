//
//  ArecordViewController.swift
//  CashFlow
//
//  Created by 葛茂菁 on 2020/8/23.
//  Copyright © 2020 葛茂菁. All rights reserved.
//

import UIKit
import CoreData



private let H1:CGFloat = 15
private let H0:CGFloat = 100 + 4*H1
//private let rowHiPad:CGFloat   = 112
private let rowHiphone:CGFloat = 64/667 * kScreenHeight

class ArecordViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var recoredTableV = UITableView()
    var arrRecord = Array<Record>()
    var isChanged = false // 是否编辑过cell
    
    let colorIn  = UIColor(red: 97/255, green: 189/255, blue: 156/255, alpha: 1)
    let colorOut = UIColor(red: 176/255, green: 23/255, blue: 31/255, alpha: 1)
    
    
    
    // 记一笔 流水账
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title  = "记一笔"
        self.getRecord() // 取数据
        
        recoredTableV = UITableView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight), style: .grouped)
        recoredTableV.delegate = self
        recoredTableV.dataSource = self
        recoredTableV.register(recordCell.self, forCellReuseIdentifier: "resuer")
        self.view.addSubview(recoredTableV)
//        recoredTableV.backgroundColor = UIColor(white: 0.95, alpha: 1)
        recoredTableV.tableFooterView = nil // 默认高度20
        recoredTableV.sectionFooterHeight = 0
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if isChanged == true { // 进行过删除数据操作
            deleteClass(modelname: "Record") // 收支记录表
            saveRecord()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return H0
        } else {
            return H1
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return rowHiphone
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let v  = recordHeaderView()
            
            v.btnIn.addTarget(self, action: #selector(showRecordIn), for: .touchUpInside)
            v.btnIn.tag  = 1
            v.btnOut.addTarget(self, action: #selector(showRecordIn), for: .touchUpInside)
            v.btnOut.tag = 0
            return v
        } else {
            return nil
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrRecord.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resuer", for: indexPath) as! recordCell
        
        cell.selectionStyle = .none
        
        let r = arrRecord[indexPath.section]
        
        let ii =  r.ie ? "+" : "-" //三目 true + false -
        cell.btn.backgroundColor = ii == "+" ? colorIn : colorOut
        
        let str1:String = r.title ?? "支"
        let str2 = str1.trimmingCharacters(in: .whitespaces)
        let str3:String = String(str2.prefix(1))
        cell.btn.setTitle(str3, for: .normal)
        
        
        cell.labtitle1.text = r.title
        cell.labdate.text   = r.titledate
        cell.labtitle2.text = ii + (r.integer ?? "0" )
        cell.labtitle3.text = ".\(r.decimal ?? "00")"
        
        return cell
        
    }
    //MARK:向左侧滑动
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteSection = UITableViewRowAction(style: .destructive, title: "删除") { (action, indexP) in
            let alert = UIAlertController(title: "\n\n要删除？\n\n", message: nil, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "取消", style: .default, handler: nil)
            let delete = UIAlertAction(title: "删除", style: .destructive) { (act) in
                self.arrRecord.remove(at: indexPath.section)
                //                self.recoredTableV.deleteSections(IndexSet(integer: indexPath.section), with: .bottom)
                self.isChanged = true // 删除过数据
                self.recoredTableV.reloadData()
            }
            alert.addAction(cancel)
            alert.addAction(delete)
            self.present(alert, animated: true) {
                // 重置数据表？
            }
        }
        return [deleteSection]
    }
    
    
    
    
    // MARK: -- 收+支—点击操作 ---
    @objc func showRecordIn(btn:UIButton) {
        let arsVC = ArecordShow()
        
//        if kScreenHeight >= 1024 {
          arsVC.modalPresentationStyle = .currentContext
//        }
        if btn.tag == 1 {
            arsVC.ieBool = true // 收+
        } else { //tag 0
            arsVC.ieBool = false // 收+
        }
        
        arsVC.callBack { (newRecord) in
            // 添加回调数据
            self.arrRecord.insert(newRecord, at: 0)
            self.recoredTableV.reloadData()
        }
        self.present(arsVC, animated: true) {
            
        }
    }
    
    //MARK:-数据库操作
    func getRecord()  {
        
        getClass(modelname: "Record") { (arr) in
            
            let fetchObject = arr as! [Record]
            
            for r in fetchObject.reversed() {
                self.arrRecord.append(r)
            }
            //
            // 给定默认值
            if self.arrRecord.count == 0 {
                // 调用下级界面方法获取Record
                let defRecord = ArecordShow().saveRecordData()
                self.arrRecord.append(defRecord)
            }
            self.recoredTableV.reloadData()
        }
    }
    
    func saveRecord() {
        
        for r in arrRecord.reversed() {
            
            let context = getContext()
            let entity  = NSEntityDescription.entity(forEntityName: "Record", in: context)!
            let recordEntity = NSManagedObject(entity: entity, insertInto: context) as! Record
            recordEntity.id = r.id
            recordEntity.ie = r.ie
            recordEntity.title = r.title
            recordEntity.titledate = r.titledate
            recordEntity.integer = r.integer
            recordEntity.decimal = r.decimal
            
            do {
                try context.save()
            } catch  {
                let nsrror = error as NSError
                fatalError("错误：saveRecordData\(nsrror), \(nsrror.userInfo)")
            }
            
        }
        
    }
    
    
// ---数据库结束----
}


class recordHeaderView:UITableViewHeaderFooterView {
    let backgroundV = UIView()
    var btnIn  = UIButton()
    var btnOut = UIButton()
    
    
    
    override func layoutSubviews() {
        backgroundV.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height-H1)
        backgroundV.backgroundColor = UIColor(red: 70/255, green: 61/255, blue: 71/255, alpha: 1)
        
        
        let center_x = (kScreenWidth-200)/3.0 + 50
        btnIn.frame = CGRect(x: 0, y: 2*H1, width: 100, height: 100)
        btnIn.center.x = center_x
        btnIn.backgroundColor = UIColor(red: 97/255, green: 189/255, blue: 156/255, alpha: 1)
        btnIn.setTitle("收+", for: .normal)
        btnIn.setTitleColor(UIColor.white, for: .normal)
        btnIn.titleLabel?.font = .boldSystemFont(ofSize: 34)
        btnIn.setTitleShadowColor(UIColor.gray, for: .normal)
        btnIn.layer.cornerRadius = 50
        
        
        btnOut.frame = CGRect(x: 0, y: 2*H1, width: 100, height: 100)
        btnOut.center.x = kScreenWidth - center_x
        btnOut.backgroundColor = UIColor(red: 252/255, green: 57/255, blue: 81/255, alpha: 1)
        btnOut.setTitle("支-", for: .normal)
        btnOut.setTitleColor(UIColor.white, for: .normal)
        btnOut.titleLabel?.font = .boldSystemFont(ofSize: 34)
        btnOut.setTitleShadowColor(UIColor.gray, for: .normal)
        btnOut.layer.cornerRadius = 50
        
        
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addSubview(backgroundV)
        self.addSubview(btnIn)
        self.addSubview(btnOut)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class recordCell:UITableViewCell {
    
    let b_f:CGFloat = kScreenHeight <= 667 ? 24 : 34
    
    let btn = UIButton()//收支+-圆 img1
    let labtitle1 = UILabel() // 备注1
    let labdate   = UILabel() // 日期
    let labtitle2 = UILabel() // 整数
    let labtitle3 = UILabel() // 小数部分
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(btn)
        self.addSubview(labtitle1)
        self.addSubview(labdate)
        self.addSubview(labtitle3)
        self.addSubview(labtitle2)
        
    }
    override func layoutSubviews() {
        
        let topY:CGFloat = 15/896 * kScreenHeight
        let btn_w = rowHiphone-20
        btn.frame = CGRect(x: 10, y: 10, width: btn_w, height:btn_w)
        //        btn.backgroundColor = UIColor(red: 97/255, green: 189/255, blue: 156/255, alpha: 1)
        //        btn.setTitle("吃", for: .normal)
        btn.layer.cornerRadius = btn.frame.height/2
        btn.titleLabel?.font = .boldSystemFont(ofSize: b_f)
        btn.setTitleColor(UIColor.white, for: .normal)
        
        
        labtitle3.frame = CGRect(x: kScreenWidth - 30, y: topY, width: 30, height: 20)
        labtitle3.center.y = btn.center.y + 1
        labtitle3.textColor = btn.backgroundColor
        labtitle3.textAlignment = .left
        labtitle3.font = .systemFont(ofSize: 14)
        //        labtitle3.text = ".98"
        
        let lab2_w:CGFloat = 80
        labtitle2.frame = CGRect(x: labtitle3.frame.minX-lab2_w, y: topY, width: lab2_w, height: 30)
        labtitle2.center.y = btn.center.y
        labtitle2.textColor = btn.backgroundColor
        labtitle2.textAlignment = .right
        labtitle2.font = .systemFont(ofSize: 18)
        //        labtitle2.text = "-654321"
        
        
        let lab1_w = labtitle2.frame.minX - btn.frame.maxX - 10
        labtitle1.frame = CGRect(x: btn.frame.maxX+10, y: topY, width: lab1_w, height: 30)
        labtitle1.center.y = self.frame.height/3.0
        labtitle1.textColor = btn.backgroundColor
        //        labtitle1.text = "吃饭聚餐KTV早晚中约会过山车看电影吃火锅"
        labtitle1.numberOfLines = 0
        
        
        labdate.frame = CGRect(x: labtitle1.frame.origin.x, y: labtitle1.frame.maxY, width: labtitle1.frame.width, height: 20)
        //        labdate.text = "2020-08-25 10:10:18"
        labdate.textColor = UIColor.gray
        
    }
    
}
