//
//  CFBarChartVC.swift
//  CashFlow
//
//  Created by David on 2019/5/27.
//  Copyright © 2019 葛茂菁. All rights reserved.
//

import UIKit

class CFBarChartVC: UIViewController {
    
    // 资产比负债 杜邦分析模型 增长率 收益率

    var basicBarChart = BasicBarChart()
    var barChart =  BeautifulBarChart()
    private let numEntry = 20 // 数据数量
    
    let numArr = Array<Double>()
    let nameArr = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // 柱状图统计
        basicBarChart.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height / 2.0)
        basicBarChart.backgroundColor = UIColor.clear
        
        barChart.frame = CGRect(x: 0, y: basicBarChart.frame.size.height, width: self.view.bounds.width, height: self.view.bounds.height / 2.0)
        barChart.backgroundColor = UIColor.white
        self.view.addSubview(basicBarChart)
        self.view.addSubview(barChart)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let dataEntries = generateEmptyDataEntries()
        basicBarChart.updateDataEntries(dataEntries: dataEntries, animated: false)
        barChart.updateDataEntries(dataEntries: dataEntries, animated: false)
        
        let timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) {[unowned self] (timer) in
            let dataEntries = self.generateRandomDataEntries()
            self.barChart.updateDataEntries(dataEntries: dataEntries, animated: false)
            self.basicBarChart.updateDataEntries(dataEntries: dataEntries, animated: false)
        }
        timer.fire()
    }
    
    func generateEmptyDataEntries() -> [DataEntry] {
        var result: [DataEntry] = []
        Array(0..<numEntry).forEach {_ in
            result.append(DataEntry(color: UIColor.clear, height: 0, textValue: "0", title: ""))
        }
        return result
    }
    
    
    func generateRandomDataEntries() -> [DataEntry] {
        let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 1, green: 0.5464518881, blue: 0.5778202487, alpha: 1), #colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1), #colorLiteral(red: 0.08988254517, green: 0.4508849382, blue: 0.4628053904, alpha: 1), #colorLiteral(red: 0.4156908393, green: 0.1607943177, blue: 0.08235750347, alpha: 1)]//质数11
        var result: [DataEntry] = []
        for i in 0..<numEntry {
            let value = (arc4random() % 90) + 10
            let height: Float = Float(value) / 100.0
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"
            var date = Date()
            date.addTimeInterval(TimeInterval(24*60*60*i))
            result.append(DataEntry(color: colors[i % colors.count], height: height, textValue: "\(value)", title: formatter.string(from: date)))
        }
        return result
    }

}
