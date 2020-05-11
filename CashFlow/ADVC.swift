//
//  ADVC.swift
//  CashFlow
//
//  Created by David on 2019/8/7.
//  Copyright © 2019 葛茂菁. All rights reserved.
//

import UIKit
//  广告界面
class ADVC: UIViewController,UITextFieldDelegate,UIWebViewDelegate {
    
    
    
    var textField = UITextField()
    var webView =  UIWebView()
    let conLable = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "广告/公告"
        
        conLable.numberOfLines = 0
        conLable.text = "这个法则神奇的地方，是可以推而广之，如果复利是1%，那么需要72年，如果复利是2%，需要36年，依次类推。假如你初始的本金是20万，每年做到投资回报率24%，这笔钱完全不动，所获利息照样投入到投资回报率24%的项目，那么翻一倍的时间，需要3年（72/24）。再翻一番，还是3年。那么你的投资本金变化是：3年 40万 6年 80万 9年 160万 12年 320万 制约财务自由的外因，导致稳定被动收入不可持续的因素，就是世界永远存在竞争。"
        conLable.frame = CGRect(x: 10, y: 10, width: self.view.bounds.width-20, height: self.view.bounds.height-20)
        self.view.addSubview(conLable)
        
        textField.frame = CGRect(x: 10, y: 110, width: self.view.bounds.width / 2, height: 40)
        textField.delegate = self
        textField.text = "https://www.legulegu.com/stockdata/market/nasdaq"
        textField.borderStyle = .roundedRect
        
        webView.frame = CGRect(x: textField.frame.minX, y: textField.frame.maxY, width: self.view.bounds.width, height: self.view.bounds.height - 60)
        webView.delegate = self
        
        let maintitle = webView.stringByEvaluatingJavaScript(from: "nasdaq.getElementById('keywords').innerHTML")
        let maitle = webView.stringByEvaluatingJavaScript(from: "document.getElementById('keywords').innerHTML")
        
        
        
        
        let surebutton = UIButton()
        surebutton.backgroundColor = .black
        surebutton.setTitle("确定", for: .normal)
        surebutton.frame = CGRect(x: self.view.bounds.width - 60, y: 100, width: 40, height: 40)
        surebutton.addTarget(self, action: #selector(buttonGoClicked), for: .touchUpInside)
        
        view.addSubview(textField)
         view.addSubview(webView)
        view.addSubview(surebutton)
        
        
        //注册URL Loading System协议，让每一个请求都会经过MyURLProtocol处理
//        URLProtocol.registerClass(MyURLProtocol.self)
        
        
    }
    
    
    let headerV = UITableViewHeaderFooterView()
    
    var tabviewAD = UITableView()
    // 什么是资产 什么是负债 什么是现金流 什么是健康状况 什么是杜邦统计模型
    // 大盘指数 油价  风口理论 汇率  webview
    // 调查表A--住房需求调查  tabviewcell
   
    
    
    
    @objc func buttonGoClicked(_ sender: UIButton) {
        if self.textField.isFirstResponder {
            self.textField.resignFirstResponder()
        }
        self.sendRequest()
//        self.loadHTML()
    }
    
    
    
