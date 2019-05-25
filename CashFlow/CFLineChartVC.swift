//
//  CFLineChartVC.swift
//  CashFlow
//
//  Created by David on 2019/5/24.
//  Copyright © 2019 葛茂菁. All rights reserved.
//

import UIKit
import QuartzCore

class CFLineChartVC: UIViewController,LineChartDelegate {

    var label = UILabel()
    var lineChart: LineChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = .white

        // Do any additional setup after loading the view.
        var views: [String: AnyObject] = [:]
        
        label.text = "...nufbasb"
        label.translatesAutoresizingMaskIntoConstraints = false
//        self.view.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.center
        self.view.addSubview(label)
//        views = ["label":label, "superV":self.view]
//        views["label"] = label
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[label]-|", options: [], metrics: nil, views: views))
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "[label]-1@1-[superV]", options: .alignAllCenterY, metrics: nil, views: views))//V:|-300-[label]
        
        // simple arrays
        let data: [CGFloat] = [3, 4, -2, 11, 13, 15]
        let data2: [CGFloat] = [1, 3, 5, 13, 17, 20]
        
        // simple line with custom x axis labels
        let xLabels: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        
        lineChart = LineChart()
        lineChart.animation.enabled = true
        lineChart.area = true
        lineChart.x.labels.visible = true
        lineChart.x.grid.count = 5
        lineChart.y.grid.count = 5
        lineChart.x.labels.values = xLabels
        lineChart.y.labels.visible = true
        lineChart.addLine(data)
        lineChart.addLine(data2)
        
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.delegate = self
        self.view.addSubview(lineChart)
//        lineChart.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
       
//        lineChart.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width-20, height: 200)
//        lineChart.center = self.view.center
        views = ["chart":lineChart,"superV":self.view]
//        views["chart"] = lineChart
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[chart]-|", options: [], metrics: nil, views: views))//H:|-[chart]-|
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "[chart]-1@1-[superV]", options: .alignAllCenterY, metrics: nil, views: views))//V:[label]-[chart(==200)]
//        lineChart.layoutIfNeeded()
        let height = NSLayoutConstraint(item: lineChart, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 200)
        lineChart.addConstraint(height)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     * Line chart delegate method.
     */
    func didSelectDataPoint(_ x: CGFloat, yValues: Array<CGFloat>) {
        label.text = "x: \(x)     y: \(yValues)"
    }
    
    
    
    /**
     * Redraw chart on device rotation.
     */
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if let chart = lineChart {
            chart.setNeedsDisplay()
        }
    }
    

    

}
