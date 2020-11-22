//
//  A.swift
//  CashFlow
//
//  Created by David on 2019/1/17.
//  Copyright © 2019年 葛茂菁. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds

// 界面A  现状界面
class A: UIViewController,UITableViewDelegate,UITableViewDataSource, GADRewardBasedVideoAdDelegate, GADInterstitialDelegate {
    
    
    let attributeName = ["status","value","myinfo"]
    let enteryName    = "Amodel"
    // 主动收入，被动收入 ， 资产，  负债，  健康， 支出
    let arrA = ["职业","小孩","工资","持有现金","月收现金","自由进度"]
    let personArr = ["职业","昵称","生活目标","常驻地","电话","E-mail"]// headerViewBtn个人信息
    var arrAnumber = Array<Double>() // 数值
    var arrMyInfo  = Array<String>() // 个人信息
    
    var dic = Dictionary<String, String>()
    let headRUID:String = "headerRUID"
    var tableVC = UITableView()
    var interstitial: GADInterstitial!// Admob广告 1
    
    
    override func viewWillDisappear(_ animated: Bool) {
        //        print("====Savedata_A======")
        saveAdata()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 一次性广告显示
        interstitial = GADInterstitial(adUnitID: AdMobcaapppubA)
        let request = GADRequest()
        interstitial.load(request)
        // 重复 广告显示
//        interstitial = createAndLoadInterstitial()
//        GADRewardBasedVideoAd.sharedInstance().delegate = self
        
        
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
        // 通知保存数据
        NotificationCenter.default.addObserver(self, selector: #selector(notication), name: NSNotification.Name(rawValue:"isTest"), object: nil)
        

        
    }
    
    
    @objc func  recordAlert() {
        
        let alert = UIAlertController(title: "\n\n\n\n\n\n\n记一笔", message: nil, preferredStyle: .alert)
        
        let imgView = UIImageView(frame: CGRect(x: 10, y: 10, width: 250, height: 150))

        imgView.image = UIImage(named: "Alert")
        print("width = \(alert.view.frame.width) height = \(alert.view.frame.height)")
        alert.view.addSubview(imgView)
        let income = UIAlertAction(title: "取消", style: .destructive) { (action) in
            // 收入
        }
        let okAction = UIAlertAction(title: "记录", style: .default, handler: {
            action in
            
            let record = ArecordViewController()
            self.navigationController?.pushViewController(record, animated: true)
        })
        alert.addAction(income)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    // 直接记录
   @objc func recordT() {
        let record = ArecordViewController()
        self.navigationController?.pushViewController(record, animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if kScreenHeight >= 1024 {
            return 2*default_row_H
        } else {
            return default_row_H //64
        }
       
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrA.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerRUID") as! headerAView
        
        if kScreenHeight >= 1024 && kScreenHeight < 1366  {
            header.imagV.image = UIImage(named: "FrogiPad1024A")
        } else if kScreenHeight >= 1366 {
            header.imagV.image = UIImage(named: "FrogiPad1366A")
        } else { // iPhone
            header.imagV.image = UIImage(named: "FrogiPhone414A")
        }
        
//        header.imagV.image = UIImage(named: "现金流headerV")
        // 昵称 --- 邮箱 ---
        if arrMyInfo[1] != "" {
            header.titleLab.text = arrMyInfo[1]
        } else if arrMyInfo[5] != "" {
            header.titleLab.text = arrMyInfo[5]
        } else {
            header.titleLab.text = "苹果公司未来CEO"//
        }
        
        header.stateBtn.addTarget(self, action: #selector(showAlterSheet), for: .touchUpInside)
        header.adBtn.addTarget(self, action: #selector(showAD), for: .touchUpInside)
        
        header.statisticsBtn.addTarget(self, action: #selector(recordAlert), for: .touchUpInside)//showStatistics
        header.recordBtn.addTarget(self, action: #selector(recordT), for: .touchUpInside)//记一笔
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
            let number = NSNumber(value: arrAnumber[indexPath.row] / 100.0)
            let percent = NumberFormatter.localizedString(from: number, number: .percent)
            cellA.detailTextLabel?.text = percent
        default:
            // 保留两位小数---财务标准显示
            let number = NSNumber(value: arrAnumber[indexPath.row])
            let detailtext = NumberFormatter.localizedString(from: number, number: .currencyAccounting)
            cellA.detailTextLabel?.text = "\(detailtext)"
        }
        if kScreenHeight >= 1024 {
            cellA.textLabel?.font = .systemFont(ofSize: 30)
            cellA.detailTextLabel?.font = .systemFont(ofSize: 28)
        } else {
            cellA.textLabel?.font = .systemFont(ofSize: 21)
        }
        cellA.textLabel?.textColor = getColor()//深色模式
        return cellA
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //        let deleteRowAction = UITableViewRowAction(style: .destructive, title: "清除") { (action, indexPath) in
        //            print("A清除")
        //        }
        let editRowAction = UITableViewRowAction(style: .default, title: "编辑") { (action, indexPath) in
            //            print("B编辑")
            let cell = tableView.cellForRow(at: indexPath)
            let title = cell?.textLabel?.text
            self.showView(title: title!, row: indexPath.row)
        }
        //        let topRowAction = UITableViewRowAction(style: .normal, title: "重要") { (action, indexPath) in
        //            print("C重要")
        //        }
        editRowAction.backgroundColor = UIColor.orange
        return [editRowAction]
    }
    
    fileprivate func getColor() -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (collection) -> UIColor in
                if (collection.userInterfaceStyle == .dark) {
                    return UIColor.gray
                }
                return UIColor.black
            }
        } else {
            return UIColor.black
        }
    }
    
    
    
    //MARK:    ------------ Google广告 ------------
    @objc func showAD() {
        
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
        
        let AD = ADVC2()
                AD.markerName = "nasdaq" // 纳斯达克
                          self.navigationController?.pushViewController(AD, animated: true)
        
        }
//        if GADRewardBasedVideoAd.sharedInstance().isReady == true {
//          GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
//        }
        
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
      let interstitial = GADInterstitial(adUnitID: AdMobcaapppubA)
      interstitial.delegate = self
      interstitial.load(GADRequest())
      return interstitial
    }

    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
      interstitial = createAndLoadInterstitial()
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
         let AD = ADVC2()
         AD.markerName = "nasdaq" // 纳斯达克
                   self.navigationController?.pushViewController(AD, animated: true)
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
      GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
          withAdUnitID: AdMobA)
    }

    
    //  统计按钮
    @objc func showStatistics() {
        
       if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
        
        let chartVC = CFchartVC()
        chartVC.valueN =  Array(arrAnumber[1...4])
        self.navigationController?.pushViewController(chartVC, animated: true)
        }
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
                    //                    print("未填写空值")
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
            //            textF.delegate = self //
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
            // String 转 Double
            let str_double:Double = Double(textStr) ?? 0 // inf应对超限 多位小数点问题
            self.arrAnumber[row] = str_double
            self.tableVC.reloadData()
        })
        alterC.addAction(cancelBtn)
        alterC.addAction(sureBtn)
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
        //        print("=== A0 保存数据 ======-")
        saveAdata()
    }
    
    func getData() {
        
        getClassA(modelname: "Amodel")
        
    }
    
    func getClassA(modelname:String) { // -> Array<Float>
        //        print("getClass")
        let context = getContext()
        var arr = Array<Double>()
        var arr2 = Array<String>()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Amodel")
        
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result : NSAsynchronousFetchResult!) in
            
            let fetchObject = result.finalResult as! [Amodel] // arr数据
            for  c in fetchObject {
                arr.append(c.value) // BLock内延迟处理
                arr2.append(c.myinfo ?? "")
                //                print("\(c.status ?? "")--\(c.value)--\(c.myinfo ?? "")")
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
            //            print("error")
        }
        
    }
    
    func saveAdata() {
        deleteClass(modelname: enteryName)
        var i = 0
        //        print("\(arrAnumber)")
        for key in arrA {
            let arrs = [key,arrAnumber[i],arrMyInfo[i]] as [Any]
            insertClass(arrays: arrs, keyArr: attributeName, modelname: enteryName)
            i = i + 1
        }
    }
    
    
    
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        //        print("interstitialDidReceiveAd")
    }
    
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        //        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        //        print("interstitialWillPresentScreen")
    }
    
    
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        //        print("interstitialWillDismissScreen")
    }

    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        //        print("interstitialWillLeaveApplication")
    }
    
}



