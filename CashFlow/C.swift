//
//  C.swift
//  CashFlow
//
//  Created by David on 2019/1/17.
//  Copyright © 2019年 葛茂菁. All rights reserved.
//

import UIKit
import GoogleMobileAds

// 资产与负债界面
class C: UIViewController,UITableViewDelegate,UITableViewDataSource, GADRewardBasedVideoAdDelegate, GADInterstitialDelegate {
    
    
    
    let mName_C = "Cmodel"
    let mName_Ca = "Cassets"
    let mName_Cl = "CLiabilities"
    
    /// 总
    let arrTotal = ["总资产","总负债","总人情"]
    var arrTotalValue = Array<Any>()// 统计
    
    /// 资产
    var assets = ["总资产","股票","基金","银行存款","银行存单","房地产","公寓","商铺","企业投资","其他资产"]
    var assetsValue = Array<Double>()
    /// 负债
    var liabilities = ["总负债","房贷","车贷","教育贷","信用卡","花呗类","额外负债","银行贷款","其他负债"]
    var liabiValue = Array<Double>()
    // 人情往来 relations
    var relations = Int()
    let relatDate = Array<Date>()// 日期
    var isNeedReadCoreDare = true
    var tableC = UITableView()
    var interstitial: GADInterstitial!// Admob广告 C
    
    
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
        
        // AdMob 2 广告页C种
        interstitial = GADInterstitial(adUnitID: AdMobcaapppubC)
        let request = GADRequest()
        interstitial.load(request)
        
