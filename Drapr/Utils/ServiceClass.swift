//
//  ServiceClass.swift
//  Wealth
//
//  Created by Rohit Ajmera on 12/17/16.
//  Copyright © 2016 Rohit Ajmera. All rights reserved.
//

import UIKit
import AFNetworking
import SVProgressHUD


class Global: NSObject {
    
    let IDIOM = UI_USER_INTERFACE_IDIOM()
    let IPAD =  UIUserInterfaceIdiom.pad
    let IPHONE = UIUserInterfaceIdiom.phone
    
    let kOFFSET_FOR_KEYBOARD:Float = 80.0
    static let APP_TIMEOUT:TimeInterval = 10.0
    

    let APIHEADER      =    "https://twindom.com/api"
    
    let USER_LOGIN     =   "/login"
    let USER_SIGNUP    =   "/createuser"

    let GETUSERDETAILS =   "/getuserdetails"
    
    let SENDRESETLINK  =   "/sendresetlink"

    let ADDUSERDETAILSV2 = "/adduserdetailsv2"
    
    
    

 
}


class ServiceClass: NSObject {
    
    let GlobalVar = Global()
    
    
    func servicePostMethodWithAPIHeaderValue(apiValue: String, headerValue: String, parameters params: NSObject, timeout: TimeInterval = Global.APP_TIMEOUT, completion completionBlock: (((NSDictionary)?) -> Void)?) -> () {
        
        let url = "\(apiValue)\(headerValue)"
        let manager = AFHTTPSessionManager()
        
        manager.requestSerializer = AFHTTPRequestSerializer()
        //manager.requestSerializer = AFJSONRequestSerializer()

        
        //manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "content-type")
        manager.requestSerializer.setAuthorizationHeaderFieldWithUsername("DSFKJ#lmkdsf@&&", password: "5sdf42151SDF5JKNHDSF@#LMDSFL")
        manager.requestSerializer.timeoutInterval = timeout
        
        
        manager.responseSerializer = AFJSONResponseSerializer()
        //manager.responseSerializer = AFHTTPResponseSerializer()
        
        
        manager.post(url, parameters: params, progress: { (nil) in
            
        }, success: { (task, responseObject) in
            
            let responseObject = responseObject as! NSDictionary
            completionBlock!(responseObject)
            
        })
            
        { (task, error) in
            
            SVProgressHUD.dismiss()
            
            print(error)
            var str_error: String = ""
            if "\(error.localizedDescription)" == "The request timed out." {
                str_error = "You are not connected to the internet."
                DispatchQueue.main.async {
                    UIApplication.shared.delegate?.window!!.makeToast("You are not connected to the internet.", duration: 4.0, position: .bottom)
                }

            } else {
                str_error = "\(error.localizedDescription)"
                let alertView = UIAlertController(title: "", message: str_error, preferredStyle: .alert)
                alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) -> Void in
                    
                }))
                alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                UIApplication.shared.delegate?.window!!.rootViewController?.present(alertView, animated: true, completion: nil)
            }
            
            
            
        }
        
    }
    
    func serviceGetMethodWithAPIHeaderValue(apiValue: String, headerValue: String, fields: String, completion completionBlock: @escaping (NSDictionary) -> Void) {
        let requestLink = "\(apiValue)\(headerValue)"
        let urlWithParams = requestLink + fields
        let myUrl = NSURL(string: urlWithParams);
        let request = NSMutableURLRequest(url: myUrl as! URL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            data, response, error in
            if error != nil
            {
                SVProgressHUD.dismiss()
                print("error=\(error)")
                return
            }
            do {
                let dictonary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
                completionBlock(NSDictionary(dictionary: dictonary!))
                
            } catch let error as NSError {
                SVProgressHUD.dismiss()
                print(error)
            }
        })
        task.resume()
    }
}

