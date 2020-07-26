//
//  ADVC1.swift
//  CashFlow
//
//  Created by gemaojing on 2020/4/29.
//  Copyright © 2020 葛茂菁. All rights reserved.
//

import UIKit
import WebKit

class ADVC1: UIViewController,UITextFieldDelegate,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler {
    
    

    var webView =  WKWebView()
    let marketName = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
//     纳斯达克指数 NASDAQ: 7417.86  字体大红27号
//     市盈率(P/E Ratio): 22.7      字体大红27号
//     (2020-03-24)(数据来源: CNN)  灰色19号

        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.userContentController = WKUserContentController()
        configuration.userContentController.add(self, name: "AppModel")
        webView = WKWebView.init(frame: self.view.frame, configuration: configuration)
        webView.scrollView.bounces = true
        webView.scrollView.alwaysBounceVertical = true
        webView.navigationDelegate = self
        webView.uiDelegate = self
//        view.addSubview(webView)
        
        
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
        
        
//         sendRequest() //ADVC1 加载web数据
        

        let str:String = "斯达克市盈率纳斯达克市盈率NASDAQ NMS COMPOSITE INDEX P/E RatioNASDAQ: 9814.08 2020-06-05市盈率(P/E Ratio): 32.2(数据来源: CNN)2020年6月5纳斯达克市盈率市盈率(PE)32.2免责声明：上述数据不构成有关任何证券、金融产品或"
                let rang1 = str.range(of: "免责声明")!
                let subStr_Prefix_upTo = str.prefix(upTo: rang1.lowerBound)
                let subStr_Prefix_through = str.prefix(through: rang1.lowerBound)
        //        print(subStr_Prefix_upTo)
        //        print(subStr_Prefix_through)
                
                let range: Range = str.range(of: ":")!
                let location: Int = str.distance(from: str.startIndex, to: range.lowerBound)
        //        print(location)
                let fstr:Substring = str[str.index(after: range.lowerBound)..<str.endIndex]
        //        print(fstr)
         let dataFrom = UILabel()
       
    }
    
    
//
//    func sendRequest() {
//         let  url = NSURL(string:"https://www.legulegu.com/stockdata/market/nasdaq")
//         let request = URLRequest(url:url! as URL)
//         self.webView.load(request)
//
//    }
    
    

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
    }
    

    
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        // body
//        webView.evaluateJavaScript("document.body.innerText") { (result, error) in
//
//            let body = result as! String
//            let cbody = body.subString(from: 40, to: 210)
//            print(cbody)
//            print(cbody.count)
//
//            self.marketName.text = cbody
//            print(cbody.split(separator: " "))//分割为数组
//            print(cbody.split(whereSeparator: {$0 == "\n"}))
//            //            print("---result\(String(describing: result))---\n------- result")
//            let marketArr = cbody.split(whereSeparator: {$0 == "\n"})
//            if marketArr.count >= 7 {
//                let Vstr = marketArr[3]
//                let PEstr = marketArr[4]
//                let Varr  = Vstr.split(separator: " ")
//                let PEarr = PEstr.split(separator: " ")
//
//                if Varr.count >= 3 && PEarr.count >= 5 {
//                    let marketValue = Varr[1]
//                    let marketDate  = Varr[2]
//                    let marketPE    = PEarr[2]
//                    let marketOrigin = PEarr[4]
//
//                    let defaults = UserDefaults.standard
//                    defaults.set(marketValue, forKey: "marketValue")
//                    defaults.set(marketDate, forKey: "marketDate")
//                    defaults.set(marketPE, forKey: "marketPE")
//                    defaults.set(marketOrigin, forKey: "marketOrigin")
//
//                }
//                print(" ==========ADVC1========== ========")
//                print(Varr)
//                print(" ==========ADVC1========== =========")
//                print(PEarr)
//
//            }
//
//        }
//    }
    
    
    
    
}




// 字符串扩展截取操作
extension String {
    /// 截取到任意位置
    func subString(to: Int) -> String {
        let index: String.Index = self.index(startIndex, offsetBy: to)
        return String(self[..<index])
    }
    /// 从任意位置开始截取
    func subString(from: Int) -> String {
        let index: String.Index = self.index(startIndex, offsetBy: from)
        return String(self[index ..< endIndex])
    }
    /// 从任意位置开始截取到任意位置
    func subString(from: Int, to: Int) -> String {
        let beginIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[beginIndex...endIndex])
    }
    //使用下标截取到任意位置
    subscript(to: Int) -> String {
        let index = self.index(self.startIndex, offsetBy: to)
        return String(self[..<index])
    }
    //使用下标从任意位置开始截取到任意位置
    subscript(from: Int, to: Int) -> String {
        let beginIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[beginIndex...endIndex])
    }
    
    //去掉所有空格,lineFeed:true 表示包含换行符
    func removeAllSpace(str:String?, lineFeed:Bool) -> String
    {
        let tempString = str ?? ""
        
        if tempString.count == 0
        {
            return tempString
        }

        if lineFeed == false
        {
            return tempString.replacingOccurrences(of: " ", with: "")
            
        }else
        {
            let characterSet = NSCharacterSet.whitespacesAndNewlines
            let trimedString = tempString.trimmingCharacters(in: characterSet)
            return trimedString.replacingOccurrences(of: " ", with: "")
        }
    }

    
    
}

// 测试  cocoapods

