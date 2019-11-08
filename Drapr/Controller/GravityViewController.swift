//
//  GravityViewController.swift
//  Drapr
//
//  Created by David Pastewka on 12/21/18.
//  Copyright © 2018 David Pastewka. All rights reserved.
//

import UIKit
import CoreMotion

var g_GoneNextPageFrom_Gravity: Int = 0
var g_current_Gravity_Flag: Bool = false

let g_motionManager = CMMotionManager()

class GravityViewController: UIViewController {
    
    //let motionManager = CMMotionManager()
    var timer: Timer!
    
    @IBOutlet weak var constraint_white_BaseView: NSLayoutConstraint!
    @IBOutlet weak var constraint_Red_UnderView: NSLayoutConstraint!
    
    @IBOutlet weak var view_Red_Under: UIView!
    
    
    @IBOutlet weak var view_Time: UIView!
    @IBOutlet weak var lbl_Time: UILabel!
    var timer_CountDown: Timer!
    var current_CountDown: Int = 1
    
    @IBOutlet weak var view_UsePrevVideo: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbl_Time.text = ""
        
        view_Time.fadeOut(0.0, delay: 0.0)
        timer_CountDown = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GravityViewController.UpdateCountDown), userInfo: nil, repeats: true)
        
        
//        g_motionManager.startAccelerometerUpdates()
        
//        motionManager.startGyroUpdates()
//        motionManager.startMagnetometerUpdates()
//        motionManager.startDeviceMotionUpdates()
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(GravityViewController.update), userInfo: nil, repeats: true) //0.05
        
        
        let ScreenHeight = UIScreen.main.bounds.height

        constraint_Red_UnderView.constant = ScreenHeight
        constraint_white_BaseView.constant = (1.0 - 0.2) * (ScreenHeight / 2)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        g_motionManager.startAccelerometerUpdates()
        g_motionManager.deviceMotionUpdateInterval = 0.01
        g_motionManager.startDeviceMotionUpdates()
        
        
        lbl_Time.text = ""
        g_GoneNextPageFrom_Gravity = 0
        current_CountDown = 1   //3   //6
        view_Time.fadeOut(0.0, delay: 0.0)
        
        if g_ProfileInfo.curVideoUrl == "" {
            view_UsePrevVideo.isHidden = true
        } else {
            view_UsePrevVideo.isHidden = false
        }
    }
    

    

//    override func shouldAutorotate() -> Bool {
//        if (UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft ||
//            UIDevice.current.orientation == UIDeviceOrientation.landscapeRight ||
//            UIDevice.current.orientation == UIDeviceOrientation.unknown) {
//            return false;
//        }
//        else {
//            return true;
//        }
//    }
    
    override open var shouldAutorotate: Bool {
        if (UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft ||
            UIDevice.current.orientation == UIDeviceOrientation.landscapeRight ||
            UIDevice.current.orientation == UIDeviceOrientation.unknown) {
            return false;
        }
        else {
            return true;
        }
    }
    
