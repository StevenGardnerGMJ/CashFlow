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
    let personArr = ["职业","E-mail","生活目标","常驻地","电话","昵称"]// headerViewBtn个人信息
    var arrAnumber = Array<Double>() // 数值
    var arrMyInfo  = Array<String>()// 个人信息
    
    var dic = Dictionary<String, String>()
    let headRUID:String = "headerRUID"
    
    var tableVC = UITableView()
    
    override func viewWillDisappear(_ animated: Bool) {
        print("====Savedata_A======")
        saveAdata()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if arrAnumber.count != arrA.count {
            for _ in arrA {
                arrAnumber.append(0.00)// default
                arrMyInfo.append("苹果公司现任CEO")
            }
        }
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        tableVC = UITableView(frame: self.view.frame, style: .grouped)
        tableVC.delegate = self
        tableVC.dataSource = self
        self.view.addSubview(tableVC)
        
        tableVC.register(headerAView.self, forHeaderFooterViewReuseIdentifier: "headerRUID")
        tableVC.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        NotificationCenter.default.addObserver(self, selector: #selector(notication), name: NSNotification.Name(rawValue:"isTest"), object: nil)
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
        // 昵称 --- 邮箱 ---
        if arrMyInfo[5] != "" {
            header.titleLab.text = arrMyInfo[5]
        } else if arrMyInfo[1] != "" {
            header.titleLab.text = arrMyInfo[1]
        } else {
            header.titleLab.text = "苹果公司未来CEO"
        }
        
        
        header.stateBtn.addTarget(self, action: #selector(showAlterSheet), for: .touchUpInside)
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
            // 百分数 %显示
            let number = NSNumber(value: arrAnumber[indexPath.row])
            let percent = NumberFormatter.localizedString(from: number, number: .percent)
            cellA.detailTextLabel?.text = percent
        default:
            // 保留两位小数---财务标准显示
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
        editRowAction.backgroundColor = UIColor.orange
        return [editRowAction]
    }
    
    
    @objc func showAlterSheet() {
      let alterS = UIAlertController(title: "用户识别信息", message: nil, preferredStyle: .alert)
        for str in personArr {
            alterS.addTextField { (textf) in
                textf.placeholder = str
            }
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let sureAction = UIAlertAction(title: "确定", style: .default) { (action) in
            /// 空数据要不要处理 昵称h还是Email
            var i = 0
            for textF in alterS.textFields! {
                if textF.text == "" {
                    print("未填写空值")
                } else {
                    self.arrMyInfo[i] =  textF.text ?? ""
                }
                i = i + 1
            }
            self.tableVC.reloadData()
        }
        alterS.addAction(cancel)
        alterS.addAction(sureAction)
        self.present(alterS, animated: true, completion: nil)
    }
    
    
    func showView(title:String,row:Int) {
        let alterC = UIAlertController(title: "修改", message: nil, preferredStyle: .alert)
        alterC.title = "修改\(title)"
        alterC.addTextField { (textF:UITextField) in
            textF.placeholder = "请输入要修改的值"
            if row == 0 {
                textF.keyboardType = .default
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
            // String 转 Float
            let str_double:Double = Double(textStr)!
            self.arrAnumber[row] = str_double
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
    
    deinit {
        /// 移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func  notication() {
        print("=== NotificationCenter_A0---------")
        saveAdata()
    }
    
    func getData() {
        
        getClassA(modelname: "Amodel")
        
    }
    
    func getClassA(modelname:String) { // -> Array<Float>
        print("getClass")
        let context = getContext()
        var arr = Array<Double>()
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
                return self.tableVC.reloadData()
            }
            
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
        print("\(arrAnumber)")
        for key in arrA {
            let arrs = [key,arrAnumber[i],arrMyInfo[i]] as [Any]
            insertClass(arrays: arrs, keyArr: attributeName, modelname: enteryName)
            i = i + 1
        }
    }

}



class headerAView: UITableViewHeaderFooterView {
    
    let imagV = UIImageView()
    let titleLab  = UILabel()
    let stateBtn  = UIButton()
    
    
//    var myString = "I AM KIRIT MODI"
//    var myMutableString = NSMutableAttributedString()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.gray
        contentView.addSubview(imagV)
        contentView.addSubview(titleLab)
        contentView.addSubview(stateBtn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imagV.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height)
        titleLab.frame = CGRect(x: 20, y: 0.75*imagV.frame.size.height, width: self.frame.width, height: 40)
        titleLab.textAlignment = .center
        titleLab.font = UIFont.systemFont(ofSize: 24)
        
//        myMutableString = NSMutableAttributedString(string: titleLab.text ?? "CEOOOOOOO", attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 18.0)!])
//        myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location:2,length:4))
//        titleLab.attributedText = myMutableString

        stateBtn.frame = titleLab.frame
        stateBtn.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

