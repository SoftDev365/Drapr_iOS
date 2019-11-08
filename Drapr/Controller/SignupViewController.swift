//
//  SignupViewController.swift
//  Drapr
//
//  Created by Pedro on 12/20/18.
//  Copyright © 2018 Pedro. All rights reserved.
//

import UIKit
import SVProgressHUD

import FBSDKCoreKit
import FBSDKLoginKit

import Firebase
import GoogleSignIn

import FirebaseAuth
import FirebaseDatabase



class SignupViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    let GlobalVar = Global()
    
    @IBOutlet weak var view_email: UIView!
    @IBOutlet weak var view_password: UIView!
    @IBOutlet weak var view_accesscode: UIView!
    
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var txt_accesscode: UITextField!
    
    @IBOutlet weak var btn_Signup: UIButton!
    @IBOutlet weak var btn_facebook: UIButton!
    @IBOutlet weak var btn_google: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        InitUI()
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        g_current_Pop_Pages = 0
        
        GIDSignIn.sharedInstance().signOut()
        
        if FBSDKAccessToken.current() != nil {
            let logout = FBSDKLoginManager()
            logout.logOut()
            FBSDKAccessToken.setCurrent(nil)
        }
    }
    
    func InitUI() {
        view_email.layer.cornerRadius = 8.0
        view_password.layer.cornerRadius = 8.0
        view_accesscode.layer.cornerRadius = 8.0
        
        btn_Signup.layer.cornerRadius = 8.0
        btn_facebook.layer.cornerRadius = 8.0
        btn_google.layer.cornerRadius = 8.0
    }

    @IBAction func onTapped_Term(_ sender: Any) {
        let directionUrl = "https://drapr.com/terms-of-service/"
        
        if (UIApplication.shared.canOpenURL(URL(string:"https://drapr.com/terms-of-service/")!)) {
            UIApplication.shared.openURL(URL(string: directionUrl)!)
        } else {
            NSLog("Can't use Apple Maps");
        }
    }
    
    @IBAction func onTapped_Privacy(_ sender: Any) {
        let directionUrl = "https://drapr.com/privacy-policy/"
        
        if (UIApplication.shared.canOpenURL(URL(string:"https://drapr.com/privacy-policy/")!)) {
            UIApplication.shared.openURL(URL(string: directionUrl)!)
        } else {
            NSLog("Can't use Apple Maps");
        }
    }
    
    
    @IBAction func onTapped_Back_Method(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func onTapped_GotoLogin_Method(_ sender: Any) {
         self.performSegue(withIdentifier: StorySegues.FromSignupVCToLoginVC.rawValue, sender: self)
    }
    
    @IBAction func onTapped_Signup_Method(_ sender: Any) {        

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
//                self.view.makeToast("No Email Provided.", duration: 3.0, position: .bottom)
//            }
            self.ShowAlert(str_message: "No Email Provided.", completionHandler: {
            })
            return
        }
        if txt_password.text == "" {
//            DispatchQueue.main.async {
//                self.view.makeToast("No Password Provided", duration: 3.0, position: .bottom)
//            }
            self.ShowAlert(str_message: "No Password Provided.", completionHandler: {
            })
            return
        }
        
        
        if txt_email.text! == "" {
            g_ProfileInfo.name = ""
        } else {
            let name = txt_email.text!.characters.split{$0 == "@"}.map(String.init)
            g_ProfileInfo.name = name[0]
        }
        
        trySign_Up(api_key: g_ProfileInfo.api_key, name: g_ProfileInfo.name, email: txt_email.text!, password: txt_password.text!, accesscode: txt_accesscode.text!, completionHandler: {success in
            if success == true {
                
                
                
                self.tryAdduserdetailsv2(api_key: g_ProfileInfo.api_key, email: g_ProfileInfo.email, customer_key: g_ProfileInfo.customer_key, gender: g_ProfileInfo.gender, height: g_ProfileInfo.height, weight: g_ProfileInfo.weight, fx: "1800", fy: "1800", completionHandler: {succ in
                    
                    if succ == true {
                        
                        g_GoneNextPageFromVolue = 0
                        g_current_Pop_Pages = g_current_Pop_Pages + 1
                        self.performSegue(withIdentifier: StorySegues.FromSignupVCToVolumeVC.rawValue, sender: self)
                        
                    } else {
                        
                    }
                })
                
                
            } else {
                
            }
        })
        
        
    }
    
    @IBAction func onTapped_FB_Method(_ sender: Any) {
        
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
        
        
        
        if FBSDKAccessToken.current() != nil {
            let logout = FBSDKLoginManager()
            logout.logOut()
            FBSDKAccessToken.setCurrent(nil)
        }
        

        //FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self)
        FBSDKLoginManager().logIn(withReadPermissions: ["email"], from: self) { (result, err) in
            
            if err != nil {
                print("FB login failed: \(err)")
                return
            }
            self.showEmailAddress()
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        showEmailAddress()
    }
    
    func showEmailAddress() {
        
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("Something is wrong with FB user: \(error)")
            }
            
            print("successfully logged in with our user: \(user)")
            
        })

        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, first_name, last_name, email, picture.type(normal), link"]).start { (connection, result, err) in
            
            if err != nil {
                print("failed to login: \(err)")
                return
            }
            
            print(result ?? "")
            
            //-----------------------------------------------------------
            let data:[String:AnyObject] = result as! [String : AnyObject]
            
            let userName : NSString? = data["name"]! as? NSString
            let facebookID : NSString? = data["id"]! as? NSString
            let firstName : NSString? = data["first_name"]! as? NSString
            let lastName : NSString? = data["last_name"]! as? NSString
            let email : NSString? = data["email"]! as? NSString
            
            print(userName!)
            print(facebookID!)
            print(firstName!)
            print(lastName!)
            print(email!)
            //----------------------------------------------------------
            
            //logout----------------------------------------------------
            /*if FBSDKAccessToken.current() != nil {
             let logout = FBSDKLoginManager()
             logout.logOut()
             }*/
            //----------------------------------------------------------
            

            g_ProfileInfo.name = userName! as String
            
            self.trySign_Up(api_key: g_ProfileInfo.api_key, name: g_ProfileInfo.name, email: email! as String, password: facebookID as! String, accesscode: self.txt_accesscode.text!, completionHandler: {success in
                if success == true {
                    
                    self.tryAdduserdetailsv2(api_key: g_ProfileInfo.api_key, email: g_ProfileInfo.email, customer_key: g_ProfileInfo.customer_key, gender: g_ProfileInfo.gender, height: g_ProfileInfo.height, weight: g_ProfileInfo.weight, fx: "1800", fy: "1800", completionHandler: {succ in
                        
                        if succ == true {
                            
                            g_GoneNextPageFromVolue = 0
                            self.performSegue(withIdentifier: StorySegues.FromSignupVCToVolumeVC.rawValue, sender: self)
                            
                        } else {
                            
                        }
                    })
                    
                    
                } else {
                    
                }
            })            
        }
    }
    
    @IBAction func onTapped_Google_Method(_ sender: Any) {
        
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
        
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let err = error {
            print("Failed to log in with Google: \(err)")
            return
        }
        print("Successfully logged in with Goodle: \(user)")
        
        guard let idToken = user.authentication.idToken else { return }
        guard let accessToken = user.authentication.accessToken else { return }
        let credentials = FIRGoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if let err = error {
                print("Failed to create a user with google sign in methond: \(err)")
                return
            }

            guard let uid = user?.uid else { return }
            let userName = user?.displayName
            let email = user?.email
            
            print(uid)
            print(userName!)
            print(email!)
            
            g_ProfileInfo.name = userName!
            
            self.trySign_Up(api_key: g_ProfileInfo.api_key, name: g_ProfileInfo.name, email: email!, password: uid, accesscode: self.txt_accesscode.text!, completionHandler: {success in
                if success == true {
                    
                    self.tryAdduserdetailsv2(api_key: g_ProfileInfo.api_key, email: g_ProfileInfo.email, customer_key: g_ProfileInfo.customer_key, gender: g_ProfileInfo.gender, height: g_ProfileInfo.height, weight: g_ProfileInfo.weight, fx: "1800", fy: "1800", completionHandler: {succ in
                        
                        if succ == true {
                            
                            g_GoneNextPageFromVolue = 0
                            self.performSegue(withIdentifier: StorySegues.FromSignupVCToVolumeVC.rawValue, sender: self)
                            
                        } else {
                            
                        }
                    })
                    
                    
                } else {
                    
                }
            })
            
        })
    }
    
    
    //*************************    Signup  Methods      *************************//
    func trySign_Up(api_key: String, name: String, email: String, password: String, accesscode: String, completionHandler: @escaping (Bool) -> Void) {

        g_ProfileInfo.accesscode = accesscode
        
        let params: NSDictionary = [
            "api_key":     api_key,
            "name":        name,
            "email":       email,
            "password":    password,
            "accesscode":  accesscode
            ]
        
        let serviceObj = ServiceClass()
        
        SVProgressHUD.show()
        
        serviceObj.servicePostMethodWithAPIHeaderValue(apiValue: GlobalVar.APIHEADER, headerValue: GlobalVar.USER_SIGNUP, parameters: params, completion: { (responseObject) in
            
            SVProgressHUD.dismiss()
            
            if (responseObject != nil ) {
                
                let dict = responseObject as! [String: AnyObject]
                
                if (dict["success"] as? String) != nil {
                    
                    //"success": "User created successfully"
                    g_ProfileInfo.id            = dict["id"]            as! String
                    g_ProfileInfo.customer_key  = dict["customer_key"]  as! String
                    g_ProfileInfo.submitted     = dict["submitted"]     as! String
                    
                    g_ProfileInfo.email         = email
                    
                    UserDefaults.standard.set(true,      forKey: "SignIned")
                    UserDefaults.standard.set(email,     forKey: "email")
                    UserDefaults.standard.set(password,  forKey: "password")
                    
                    completionHandler(true)
                    
                } else if (dict["error"] as? String) != nil {
                    
                    //"error": "User/E-mail Already Exists"
                    let str_error = dict["error"]  as! String
//                    DispatchQueue.main.async {
//                        self.view.makeToast("\(str_error)", duration: 3.0, position: .bottom)
//                    }
                    self.ShowAlert(str_message: str_error, completionHandler: {
                        completionHandler(false)
                    })
                    
                    
                } else if (dict["Error"] as? String) != nil {

                    //"Error": "Access denied. Unable to authenticate 93jd9qjaS3SUISHhr39Su3uid0Kew3ds"
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
    
    //data uploading api call
    func tryAdduserdetailsv2(api_key: String, email: String, customer_key: String, gender: String, height: String, weight: String, fx: String, fy: String, completionHandler: @escaping (_ result: Bool)-> Void) {
        
        let params: NSDictionary = ["api_key":      api_key,
                                    "email":        email,
                                    "customer_key": customer_key,
                                    "gender":       gender,
                                    "height":       height,
                                    "weight":       weight,
                                    "fx":           fx,
                                    "fy":           fy,
                                    ]
        
        
        let serviceObj = ServiceClass()
        
        SVProgressHUD.show()
        
        serviceObj.servicePostMethodWithAPIHeaderValue(apiValue: GlobalVar.APIHEADER, headerValue: GlobalVar.GETUSERDETAILS, parameters: params, completion: { (responseObject) in
            
            SVProgressHUD.dismiss()
            
            if (responseObject != nil ) {
                
                let dict = responseObject as! [String: AnyObject]
                
                if (dict["success"] as? String) != nil {
                    
                    //"success": "User details received successfully"
                    let str_success = dict["success"]  as! String
//                    DispatchQueue.main.async {
//                        self.view.makeToast("\(str_success)", duration: 3.0, position: .bottom)
//                    }

                     completionHandler(true)
                    
//                    self.ShowAlert(str_message: str_success, completionHandler: {
//                        completionHandler(true)
//                    })
                    
                } else if (dict["error"] as? String) != nil {
                    
                    //"error": "E-mail or customer_key incorrect",
                    let str_error = dict["error"]  as! String
//                    DispatchQueue.main.async {
//                        self.view.makeToast("\(str_error)", duration: 3.0, position: .bottom)
//                    }
//
//                    completionHandler(false)
                    self.ShowAlert(str_message: str_error, completionHandler: {
                        completionHandler(false)
                    })
                    
                } else if (dict["Error"] as? String) != nil {
                    
                    //"Error": "Access denied. Unable to authenticate sss"
                    let str_Error = dict["Error"]  as! String
//                    DispatchQueue.main.async {
//                        self.view.makeToast("\(str_Error)", duration: 3.0, position: .bottom)
//                    }
//
//                    completionHandler(false)
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