        // 重复 广告
//        interstitial = createAndLoadInterstitial()
//        GADRewardBasedVideoAd.sharedInstance().delegate = self
        
        
        if assetsValue.count == 0 || liabiValue.count == 0 {
            isNoValue(t_f: true)
        }
        // Do any additional setup after loading the view.
        tableC = UITableView(frame: self.view.frame, style: .grouped)
        tableC.delegate = self
        tableC.dataSource = self
        self.view.addSubview(tableC)
        tableC.register(UITableViewCell.self, forCellReuseIdentifier: "cellC")
        tableC.register(headerCView.self, forHeaderFooterViewReuseIdentifier: "headerA")
        tableC.register(headerC1View.self, forHeaderFooterViewReuseIdentifier: "headerC")
        
    }
    
    
    // MARK:UI Table View Delegate
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let titleAction = UIContextualAction(style: .normal, title: "名称") { (action, view, handeler) in
            //            print("修改资产项目名称")
            
            let oldname = tableView.cellForRow(at: indexPath)?.textLabel?.text
            
            self.changeName(inP:indexPath, oldName: oldname ?? "")
            handeler(true)
        }
        titleAction.backgroundColor = .init(red: 76/255.0, green: 217/255.0, blue: 100/255.0, alpha: 1.0)
        //.init(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1.0)
        var config = UISwipeActionsConfiguration(actions: [titleAction])
        // 禁用 leadingSwipeActions
        switch indexPath.section {
        case 0:
            config = UISwipeActionsConfiguration(actions: [])
        case 1:
            if indexPath.row < 10 {
                config = UISwipeActionsConfiguration(actions: [])
            }
        case 2:
            if indexPath.row < 9 {
                config = UISwipeActionsConfiguration(actions: [])
            }
        default:
            print("禁用 leadingSwipeActions")
        }
        return  config
    }
    
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
            //            print("清零值数据")
        }
        let editAction = UITableViewRowAction(style: .default, title: "数值") { (action, indexpath) in
            let cell = self.tableC.cellForRow(at: indexPath)
            let str = cell?.detailTextLabel?.text ?? ""
            self.changeValue(inP: indexPath, text: str)
        }
        editAction.backgroundColor = UIColor.orange
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if kScreenHeight >= 1024 {
            return 100
        } else {
            return default_row_H //64
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 300
        } else {
            return 40
        }
    }
    
    // MARK： UI Table View Data  Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else if section == 1 {
            return assets.count
        } else {
            return liabilities.count
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerA") as! headerCView
            if kScreenWidth == 1024  {
                headerView.imagV.image = UIImage(named: "FrogiPad1024C")
            } else if kScreenWidth >= 1366 {
                headerView.imagV.image = UIImage(named: "FrogiPad1366C")
            } else {
                headerView.imagV.image = UIImage(named: "FrogiPhone414C")
            }
            
            headerView.statisticsBtn.addTarget(self, action: #selector(showStatistics), for: .touchUpInside)
            headerView.adBtn.addTarget(self, action: #selector(showAD), for: .touchUpInside)
            return headerView
            
        } else {
            let headView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerC") as! headerC1View
            if section == 1 {
                headView.titleL.text = "资产列表"
                headView.contentBtn.tag = 1
            } else {
                headView.titleL.text = "负债列表"
                headView.contentBtn.tag = 2
            }
            headView.contentBtn.addTarget(self, action:#selector(newAssetsLib), for: .touchUpInside)
            
            return headView
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
                cell?.detailTextLabel?.text = currencyAccounting(num: assetsValue[0])
            case 1:
                cell?.detailTextLabel?.text = currencyAccounting(num: liabiValue[0])
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
        cell?.textLabel?.textColor = #colorLiteral(red: 0.6056007743, green: 0.2474309206, blue: 0.0722637102, alpha: 1)
        
        if kScreenHeight >= 1024 {
            cell?.textLabel?.font = .systemFont(ofSize: 30)
            cell?.detailTextLabel?.font = .systemFont(ofSize: 28)
        } else {
            cell?.textLabel?.font = .systemFont(ofSize: 19)
        }
        return cell!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeValue(inP:IndexPath, text:String) {
        let alterC = UIAlertController(title: "修改该项金额值", message: nil, preferredStyle: .alert)
        alterC.addTextField { (textField) in
            
            //            var valueStr = String()
            //            text == "0.0" ? (valueStr = "") : (valueStr = "\(text)")
            //            textField.text = valueStr
            textField.keyboardType = .decimalPad
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let sureBtn = UIAlertAction(title: "确定", style: .default) { (action) in
            // Str -> Double
            let value = alterC.textFields?.last!.text ?? "0"
            let double = Double(value) ?? 0
            switch inP.section {
            case 1 :
                self.assetsValue[inP.row] = double
            case 2 :
                self.liabiValue[inP.row]  = double
            default:
                print("总计")
            }
            self.tableC.reloadData()
        }
        alterC.addAction(sureBtn)
        alterC.addAction(cancel)
        self.present(alterC, animated: true, completion: nil)
    }
    
    
    // MARK: ========= 广告 ========
    @objc func showAD() {
        
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            
            let AD = ADVC2()
            AD.markerName = "china" // 中国股市
            self.navigationController?.pushViewController(AD, animated: true)
        }
        
        //        if GADRewardBasedVideoAd.sharedInstance().isReady == true {
        //          GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
        //        }
        
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
      let interstitial = GADInterstitial(adUnitID: AdMobcaapppubC)
      interstitial.delegate = self
      interstitial.load(GADRequest())
      return interstitial
    }

    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
      interstitial = createAndLoadInterstitial()
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        
        let AD = ADVC2()
        AD.markerName = "china" // 中国股市
        self.navigationController?.pushViewController(AD, animated: true)
    }
    // 下一次
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
                                                    withAdUnitID: AdMobA)
    }
    
    // 柱状图 
    @objc func showStatistics() {
        
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            let chartVC = CFBarChartVC()// CFLineChartVC()
            chartVC.assetsArr   = self.assets
            chartVC.assetsValue = self.assetsValue
            chartVC.liabilities = self.liabilities
            chartVC.liabilValue = self.liabiValue
            self.navigationController?.pushViewController(chartVC, animated: true)
        }
    }
    
    
    @objc func newAssetsLib(inP:UIButton){
        
        var row = 0
        switch inP.tag  {
        case 1:
            assets.append("新添加资产项")
            assetsValue.append(0.0)
            row = assets.count - 1
        case 2:
            liabilities.append("新添加负债项")
            liabiValue.append(0.0)
            row = liabilities.count - 1
        default:
            print("其他")
        }
        // 刷新位置信息
        let indexset = IndexSet(integer: inP.tag)
        self.tableC.reloadSections(indexset, with: .automatic)
        // 滚动到新增位置 bottom
        let position = IndexPath(row: row, section: inP.tag)
        self.tableC.scrollToRow(at: position, at: .middle, animated: true)
    }
    
    
    func changeName(inP:IndexPath, oldName:String) {
        let alter = UIAlertController(title: "修改项目类型名", message: nil, preferredStyle: .alert)
        alter.addTextField { (textfied) in
            //            textfied.text = oldName
        }
        let sureAction = UIAlertAction(title: "确定", style: .default) { (action) in
            switch inP.section {
            case 1 :
                self.assets[inP.row] = alter.textFields?.last?.text ?? "-----"
            case 2 :
                self.liabilities[inP.row] = alter.textFields?.last?.text ?? "-----"
            default:
                print("总计")
            }
            self.tableC.reloadData()
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alter.addAction(cancelAction)
        alter.addAction(sureAction)
        self.present(alter, animated: true, completion: nil)
        
    }
    
    
    /// 财务标准显示---货币以会计形式:例子 ￥1000.23
    func currencyAccounting(num:Double) -> String {
        let number = NSNumber(value: num)
        let strNum = NumberFormatter.localizedString(from: number, number: .currencyAccounting)
        return strNum
    }
    
    
    /// MARK: 数据操作
    
    func readData_C(){
        
        getClass(modelname: mName_Ca) { (data) in
            let arr = data as! [Cassets]
            if arr.count > 0 {
                self.assets = Array<String>()
                self.assetsValue = Array<Double>()
                for c in arr {
                    //                    print(c.keyname ?? "", c.value)
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
                self.liabiValue  = Array<Double>()
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
                    //                    print(c.assets, c.liabilities, c.relations)
//                    let de = Decimal(c.relations)
                    //                    print(de)
                    self.relations = Int(c.relations)// 仅需
                }
                self.tableC.reloadData()
            }
            
        }
        
    }
    
    func saveData_C(){
        
        //        print("======SaveData_C =========")
        
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


/// MARK: -------C界面 头部 负债列表
class headerC1View: UITableViewHeaderFooterView {
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
        //  子列表header标题
        titleL.textColor = #colorLiteral(red: 0.4218756557, green: 0.681618154, blue: 0.07648370415, alpha: 1)
        titleL.font = UIFont.boldSystemFont(ofSize: 21.0)
        
        contentBtn.frame = CGRect(x: self.contentView.frame.size.width - 60, y: 0, width: 40, height: 30)
        contentBtn.setTitle("增加", for: .normal)
        contentBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
//        contentBtn.setTitleColor(UIColor.black, for: .normal)
        contentBtn.backgroundColor = UIColor.gray
        contentBtn.layer.cornerRadius = 8
        contentBtn.layer.masksToBounds = true
        contentBtn.layer.borderColor = UIColor.gray.cgColor
        contentBtn.layer.borderWidth = 1
    }
    
}

class headerCView: UITableViewHeaderFooterView {
    
    let imagV = UIImageView() // 背景图
    let statisticsBtn = UIButton()// 统计按钮
    let adBtn = UIButton()   // 广告按钮
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.gray
        contentView.addSubview(imagV)
        contentView.addSubview(statisticsBtn)
        contentView.addSubview(adBtn)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imagV.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height)
        statisticsBtn.frame = CGRect(x: self.contentView.frame.width - 50, y: 10, width: 40, height: 30)
        adBtn.frame = CGRect(x: 10, y: 5, width: 40, height: 40)
    
        statisticsBtn.backgroundColor = UIColor.clear
        statisticsBtn.setImage(UIImage(named: "统计"), for: .normal)
        adBtn.backgroundColor = UIColor.clear
        adBtn.setImage(UIImage(named: "广告"), for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




