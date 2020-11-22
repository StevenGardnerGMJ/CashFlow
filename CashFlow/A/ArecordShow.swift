//
//  ArecordShow.swift
//  CashFlow
//
//  Created by 葛茂菁 on 2020/8/25.
//  Copyright © 2020 葛茂菁. All rights reserved.
//

import UIKit
import CoreData

// 1,Block
typealias rBlock = (Record) -> Void

class ArecordShow: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    // 2 Block
    var rblock:rBlock!
    var recordTB   = UITableView()
    var datePicker = UIDatePicker()
    var btnDate    = UIButton()
    
    var ieBool     = Bool() // 判断是收 true 还是支出 false
    var rTextField = UITextField()// 用来判断哪个TF
    var cashStr    = String() // 金额
    var titleStr   = String() // 备注
    var dateString = String() // 记录日期日期
    
    /*
     modelName: Record
     id:integer32 标记第几条数据，
     ie:Bool      正负号 true +号
     title:string 备注标题 s
     titledate    记录日期
     integer:     整数位str
     decimal:     小数位str
     */
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
        
        dateString = currentTime()// 当前日期
        
        let gap:CGFloat = 80
        let tab_w = kScreenWidth-gap
        recordTB = UITableView(frame: CGRect(x: 0, y: 0, width: tab_w, height: 375), style: .grouped)//H=375 比例较协调
        recordTB.center = self.view.center
        recordTB.center.y = self.view.center.y - 50
        recordTB.layer.cornerRadius = tab_w * 0.05
        recordTB.backgroundColor =  getColor()
        recordTB.delegate = self
        recordTB.dataSource = self
        self.view.addSubview(recordTB)
        recordTB.register(recordShowCell.self, forCellReuseIdentifier: "record")
        recordTB.register(recordDateCell.self, forCellReuseIdentifier: "date")
        recordTB.register(recordCashCell.self, forCellReuseIdentifier: "cash")
        
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: kScreenHeight - 300, width: kScreenWidth, height: 230))
        datePicker.backgroundColor = .white
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(chooseDate), for:UIControlEvents.valueChanged)
        self.view.addSubview(datePicker)
        datePicker.isHidden = true
        
        btnDate = UIButton(frame: CGRect(x: 0, y: datePicker.frame.minY, width: 25, height: 25))
        btnDate.layer.cornerRadius = btnDate.frame.width/2
        btnDate.backgroundColor = getColor()//.white
        btnDate.setImage(UIImage(named: "cancel"), for: .normal)
        btnDate.addTarget(self, action: #selector(hiddenPicker), for: .touchUpInside)
        self.view.addSubview(btnDate)
        btnDate.isHidden = true
        
        
        // X  按钮
        let btn_w:CGFloat = 50
        let cancel = UIButton(frame: CGRect(x: 0, y: recordTB.frame.minY-btn_w, width: btn_w, height: btn_w))
        cancel.center.x = tab_w/4 + gap/2
        cancel.layer.cornerRadius = cancel.frame.width/2
        cancel.backgroundColor = .white//UIColor(red: 97/255, green: 189/255, blue: 156/255, alpha: 1)
        cancel.setImage(UIImage(named: "cancel"), for: .normal)
        cancel.addTarget(self, action: #selector(cancelBtn), for: .touchUpInside)
        self.view.addSubview(cancel)
        
        // V 按钮
        let okbutn = UIButton(frame: CGRect(x: 0, y: recordTB.frame.minY-btn_w, width: btn_w, height: btn_w))
        okbutn.center.x = kScreenWidth - cancel.center.x
        okbutn.layer.cornerRadius = okbutn.frame.width/2
        okbutn.backgroundColor = .white //UIColor(red: 97/255, green: 189/255, blue: 156/255, alpha: 1)
        okbutn.setImage(UIImage(named: "okbutn"), for: .normal)
        okbutn.addTarget(self, action: #selector(okRecord), for: .touchUpInside)
        self.view.addSubview(okbutn)
        
        
    }
    // 3,Block
    func callBack(blocK:rBlock!){
        // 4,赋值闭包属性
        self.rblock = blocK
    }
    // 5,Block 属性是否不为nil 回传
    func respondsToVC(r:Record) {
        if let block = self.rblock {
           block(r)
        }
    }
    
    @objc func hiddenPicker () {
        
        datePicker.isHidden = true
        btnDate.isHidden    = true
        recordTB.reloadData()
        self.view.endEditing(true)//所有控件的键盘隐藏
    }
    
    // 点击 X
    @objc func cancelBtn() {
        self.dismiss(animated: false, completion: nil)
    }
    
    // 点击 V
    @objc func okRecord() {
        self.view.endEditing(true)//所有控件的键盘隐藏

        self.insterRecord()
        
        self.dismiss(animated: false, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let  vv = UIButton()
        vv.titleLabel?.font = .boldSystemFont(ofSize: 28)
        vv.setTitleColor(UIColor.gray, for: .normal)
        vv.addTarget(self, action: #selector(hiddenPicker), for: .touchUpInside)
        if section == 0 {
            vv.contentVerticalAlignment = .bottom
            vv.setTitle("备注", for: .normal)
        } else if section == 1 {
            vv.setTitle("金额", for: .normal)
        } else {
            vv.setTitle("日期", for: .normal)
        }
        return vv
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 2 {
            let foot = UIButton()
            foot.addTarget(self, action: #selector(hiddenPicker), for: .touchUpInside)
            return foot
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
           return 80
        }
        return 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 80 //金额距离
        } else {
            return 40
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3 // 金额 备注 日期
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "record", for: indexPath) as! recordShowCell
            rTextField = cell.textF
            cell.textF.delegate = self
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cash", for: indexPath) as! recordCashCell
            cell.textF.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "date", for: indexPath) as! recordDateCell
            cell.selectionStyle = .none
            cell.textL.text = dateString
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  indexPath.section == 2 {
            datePicker.isHidden = false
            btnDate.isHidden    = false
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == rTextField {
            titleStr = textField.text!
        } else {
            //"金额"
            cashStr = textField.text!
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        titleStr = textField.text ?? ""
        
        //收起键盘
        textField.resignFirstResponder()
        //打印出文本框中的值
        
        return true;
    }
    
    //获取选择的时间
    @objc func chooseDate(_ datePicker:UIDatePicker) {
        let  chooseDate = datePicker.date
        let  dateFormater = DateFormatter.init()
        dateFormater.dateFormat = "YYYY-MM-dd" // HH:mm:ss
//        print(dateFormater.string(from: chooseDate))
        dateString = dateFormater.string(from: chooseDate)
    }
    // 当前日期
    func currentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let date = Date()
        return dateFormatter.string(from: date)
    }
    
    
// MARK: ======================== 数据库 CoreData 操作 ====
    func insterRecord() {
        let context = getContext()
        
        let newRecord = NSEntityDescription.insertNewObject(forEntityName: "Record", into: context) as! Record
        
        let doubleValue = Double(cashStr) ?? 0
        let cash = currencyAccounting(num: doubleValue)// 财务化string
        guard cash.count != 0 else {
            return
        }
        var integer = String()
        var decimal = String()
        if cash.contains(".") == true {
            let arr = cash.split(separator: ".")
            integer = String(arr[0])
            decimal = String(arr[1])
            
        }
        
        newRecord.id        = 1
        newRecord.ie        = ieBool // 收+
        newRecord.title     = titleStr//"新的一天吃羊肉泡馍"
        newRecord.titledate = dateString//"2020-08-26"
        newRecord.integer   = integer
        newRecord.decimal   = decimal
        
        //6,Block
        self.respondsToVC(r: newRecord)
        
        do {
            try context.save()
        } catch  {
            let nserror = error as NSError
            fatalError("错误：insterRecord\(nserror),\(nserror.userInfo)")
        }
        
    }
    
    // 查找数据库：特定日期
    func queryRecordData() {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Record", in: context)
        let request = NSFetchRequest<Record>(entityName: "Record")
        request.entity = entity
        
        //创建一个谓词对象，设置提取数据的查询条件。
        //谓词被用来指定数据被获取，或者过滤的方式
        let predicate = NSPredicate(format: "titledate= '2020-08-26' ", "")
        //设置数据提取请求的谓词属性
        request.predicate = predicate
        do{
            //  执行管理对象上下文数据提取的操作，并存入一个数组
            let results:[AnyObject]? = try context.fetch(request)
            //            对提取结果进行遍历
            for r in results as! [Record]{
                print("userName=\(String(describing: r.id))")
                print("password=\(String(describing: r.titledate))")
            }
        } catch{
            print("无法获取数据:Failed to fetch data.")
        }
        
        
    }
    
    
    // 保存数:给定默认值
    func saveRecordData()->Record {
        
        let context = getContext()
        let entity  = NSEntityDescription.entity(forEntityName: "Record", in: context)!
        let recordEntity = NSManagedObject(entity: entity, insertInto: context)
        recordEntity.setValue(1, forKey: "id")
        recordEntity.setValue(true, forKey: "ie")//收入+
        recordEntity.setValue("例子：吃饭聚餐KTV看电影游乐园自", forKey: "title")
        recordEntity.setValue("2020-08-26", forKey: "titledate")
        recordEntity.setValue("654321", forKey: "integer")
        recordEntity.setValue("58", forKey: "decimal")
        
        return recordEntity as! Record

    }
    
    
    
    
    
}


class recordCashCell: UITableViewCell {
    // 金额
    let textF = UITextField()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(textF)
    }
    
    override func layoutSubviews() {
        self.backgroundColor = getColor()
        textF.frame = CGRect(x: 10, y: 0, width: self.frame.width-20, height: self.frame.height)
        textF.font = .systemFont(ofSize: 24)
        textF.placeholder = "填写费用金额"
        textF.keyboardType = .decimalPad
        textF.borderStyle = .line
        textF.borderStyle = .roundedRect
        textF.layer.borderColor = UIColor.lightGray.cgColor
    }
}

class recordShowCell: UITableViewCell {
    // 备注
    let textF = UITextField()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(textF)
    }
    
    override func layoutSubviews() {
        self.backgroundColor = getColor()
        textF.frame = CGRect(x: 10, y: 0, width: self.frame.width-20, height: self.frame.height)
        textF.font = .systemFont(ofSize: 24)
        textF.placeholder = "填写备注信息"
        textF.borderStyle = .line  // 矩形框
        textF.borderStyle = .roundedRect// 圆角加阴影
        textF.layer.borderColor = UIColor.lightGray.cgColor
        textF.returnKeyType = UIReturnKeyType.done //return完成输入
        textF.autocapitalizationType = .none// 首字母不大写
        textF.autocorrectionType     = .no// 关闭更正
        textF.adjustsFontSizeToFitWidth = true  //当文字超出文本框宽度时，自动调整文字大小
        textF.minimumFontSize = 11  //最小可缩小的字号
        
    }
}


class recordDateCell: UITableViewCell {
    // 日期
    let textL = UILabel()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(textL)
    }
    
    override func layoutSubviews() {
        self.backgroundColor = getColor()
        textL.frame = CGRect(x: 10, y: 0, width: self.frame.width-20, height: self.frame.height)
        textL.backgroundColor = getColor()//UIColor.white
        textL.font = .systemFont(ofSize: 24)
        textL.textAlignment = .center
        textL.layer.cornerRadius  = 5
        textL.layer.masksToBounds = true
        textL.layer.borderWidth   = 1.5
        textL.layer.borderColor   = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1).cgColor
    }
}


// 深色模式
fileprivate func getColor() -> UIColor {
    if #available(iOS 13.0, *) {
        return UIColor { (collection) -> UIColor in
            if (collection.userInterfaceStyle == .dark) {
                return UIColor.clear
            }
            return UIColor(white: 0.95, alpha: 1)
        }
    } else {
        return UIColor(white: 0.95, alpha: 1)
    }
}

// 会计计数
func currencyAccounting(num:Double) -> String {
    let num = NSNumber(value: num)
    let strNum = NumberFormatter.localizedString(from: num, number: .currencyAccounting)
    return strNum
}


