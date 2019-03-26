//
//  C.swift
//  CashFlow
//
//  Created by David on 2019/1/17.
//  Copyright © 2019年 葛茂菁. All rights reserved.
//

import UIKit

class C: UIViewController,UITableViewDelegate,UITableViewDataSource {


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 2 {
            let c1VC = C1.init()
            self.navigationController?.pushViewController(c1VC, animated: true)
        } else {
            
        }
    }
    
    
    
    
    
   //
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
            if indexPath.row == 0 {
                cell?.textLabel?.text = "总资产"
            } else if indexPath.row == 1 {
                cell?.textLabel?.text = "总负债"
            } else {
                cell?.textLabel?.text = "总人情"
            }
        } else if indexPath.section == 1 {
            // 资产
            cell?.textLabel?.text = assets[indexPath.row]
        } else {
            // 负债
            cell?.textLabel?.text =   liabilities[indexPath.row]
        }
        return cell!
    }
    

    
    
    /// 资产
    let assets = ["总成本","股票","基金","银行存款","银行存单","房地产","公寓","商铺","企业投资","其他C"]
    /// 负债
    let liabilities = ["总贷款","房贷","车贷","教育贷","信用卡","花呗类","额外负债","银行贷款","其他C"]
    // 人情往来 relations
    let relations = ["李四总送来五十大寿礼金6万","张三总送来53度飞天茅台一箱美元教育金券5w"]
    let relatDate = Array<Date>()// 日期
    
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

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






