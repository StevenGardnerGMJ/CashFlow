//
//  Global.swift
//  CashFlow
//
//  Created by David on 2019/1/30.
//  Copyright © 2019年 葛茂菁. All rights reserved.
//
// iOS获取设备真实UDID和IMEI  "https://www.jianshu.com/p/655c6f655d88"
// 自定义的UITableViewHeaderFooterView的注意要点 https://blog.csdn.net/eiamor/article/details/71155246
// String 使用 NumberFormatter 的 localizedString 方法进行数字格式化

import Foundation
import UIKit
import CoreData


func getContext() -> NSManagedObjectContext {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    return appDelegate.persistentContainer.viewContext
}

//MARK:    统计信息
func countClass() {
   
    let context = getContext()
   
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Amodel")
    
    //请求的描述，按classNo 从小到大排序
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "value", ascending: true)]
    
    //请求的结果类型
    //        NSManagedObjectResultType：返回一个managed object（默认值）
    //        NSCountResultType：返回满足fetch request的object数量
    //        NSDictionaryResultType：返回字典结果类型
    //        NSManagedObjectIDResultType：返回唯一的标示符而不是managed object
    
    fetchRequest.resultType = .dictionaryResultType
    
//创建NSExpressionDescription来请求进行平均值计算，取名为AverageNo，通过这个名字，从fetch请求返回的字典中找到平均值
    let description = NSExpressionDescription()
    description.name = "AverageNo"
    
    //指定要进行平均值计算的字段名classNo并设置返回值类型
    let args  = [NSExpression(forKeyPath: "value")]
    
    // forFunction参数有sum:求和 count:计算个数 min:最小值 max:最大值 average:平均值等等
    description.expression = NSExpression(forFunction: "average:", arguments: args)
    
    description.expressionResultType = .floatAttributeType
    
    // 设置请求的propertiesToFetch属性为description告诉fetchRequest，我们需要对数据进行求平均值
    
    fetchRequest.propertiesToFetch = [description]
    
    do {
        
        let entries =  try context.fetch(fetchRequest)
        
        let result = entries.first! as! NSDictionary
        
        let averageNo = result["AverageNo"]!
        
        print("\(averageNo)")
    } catch  {
        print("failed")
    }
    
}

//MARK:    修改班级信息
func modifyClass() {
    let app = UIApplication.shared.delegate as! AppDelegate
    let context = getContext()
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Amodel")
    
    fetchRequest.predicate = NSPredicate(format: "value = 2", "")
    
    let asyncFecthRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result: NSAsynchronousFetchResult!) in
        
        //对返回的数据做处理。
        
        let fetchObject  = result.finalResult! as! [Amodel]
        
        for c in fetchObject{
            c.value = 99999
            app.saveContext()
            
        }
        
    }
    
    do {
        try context.execute(asyncFecthRequest)
    } catch  {
        print("error")
    }
}
//MARK:    删除班级信息
func deleteClass() -> Void {
   let app = UIApplication.shared.delegate as! AppDelegate
   let context = getContext()
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Amodel")
    let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result:NSAsynchronousFetchResult) in
        let fetchObject = result.finalResult! as! [Amodel]
        for c in fetchObject{
            context.delete(c)
        }
        app.saveContext()
    }
    
    
    do {
        try context.execute(asyncFetchRequest)
    } catch  {
        print("error")
    }
}

// 插入信息
func insertClass(arrays:Array<Any>,keyArr:Array<String>,modelname:String,myinfo:String) {
    let context = getContext()
    let Entity = NSEntityDescription.entity(forEntityName: modelname, in: context)
    
    let classEntity = NSManagedObject(entity: Entity!, insertInto: context)
    
    classEntity.setValue(arrays[0], forKey: keyArr[0])
    classEntity.setValue(arrays[1], forKey: keyArr[1])
    classEntity.setValue(myinfo, forKey: "myinfo")
    
    
    do {
        try context.save()
    } catch  {
        let nserror = error as NSError
        fatalError("错误:\(nserror),\(nserror.userInfo)")
    }
}

// 得到信息
func getClass(modelname:String)-> Array<Float> {
    print("getClass")
    let context = getContext()
    var arr = Array<Float>()
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Amodel")
    
    let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result : NSAsynchronousFetchResult!) in
   
        let fetchObject = result.finalResult as! [Amodel] // arr数据
        
        for  c in fetchObject{
            arr.append(c.value)
            print("\(c.status ?? "")--\(c.value)--\(c.myinfo ?? "")")
        }
    }
    do {
        try context.execute(asyncFetchRequest)
    } catch  {
        print("error")
    }
    return arr
}



///全局函数 T是泛型 传入不同的参数
public  func PrintCCLog<T>(_ message:T,file:String = #file,funcName:String = #function,lineNum:Int = #line){
    
    let file = (file as NSString).lastPathComponent;
    //    let file = (#file as NSString).lastPathComponent
    //    let funcName = #function
    //    print("\(file):\(funcName)-",dic);
    // 文件名：行数---要打印的信息
    print("\(file):(\(lineNum))--\(message)")
    
}

func getImagewithcolor(color:UIColor) -> UIImage {
    
    let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context!.setFillColor(color.cgColor)
    context!.fill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image!
}
public let default_H = 40
public let default_w = 200










