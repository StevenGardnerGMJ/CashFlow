//
//  CFBarChartVC.swift
//  CashFlow
//
//  Created by David on 2019/5/27.
//  Copyright © 2019 葛茂菁. All rights reserved.
//

import UIKit

// 柱状统计图 统计界面使用
class CFBarChartVC: UIViewController {
    
    var basicBarChart = BasicBarChart()
    var barChart =  BeautifulBarChart()
    var timer = Timer()
    private let numEntry = 20 // 数据数量
    
    
    var assetsArr   = Array<String>()
    var assetsValue = Array<Double>()
    
    var liabilities = Array<String>()
    var liabilValue = Array<Double>()
    
    // 横竖屏协议
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var isFullScreen = false // 是否横屏
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = getColor()//UIColor.white
        
        appDelegate.blockRotation = true // 可以横竖屏
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "横屏"), style: .plain, target: self, action: #selector(orientationClick))
        
        // 柱状图统计
        basicBarChart.backgroundColor = getColor()//UIColor.black
        basicBarChart.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(basicBarChart)
        
        // 气泡状统计
        barChart.backgroundColor = getColor()//UIColor.black
        barChart.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(barChart)
        
        

        
        // 适配 --> 半屏显示 上下半屏
        let views = ["basicChart":basicBarChart,"barChart":barChart]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[basicChart]-|", options: [], metrics: nil, views: ["basicChart":basicBarChart]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[barChart]-|", options: [], metrics: nil, views: ["barChart":barChart]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[basicChart]-10-[barChart(==basicChart)]-|", options: [], metrics: nil, views: views))
        
        basicBarChart.isUserInteractionEnabled = true
        
        let tapGes = UITapGestureRecognizer(target: self,action:#selector(viewDidLoad2))
        basicBarChart.addGestureRecognizer(tapGes)
        
        let tapGesD = UITapGestureRecognizer(target: self, action: #selector(viewDidLoad3))
        barChart.addGestureRecognizer(tapGesD)
        
    }
    
    @objc func  viewDidLoad2 () {
//        print("viewDidLoad2======")
        
        // 视图的先后顺序决定是否能全屏显示
        view.bringSubview(toFront: basicBarChart)
        let viewbasic = ["basicChart":basicBarChart]
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[barChart]-|", options: [], metrics: nil, views: ["barChart":barChart]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[basicChart]-|", options: [], metrics: nil, views: ["basicChart":basicBarChart]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[basicChart]-|", options: [], metrics: nil, views: viewbasic))
        
        
    }
    
    @objc func  viewDidLoad3 () {
//        print("viewDidLoad3")
        let viewBar = ["barChart":barChart]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[basicChart]-|", options: [], metrics: nil, views: ["basicChart":basicBarChart]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[barChart]-|", options: [], metrics: nil, views: ["barChart":barChart]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[barChart]-|", options: [], metrics: nil, views: viewBar))
    }
    
    
    
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        let dataEntries = generateEmptyDataEntries()
        basicBarChart.updateDataEntries(dataEntries: dataEntries, animated: true)
        barChart.updateDataEntries(dataEntries: dataEntries, animated: true)
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) {[unowned self] (timer) in
            //  资产
            let dataEntriesA = self.generateRandomDataEntries(valueArr: self.assetsValue, titleArr: self.assetsArr)
            //  负债
              let dataEntriesB = self.generateRandomDataEntries(valueArr: self.liabilValue, titleArr: self.liabilities)
            self.barChart.updateDataEntries(dataEntries: dataEntriesA, animated: true)
            self.basicBarChart.updateDataEntries(dataEntries: dataEntriesB, animated: true)
        }
        timer.fire()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.timer.invalidate() // 界面返回后停止动画效果
        //该页面显示时禁止横竖屏切换
        appDelegate.blockRotation = false
        //判断退出时是否是横屏
        if UIApplication.shared.statusBarOrientation.isLandscape {
            //是横屏让变回竖屏
            appDelegate.setNewOrientation(fullScreen: false)
        }
    }
    
    @objc func orientationClick(tapGes:UITapGestureRecognizer) {
//        print("横竖屏幕")
        if isFullScreen == false {
            self.appDelegate.setNewOrientation(fullScreen: true)
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "退出横屏"), style: .plain, target: self, action: #selector(orientationClick))
            isFullScreen = true
        } else {
            self.appDelegate.setNewOrientation(fullScreen: false)
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "横屏"), style: .plain, target: self, action: #selector(orientationClick))
            isFullScreen = false
        }
    }
    
    
    // 空数据初始化
    func generateEmptyDataEntries() -> [DataEntry] {
        var result: [DataEntry] = []
        Array(0..<numEntry).forEach {_ in
            result.append(DataEntry(color: UIColor.clear, height: 0, textValue: "0", title: ""))
        }
        return result
    }
    
    
    func generateRandomDataEntries(valueArr:Array<Double>,titleArr:Array<String>) -> [DataEntry] {
        let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 1, green: 0.5464518881, blue: 0.5778202487, alpha: 1), #colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1), #colorLiteral(red: 0.08988254517, green: 0.4508849382, blue: 0.4628053904, alpha: 1), #colorLiteral(red: 0.4156908393, green: 0.1607943177, blue: 0.08235750347, alpha: 1)]//质数11
        var result: [DataEntry] = []
        
        guard valueArr[0] > 0 else {
            return [] //数值与总资产对比 valueArr[0]总资产为0会崩溃
        }
        for i in 1..<valueArr.count {
            let value  = valueArr[i] //测试数据(arc4random() % 90) + 10
            let valveH = Float(value / valueArr[0] )
            let height:Float = valveH > 0 ? valveH:0
           
            let title = titleArr[i]
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"
            var date = Date()
            date.addTimeInterval(TimeInterval(24*60*60*i))
            result.append(DataEntry(color: colors[i % colors.count], height: height, textValue: "\(value)", title: title))//formatter.string(from: date)
        }
        return result
    }

}

// 深色模式
fileprivate func getColor() -> UIColor {
    if #available(iOS 13.0, *) {
        return UIColor { (collection) -> UIColor in
            if (collection.userInterfaceStyle == .dark) {
                return UIColor.clear
            }
            return UIColor.white
        }
    } else {
        return UIColor.white
    }
}



//        barChart.frame = CGRect(x: 0, y: basicBarChart.frame.size.height, width: self.view.bounds.width, height: self.view.bounds.height / 2.0)

//        basicBarChart.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height / 2.0)
