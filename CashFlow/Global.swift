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

//MARK:    修改班级信息
func modifyClass() {
    let app = UIApplication.shared.delegate as! AppDelegate
    let context = getContext()
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Amodel")
    
    fetchRequest.predicate = NSPredicate(format: "value = 2", "")
    
    
    
    // 异步请求由两部分组成：普通的request和completion handler
    
    // 返回结果在finalResult中
    
    let asyncFecthRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result: NSAsynchronousFetchResult!) in
        
        
        
        //对返回的数据做处理。
        
        let fetchObject  = result.finalResult! as! [Amodel]
        
        for c in fetchObject{
            c.value = 99999
            app.saveContext()
            
        }
        
    }
    
    
    
    // 执行异步请求调用execute
    
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
func insertClass(arrays:Array<Any>,keyArr:Array<String>,modelname:String) {
    let context = getContext()
    let Entity = NSEntityDescription.entity(forEntityName: modelname, in: context)
    
    let classEntity = NSManagedObject(entity: Entity!, insertInto: context)
    
    
    classEntity.setValue(arrays[0], forKey: keyArr[0])
    classEntity.setValue(arrays[1], forKey: keyArr[1])
//    classEntity.setValue(myInfo, forKey: keyArr[3])
    
    
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
            print("\(c.status ?? "")--\(c.value)")
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










