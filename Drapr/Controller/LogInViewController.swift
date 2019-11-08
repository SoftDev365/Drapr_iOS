//
//  LogInViewController.swift
//  Drapr
//
//  Created by Pedro on 12/19/18.
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

    
class LogInViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    let GlobalVar = Global()
    
    @IBOutlet weak var view_email: UIView!
    @IBOutlet weak var view_password: UIView!
    
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    
    @IBOutlet weak var btn_LogIn: UIButton!
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
        
        /*let str_height = UserDefaults.standard.string(forKey: "height")
        if (str_height != nil) {
            
            g_ProfileInfo.height = str_height!
        } else {
            g_ProfileInfo.height = "70"
        }
        
        let str_weight = UserDefaults.standard.string(forKey: "weight")
        if (str_weight != nil) {
            
            g_ProfileInfo.weight = str_weight!
        } else {
            g_ProfileInfo.weight = "150"
        }
        
        let str_gender = UserDefaults.standard.string(forKey: "gender")
        if (str_gender != nil) {
            
            g_ProfileInfo.gender = str_gender!
        } else {
            g_ProfileInfo.gender = "male"
        }
        */
        
        g_current_Pop_Pages = 0
        
        GIDSignIn.sharedInstance().signOut()
        
        if FBSDKAccessToken.current() != nil {
            let logout = FBSDKLoginManager()
            logout.logOut()
            FBSDKAccessToken.setCurrent(nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func InitUI() {
        view_email.layer.cornerRadius = 8.0
        view_password.layer.cornerRadius = 8.0
        btn_LogIn.layer.cornerRadius = 8.0
        btn_facebook.layer.cornerRadius = 8.0
        btn_google.layer.cornerRadius = 8.0
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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
    
    @IBAction func onTapped_GotoRigister_Method(_ sender: Any) {
         self.performSegue(withIdentifier: StorySegues.FromLoginVCToOptionVC.rawValue, sender: self)
    }
    
    @IBAction func onTapped_ResetPass_Method(_ sender: Any) {
        
        g_ProfileInfo.email = txt_email.text!
        self.performSegue(withIdentifier: StorySegues.FromLoginVCToResetVC.rawValue, sender: self)
    }
    
    
    @IBAction func onTapped_Login_Method(_ sender: Any) {
//        let app = UIApplication.shared
//        let subviews = ((app.value(forKey: "statusBar") as! UIView).value(forKey: "foregroundView") as! UIView).subviews
//        var dataNetworkItemView: UIView? = nil
//        for subview in subviews {
//            if subview.isKind(of: NSClassFromString("UIStatusBarSignalStrengthItemView")!) {
//                dataNetworkItemView = subview
//            }
//        }
//        let signalStrength = dataNetworkItemView?.value(forKey: "signalStrengthRaw") as! Double
//        if (signalStrength > 0) {
//
//        } else {
//
//        }
        
        
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
        if txt_password.text == "" {
//            DispatchQueue.main.async {
//                self.view.makeToast("No Password Provided", duration: 3.0, position: .bottom)
//            }
            self.ShowAlert(str_message: "No Password Provided.", completionHandler: {
            })
            return
        }
        
        trySign_In(api_key: g_ProfileInfo.api_key, email: txt_email.text!, password: txt_password.text!, completionHandler: {success in
            if success == true {
                
                self.tryGetDetail(api_key: g_ProfileInfo.api_key, email: self.txt_email.text!, customer_key: g_ProfileInfo.customer_key, completionHandler: {succ in
                    
                    if succ == true {
                        //let submitted = UserDefaults.standard.bool(forKey: "submitted")
                        if (g_ProfileInfo.submitted == "1") {
                            
                            g_current_Pop_Pages = g_current_Pop_Pages + 1
                            g_Flag_straight_From = 1
                            self.performSegue(withIdentifier: StorySegues.FromLoginVCToWhatsVC.rawValue, sender: self)
                            
                        } else {
                            
                            g_current_Pop_Pages = g_current_Pop_Pages + 1
                            g_Flag_straight_From = 0
                            self.performSegue(withIdentifier: StorySegues.FromLoginVCToVolumeVC.rawValue, sender: self)
                            
                        }
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
            
            self.trySign_In(api_key: g_ProfileInfo.api_key, email: email! as String, password: facebookID as! String, completionHandler: {success in
                if success == true {
                    
                    self.tryGetDetail(api_key: g_ProfileInfo.api_key, email: email! as String, customer_key: g_ProfileInfo.customer_key, completionHandler: {succ in
                        
                        if succ == true {
                            //let submitted = UserDefaults.standard.bool(forKey: "submitted")
                            if (g_ProfileInfo.submitted == "1") {
                                
                                g_current_Pop_Pages = g_current_Pop_Pages + 1
                                g_Flag_straight_From = 1
                                self.performSegue(withIdentifier: StorySegues.FromLoginVCToWhatsVC.rawValue, sender: self)
                                
                            } else {
                                
                                g_current_Pop_Pages = g_current_Pop_Pages + 1
                                g_Flag_straight_From = 0
                                self.performSegue(withIdentifier: StorySegues.FromLoginVCToVolumeVC.rawValue, sender: self)
                                
                            }
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
            
            self.trySign_In(api_key: g_ProfileInfo.api_key, email: email!, password: uid, completionHandler: {success in
                if success == true {
                    
                    self.tryGetDetail(api_key: g_ProfileInfo.api_key, email: email! as String, customer_key: g_ProfileInfo.customer_key, completionHandler: {succ in
                        
                        if succ == true {
                            //let submitted = UserDefaults.standard.bool(forKey: "submitted")
                            if (g_ProfileInfo.submitted == "1") {
                                
                                g_current_Pop_Pages = g_current_Pop_Pages + 1
                                g_Flag_straight_From = 1
                                self.performSegue(withIdentifier: StorySegues.FromLoginVCToWhatsVC.rawValue, sender: self)
                                
                            } else {
                                
                                g_current_Pop_Pages = g_current_Pop_Pages + 1
                                g_Flag_straight_From = 0
                                self.performSegue(withIdentifier: StorySegues.FromLoginVCToVolumeVC.rawValue, sender: self)
                                
                            }
                        } else {
                            
                        }
                    })
                    
                } else {
                    
                }
            })
            
        })
    }
    
    
    
    
    //*************************    Login  Methods      *************************//
    func trySign_In(api_key: String, email: String, password: String, completionHandler: @escaping (Bool) -> Void) {
        
        let params: NSDictionary = [
            "api_key": api_key,
            "email":    email,
            "password": password,
            ]
        
        let serviceObj = ServiceClass()
        
        SVProgressHUD.show()
        
        serviceObj.servicePostMethodWithAPIHeaderValue(apiValue: GlobalVar.APIHEADER, headerValue: GlobalVar.USER_LOGIN, parameters: params, completion: { (responseObject) in
            
            SVProgressHUD.dismiss()
            
            if (responseObject != nil ) {
                
                let dict = responseObject as! [String: AnyObject]
                
                if (dict["success"] as? String) != nil {
                    
                    //"success": "User logged in successfully"
                    g_ProfileInfo.id            = dict["id"]            as! String
                    g_ProfileInfo.customer_key  = dict["customer_key"]  as! String
                    g_ProfileInfo.submitted     = dict["submitted"]     as! String
                    
                    
                    g_ProfileInfo.email         = email

                    UserDefaults.standard.set(true,      forKey: "SignIned")
                    UserDefaults.standard.set(email,     forKey: "email")
                    UserDefaults.standard.set(password,  forKey: "password")
                    
                    completionHandler(true)
                    
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
    
    
    
    //*************************    GetDetail  Methods      *************************//
    func tryGetDetail(api_key: String, email: String, customer_key: String, completionHandler: @escaping (Bool) -> Void) {
        
        let params: NSDictionary = [
            "api_key": api_key,
            "email":    email,
            "customer_key": customer_key
            ]
        
        let serviceObj = ServiceClass()
        
        SVProgressHUD.show()
        
        serviceObj.servicePostMethodWithAPIHeaderValue(apiValue: GlobalVar.APIHEADER, headerValue: GlobalVar.GETUSERDETAILS, parameters: params, completion: { (responseObject) in
            
            SVProgressHUD.dismiss()
            
            if (responseObject != nil ) {
                
                let dict = responseObject as! [String: AnyObject]
                
                if (dict["success"] as? String) != nil {
                    
                    g_ProfileInfo.id   = dict["id"]     as! String
                    
                    //"success": "User logged in successfully"
                    g_ProfileInfo.gender   = dict["gender"]     as! String
                    
                    if g_ProfileInfo.gender == "1" {
                        g_ProfileInfo.gender = "male"
                    } else if g_ProfileInfo.gender == "2" {
                        g_ProfileInfo.gender = "female"
                    }
                    
                    g_ProfileInfo.height   = dict["height"]     as! String
                    if g_ProfileInfo.height == "" {
                        
                        if g_ProfileInfo.gender == "male" {
                            g_ProfileInfo.height = "67"
                        } else {
                            g_ProfileInfo.height = "64"
                        }
                        
                    }
                    
                    if dict["weight"]     as? String != nil {
                        g_ProfileInfo.weight   = dict["weight"]     as! String
                        if g_ProfileInfo.weight == "" {
                            
                            if g_ProfileInfo.gender == "male" {
                                g_ProfileInfo.weight = "190"
                            } else {
                                g_ProfileInfo.weight = "170"
                            }
                        }
                    } else {
                        if g_ProfileInfo.gender == "male" {
                            g_ProfileInfo.weight = "190"
                        } else {
                            g_ProfileInfo.weight = "170"
                        }
                    }
                    
                    
                    completionHandler(true)
                    
                } else if (dict["error"] as? String) != nil {
                    
                    //"error": "E-mail or customer_key incorrect",
                    let str_error = dict["error"]  as! String
//                    DispatchQueue.main.async {
//                        self.view.makeToast("\(str_error)", duration: 3.0, position: .bottom)
//                    }
                    
                    completionHandler(false)
                    
                } else if (dict["Error"] as? String) != nil {
                    
                    //"Error": "Access denied. Unable to authenticate sss"
                    let str_Error = dict["Error"]  as! String
//                    DispatchQueue.main.async {
//                        self.view.makeToast("\(str_Error)", duration: 3.0, position: .bottom)
//                    }
                    
                    completionHandler(false)
                    
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







