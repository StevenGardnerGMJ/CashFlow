//
//  ADModel.swift
//  CashFlow
//
//  Created by 葛茂菁 on 2020/5/15.
//  Copyright © 2020 葛茂菁. All rights reserved.
//

import UIKit
import WebKit

class ADModel: UIViewController,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler {
    
    
     let  url_nasdaq = NSURL(string:"https://www.legulegu.com/stockdata/market/nasdaq") //纳斯达克市盈率
     let  url_dow = NSURL(string:"https://www.legulegu.com/stockdata/market/dow") //道琼斯市盈率
     let  url_sandp = NSURL(string:"https://www.legulegu.com/stockdata/market/sandp") //普标500市盈率
     let  url_hsi = NSURL(string:"https://www.legulegu.com/stockdata/market/hsi")   // 恒生指数市盈率
    
     let  url_china = NSURL(string:"https://www.legulegu.com/stockdata/market_pe")   // A股平均市盈率走势图(上证， 深证，中小板， 创业板)
    
    
    var webView =  WKWebView()
    var wknavgation = WKNavigation()
    
    
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
        configuration.userContentController.add(self, name: "ADModel")
        webView = WKWebView.init(frame: self.view.frame, configuration: configuration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view.addSubview(webView)
    }
    
   /// 请求市场 PE 网络数据
    func sendRequest() {
        let  url = NSURL(string:"https://www.legulegu.com/stockdata/market/nasdaq")
        let request = URLRequest(url:url! as URL)
        self.webView.load(request)
//        print("===========ADModel=====================")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // body
        webView.evaluateJavaScript("document.body.innerText") { (result, error) in
            
            let body = result as! String
            let cbody = body.subString(from: 40, to: 188)
//            print("===========ADModel=cbody============")
//            print(cbody)
//            print("========== ADModel = cbody.count ==============")
//            print(cbody.count)
            
            //print(cbody.split(separator: " "))//分割为数组
            
            let marketArr = cbody.split(whereSeparator: {$0 == "\n"})
            
            if marketArr.count >= 7 {
                let Vstr = marketArr[3]
                let PEstr = marketArr[4]
                let Orstr = marketArr[5]
                // 市盈率 第 3 行
                let Varr  = Vstr.split(separator: " ")
                // PE 第 4 行
                let PEarr = PEstr.split(separator: " ")
                // 来源 第5行
                let Orarr = Orstr.split(separator: " ")
                
                if Varr.count >= 3 && PEarr.count >= 3 && Orarr.count >= 2 {
                    let marketValue  = Varr[1]
                    let marketDate   = Varr[2]
                    let marketPE     = PEarr[2]
                    let marketOrigin = Orarr[1]
                    
                    let defaults = UserDefaults.standard
                    defaults.set(marketValue, forKey: "marketValue")
                    defaults.set(marketDate, forKey: "marketDate")
                    defaults.set(marketPE, forKey: "marketPE")
                    defaults.set(marketOrigin, forKey: "marketOrigin")
                    
                }
//                print(" ===========ADMob================ ")
//                print(Varr)
//                print(" ===========ADMob================ ")
//                print(PEarr)
                
            }
            
        }
    }
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // 网络数据
//        print(" ===========ADMob=message.body=网络数据============== ")
//        print(message.body)
//        print(" ===========ADMob=message.body=网络数据============== ")
        
    }
    
    
    // 请求
    func sendRequestURL(url:NSURL) {
        
        
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