class headerAView: UITableViewHeaderFooterView {
    
    let imagV = UIImageView() // 背景图
    let titleLab  = UILabel() // 名称
    let stateBtn  = UIButton() // 个人信息 邮箱昵称。。。
    let statisticsBtn = UIButton()// 统计按钮
    let adBtn = UIButton() // 广告
    let recordBtn = UIButton()// 点击记账
    
    
    //    var myString = "I AM KIRIT MODI"
    //    var myMutableString = NSMutableAttributedString()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.addSubview(imagV)
        contentView.addSubview(titleLab)
        contentView.addSubview(stateBtn)
        contentView.addSubview(statisticsBtn)
        contentView.addSubview(adBtn)
        contentView.addSubview(recordBtn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imagV.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height)
        imagV.backgroundColor = UIColor(white: 1, alpha: 0.3)
        statisticsBtn.frame = CGRect(x: self.contentView.frame.width - 50, y: 10, width: 40, height: 30)
        adBtn.frame = CGRect(x: 10, y: 5, width: 40, height: 40)
        titleLab.frame = CGRect(x: 5, y: 230, width: self.frame.width/2, height: 40)
        titleLab.center.x = self.center.x
        titleLab.textAlignment = .center
        titleLab.textColor = .black
        titleLab.backgroundColor = getColor()
        if kScreenHeight >= 1024 {
            titleLab.frame.origin.y = 205
            titleLab.backgroundColor = .clear
            titleLab.center.x = self.center.x + 20
            titleLab.font = UIFont.boldSystemFont(ofSize: 40)
        } else {
            titleLab.font = UIFont.boldSystemFont(ofSize: 22)
        }
        recordBtn.frame = CGRect(x: 0, y: 15, width: 100, height: 100)
        recordBtn.center.x = titleLab.center.x
        recordBtn.backgroundColor = UIColor.clear
        
        // 彩色文字       myMutableString = NSMutableAttributedString(string: titleLab.text ?? "CEOOOOOOO", attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 18.0)!])
        //        myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location:2,length:4))
        //        titleLab.attributedText = myMutableString
        
        stateBtn.frame = CGRect(x: 0, y: 0, width: kScreenWidth/2.0, height: 100)
        stateBtn.center = titleLab.center
        stateBtn.backgroundColor = UIColor.clear
        statisticsBtn.backgroundColor = UIColor.clear
        statisticsBtn.setImage(UIImage(named: "统计"), for: .normal)
        adBtn.backgroundColor = UIColor.clear
        adBtn.setImage(UIImage(named: "广告"), for: .normal)
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}









