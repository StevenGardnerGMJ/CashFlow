//
//  CFchartVC.swift
//  CashFlow
//
//  Created by David on 2019/5/20.
//  Copyright © 2019 葛茂菁. All rights reserved.
//

import UIKit
import PieCharts

class CFchartVC: UIViewController,PieChartDelegate {
    var chartView = PieChart() //饼状统计数据
    let titleN = Array<String>()
    var valueN:Array<Double>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if valueN.count != 4 {
            valueN = [1,2,3,4] // 数据不全时指定默认值
        }
        let charw_h = 250 //pie饼状图宽度和高度
        self.view.backgroundColor = .white
        chartView.frame = CGRect(x: 0, y: 0, width: charw_h , height: charw_h)
        chartView.center = self.view.center
        chartView.innerRadius = 0
        chartView.outerRadius = 108.1
        chartView.selectedOffset = 30
        chartView.layers = [createCustomViewsLayer(), createTextLayer()]
        chartView.delegate = self
        chartView.models = createModels()
        self.view.addSubview(chartView)
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        var views: [String: AnyObject] = [:]
        views = ["superview":self.view, "chartview":chartView]
        let consH = NSLayoutConstraint.constraints(withVisualFormat: "H:[superview]-(0)-[chartview(==\(charw_h))]", options: .alignAllCenterY , metrics: nil, views: views)
        let consV = NSLayoutConstraint.constraints(withVisualFormat: "V:[superview]-(0)-[chartview(==\(charw_h))]", options: .alignAllCenterX, metrics: nil, views: views)
        self.view.addConstraints(consH)
        self.view.addConstraints(consV)
    
        
    }
    // A 雷达  B饼状  C 饼状
    
    // pie chart// MARK: - PieChartDelegate
    
    func onSelected(slice: PieSlice, selected: Bool) {
        print("Selected: \(selected), slice: \(slice)")
    }
    
    // MARK: - Models  切片数据  加上颜色
    
    fileprivate func createModels() -> [PieSliceModel] {
        let alpha: CGFloat = 0.5
        
        return [
            PieSliceModel(value: valueN[0], color: UIColor.yellow.withAlphaComponent(alpha)),
            PieSliceModel(value: valueN[1], color: UIColor.blue.withAlphaComponent(alpha)),
            PieSliceModel(value: valueN[2], color: UIColor.green.withAlphaComponent(alpha)),
            PieSliceModel(value: valueN[3], color: UIColor.cyan.withAlphaComponent(alpha)),
//            PieSliceModel(value: 12, color: UIColor.red.withAlphaComponent(alpha)),
//            PieSliceModel(value: 11.5, color: UIColor.magenta.withAlphaComponent(alpha)),
//            PieSliceModel(value: 10.5, color: UIColor.orange.withAlphaComponent(alpha))
        ]
    }
    
    // MARK: - Layers
   
    fileprivate func createCustomViewsLayer() -> PieCustomViewsLayer {
        
        let viewLayer = PieCustomViewsLayer()
        
        let settings = PieCustomViewsLayerSettings()
        settings.viewRadius = 135
        settings.hideOnOverflow = false
        viewLayer.settings = settings
        // 注释显示
        viewLayer.viewGenerator = createViewGenerator()
        
        return viewLayer
    }
    
    /// 切片占比百分之几
    fileprivate func createTextLayer() -> PiePlainTextLayer {
        let textLayerSettings = PiePlainTextLayerSettings()
        textLayerSettings.viewRadius = 60
        textLayerSettings.hideOnOverflow = true
        textLayerSettings.label.font = UIFont.systemFont(ofSize: 13)
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        textLayerSettings.label.textGenerator = {slice in
            return formatter.string(from: slice.data.percentage * 100 as NSNumber).map{"\($0)%"} ?? ""
        }
        
        let textLayer = PiePlainTextLayer()
        textLayer.settings = textLayerSettings
        return textLayer
    }
    
    fileprivate func createViewGenerator() -> (PieSlice, CGPoint) -> UIView {
        
        return {slice, center in
            
            let container = UIView() // 载体
            container.frame.size = CGSize(width: 40, height: 40)
//            container.frame.size = CGSize(width: 200, height: 60)
            container.center = center
        
            
            let imgv = UIImageView() // 图
            imgv.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            container.addSubview(imgv)
            

        
//            if slice.data.id == 3 || slice.data.id == 0 { //特殊处理3,0号数据
            let specialTextLabel = UILabel() // 文字
            specialTextLabel.frame = CGRect(x: -20, y: 30, width: 80, height: 30)
            
            specialTextLabel.textAlignment = .justified
//                specialTextLabel.sizeToFit()
            container.addSubview(specialTextLabel)
            
            
            // src of images: www.freepik.com, http://www.flaticon.com/authors/madebyoliver
            let imageName: String? = {
                switch slice.data.id {
                case 0: return "小孩"
                case 1: return "工资"
                case 2: return "持有现金"
                case 3: return "月收现金"
                default: return nil
                }
            }()
            
            imgv.image = imageName.flatMap{UIImage(named: $0)}
            specialTextLabel.text = imageName.flatMap{ $0 }
            let textstring = imageName.flatMap{ $0 }
            let textFont = UIFont.systemFont(ofSize: 14)
            let textMaxSize = CGSize(width: 100, height: CGFloat(MAXFLOAT))
            let textLabelSize = self.textSize(text: textstring ?? "00", font: textFont, maxSize: textMaxSize)
            print(textLabelSize)
            
            
            
            
            return container
        }
    }
    
    func textSize(text : String , font : UIFont , maxSize : CGSize) -> CGSize{
        return text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font : font], context: nil).size
    }
  
    
    
}




//                if slice.data.id == 0 {
//                    specialTextLabel.text = "小孩"
////                  specialTextLabel.font = UIFont.boldSystemFont(ofSize: 18)
//                } else if slice.data.id == 1 {
//                    specialTextLabel.textColor = UIColor.black
//                    specialTextLabel.text = "工资"
//                }
