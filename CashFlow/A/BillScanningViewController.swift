//
//  BillScanningViewController.swift
//  CashFlow
//
//  Created by 葛茂菁 on 2020/8/28.
//  Copyright © 2020 葛茂菁. All rights reserved.
//

import UIKit
import Vision

//    账单扫描功能
class BillScanningViewController: UIViewController {
    
   private var resultLabel: UILabel!
    var textImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        resultLabel = UILabel(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 30))
        resultLabel.center.x = self.view.center.x
        resultLabel.center.y = self.view.center.y - 250
        self.view.addSubview(resultLabel)
        
        textImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        textImageView.center = self.view.center
        self.view.addSubview(textImageView)
        
        

        self.findText()
        
    }
    
    func findText() {

        var textLayers : [CAShapeLayer] = []
        let textDetectionRequest = VNDetectTextRectanglesRequest(completionHandler: {(request, error) in

            guard let observations = request.results as? [VNTextObservation]
                else { fatalError("unexpected result type from VNDetectTextRectanglesRequest") }

            //把检测到的文字添加layer
            textLayers = self.addShapesToText(forObservations: observations, withImageView: self.textImageView)
        })

        //如果图片存在，那就进行处理（添加layer）
        if let image = self.textImageView.image, let cgImage = image.cgImage {
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

            guard let _ = try? handler.perform([textDetectionRequest]) else {
                return print("Could not perform text Detection Request!")
            }

            for layer in textLayers {
                textImageView.layer.addSublayer(layer)
            }
        }

    }
    
    
    func addShapesToText(forObservations observations: [VNTextObservation], withImageView textImageView: UIImageView) -> [CAShapeLayer] {


        //map 筛选里面的结构
        let layers: [CAShapeLayer] = observations.map { observation in

            let w = observation.boundingBox.size.width * textImageView.bounds.width
            let h = observation.boundingBox.size.height * textImageView.bounds.height
            let x = observation.boundingBox.origin.x * textImageView.bounds.width
            let y = abs(((observation.boundingBox.origin.y * (textImageView.bounds.height)) - textImageView.bounds.height)) - h

            let layer = CAShapeLayer()
            layer.frame = CGRect(x: x , y: y, width: w, height: h)
            layer.borderColor = UIColor.green.cgColor
            layer.borderWidth = 2
            layer.cornerRadius = 3

            return layer
        }
        return layers
    }
    
    
}




