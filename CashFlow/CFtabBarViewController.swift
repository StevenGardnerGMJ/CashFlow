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
        vc1.tabBarItem.image = UIImage(named: "tab当前")
        let vc2 = B()
        vc2.title = "现金"
        vc2.tabBarItem.image = UIImage(named: "tab现金流量表")
        
        let vc3 = C()
        vc3.title = "负债"
        vc3.tabBarItem.image = UIImage(named: "tab资产负债")
        
        self.viewControllers = [vc1,vc2,vc3]
        self.tabBar.isTranslucent = true
        self.tabBar.tintColor = UIColor.black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
