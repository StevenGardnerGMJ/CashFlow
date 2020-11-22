//
//  ADVC2.swift
//  CashFlow
//
//  Created by 葛茂菁 on 2020/7/23.
//  Copyright © 2020 葛茂菁. All rights reserved.
//

import UIKit

class ADVC2: UIViewController {
    
    var markerName  = String() /// 判断哪个市场
    let warningArr  = [
     "凛冬已至在未冻死的冰壳下面说不定藏着一棵参天大树种子",
     "冷风嗖嗖的低温市场里或许能抄到宝投资也需谨慎",
     "天朗气清温暖如初夏若非人为操控可以活动一下",
     "市场这么热闹了是时候该离场了",
     "资本市场这么狂热爱卿赶紧撤吧",
     "当前市场处于不断变化状态投资需要谨慎从事"
     ]
    private var marketValu = UILabel()
    private var PE         = UILabel()
    private var dateTime   = UILabel()
    private var weatherLabel = UILabel()
    private var weatherImgV  = UIImageView()
    private var tempA        = UILabel()
    private var tempB        = UILabel()
    private var warningLab   = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 深色模式
        if #available(iOS 13.0, *) {
            let currentMode = UITraitCollection.current.userInterfaceStyle
            if (currentMode == .dark) {
                print("深色模式")
            } else if (currentMode == .light) {
                print("浅色模式")
                self.view.backgroundColor = .white
            } else {
                print("未知模式")
            }
        } else {
            self.view.backgroundColor = .white
        }
        
        
        // 中国市场
        marketValu = UILabel()
        marketValu.font = .boldSystemFont(ofSize: 27)
        marketValu.textColor = UIColor.red
        marketValu.textAlignment = .center
        
        PE = UILabel()
        PE.font = .boldSystemFont(ofSize: 27)
        PE.textColor = UIColor.red
        PE.textAlignment = .center
        
        
        dateTime = UILabel()
        dateTime.font = .systemFont(ofSize: 19)
        dateTime.textColor = .darkGray
        dateTime.numberOfLines = 2
        dateTime.textAlignment = .center
        
        
        // 纳斯达克 市盈率 数据来源 位置
        let viewWith:CGFloat = self.view.frame.width
        let y_f:CGFloat = self.view.frame.height / 2.0
        let v_h:CGFloat = 40
        
        marketValu.frame = CGRect(x: 20, y: y_f, width: viewWith, height: v_h)
        PE.frame  = CGRect(x: 20, y: y_f + 50, width: viewWith, height: v_h)
        dateTime.frame = CGRect(x: 20, y: y_f + 100, width: viewWith, height: v_h)
        marketValu.center.x = self.view.center.x
        PE.center.x         = self.view.center.x
        dateTime.center.x   = self.view.center.x
        view.addSubview(marketValu)
        view.addSubview(PE)
        view.addSubview(dateTime)
        
        let swipGestureleft = UISwipeGestureRecognizer(target: self, action: #selector(changeMarket))
        swipGestureleft.direction = .left
//        marketValu.isUserInteractionEnabled = true
//        PE.isUserInteractionEnabled = true
//        dateTime.isUserInteractionEnabled = true
//        marketValu.addGestureRecognizer(swipGestureleft)
//        PE.addGestureRecognizer(swipGestureleft)
//        dateTime.addGestureRecognizer(swipGestureleft)
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(swipGestureleft)
        
        let swipGestureright = UISwipeGestureRecognizer(target: self, action: #selector(changeMarket))
        swipGestureright.direction = .right
         self.view.addGestureRecognizer(swipGestureright)
        

        
        let y_y = 100/667 * kScreenHeight
        weatherLabel = UILabel(frame: CGRect(x: 0, y: y_y, width: kScreenWidth/2, height: 40))
        weatherLabel.center.x = self.view.center.x
        weatherLabel.text = "当前市场天气"
        weatherLabel.font = .boldSystemFont(ofSize: 24)
        weatherLabel.textAlignment = .center
        self.view.addSubview(weatherLabel)
        
        let w_center = weatherLabel.center.x - 80
        weatherImgV = UIImageView(frame: CGRect(x: w_center, y: weatherLabel.frame.maxY + 10, width: 80, height: 80))
        self.view.addSubview(weatherImgV)
        
        tempA = UILabel(frame: CGRect(x: weatherImgV.frame.maxX + 10, y: weatherLabel.frame.maxY+10, width: 80, height: 40))
        
        tempA.textAlignment = .center
        self.view.addSubview(tempA)
        
        tempB = UILabel(frame: CGRect(x: weatherImgV.frame.maxX + 10, y: tempA.frame.maxY , width: 80, height: 40))
        
        tempB.textAlignment = .center
        self.view.addSubview(tempB)
        
        
        warningLab = UILabel(frame: CGRect(x: 0, y: tempB.frame.maxY + 10, width: kScreenWidth, height: 40))
        warningLab.textAlignment = .center
        self.view.addSubview(warningLab)
        
        
        // 小建议
        let infoLabel = contactLabel()
        self.view.addSubview(infoLabel)
        
        // 市场数据
        self.markerData()
        
        self.iPadScreen ()
        
    }
    
    // 改变市场
    @objc func changeMarket() {
        
        switch markerName {
        case "nasdaq":
          // 如果纳斯达克 则换为道琼斯
          markerName = "dow"
        case "dow":
             // 如果道琼斯 则换为普标500
            markerName = "sandp"
        case "sandp":
            // 如果普标500 则换为纳斯达克
            markerName = "nasdaq"
        default:
            return
        }
        UIView.animate(withDuration: 1) {
            self.markerData()
        }
        
    }
    
    
    
    
    func markerData(){
        var nameStr = String() // 市场名称
               /// 判断哪个市场
               switch markerName {
               case "nasdaq":
                   nameStr = "纳斯达克"
               case "dow":
                   nameStr = "道琼斯"
               case "sandp":
                   nameStr = "普标500"
               case "hsi":
                   nameStr = "恒生指数"
               case "china":
                   nameStr = "中国股市"
                   
               default:
                   nameStr = "暂无数据"
               }
        let defaults = UserDefaults.standard
        let mVale:String = defaults.string(forKey: "\(markerName)marketValue") ?? "暂无数据"
        let mPE:String   = defaults.string(forKey: "\(markerName)marketPE") ?? "暂无数据"
        let mDate:String = defaults.string(forKey: "\(markerName)marketDate") ?? "暂无数据"
        let mOrig:String = defaults.string(forKey: "\(markerName)marketOrigin") ?? "暂无数据"
        // (hot,img,mPE)
        var hot  = String();var img  = String();
        var mPEt = String();var warn = String();
        
        if markerName == "china" {
            marketValu.text = "\(mVale)"
            let arr = mVale.split(separator: " ")//以空格切分
            if arr.count >= 3 {
                let mpe = arr[2]
                (hot,img,mPEt,warn) = weatherMarket(mPE: String(mpe))
            } else {
                (hot,img,mPEt,warn) = weatherMarket(mPE: "暂无数据")
            }
        } else {
            marketValu.text = "\(nameStr)指数: \(mVale)"
        }
        if markerName == "china" {
                   PE.text = "\(mPE)"
               } else {
                   PE.text = "市盈率(P/E Ratio): \(mPE)"
                   (hot,img,mPEt,warn) = weatherMarket(mPE: String(mPE))
               }
        if markerName == "china" {
                  dateTime.text = "(\(mDate))\(mOrig)"
               } else {
                  dateTime.text = "(\(mDate))(数据来源: \(mOrig)"
               }
        weatherImgV.image = UIImage(named: "\(img)")
        tempA.text = "\(hot)"
        tempB.text = "\(mPEt)度"
        warningLab.text = warn
    }
    
    
    
    func weatherMarket(mPE:String)->(A:String,B:String,C:String,D:String) {
        
        print("=====mPE=====\(mPE)======")
        var hot  = String()
        var img  = String()
        var warn = String()
//        let mPE = "35.4"
         var PE = Double()
        if mPE == "暂无数据" || mPE == "" {
            PE = 1234
        } else {
            PE = Double(mPE)!
        }
        
        switch PE {
        case 0..<10.00:
            hot = "冰封"; img = "frozen";warn = warningArr[0]
        case 10.00..<15.00:
            hot = "低温"; img = "coldDay";warn = warningArr[1]
        case 15.00..<20.00:
            hot = "偏热"; img = "warmDay";warn = warningArr[2]
        case 20.00..<25.00:
            hot = "过热"; img = "sunndyDay";warn = warningArr[3]
        case 25.00..<999.00 :
            hot = "高温"; img = "Hotweather";warn = warningArr[4]
        default:
            hot = "天气"; img = "sunndyDay";warn = warningArr[5]
        }
        
        return (hot,img,mPE,warn)
        
    }
    
    func  iPadScreen () {
        if kScreenWidth >= 1024 {
            marketValu.font = .boldSystemFont(ofSize: 40)
            PE.font = .boldSystemFont(ofSize: 40)
            dateTime.font = .systemFont(ofSize: 32)
           
            
            weatherLabel.font = .boldSystemFont(ofSize: 50)
            weatherImgV.frame.size = CGSize(width: 160, height: 160)
            weatherImgV.center.x = weatherLabel.center.x - weatherImgV.frame.size.width/2
            let sizeW = weatherImgV.frame.size.width
            tempA.font = .systemFont(ofSize: 40)
            tempA.frame.size = CGSize(width: sizeW, height: sizeW/2)
            tempB.font = .systemFont(ofSize: 40)
            tempB.frame.size = tempA.frame.size
            tempB.frame.origin.y = tempA.frame.maxY
            warningLab.frame.origin.y = weatherImgV.frame.maxY + 20
            warningLab.font = .systemFont(ofSize: 37)
        }
    }
    
    
    
    
    
    
    
    
    // 尘埃科技有限责任公司 Dust Technology Co., Ltd
    
}
