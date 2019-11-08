//
//  WhatsNextViewController.swift
//  Drapr
//
//  Created by Pedro on 12/24/18.
//  Copyright © 2018 Pedro. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

class WhatsNextViewController: UIViewController, UIWebViewDelegate {

    
    @IBOutlet weak var btn_TakeAnotherVideo: UIButton!
    @IBOutlet weak var btn_TryDemo: UIButton!
    @IBOutlet weak var btn_logout: UIButton!
    
    @IBOutlet weak var lbl_submittedTime: UILabel!
    
    @IBOutlet weak var view_TryDemo: UIView!

    @IBOutlet weak var webView: UIWebView!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        view_TryDemo.fadeOut(0.0, delay: 0.0)
            
        if let url = URL(string: "https://drapr.com/viewer/review/review.php?height=\(g_ProfileInfo.height)&weight=\(g_ProfileInfo.weight)&gender=\(g_ProfileInfo.gender)&id=\(g_ProfileInfo.id)&customer_key=\(g_ProfileInfo.customer_key)") {
            let request = URLRequest(url: url)
            webView.mediaPlaybackRequiresUserAction = false
            webView.loadRequest(request)
        }
        
        InitUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
        view_TryDemo.fadeOut(0.0, delay: 0.0)
        
//        let date = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "hh:mm a"
//        var strDate = dateFormatter.string(from: date)

         let str_Notification_Time = UserDefaults.standard.string(forKey: "Notification_Time")
         if (str_Notification_Time != nil) {
            
            lbl_submittedTime.text = "Your video was submitted at \(str_Notification_Time!) and it usually takes one hour to process your avatar."
            
         } else {
            lbl_submittedTime.text = ""
         }
 
        

    }
    func InitUI() {
        btn_TakeAnotherVideo.layer.cornerRadius = 8
        btn_TryDemo.layer.cornerRadius = 8
        btn_logout.layer.cornerRadius = 8
    }

    @IBAction func onTapped_TakeAnotherVideo_Method(_ sender: Any) {
        
/*
        if (g_Flag_straight_From == 0) {    //login -> volume -> ... ->whatsNext
            
            g_GoneNextPageFrom_Gravity = 0
            var viewControllers = navigationController?.viewControllers
            viewControllers?.removeLast(4)
            navigationController?.setViewControllers(viewControllers!, animated: true)
            
        } else {                             //login -> whatsNext
            
            g_current_Pop_Pages = g_current_Pop_Pages + 1            
            g_Flag_straight_From = 2
            g_GoneNextPageFrom_Gravity = 0
            self.performSegue(withIdentifier: StorySegues.FromWhatsVCToGravityVC.rawValue, sender: self)
        }
*/
        
        g_current_Pop_Pages = g_current_Pop_Pages + 1
        g_Flag_straight_From = 2
        g_GoneNextPageFrom_Gravity = 0
        self.performSegue(withIdentifier: StorySegues.FromWhatsNextVCToVolumeVC.rawValue, sender: self)
        
        
    }
    
    @IBAction func onTapped_TryDemo_Method(_ sender: Any) {
        view_TryDemo.fadeIn(0.3, delay: 0.3)
    }
    
    @IBAction func onTapped_Back_Method(_ sender: Any) {
        
        g_current_Pop_Pages = g_current_Pop_Pages - 1
        view_TryDemo.fadeOut(0.05, delay: 0.05)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTapped_Hide_TryDemo(_ sender: Any) {
        view_TryDemo.fadeOut(0.05, delay: 0.05)
    }
    
    @IBAction func onTapped_Set_Reminder(_ sender: Any) {
        
//        DispatchQueue.main.async {
//            self.view.makeToast("You set a push notification reminder for 25 minutes later.", duration: 3.0, position: .bottom)
//        }

        self.ShowAlert(str_message: "You set a push notification reminder for 25 minutes later.", completionHandler: {
        })
        
    }
    
    
    @IBAction func onTapped_Logout_Method(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signOut()
        
        if FBSDKAccessToken.current() != nil {
            let logout = FBSDKLoginManager()
            logout.logOut()
            FBSDKAccessToken.setCurrent(nil)
        
        }
        

/*
        if (g_Flag_straight_From == 1) {         //login -> whatsNext
            
            var viewControllers = navigationController?.viewControllers
            viewControllers?.removeLast(g_current_Pop_Pages)
            navigationController?.setViewControllers(viewControllers!, animated: true)
            
            
        } else if g_Flag_straight_From == 0 {    //login -> volume -> ... ->whatsNext
            
            var viewControllers = navigationController?.viewControllers
            viewControllers?.removeLast(9)
            navigationController?.setViewControllers(viewControllers!, animated: true)
            
        } else {                                 //login -> whatsNext
            
            var viewControllers = navigationController?.viewControllers
            viewControllers?.removeLast(g_current_Pop_Pages)
            navigationController?.setViewControllers(viewControllers!, animated: true)
        }
*/
        
        var viewControllers = navigationController?.viewControllers
        viewControllers?.removeLast(g_current_Pop_Pages)
        navigationController?.setViewControllers(viewControllers!, animated: true)
        
    }
    
}
