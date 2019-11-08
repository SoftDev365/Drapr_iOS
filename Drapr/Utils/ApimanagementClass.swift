 
//
//  ApimanagementClass.swift
//  Canvazone
//
//  Created by Jaison Joseph on 5/5/17.
//  Copyright © 2017 Jaison Joseph. All rights reserved.
//  Managing api operations

import Foundation
import Alamofire
import SwiftyJSON
 
 
class ApimanagementClass:NSObject{    

    func uploadRequest(parameters:[[String: AnyObject]],header:String,baseUrl: String, callback:@escaping (_ result:AnyObject) -> Void) -> Void
    {
        let URL:URLRequest = try! URLRequest(url: "https://twindom.com/api/adduserdetailsv2", method: .post, headers: ["Authorization":("Bearer "+header)])
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for var i:[String:AnyObject] in parameters{
                if(i["Type"] as! String == "String"){
                    guard let value:String=i["Value"] as? String else{
                        return
                    }
                    multipartFormData.append((value.data(using: .utf8)!), withName: i["Key"] as! String)
                }
                else if(i["Type"] as! String == "Data"){
                    guard let data:NSData=i["Value"] as? NSData else{
                        return
                    }
                    multipartFormData.append(data as Data, withName: i["Key"] as! String)
                }
                else if(i["Type"] as! String == "file/image"){
                    guard let data:NSData=i["Value"] as? NSData else{
                        return
                    }
                    multipartFormData.append(data as Data, withName: i["Key"] as! String, fileName: "file1111.jpeg", mimeType: "image/jpeg")
                }
                else if(i["Type"] as! String == "file/video"){
                    guard let data:NSData=i["Value"] as? NSData else{
                        return
                    }
                    multipartFormData.append(data as Data, withName: i["Key"] as! String, fileName: "file1111.mp4", mimeType: "video/mp4")
                }
                else{
                    
                }//video/mp4
            }
            
        },
                         with: URL,
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    if(response.result.value != nil){
                                        let swiftyJsonVar = JSON(response.result.value!)
                                        if swiftyJsonVar["status"] ==  1
                                        {
                                            callback(response.result.value! as AnyObject)
                                        }
                                        else if (swiftyJsonVar["status"] == 0)
                                        {
                                            callback(response.result.value! as AnyObject)
                                            
                                        }
                                    }else{
                                        callback("Not Found" as AnyObject)
                                    }
                                }
                            case .failure( _):
                                callback("Not Found" as AnyObject)
                            }
        }
        )
    }
}
 class BackendAPIManager: NSObject {
    static let sharedInstance = BackendAPIManager()
    
    var alamoFireManager : Alamofire.SessionManager!
    
    var backgroundCompletionHandler: (() -> Void)? {
        get {
            return alamoFireManager?.backgroundCompletionHandler
        }
        set {
            alamoFireManager?.backgroundCompletionHandler = newValue
        }
    }
    
    fileprivate override init()
    {
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.url.background")
        //configuration.timeoutIntervalForRequest = 1000 // seconds
        //configuration.timeoutIntervalForResource = 200
        self.alamoFireManager = Alamofire.SessionManager(configuration: configuration)
    }
 }
