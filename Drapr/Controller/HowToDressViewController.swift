//
//  HowToDressViewController.swift
//  Drapr
//
//  Created by Pedro on 12/21/18.
//  Copyright © 2018 Pedro. All rights reserved.
//


import UIKit
import AVFoundation

@available(iOS 10.0, *)
class HowToDressViewController: UIViewController {

    @IBOutlet weak var btn_Next_Method: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         btn_Next_Method.layer.cornerRadius = 8.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onTapped_Back_Method(_ sender: Any) {
        g_current_Pop_Pages = g_current_Pop_Pages - 1
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTapped_Next_Method(_ sender: Any) {
        
        AVCaptureDevice.requestAccess(for: .video) { success in
            if success { // if request is granted (success is true)
                
            } else { // if request is denied (success is false)
                // Create Alert
                let alert = UIAlertController(title: "Drapr Try-On", message: "Camera access is absolutely necessary to use this app", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
                    self.ShowAlert(str_message: "Please allow access to the camera in the device's Settings -> Privacy -> Camera.", completionHandler: {
                    })
                }))
                alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { action in
                    UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
                }))
                // Show the alert with animation
                self.present(alert, animated: true)
            }
        }
        
        g_current_Pop_Pages = g_current_Pop_Pages + 1
        self.performSegue(withIdentifier: StorySegues.FromHowDressVCToDressVideoVC.rawValue, sender: self)
    }
    
}
