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

// 收入与支出界面
class B: UIViewController,UITableViewDelegate,UITableViewDataSource, GADRewardBasedVideoAdDelegate, GADInterstitialDelegate {
    
    let total = ["总收入","总支出"]
    let income = ["总收入","主动收入","被动收入","工资收入","银行存款","股票红利","房产租金","商业现金","知识产权","其他收入"]
    let incomeOther = ["版权收入","专利收入","意外收入","小生意","演出","演讲","字画书法","视频博主"]
    let expenditure = ["总支出","税金","房贷","车贷","教育贷款","信用卡","维修费","医疗支出","花呗类","意外支出","小孩支出","银行贷款支出","取暖","物业","停车","加油","其他支出"]
    var incomeArr = Array<Double>()
    var expendArr = Array<Double>()
//    var totalArr  = Array<Double>()//总收入Double数据
    
    var interstitial: GADInterstitial!// Admob广告 B
    var tableV = UITableView()
    
    override func viewWillAppear(_ animated: Bool) {
        readData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        saveData() // 耗时操作
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // AdMob 2  广告页B种
        interstitial = GADInterstitial(adUnitID: AdMobcaapppubB)
        let request = GADRequest()
        interstitial.load(request)
        
        // 重复 AdMob
//        interstitial = createAndLoadInterstitial()
//        GADRewardBasedVideoAd.sharedInstance().delegate = self
        
        if incomeArr.count == 0 || expendArr.count == 0 ||  incomeArr.count != income.count {
            for _ in income {
                incomeArr.append(0.0)
                
            }
            for _ in expenditure {
                expendArr.append(0.0)
                
            }
        }
        tableV = UITableView(frame: self.view.frame, style: .grouped)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.register(UITableViewCell.self, forCellReuseIdentifier: "cellR")
        tableV.register(headerBView.self, forHeaderFooterViewReuseIdentifier: "headerB")
        tableV.register(headerB1View.self, forHeaderFooterViewReuseIdentifier: "headerC")
        view.addSubview(tableV)
    }
    
    
    
    //MARK:--向左侧滑动
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleAction = UITableViewRowAction(style: .destructive, title: "清除") { (action, indexpath) in
            //            print("A清除")
        }
        let editAction = UITableViewRowAction(style: .default, title: "编辑") { (action, indexpath) in
            //            print("编辑=====\(indexPath.section),\(indexPath.row)")
            self.showAlter(indexP: indexPath)
        }
        let moreAction = UITableViewRowAction(style: .normal, title: "更多") { (action, indexpath) in
            //            print("更多")
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
            return 300
        }
        return 40
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        if section == 0 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerB") as! headerBView
            if kScreenWidth == 1024  {
                header.imagV.image = UIImage(named: "FrogiPad1024B")
            } else if kScreenWidth >= 1366 {
                header.imagV.image = UIImage(named: "FrogiPad1366B")
            } else {
                header.imagV.image = UIImage(named: "FrogiPhone414B")
            }
            
            header.statisticsBtn.addTarget(self, action: #selector(showStatistics), for: .touchUpInside)
            header.adBtn.addTarget(self, action: #selector(showAD), for: .touchUpInside)
            return header
            
        } else {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerC") as! headerB1View
            if section == 1 {
                header.titleLab.text = "收入列表"
            } else {
                header.titleLab.text = "支出列表"
            }
            return header
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if kScreenWidth >= 1024 {
            return 100
        } else {
            return default_row_H //64
        }
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
            switch indexPath.row {
            case 0:
                detailValue = currencyAccounting(num: incomeArr[0])
            case 1:
                detailValue = currencyAccounting(num: expendArr[0])
            default:
                detailValue = "0.0"
            }
            cell?.textLabel?.text  = total[indexPath.row]
            cell?.imageView?.image = UIImage(named: "\(total[indexPath.row])")
            
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
        cell?.textLabel?.textColor = #colorLiteral(red: 0.002404888626, green: 0.3877603114, blue: 0.2272897065, alpha: 1)
        if kScreenWidth >= 1024 {
            cell?.textLabel?.font = .systemFont(ofSize: 30)
            cell?.detailTextLabel?.font = .systemFont(ofSize: 28)
        } else {
            cell?.textLabel?.font = .systemFont(ofSize: 19)
        }
        return cell!
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
    
    
    // MARK: === 谷歌广告 ====
    @objc func showAD() {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            let AD = ADVC2()
            AD.markerName = "hsi" //港股恒生指数
            self.navigationController?.pushViewController(AD, animated: true)
        }
        
        //        if GADRewardBasedVideoAd.sharedInstance().isReady == true {
        //          GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
        //        }
        
        
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
      let interstitial = GADInterstitial(adUnitID: AdMobcaapppubB)
      interstitial.delegate = self
      interstitial.load(GADRequest())
      return interstitial
    }

    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
      interstitial = createAndLoadInterstitial()
    }
    
    
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        
        let AD = ADVC2()
        AD.markerName = "hsi" //港股恒生指数
        self.navigationController?.pushViewController(AD, animated: true)
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
                                                    withAdUnitID: AdMobA)
    }
    //MARK:--- 统计
    @objc func showStatistics() {
        
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            let chartVC = CFBarChartVC()//CFRadarVC()
            chartVC.assetsArr = self.income
            chartVC.assetsValue = self.incomeArr
            chartVC.liabilities = self.expenditure
            chartVC.liabilValue = self.expendArr
            
            self.navigationController?.pushViewController(chartVC, animated: true)
        }
    }
    //MARK:--得到数据
    func getData(arr:Array<String>) -> Array<String> {
        let str = arr[0]
        var arrBack = Array<String>()
        arrBack.append(str)
        return arrBack
    }
    
    func readData() {
      
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
        tableV.reloadData()
        
    }
    
    func saveData() {
        //        print("保存数据===== B =====")
        if incomeArr.count > 0 {
            deleteClass(modelname: "Bincome")
            addCoreDataClass(arrs: [incomeArr], keyArr: ["value"], mName: "Bincome")
        }
        if expendArr.count > 0 {
            deleteClass(modelname: "Bexpend")
            addCoreDataClass(arrs: [expendArr], keyArr: ["value"], mName: "Bexpend")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - B sectionHeader=2,3
class headerB1View: UITableViewHeaderFooterView {
    
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
        titleLab.font = UIFont.boldSystemFont(ofSize: 21.0)
        // 列表子header标题
        titleLab.textColor = #colorLiteral(red: 1, green: 0.3426144123, blue: 0.2921580672, alpha: 1)
    }
    
}

class headerBView: UITableViewHeaderFooterView {
    
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
        
        
        statisticsBtn.frame = CGRect(x: self.frame.width - 50, y: 10, width: 40, height: 30)
        statisticsBtn.backgroundColor = UIColor.clear
        statisticsBtn.setImage(UIImage(named: "统计"), for: .normal)
        
        adBtn.frame = CGRect(x: 10, y: 5, width: 40, height: 40)
        adBtn.backgroundColor = UIColor.clear
        adBtn.setImage(UIImage(named: "广告"), for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




