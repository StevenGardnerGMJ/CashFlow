//
//  ADVC2.swift
//  CashFlow
//
//  Created by 葛茂菁 on 2020/7/23.
//  Copyright © 2020 葛茂菁. All rights reserved.
//

import UIKit

class ADVC2: UIViewController {
    
    
    let marketName = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let defaults = UserDefaults.standard
                let mVale:String = defaults.string(forKey: "marketValue") ?? "暂无数据"
                let mPE:String   = defaults.string(forKey: "marketPE") ?? "暂无数据"
                let mDate:String = defaults.string(forKey: "marketDate") ?? "暂无数据"
                let mOrig:String = defaults.string(forKey: "marketOrigin") ?? "暂无数据"
                
                let marketValu = UILabel()
                marketValu.text = "纳斯达克指数: \(mVale)"
                marketValu.font = .boldSystemFont(ofSize: 27)
                marketValu.textColor = UIColor.red
                let PE = UILabel()
                PE.text = "市盈率(P/E Ratio): \(mPE)"
                PE.font = .boldSystemFont(ofSize: 27)
                PE.textColor = UIColor.red
                let dateTime = UILabel()
                dateTime.text = "(\(mDate))(数据来源: \(mOrig)"
                dateTime.font = .systemFont(ofSize: 21)
                dateTime.textColor = .darkGray
                
                
                let viewWith:CGFloat = self.view.frame.width
                let y_f:CGFloat = self.view.frame.height / 3.0
                let v_h:CGFloat = 40
                
                marketValu.frame = CGRect(x: 20, y: y_f, width: viewWith, height: v_h)
                PE.frame  = CGRect(x: 20, y: y_f + 50, width: viewWith, height: v_h)
                dateTime.frame = CGRect(x: 20, y: y_f + 100, width: viewWith, height: v_h)
                view.addSubview(marketValu)
                view.addSubview(PE)
                view.addSubview(dateTime)
              
                marketName.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height / 2.0)
                marketName.center = view.center
                marketName.numberOfLines = 0
                
                view.addSubview(marketName)

        
    }
    

 

}