//    override func viewWillLayoutSubviews() {
//
//        let orientation: UIDeviceOrientation = UIDevice.current.orientation
//        print(orientation)
//
//        switch (orientation) {
//        case .portrait:
//            break
//        case .landscapeRight:
//            break
//        case .landscapeLeft:
//            break
//        default:
//            break
//        }
//    }
    
    @objc func UpdateCountDown() {
        
        self.view_Time.fadeOut(0.1, delay: 0.1)
        
        if g_current_Gravity_Flag == true {
            
            if g_GoneNextPageFrom_Gravity == 0 {
                
                current_CountDown = current_CountDown - 1
                lbl_Time.text = "\(current_CountDown)"
                
                view_Time.fadeIn(0.2, delay: 0.2, completion: {_ in
                    
                    if self.current_CountDown == 0 {
                        
                        self.view_Time.fadeOut(0.0, delay: 0.0)
                        
                        g_current_Pop_Pages = g_current_Pop_Pages + 1                        
                        self.performSegue(withIdentifier: StorySegues.FromGravityVCToRecordingVC.rawValue, sender: self)
                    }
                })
            }
            
            
            
        }
        
    }
    
    
    var bool_init_portrait: Bool = true
    @objc func update() {
        
        let orientation: UIDeviceOrientation = UIDevice.current.orientation
        print(orientation)
        
        switch (orientation) {
        case .portrait:
            break
        case .landscapeRight:
            bool_init_portrait = false
            g_current_Gravity_Flag = false
            self.ShowAlert(str_message: "Please ensure your phone is oriented in portrait mode.", completionHandler: {
                self.bool_init_portrait = true
            })
            return
        case .landscapeLeft:
            bool_init_portrait = false
            g_current_Gravity_Flag = false
            self.ShowAlert(str_message: "Please ensure your phone is oriented in portrait mode.", completionHandler: {
                self.bool_init_portrait = true
            })
            return
        default:
            break
        }

        if bool_init_portrait == false {
            return
        }
        
        if let gravity = g_motionManager.deviceMotion?.gravity {
                let rotationYZRad = (atan2(gravity.y, gravity.z) - Double.pi)
                let rotationYZDeg = rotationYZRad * 180/Double.pi * -1.0
//                print(rotationYZDeg)
                let ScreenHeight = UIScreen.main.bounds.height
                let tiltBottomBoundary = 270.0
                let tiltTopBoundary = 310.0
                let tiltRange = tiltTopBoundary - tiltBottomBoundary
                let pinkBlueBoundary = 180.0
                let pink = UIColor.init(red: 250.0/255.0, green: 107.0/255.0, blue: 97.0/255.0, alpha: 1.0)
                let green = UIColor.init(red: 116.0/255.0, green: 190.0/255.0, blue: 79.0/255.0, alpha: 1.0)
                
                if rotationYZDeg <= pinkBlueBoundary || rotationYZDeg > tiltTopBoundary { // All blue

                    g_current_Gravity_Flag = false // Mark this as not the correct orientation
                    self.current_CountDown = 1   // Set the coundown to 1 second
                    self.constraint_Red_UnderView.constant = ScreenHeight // Don't show tilt bar
                    self.view_Red_Under.backgroundColor = pink
                    
                } else if rotationYZDeg > pinkBlueBoundary && rotationYZDeg <= tiltBottomBoundary { // All pink

                    g_current_Gravity_Flag = false // Mark this as not the correct orientation
                    self.current_CountDown = 1   // Set the coundown to 1 second
                    self.constraint_Red_UnderView.constant = 0 // Tilt bar fullscreen
                    self.view_Red_Under.backgroundColor = pink
                    
                } else if rotationYZDeg > tiltBottomBoundary && rotationYZDeg <= tiltTopBoundary{ // Tilt bar active

                    g_current_Gravity_Flag = false // Mark this as not the correct orientation
                    self.constraint_Red_UnderView.constant = CGFloat((rotationYZDeg - tiltBottomBoundary) / tiltRange) * ScreenHeight// Update height of level
                    self.view_Red_Under.backgroundColor = pink
                    
                    if rotationYZDeg > 284.0 && rotationYZDeg < 286.0 { // Correct orientation

                        g_current_Gravity_Flag = true // Mark this as not the correct orientation
                        self.constraint_Red_UnderView.constant = 0 // Tilt bar fullscreen
                        self.view_Red_Under.backgroundColor = green
                        
                    } else {
                        self.current_CountDown = 1   // Reset countdown timer to 1 sec
                    }
                }
            }        
        

            
//            if rotationYZDeg > 0 {
//                g_current_Gravity_Flag = false // Mark this as not the correct orientation
//                current_CountDown = 1   // Set the coundown to 1 second
//
//                self.view_Time.fadeOut(0.1, delay: 0.1)
//                self.constraint_Red_UnderView.constant = ScreenHeight / 2 + CGFloat(Double(ScreenHeight / 2) * accelerometerData.acceleration.z) // Update height of level
//                self.view_Red_Under.backgroundColor = UIColor.init(red: 250.0/255.0, green: 107.0/255.0, blue: 97.0/255.0, alpha: 1.0) // Set level color to Pink
//
//            } else {
//                if rotationYZDeg > -0.4 && rotationYZDeg < -0.2  {
//                    g_current_Gravity_Flag = true // Mark this as the correct orientation
//
//                        self.constraint_Red_UnderView.constant = self.constraint_white_BaseView.constant // Set level fullscreen?
//                        self.view_Red_Under.backgroundColor = UIColor.init(red: 116.0/255.0, green: 190.0/255.0, blue: 79.0/255.0, alpha: 1.0) // Set level color to green
//
//                } else {
//                    g_current_Gravity_Flag = false
//                    current_CountDown = 1   // set countdown to 1 second
//
//                    self.view_Time.fadeOut(0.1, delay: 0.1)
//                    self.constraint_Red_UnderView.constant = CGFloat((-1.0) * (-1.0 - accelerometerData.acceleration.z) * Double(ScreenHeight / 2))
//                    self.view_Red_Under.backgroundColor = UIColor.init(red: 250.0/255.0, green: 107.0/255.0, blue: 97.0/255.0, alpha: 1.0) // Pink
//                }
//
//            }
        
    }
    
    @IBAction func onTapped_Back_Method(_ sender: Any) {
        
        
        //if g_Flag_straight_From == 2 {
            if timer != nil {
                timer.invalidate()
                timer = nil
            }
            if timer_CountDown != nil {
                timer_CountDown.invalidate()
                timer_CountDown = nil
            }
        //}
        
        g_current_Pop_Pages = g_current_Pop_Pages - 1
        g_Flag_straight_From = 1
        
        g_motionManager.stopAccelerometerUpdates()
        g_motionManager.stopDeviceMotionUpdates()
        g_GoneNextPageFrom_Gravity = 2
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func onTapped_UsePrevVideo(_ sender: Any) {
        g_GoneNextPageFrom_Gravity = 3
        g_current_Pop_Pages = g_current_Pop_Pages + 1
        self.performSegue(withIdentifier: StorySegues.FromGravityVCToSubmittingVC.rawValue, sender: self)
    }
}
