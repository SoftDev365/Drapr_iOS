//
//  ResetPassViewController.swift
//  Drapr
//
//  Created by Pedro on 12/21/18.
//  Copyright © 2018 Pedro. All rights reserved.
//

import UIKit
import SVProgressHUD

class ResetPassViewController: UIViewController {

    @IBOutlet weak var view_email: UIView!
    @IBOutlet weak var txt_email: UITextField!
    
    @IBOutlet weak var btn_SendMeLink: UIButton!
    
    let GlobalVar = Global()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        InitUI()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        txt_email.text = g_ProfileInfo.email
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func InitUI() {
        view_email.layer.cornerRadius = 8.0
        btn_SendMeLink.layer.cornerRadius = 8.0
    }

    @IBAction func onTapped_Back_Method(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTapped_SendResetPassword_Method(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
        }else{
            print("You are not connected to the internet.")
//            DispatchQueue.main.async {
//                self.view.makeToast("You are not connected to the internet.", duration: 3.0, position: .bottom)
//            }
            self.ShowAlert(str_message: "You are not connected to the internet.", completionHandler: {
            })
            return
        }
        
        if txt_email.text == "" {
//            DispatchQueue.main.async {
//                self.view.makeToast("No Email Provided", duration: 3.0, position: .bottom)
//            }
            self.ShowAlert(str_message: "No Email Provided.", completionHandler: {
            })
            return
        }
        
        self.trySendResetLink(api_key: g_ProfileInfo.api_key, email: txt_email.text!, completionHandler: {success in
            if success == true {
                //self.navigationController?.popViewController(animated: true)
            } else {
                
            }
        })
    }
    
    //*************************    RESER PASSWORD  Methods      *************************//
    func trySendResetLink(api_key: String, email: String, completionHandler: @escaping (Bool) -> Void) {
        
        let params: NSDictionary = [
            "api_key": api_key,
            "email":    email
            ]
        
        let serviceObj = ServiceClass()
        
        SVProgressHUD.show()
        
        serviceObj.servicePostMethodWithAPIHeaderValue(apiValue: GlobalVar.APIHEADER, headerValue: GlobalVar.SENDRESETLINK, parameters: params, completion: { (responseObject) in
            
            SVProgressHUD.dismiss()
            
            if (responseObject != nil ) {
                
                let dict = responseObject as! [String: AnyObject]
                
                if (dict["success"] as? String) != nil {
                    
                    // "success": "Password reset link sent successfully if email exists"
                    //“If there’s a Drapr account linked to this email address, we’ll send over instruction to reset your password"
                    let str_success = dict["success"]  as! String
//                    DispatchQueue.main.async {
//                        self.view.makeToast("\(str_success)", duration: 3.0, position: .bottom)
//                    }
                    self.ShowAlert(str_message: "If there’s a Drapr account linked to this email address, we’ll send over instruction to reset your password.", completionHandler: {
                        completionHandler(true)
                    })
                    
                } else if (dict["error"] as? String) != nil {
                    
                    //"error": "Username or password incorrect"
                    let str_error = dict["error"]  as! String
//                    DispatchQueue.main.async {
//                        self.view.makeToast("\(str_error)", duration: 3.0, position: .bottom)
//                    }
                    self.ShowAlert(str_message: str_error, completionHandler: {
                        completionHandler(false)
                    })
                    
                    
                } else if (dict["Error"] as? String) != nil {
                    
                    //"Error": "Access denied. Unable to authenticate sss"
                    let str_Error = dict["Error"]  as! String
//                    DispatchQueue.main.async {
//                        self.view.makeToast("\(str_Error)", duration: 3.0, position: .bottom)
//                    }
                    self.ShowAlert(str_message: str_Error, completionHandler: {
                        completionHandler(false)
                    })

                    
                } else {
                    completionHandler(false)
                }
                
            }
                
            else {
                completionHandler(false)
            }
            
        })
    }
}
