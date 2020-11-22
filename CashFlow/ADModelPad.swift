//
//  ADModelPad.swift
//  CashFlow
//
//  Created by 葛茂菁 on 2020/8/4.
//  Copyright © 2020 葛茂菁. All rights reserved.
//

import UIKit
import WebKit

class ADModelPad: UIViewController,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler {
    
    
     let  url_nasdaq = NSURL(string:"https://www.legulegu.com/stockdata/market/nasdaq") //纳斯达克市盈率
     let  url_dow    = NSURL(string:"https://www.legulegu.com/stockdata/market/dow") //道琼斯市盈率
     let  url_sandp  = NSURL(string:"https://www.legulegu.com/stockdata/market/sandp") //普标500市盈率
     let  url_hsi    = NSURL(string:"https://www.legulegu.com/stockdata/market/hsi")   // 恒生指数市盈率
     let  url_china  = NSURL(string:"https://www.legulegu.com/stockdata/market_pe")   // A股平均市盈率走势图(上证， 深证，中小板， 创业板)
    
    
//    var webView =  WKWebView()
    var wknavgation = WKNavigation()
    
//    var wkweb   = WKWebView()
    
    
    var wkweb_nasdaq = WKWebView()
    var wkweb_dow    = WKWebView()
    var wkweb_sandp  = WKWebView()
    var wkweb_hsi    = WKWebView()
    var wkweb_china  = WKWebView()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 加载数据时间21.7秒
        
    }
    
    func loadADwebView() {
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.userContentController = WKUserContentController()
        configuration.userContentController.add(self, name: "ADModel")//JS
    
        print("===========ADModelPad=====================")

        
        
        let preference = WKPreferences()
        preference.javaScriptEnabled = true
        let configuratio = WKWebViewConfiguration()
        configuratio.preferences = preference
        configuratio.userContentController = WKUserContentController()
        configuratio.userContentController.add(self, name: "ADMode")//JS
        
        
        let nasdaq = URLRequest(url: url_nasdaq! as URL)
        wkweb_nasdaq = WKWebView(frame: self.view.frame, configuration: configuration)
        wkweb_nasdaq.uiDelegate = self
        wkweb_nasdaq.navigationDelegate = self
        wkweb_nasdaq.load(nasdaq)
        
        
        let dow = URLRequest(url: url_dow! as URL)
        wkweb_dow = WKWebView(frame: self.view.frame, configuration: configuration)
        wkweb_dow.uiDelegate = self
        wkweb_dow.navigationDelegate = self
        wkweb_dow.load(dow)
        
        let sandp = URLRequest(url: url_sandp! as URL)
        wkweb_sandp = WKWebView(frame: self.view.frame, configuration: configuration)
        wkweb_sandp.uiDelegate = self
        wkweb_sandp.navigationDelegate = self
        wkweb_sandp.load(sandp)
        
        let hsi = URLRequest(url: url_hsi! as URL)
        wkweb_hsi = WKWebView(frame: self.view.frame, configuration: configuration)
        wkweb_hsi.uiDelegate = self
        wkweb_hsi.navigationDelegate = self
        wkweb_hsi.load(hsi)
        
        
        let china = URLRequest(url: url_china! as URL)
        wkweb_china = WKWebView(frame: self.view.frame, configuration: configuration)
        wkweb_china.uiDelegate = self
        wkweb_china.navigationDelegate = self
        wkweb_china.load(china)
        
     
        
        
        
    }
    

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
//        print(" ====A==B==C==D===== ")
        
        
        
        
        // body
        webView.evaluateJavaScript("document.body.innerText") { (result, error) in
            

            switch webView {
            case self.wkweb_nasdaq:
                print("========nasdaq=============")
                let body = result as! String
                let cbody = body.subString(from: 122, to: 270)
                self.marketStringToArr(cbody: cbody, mName: "nasdaq")
                
            case self.wkweb_dow:
                print("=========== dow ============")
                let body = result as! String
                let cbody = body.subString(from: 122, to: 270)
                self.marketStringToArr(cbody: cbody, mName: "dow")
                
            case self.wkweb_sandp:
                print("========== sandp ============")
                let body = result as! String
                let cbody = body.subString(from: 122, to: 270)
                self.marketStringToArr(cbody: cbody, mName: "sandp")
                
            case self.wkweb_hsi:
                print("========== hsi  =============")
                let body = result as! String
                let cbody = body.subString(from: 122, to: 270)
                self.marketStringToArr(cbody: cbody, mName: "hsi")
                
            case self.wkweb_china:
                print("========== china =============")
                let body = result as! String
                let cbody = body.subString(from: 122, to: 270)
                self.markerChinaArr(cbody:cbody ,mName:"china")
                
            default:
                print("未知市场指数")
            }
            
            
        }
        
        
    }
    
    // 中国市场
    func markerChinaArr(cbody:String,mName:String) {
        
        // 以回车切分为 7 行
        let marketArr = cbody.split(whereSeparator: {$0 == "\n"})
        
//        print(cbody)
        
        if marketArr.count >= 7 {
            let Vstr  = marketArr[3] //上 证: 15.84 深 证: 33.5
            let PEstr = marketArr[4] //中小板: 36.56 创业板: 61.92  2020-08-03
            let Orstr = marketArr[5] //(数据来源: 上交所 深交所)
            // 市盈率 第 3 行
            let Varr  = Vstr.split(separator: " ")
            // PE 第 4 行
            let PEarr = PEstr.split(separator: " ")
            // 来源 第5行
//            let Orarr = Orstr.split(separator: " ")
            
//            print(" =========== China ================ ")
//            print(Varr)
//            print(PEarr)
//            print(Orstr)
            
            if Varr.count >= 7 &&  PEarr.count >= 7 {
                let marketVale = Vstr.prefix(22)//上 证: 15.84 深 证: 33.32
                let marketPE = PEarr[0] + PEarr[1] + PEarr[2] + PEarr[3]//PEarr[0...3]
                let marketDate = Varr[6] //2020-08-03
                let markerOri  = PEarr[4]+PEarr[5]+PEarr[6]//(数据来源: 上交所 深交所)
                
                let defaults = UserDefaults.standard
                // 股市指数 中国市场
                defaults.set(marketVale, forKey: "\(mName)marketValue")
                // PE值
                defaults.set(marketPE, forKey: "\(mName)marketPE")
                // 日期
                defaults.set(marketDate, forKey: "\(mName)marketDate")
                // 数据来源
                defaults.set(markerOri, forKey: "\(mName)marketOrigin")
                
            }
            
        }
        
        
    }
    
    
    
    
    func marketStringToArr(cbody:String,mName:String) {
        
//        print("========== ADModel = cbody ============")
//        print(cbody)
//        print("========== ADModel = cbody.count ==============")
//        print(cbody.count)
        
         // 以回车切分为 7 行
        let marketArr = cbody.split(whereSeparator: {$0 == "\n"})
        
        if marketArr.count >= 7 {
            let Vstr  = marketArr[3]// 3行
            let PEstr = marketArr[4]
            let Orstr = marketArr[5]
            // 市盈率 第 3 行
            let Varr  = Vstr.split(separator: " ")
            // PE 第 4 行
            let PEarr = PEstr.split(separator: " ")
            // 来源 第5行
            let Orarr = Orstr.split(separator: " ")
            
            // 容错防止数据变化 超越数组崩溃  美股市场
            if Varr.count >= 3 && PEarr.count >= 5 && Orarr.count >= 2 {
                let marketValue  = Varr[1]
                let marketDate   = Varr[2]
                let marketPE     = PEarr[2]
                let marketOrigin = PEarr[4]
                
                let defaults = UserDefaults.standard
                // 股市指数
                defaults.set(marketValue, forKey: "\(mName)marketValue")
                // 日期
                defaults.set(marketDate, forKey: "\(mName)marketDate")
                // PE值
                defaults.set(marketPE, forKey: "\(mName)marketPE")
                // 数据来源
                defaults.set(marketOrigin, forKey: "\(mName)marketOrigin")
                
            } else if Varr.count >= 3 && PEarr.count >= 4  {
                // 港股市场
                let marketValue  = Varr[1]
                let marketDate   = Varr[2]
                let marketPE     = PEarr[1] // ["平均市盈率:", "10.28"]
                let marketOrigin = PEarr[3]
                
                let defaults = UserDefaults.standard
                // 股市指数
                defaults.set(marketValue, forKey: "\(mName)marketValue")
                // 日期
                defaults.set(marketDate, forKey: "\(mName)marketDate")
                // PE值
                defaults.set(marketPE, forKey: "\(mName)marketPE")
                // 数据来源
                defaults.set(marketOrigin, forKey: "\(mName)marketOrigin")
                
                
                
            }
        
//            print(" ===========ADMob================ ")
//            print(Varr)
//            print(PEarr)
//            print(Orarr)
        }
        
        
    }
    
    
    
    
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // 网络数据
        print(" ===========ADMob=message.body=网络数据userContentController============== ")
        print(message.body)
        print(" ===========ADMob=message.body=网络数据userContentController============== ")
        
    }
    

    
    ///  MARK:- 暂时不启用 ：清空操作，默认值操作 此为容错处理
    func userDefaults() {
        // 清除所有UserDefaults
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
        
        let defaults = UserDefaults.standard
        defaults.set("暂无数据", forKey: "marketValue")
        defaults.set("暂无数据", forKey: "marketDate")
        defaults.set("暂无数据", forKey: "marketPE")
        defaults.set("暂无数据", forKey: "marketOrigin")
    }
    
    
}
