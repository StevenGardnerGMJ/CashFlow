//
//  ViewController.swift
//  CashFlow
//
//  Created by David on 2019/1/11.
//  Copyright © 2019年 葛茂菁. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*解决办法：iOS10之后，必须要加进这四个进plist文件列表
     
     Privacy - Photo Library Usage Description  调用相册
     
     Privacy - Camera Usage Description  调用相机
     
     Privacy - Microphone Usage Description  调用麦克风
     
     Privacy - Contacts Usage Description  调用联系人
     ---------------------
     作者：yuhao309
     来源：CSDN
     原文：https://blog.csdn.net/yuhao309/article/details/55272075
     版权声明：本文为博主原创文章，转载请附上博文链接！*/
    
}
/*  教育中心北京盘点北京的各大中心职能，带你认识真正的北京，从客观角度看待北京。
北京是中国拥有最多高校的城市，在这座城市里共有42座一本类高校，从赫赫有名的北京大学到首钢工学院，还有40多所二类三类学校和专科学校，（中国一本二本三本以及专科学校是什么，详细请看我的另一个视频，中国教育制度一览）。大学是一个庞大的经济体，对一个城市的经济、科技等发展起着重要的作用，大学生代表着的是一个国家当下的人才状况和未来的人才状况，可以说大学代表着一个国家的当下和未来10年到20年的发展，在中国大学教育更多的意义上是经济因素，中国北京的大学更像是一个个大型的商场，里面圈养的一群年轻人，这些年轻人对未来充满了希望，但这些更多的意义是消费者，他们吃喝穿行都得消费，这是个彻彻底底只有支出没有收入的阶层。
 每年清华大学，北大大学这类高校都会吸收全中国最优秀的学生，但是从这里培养出的学生却不是世界顶尖的，这并不是清华北大这两所学校的个例，北京这座教育城市每年吸收了全中国最优秀的学子，却没有培养出最优秀的学生，这类学校在北京占领的最繁华的地段，拥有上最好的教学场地，最充沛的教育资源，但是很遗憾的是很多的顶尖器材和教室基本都是闲置状态，有些顶尖器材从进口到其老化过期也仅仅是打开防尘布展示了一下，我记得很清楚参观某个大学的时候，老师很自豪的介绍自己的学校物理实验室拥有一台价值100万的叫做流体气体小球分析仪，好像是这个名字具体名字对不对具体是干什么的我也不知道，反正给我印象最深刻的是台机器用一块极好的静电防尘布罩着，买回来已经5年之久了，却从来也没使用过，是不会死怕学生使用坏了担责任还是这样一台机器本来就是用来看的？我不得而知。
 那么学生们在干什么呢，大部分学生上课在睡觉，回到宿舍在打游戏，看电视剧，还有的被称为学霸的孩子在靠各种的证，报各种的考研辅导班，在他们的生活里学习就是为了考试而考试。学习本身不是为了求知务实，而是考证考证再考证。另一外一个让人吃惊的事情是中国高校的HIV携带者数量惊人，值得值得注意的是所有的大学生，在参加高考的时候都会严格的进行体检，可以断定这些HIV携带者的大学生是在学校内感染的，可拍的是很多的学生并不知道自己是HIV携带者。有个调查对一个有一万名学生的学校HIV测试，结果又200-300人有HIV携带者，发明率是2%-3%在这样一个拥有庞大学生基数的国度，这就是个天文数字。
 那么学校的教师们在干什么呢，绝大部分是混吃等死型，有的忙着赚钱捞外快，有的忙着和女学生睡觉，有句顺口溜这么讲的，台上是教授台下是禽兽。
 关于教育中心的职能就讲到这里，不论你认同也好不认同也好，这就是现实。
 */


// 禁止 textField 输入多个小数点  执行协议 UITextFieldDelegate
//func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//    if (string == ".") && textField.text?.replacingOccurrences(of: " ", with: "").count == 0 {
//        //  首位为空和 "."
//        textField.text = ""
//        return false
//    } else if (string == ".") && (textField.text?.contains("."))! {
//        return false
//    } else {
//        return true
//    }
//}




