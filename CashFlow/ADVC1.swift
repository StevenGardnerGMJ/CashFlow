//
//  ADVC1.swift
//  CashFlow
//
//  Created by gemaojing on 2020/4/29.
//  Copyright © 2020 葛茂菁. All rights reserved.
//

import UIKit
import WebKit

class ADVC1: UIViewController,UITextFieldDelegate,UIWebViewDelegate,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler {
    
    

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
        
       sendRequest()
        
        
        let marketValu = UILabel()
        marketValu.text = "纳斯达克指数: 7417.86"
        marketValu.font = .boldSystemFont(ofSize: 27)
        marketValu.textColor = UIColor.red
        let PE = UILabel()
        PE.text = "市盈率(P/E Ratio): 22.7"
        PE.font = .boldSystemFont(ofSize: 27)
        PE.textColor = UIColor.red
        let dateTime = UILabel()
        dateTime.text = "(2020-03-24)(数据来源: CNN)"
        dateTime.font = .systemFont(ofSize: 21)
        dateTime.textColor = .darkGray
        
        
        let viewWith:CGFloat = self.view.frame.width
        let v_h:CGFloat = 40
        
        marketValu.frame = CGRect(x: 20, y: 100, width: viewWith, height: v_h)
        PE.frame  = CGRect(x: 20, y: 150, width: viewWith, height: v_h)
        dateTime.frame = CGRect(x: 20, y: 200, width: viewWith, height: v_h)
        view.addSubview(marketValu)
        view.addSubview(PE)
        view.addSubview(dateTime)
        
        let dataFrom = UILabel()
        
        
        
        
        
        
        
        marketName.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height / 2.0)
        marketName.center = view.center
        marketName.numberOfLines = 0
        
        view.addSubview(marketName)
        
        
        
       
    }
    
    func sendRequest() {
         let  url = NSURL(string:"https://www.legulegu.com/stockdata/market/nasdaq")
         let request = URLRequest(url:url! as URL)
         self.webView.load(request)
        
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
       // body
        webView.evaluateJavaScript("document.body.innerText") { (result, error) in
            
            let body = result as! String
            let cbody = body.subString(from: 40, to: 200)
            print(cbody)
            print(cbody.count)
            
            self.marketName.text = cbody
            
            print("---result\(String(describing: result))---\n------- result")
            
        }

    }
    

    
    
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        // 防止重复加载
        if webView.isLoading {
            return
        }
        // URL
        let  url = webView.stringByEvaluatingJavaScript(from: "document.location.href") ?? "" as String
        print("--url:\(url)")
        
        // title
        let title = webView.stringByEvaluatingJavaScript(from: "document.title") ?? "" as String
        print("--title:\(title)")
        
        // body
        let body = webView.stringByEvaluatingJavaScript(from: "document.body.innerText") ?? "" as String
        print("---body\(body)---\n------- body")
        print(body.count)
        
        let cbody = body.subString(from: 120, to: 350)
        print(cbody)
        print(cbody.count)
        
        marketName.text = cbody
        
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
    
    
}
