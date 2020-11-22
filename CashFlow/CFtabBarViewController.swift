//
//  CFtabBarViewController.swift
//  CashFlow
//
//  Created by David on 2019/1/22.
//  Copyright © 2019年 葛茂菁. All rights reserved.
//

import UIKit

class CFtabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let vc1 = A()
        vc1.title = "当前"
        vc1.tabBarItem.image = UIImage(named: "nowtabbar")
        vc1.tabBarItem.selectedImage = UIImage(named: "nowselect")
        let vc2 = B()
        vc2.title = "现金"
        vc2.tabBarItem.image = UIImage(named: "crashtabbar")
        vc2.tabBarItem.selectedImage = UIImage(named: "cashselect")
        
        let vc3 = C()
        vc3.title = "负债"
        vc3.tabBarItem.image = UIImage(named: "debty")
        vc3.tabBarItem.selectedImage = UIImage(named: "debtyselect")
        
        self.viewControllers = [vc1,vc2,vc3]
        self.tabBar.isTranslucent = true
        self.tabBar.tintColor = UIColor(red: 67/255.0, green: 183/255, blue: 81/255, alpha: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}

let tipsArr = [
 "tips:广告里面通常是当前市场最火的产品,说不定就有符合你的赚钱机会",
 "tips:市盈率PE反应一个市场的冷热情况通常在10-20之间",
 "tips:市场市盈率高于20时表示市场进入过热期",
 "tips:市场PE低于10时候表示市场进入冰封期",
 "tips:冰封期的市场上会存在许多<便宜货>但仍需谨慎投资",
 "tips:很多市场都存在人为控制因数在里面，不要盲目追高",
 "tips:市场平均PE是很好反应市场的指数，但是各个割韭菜软件是不会显示这个数值的",
 "tips:乔治拜登当选总统，美股金融刺激性政策趋于结束，能撤的赶紧撤吧！",
 "tips:特朗普曾经同别人参与投资中国金矿开发，后来该金矿被中政府收回，特朗普损失不少，该金矿位于辽宁大连北三市辖区内",
 "tips:A股市场存在很多人为操控因数在里面，投资需考虑政策面问题",
 "tips:中国市场实行严格的外汇管制措施，每个人每年外汇限额5万美金",
 "tips:港股市场市盈率普遍较低，这是港股市场的一大特点",
 "tips:《新国安法》的实行对港股市场影响较大，港股投资需注意政策面问题",
 "tips:个人投资受到性格，资金实力，健康费用支出，未来收入，是否持续就业，婚姻关系等诸多因素影响",
 "tips:财务上最大的问题是乱投资，乱投资会让你倾家荡产，资本市场可不是电视剧里过家家，这里的血雨腥风妻离子散可是玩真的！"
    
 ]




// 小建议
class contactLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let lower:Int = 0;let upper:Int = tipsArr.count-1;
        let ii = lower + Int(arc4random_uniform(UInt32(upper - lower)))
        let tabbar_h = kTabbarkStatusbar(kScreenHeight: kScreenHeight)
        let width = UIScreen.main.bounds.width - 20
        let bottom_y = UIScreen.main.bounds.height - tabbar_h.0//kTabbar
        self.frame =  CGRect(x: 10, y: bottom_y - 60, width: width, height: 60)
        self.text = tipsArr[ii]//随机一个小建议
        self.textAlignment = .center
        self.numberOfLines = 0
        self.textColor = UIColor.lightGray
        self.font = UIFont.systemFont(ofSize: 15)
        if kScreenWidth >= 1024 {
            self.font = UIFont.systemFont(ofSize: 30)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// 判断多高
public func kTabbarkStatusbar (kScreenHeight:CGFloat) -> (kTabbar:CGFloat,kStatusbar:CGFloat) {
    
    if kScreenHeight == 896 {
//        print("iPhoneXSMax-XR-11-11ProMax 6.1/6.5寸  414x896 ")
    }
    if kScreenHeight == 812 {
//        print("iPhoneX-XS-11Pro 5.8寸 375x812")
    }
    if kScreenHeight == 736  {
//        print("iPhone8P-7P-6SP-6P  5.5寸 414x736")
    }
    if kScreenHeight == 667 {
//        print("iPhone8-7-6S-6   4.7寸 375x667")
    }
    if kScreenHeight == 568 {
//        print("iPhoneSE-5S-5C-5 4.0寸 320x568")
    }
    
    
    var kTabbar:CGFloat
    var kStatusbar:CGFloat
    
    switch kScreenHeight  {
    case 896:
        kTabbar = 83
        kStatusbar = 44
    case 812:
        kTabbar = 83
        kStatusbar = 44
        
    default:
        kTabbar    = 49
        kStatusbar = 20
    }
    
    return (kTabbar,kStatusbar)
    
}

