//
//  ADVC.swift
//  CashFlow
//
//  Created by David on 2019/8/7.
//  Copyright © 2019 葛茂菁. All rights reserved.
//

import UIKit
//  广告界面
class ADVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "广告/公告"
        let conLable = UILabel()
        conLable.numberOfLines = 0
        conLable.text = "这个法则神奇的地方，是可以推而广之，如果复利是1%，那么需要72年，如果复利是2%，需要36年，依次类推。假如你初始的本金是20万，每年做到投资回报率24%，这笔钱完全不动，所获利息照样投入到投资回报率24%的项目，那么翻一倍的时间，需要3年（72/24）。再翻一番，还是3年。那么你的投资本金变化是：3年 40万 6年 80万 9年 160万 12年 320万 制约财务自由的外因，导致稳定被动收入不可持续的因素，就是世界永远存在竞争。"
        conLable.frame = CGRect(x: 10, y: 10, width: self.view.bounds.width-20, height: self.view.bounds.height-20)
        self.view.addSubview(conLable)
    }
    


}
