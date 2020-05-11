////
////  MyURLProtocol.swift
////  CashFlow
////
////  Created by gemaojing on 2020/3/24.
////  Copyright © 2020 葛茂菁. All rights reserved.
////
//
//
//
//import UIKit
//import Foundation
//import CoreData
//
///*
//data：内容数据
//encoding：响应编码
//mimeType：响应数据类型
//timestamp：时间戳（记录缓存的时间）
//url：请求地址
// */
//
//var requestCount = 0
//
//class MyURLProtocol: URLProtocol , URLSessionDataDelegate, URLSessionTaskDelegate {
//    //URLSession数据请求任务
//    var dataTask:URLSessionDataTask?
//    //url请求响应
//    var urlResponse: URLResponse?
//    //url请求获取到的数据
//    var receivedData: NSMutableData?
//    
//    //判断这个 protocol 是否可以处理传入的 request
//    override class func canInit(with request: URLRequest) -> Bool {
//        //对于已处理过的请求则跳过，避免无限循环标签问题
//        if URLProtocol.property(forKey: "MyURLProtocolHandledKey", in: request) != nil {
//            return false
//        }
//        return true
//    }
//    
//    //回规范化的请求（通常只要返回原来的请求就可以）
//    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
//        return request
//    }
//   //判断两个请求是否为同一个请求，如果为同一个请求那么就会使用缓存数据。
//   override class func requestIsCacheEquivalent(_ aRequest: URLRequest,
//                                                 to bRequest: URLRequest) -> Bool {
//        return super.requestIsCacheEquivalent(aRequest, to:bRequest)
//    }
//    
//    //开始处理这个请求
//    override func startLoading() {
//        requestCount+=1
//        print("Request请求\(requestCount): \(request.url!.absoluteString)")
//        //判断是否有本地缓存
//        let possibleCachedResponse = self.cachedResponseForCurrentRequest()
//        if let cachedResponse = possibleCachedResponse {
//            print("----- 从缓存中获取响应内容 -----")
//             
//            //从本地缓中读取数据
//            let data = cachedResponse.value(forKey: "data") as! Data!
//            let mimeType = cachedResponse.value(forKey: "mimeType") as! String!
//            let encoding = cachedResponse.value(forKey: "encoding") as! String!
//            
//        print("----:mimeType=\(mimeType),encoding=\(encoding)")
//            
//            let requestStr = request.url!.absoluteString
//            
//            
//if requestStr.contains("https://www.legulegu.com") && (mimeType?.contains("text/css"))!{
//                
//                
//                // MARK:
//           let strData = String(data: data!, encoding: .utf8)
//        
//        var la_str =  String()
//                
//        la_str = strData!.htmlToString
//    print("==============+ABCD+========================")
//        print(la_str)
//                          
//                            
//}
//            
//
//            
//            
//             
//            //创建一个NSURLResponse 对象用来存储数据。
//            let response = URLResponse(url: self.request.url!, mimeType: mimeType,
//                                         expectedContentLength: data!.count,
//                                         textEncodingName: encoding)
//             
////将数据返回到客户端。然后调用URLProtocolDidFinishLoading方法来结束加载。
////（设置客户端的缓存存储策略.NotAllowed ，即让客户端做任何缓存的相关工作）
//            self.client!.urlProtocol(self, didReceive: response,
//                                     cacheStoragePolicy: .notAllowed)
//            self.client!.urlProtocol(self, didLoad: data!)
//            self.client!.urlProtocolDidFinishLoading(self)
//        } else {
//            //请求网络数据
//            print("===== 从网络获取响应内容 =====")
//             
//            let newRequest = (self.request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
//            //NSURLProtocol接口的setProperty()方法可以给URL请求添加自定义属性。
//            //（这样把处理过的请求做个标记，下一次就不再处理了，避免无限循环请求）
//            URLProtocol.setProperty(true, forKey: "MyURLProtocolHandledKey",
//                                      in: newRequest)
//             
//            //使用URLSession从网络获取数据
//            let defaultConfigObj = URLSessionConfiguration.default
//            let defaultSession = Foundation.URLSession(configuration: defaultConfigObj,
//                                              delegate: self, delegateQueue: nil)
//            self.dataTask = defaultSession.dataTask(with: self.request)
//            self.dataTask!.resume()
//        }
//    }
//    
//    //结束处理这个请求
//    override func stopLoading() {
//        self.dataTask?.cancel()
//        self.dataTask       = nil
//        self.receivedData   = nil
//        self.urlResponse    = nil
//    }
//    //URLSessionDataDelegate相关的代理方法
//    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask,
//                    didReceive response: URLResponse,
//                            completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
//         
//        self.client?.urlProtocol(self, didReceive: response,
//                                 cacheStoragePolicy: .notAllowed)
//        self.urlResponse = response
//        self.receivedData = NSMutableData()
//        
//        
//        
//        
//        completionHandler(.allow)
//    }
//     
//    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask,
//                    didReceive data: Data) {
//        self.client?.urlProtocol(self, didLoad: data)
//        self.receivedData?.append(data)
//    }
//    //URLSessionTaskDelegate相关的代理方法
//    func urlSession(_ session: URLSession, task: URLSessionTask
//        , didCompleteWithError error: Error?) {
//        if error != nil {
//            self.client?.urlProtocol(self, didFailWithError: error!)
//        } else {
//            //保存获取到的请求响应数据
//            saveCachedResponse()
//            self.client?.urlProtocolDidFinishLoading(self)
//        }
//    }
//    
//    //保存获取到的请求响应数据
//    func saveCachedResponse () {
//        print("+++++ 将获取到的数据缓存起来 +++++")
//         
//        //获取管理的数据上下文 对象
//        let app = UIApplication.shared.delegate as! AppDelegate
//        let context = app.persistentContainer.viewContext
//         
//        //创建NSManagedObject的实例，来匹配在.xcdatamodeld 文件中所对应的数据模型。
//        let cachedResponse = NSEntityDescription
//            .insertNewObject(forEntityName: "CachedURLResponse",
//                                             into: context) as NSManagedObject
//        cachedResponse.setValue(self.receivedData, forKey: "data")
//        
//        cachedResponse.setValue(self.request.url!.absoluteString, forKey: "url")
//        cachedResponse.setValue(Date(), forKey: "timestamp")
//        cachedResponse.setValue(self.urlResponse?.mimeType, forKey: "mimeType")
//        cachedResponse.setValue(self.urlResponse?.textEncodingName, forKey: "encoding")
//         
//        //保存（Core Data数据要放在主线程中保存，要不并发是容易崩溃）
//        DispatchQueue.main.async(execute: {
//            do {
//                try context.save()
//            } catch {
//                print("不能保存：\(error)")
//            }
//        })
//    }
//    
//    //检索缓存请求
//    func cachedResponseForCurrentRequest() -> NSManagedObject? {
//        //获取管理的数据上下文 对象
//        let app = UIApplication.shared.delegate as! AppDelegate
//        let context = app.persistentContainer.viewContext
//         
//        //创建一个NSFetchRequest，通过它得到对象模型实体：CachedURLResponse
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
//        let entity = NSEntityDescription.entity(forEntityName: "CachedURLResponse",
//                                                       in: context)
//        fetchRequest.entity = entity
//         
//        //设置查询条件
//        let predicate = NSPredicate(format:"url == %@", self.request.url!.absoluteString)
//        fetchRequest.predicate = predicate
//         
//        //执行获取到的请求
//        do {
//            let possibleResult = try context.fetch(fetchRequest)
//                as? Array<NSManagedObject>
//            if let result = possibleResult {
//                if !result.isEmpty {
//                    return result[0]
//                }
//            }
//        }
//        catch {
//            print("获取缓存数据失败：\(error)")
//        }
//        return nil
//    }
//    
//    
//}
//
//
//
//extension String {
//    var htmlToAttributedString:NSAttributedString? {
//        guard let data = data(using: .utf8) else {
//            return NSAttributedString()
//        }
//        do {
//          return  try NSAttributedString(data: data, options:[.documentType:NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
//        } catch  {
//            return NSAttributedString()
//        }
//    }
//    var htmlToString:String {
//        return htmlToAttributedString?.string ?? ""
//    }
//
//}
//
//
//
//