    //键盘确定按钮点击
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.sendRequest()
//        self.loadHTML()
        return true
    }
     
    //请求页面
    func sendRequest() {
        if let text = self.textField.text {
            let url = URL(string:text)
            let request = URLRequest(url:url!)
            self.webView.loadRequest(request)
            
        }
    }
    
    func loadHTML() {
        
//NSURL(string:"https://www.legulegu.com/stockdata/market/nasdaq" )
//NSURL(string:"http://c.m.163.com/nc/article/BJ5NRE5T00031H2L/full.html"  )
        if  let  url = NSURL(string:"https://www.legulegu.com/stockdata/market/nasdaq"  ) {
            // 设置urlRequest
            let request = NSURLRequest(url: url as URL)
            // 异步加载请求
            let dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                if error == nil {
                    // 转为json数据
                    if let jsonData = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary {
                    // 处理数据并显示
                        self.deal(jsonData: jsonData)
                    }
                }
            })
            // 开启请求
            dataTask.resume()
        }
    }
    
    func deal(jsonData:NSDictionary) -> Void {
        
        let allData = jsonData["BJ5NRE5T00031H2L"] as! NSDictionary
//        guard let allData = jsonData["BJ5NRE5T00031H2L"] else {
//            return
//        }
        print(allData)
        // 1. 取body中内容
        guard  let bodyHtml = allData["body"] as? String else {
            return;
        }
        // 2. 取出标题
        guard let title = allData["title"] as? String else {
            return
        }
        // 3. 取出发布时间
        guard let ptime = allData["ptime"] as? String else {
            return
        }
        // 4. 取出来源
        guard let source = allData["source"] as? String else {
            return
        }
        // 5. 取出所有图片对象
//        guard let img = allData["img"] as? [[String: AnyObject]] else{
//            return
//        }
        // 6. html最终的body
        var finalBodyHtml = ""
        // 7. 遍历 图片
//        for i in 0..<img.count {
//            // 6.1 取出单独的图片对象
//            let imgItem = img[i]
//            // 6.2
//            if let ref = imgItem["ref"] as? String {
//            // 6.3 取出src
//            let src = ((imgItem["src"] as? String) != nil) ? imgItem["src"] as! String : ""
//            let alt = ((imgItem["alt"] as? String) != nil)  ? imgItem["src"] as! String : ""
//            let imgHtml ="< div class=\"all-img\">\< img src=\"\(src)\" alt=\"\(alt)\">\</ div>"
//            let subBodyHtml = bodyHtml.stringByReplacingOccurrencesOfString(ref, withString: imgHtml)
//          finalBodyHtml = finalBodyHtml.stringByAppendingString(subBodyHtml)
//            }
//        }
        // 创建标题的HTML标签
        let titleHtml = "< div id=\"mainTitle\">\(title)< /div>"
        // 创建子标题的html标签
        let subTitleHtml = "< div id=\"subTitle\"><span class=\"time\">\\(ptime)</span><span>\\(source)</span></ div>"
        // 加载css的url路径
        let cssUrl_temp = Bundle.main.url(forResource: "newsDetail", withExtension: "css")?.absoluteString
       let cssUrl = (cssUrl_temp != nil) ? cssUrl_temp! : ""
        // 创建link
        let cssHtml = "<link href=\"\(cssUrl)\" rel = \"stylesheet\">"
        // 加载js的路径
        let jsUrl_temp = Bundle.main.url(forResource: "newsDetail", withExtension: "js")?.absoluteString
        let jsUrl = jsUrl_temp != nil ? jsUrl_temp! : ""
        let jsHtml =  "<script src=\"\(jsUrl)\" type=\"text/javascript\"></script>"
        // 拼接
        let html =  "<html><head>\(cssHtml)</head><body>\(bodyHtml)\(subTitleHtml)\(finalBodyHtml)\(jsHtml)</body></html>"
        // 加载
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    
    //  swift4.0 data转json
    func nsdataToJSON(data: NSData) -> AnyObject? {
        do {
            return try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as AnyObject
        } catch {
            print(error)
        }
        return nil
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        // URL
        let  url = webView.stringByEvaluatingJavaScript(from: "document.location.href") ?? "" as String
        print("--url:\(url)")
        
        // title
        let title = webView.stringByEvaluatingJavaScript(from: "document.title") ?? "" as String
        print("--title:\(title)")
        
        // body
        let body = webView.stringByEvaluatingJavaScript(from: "document.body.innerText") ?? "" as String
        print("---body\(body)---body")
        
        
        
    }
    
    
    
    


}


/*
 // 1.
 if let filePath = Bundle.main.path(forResource: "/JJA/demo", ofType: "html") {
    let contents = try String(contentsOfFile: filePath)
 }

得到contents：
<!DOCTYPE html><html> <head><meta charset="utf-8"><title></title><link rel="stylesheet" href="css/mycss1.css" /></head><body><span class="demo1">这是我们的测试</span></body></html>
 
 // 2.
 let url = Bundle.main.url(forResource: "/JJA/demo", withExtension: "html")
 webView.loadRequest(URLRequest(url: url!))
 
 // 3.
 let content = "<!DOCTYPE html><html> <head><meta charset=\"utf-8\"><title></title><link rel=\"stylesheet\" href=\"css/mycss1.css\" /></head><body><span class=\"demo1\">这是我们的测试</span></body></html>"

 let basePath = Bundle.main.url(forResource: "/JJA", withExtension: nil)
 // 注：baseURL如果设置为nil的话，html中的css将失效
 webView.loadHTMLString(content, baseURL: basePath)
 
 */

//处理html标签
/*
 do{
 let attrStr = try NSAttributedString(data: (内容：String.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!)!,
                         options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
       //自定义的textView
       textView.attributedText = attrStr
}catch let error as NSError {
        print(error.localizedDescription)

*/

/*
 切换导航
  
 大家都在搜:

 市盈率 市净率
 乐咕乐股网

  首页 量化股市 纳斯达克市盈率
 纳斯达克市盈率
 NASDAQ NMS COMPOSITE INDEX P/E Ratio
 NASDAQ: 7417.86 2020-03-24
 市盈率(P/E Ratio): 22.7 (数据来源: CNN)

 2020年3月24日 纳斯达克市盈率市盈率(PE): 22.7


 免责声明：上述数据不构成有关任何证券、金融产品或其他投资工具或任何交易策略的依据或建议。对因直接或间接使用上述数据而造成的任何损失，包括但不限于因上述数据不准确、不完整或因依赖其任何内容而导致的损失，本网站不承担任何法律责任。
 其他用户正在看
 低佣开户
 乐咕乐股网 - 在这里学会股票投资
 关于我们 | 版权声明 | 免责声明 | 官方博客 | 广告合作
 Copyright © 2015-2020 乐咕乐股网 legulegu.com All Rights Reserved.
 鄂ICP备16005346号  鄂公网安备 42010402000129号
 本站由 阿里云 提供计算和安全服务
 客户服务邮箱：support@legulegu.com 商务邮箱：business@legulegu.com
 */





