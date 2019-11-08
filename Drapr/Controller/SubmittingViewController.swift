//
//  SubmittingViewController.swift
//  Drapr
//
//  Created by Pedro on 12/23/18.
//  Copyright © 2018 Pedro. All rights reserved.
//

import SwiftyJSON
import Alamofire

import UIKit
import SwiftyCam
import AVFoundation
import MediaPlayer
import SVProgressHUD

import AVKit
import Foundation

import UserNotifications
    
class SubmittingViewController: UIViewController, AVAudioPlayerDelegate {

    var AFManager = SessionManager()
    
    let GlobalVar = Global()
    
    
    @IBOutlet weak var btn_Submit: UIButton!
    @IBOutlet weak var btn_TakeAgain: UIButton!
    
    @IBOutlet weak var btn_Yes_1: UIButton!
    @IBOutlet weak var btn_Yes_2: UIButton!
    @IBOutlet weak var btn_Yes_3: UIButton!
    @IBOutlet weak var btn_Yes_4: UIButton!
    
    @IBOutlet weak var btn_No_1: UIButton!
    @IBOutlet weak var btn_No_2: UIButton!
    @IBOutlet weak var btn_No_3: UIButton!
    @IBOutlet weak var btn_No_4: UIButton!
    
    var count_Flag: Array<Int> = Array<Int>()
    
    
    @IBOutlet weak var view_uploadingBackground: UIView!
    @IBOutlet weak var view_failedBackground: UIView!
    
    
    @IBOutlet weak var const_icon: NSLayoutConstraint!
    @IBOutlet weak var view_icon: UIView!
    @IBOutlet weak var img_icon: UIImageView!
    @IBOutlet weak var lbl_uploading: UILabel!
    
    var timer: Timer!
    //var timer_1: Timer!
    
    @IBOutlet weak var view_back: UIView!
    
    var moviePlayer: MPMoviePlayerController?
    @IBOutlet weak var view_video: UIView!    
    
    let avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    
    var player4: AVAudioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var img_FrontOfVideo: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //video
        let videoPath = g_ProfileInfo.curVideoUrl
        let videoURL = NSURL(fileURLWithPath: videoPath)
        self.moviePlayer = MPMoviePlayerController.init(contentURL: videoURL as URL!)
        self.moviePlayer?.controlStyle = .none        //.none
        self.moviePlayer?.scalingMode = .aspectFit
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(movieFinish), name: NSNotification.Name.MPMoviePlayerPlaybackDidFinish, object: moviePlayer)       
        
        NotificationCenter.default.addObserver(self, selector: #selector(moviePlayerPlaybackStateDidChange), name: NSNotification.Name.MPMoviePlayerPlaybackStateDidChange, object: moviePlayer)

        
        // Do any additional setup after loading the view.
        view_uploadingBackground.fadeOut(0.0, delay: 0.0)
        view_failedBackground.fadeOut(0.0, delay: 0.0)

//        timer = Timer.scheduledTimer(timeInterval: 0.055, target: self, selector: #selector(SubmittingViewController.update), userInfo: nil, repeats: true) //0.055
        //timer_1 = Timer.scheduledTimer(timeInterval: 0.45, target: self, selector: #selector(SubmittingViewController.update_1), userInfo: nil, repeats: true)
        
        
        do{
            let audioPath = Bundle.main.path(forResource: "instructional-video-v2-part7", ofType: "m4a")
            player4 = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: audioPath!))
            player4.prepareToPlay()
            player4.delegate = self
        }
        catch{
            print(error)
        }
    }

    override func viewWillAppear(_ animated: Bool) {

        img_FrontOfVideo.isHidden = false
        let videoPath = g_ProfileInfo.curVideoUrl
        //let videoURL = NSURL(fileURLWithPath: videoPath)
        img_FrontOfVideo.image = generateThumbnailForVideoAtURL(filePathLocal: videoPath as NSString)

        lbl_uploading.text = "Uploading..."
        
        self.moviePlayer?.view.frame = self.view_video.bounds
        self.view_video.addSubview((self.moviePlayer?.view)!)
        //self.moviePlayer?.prepareToPlay()
        self.moviePlayer?.play()
        self.moviePlayer?.currentPlaybackRate = 2
  
        player4.play()
        
        count_Flag.removeAll()
        for i in 0..<4 {
            count_Flag.append(-1)
        }
        
        InitUI()
    }
    
//    override func viewDidLayoutSubviews() {
//        DispatchQueue.main.async {
//            self.moviePlayer?.view.frame = self.view_video.bounds
//            self.view_video.addSubview((self.moviePlayer?.view)!)
//            //self.moviePlayer?.prepareToPlay()
//            self.moviePlayer?.play()
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        
        if player == player4 {
            player4.stop()
        }
    }
    
    @objc func moviePlayerPlaybackStateDidChange(notification: NSNotification) {
        let moviePlayerController = notification.object as! MPMoviePlayerController
        
        var playbackState: String = "Unknown"
        switch moviePlayerController.playbackState {
        case .stopped:
            playbackState = "Stopped"
        case .playing:
            playbackState = "Playing"
            self.img_FrontOfVideo.isHidden = true
            
        case .paused:
            playbackState = "Paused"
        case .interrupted:
            playbackState = "Interrupted"
        case .seekingForward:
            playbackState = "Seeking Forward"
        case .seekingBackward:
            playbackState = "Seeking Backward"
        }
        
        print("Playback State: %@", playbackState)
    }
    
    @objc func movieFinish() {
        moviePlayer?.play()
    }
    
    @IBAction func onTapped_PayingWithFullScreen(_ sender: Any) {
        
//        moviePlayer?.stop()
        
//        DispatchQueue.main.async {
//            var videoURL = URL(fileURLWithPath: g_ProfileInfo.old_VideoUrl)
//            let fileManager = FileManager.default
//            if !fileManager.fileExists(atPath: g_ProfileInfo.old_VideoUrl) {
//                videoURL = URL(fileURLWithPath: g_ProfileInfo.old_VideoUrl)
//            }
//            let player = AVPlayer(url: videoURL)
//            let playerViewController = AVPlayerViewController()
//            playerViewController.player = player
//            self.present(playerViewController, animated: true) {
//                playerViewController.player!.play()
//            }
//        }
    }
    

//    @objc func update() {
//            const_icon.constant = const_icon.constant + 3
//
//            if const_icon.constant > 80 {
//                const_icon.constant = 3
//            }
//    }
    
    /*@objc func update_1() {

        if lbl_uploading.text == "Uploading" {
            lbl_uploading.text = "Uploading."
            
        } else if lbl_uploading.text == "Uploading." {
            lbl_uploading.text = "Uploading.."
            
        } else if lbl_uploading.text == "Uploading.." {
            lbl_uploading.text = "Uploading..."
            
        } else if lbl_uploading.text == "Uploading..." {
            lbl_uploading.text = "Uploading...."
            
        } else if lbl_uploading.text == "Uploading...." {
            lbl_uploading.text = "Uploading....."
            
        } else if lbl_uploading.text == "Uploading....." {
            lbl_uploading.text = "Uploading"
            
        } else {
            print("what is it ?")
        }
    }
    */
    
    func InitUI() {

        isCheckedAll()
        btn_Submit.layer.cornerRadius = 8
        btn_TakeAgain.layer.cornerRadius = 8
        
        view_back.layer.cornerRadius = view_back.bounds.size.height / 2.0
        
        btn_Yes_1.layer.borderColor = UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 0.7).cgColor
        btn_Yes_1.layer.cornerRadius = 2
        btn_Yes_1.layer.borderWidth = 1
        btn_Yes_2.layer.borderColor = UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 0.7).cgColor
        btn_Yes_2.layer.cornerRadius = 2
        btn_Yes_2.layer.borderWidth = 1
        btn_Yes_3.layer.borderColor = UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 0.7).cgColor
        btn_Yes_3.layer.cornerRadius = 2
        btn_Yes_3.layer.borderWidth = 1
        btn_Yes_4.layer.borderColor = UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 0.7).cgColor
        btn_Yes_4.layer.cornerRadius = 2
        btn_Yes_4.layer.borderWidth = 1
        
        btn_No_1.layer.borderColor = UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 0.7).cgColor
        btn_No_1.layer.cornerRadius = 2
        btn_No_1.layer.borderWidth = 1
        btn_No_2.layer.borderColor = UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 0.7).cgColor
        btn_No_2.layer.cornerRadius = 2
        btn_No_2.layer.borderWidth = 1
        btn_No_3.layer.borderColor = UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 0.7).cgColor
        btn_No_3.layer.cornerRadius = 2
        btn_No_3.layer.borderWidth = 1
        btn_No_4.layer.borderColor = UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 0.7).cgColor
        btn_No_4.layer.cornerRadius = 2
        btn_No_4.layer.borderWidth = 1
        
        btn_Yes_1.setTitleColor(UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0), for: .normal)
        btn_Yes_2.setTitleColor(UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0), for: .normal)
        btn_Yes_3.setTitleColor(UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0), for: .normal)
        btn_Yes_4.setTitleColor(UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0), for: .normal)
        btn_No_1.setTitleColor(UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0), for: .normal)
        btn_No_2.setTitleColor(UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0), for: .normal)
        btn_No_3.setTitleColor(UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0), for: .normal)
        btn_No_4.setTitleColor(UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0), for: .normal)
    }

    @IBAction func onTapped_Back_Method(_ sender: Any) {
        
        self.view_uploadingBackground.fadeOut(0.0, delay: 0.0)
        self.view_failedBackground.fadeOut(0.0, delay: 0.0)
        
        player4.stop()
        
        moviePlayer?.pause()
        
        if g_GoneNextPageFrom_Gravity == 3 {
            moviePlayer?.pause()
//          moviePlayer?.stop()
            g_current_Pop_Pages = g_current_Pop_Pages - 1
            self.navigationController?.popViewController(animated: true)
            
        } else {
            g_current_Pop_Pages = g_current_Pop_Pages - 2
            
            var viewControllers = navigationController?.viewControllers
            viewControllers?.removeLast(2)
            navigationController?.setViewControllers(viewControllers!, animated: true)
        }
    }
  
    @IBAction func onTapped_Yes_1(_ sender: Any) {
        btn_Yes_1.backgroundColor = UIColor.init(red: 116.0/255.0, green: 190.0/255.0, blue: 79.0/255.0, alpha: 1.0)
        btn_No_1.backgroundColor = UIColor.clear
        btn_Yes_1.setTitleColor(UIColor.white, for: .normal)
        btn_No_1.setTitleColor(UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0), for: .normal)
        btn_Yes_1.layer.borderColor = UIColor.clear.cgColor
        btn_No_1.layer.borderColor = UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 0.7).cgColor
        count_Flag[0] = 1
        isCheckedAll()
    }
    
    @IBAction func onTapped_Yes_2(_ sender: Any) {
        btn_Yes_2.backgroundColor = UIColor.init(red: 116.0/255.0, green: 190.0/255.0, blue: 79.0/255.0, alpha: 1.0)
        btn_No_2.backgroundColor = UIColor.clear
        btn_Yes_2.setTitleColor(UIColor.white, for: .normal)
        btn_No_2.setTitleColor(UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0), for: .normal)
        btn_Yes_2.layer.borderColor = UIColor.clear.cgColor
        btn_No_2.layer.borderColor = UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 0.7).cgColor
        count_Flag[1] = 1
        isCheckedAll()
    }
    
    @IBAction func onTapped_Yes_3(_ sender: Any) {
        btn_Yes_3.backgroundColor = UIColor.init(red: 116.0/255.0, green: 190.0/255.0, blue: 79.0/255.0, alpha: 1.0)
        btn_No_3.backgroundColor = UIColor.clear
        btn_Yes_3.setTitleColor(UIColor.white, for: .normal)
        btn_No_3.setTitleColor(UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0), for: .normal)
        btn_Yes_3.layer.borderColor = UIColor.clear.cgColor
        btn_No_3.layer.borderColor = UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 0.7).cgColor
        count_Flag[2] = 1
        isCheckedAll()
    }
    
    @IBAction func onTapped_Yes_4(_ sender: Any) {
        btn_Yes_4.backgroundColor = UIColor.init(red: 116.0/255.0, green: 190.0/255.0, blue: 79.0/255.0, alpha: 1.0)
        btn_No_4.backgroundColor = UIColor.clear
        btn_Yes_4.setTitleColor(UIColor.white, for: .normal)
        btn_No_4.setTitleColor(UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0), for: .normal)
        btn_Yes_4.layer.borderColor = UIColor.clear.cgColor
        btn_No_4.layer.borderColor = UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 0.7).cgColor
        count_Flag[3] = 1
        isCheckedAll()
    }
    
    
    @IBAction func onTapped_No_1(_ sender: Any) {
        btn_Yes_1.backgroundColor = UIColor.clear
        btn_No_1.backgroundColor = UIColor.init(red: 255.0/255.0, green: 98.0/255.0, blue: 101.0/255.0, alpha: 1.0)
        btn_Yes_1.setTitleColor(UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0), for: .normal)
        btn_Yes_1.layer.borderColor = UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 0.7).cgColor
        btn_No_1.layer.borderColor = UIColor.clear.cgColor
        btn_No_1.setTitleColor(UIColor.white, for: .normal)
        count_Flag[0] = 0
        isCheckedAll()
    }
    
    @IBAction func onTapped_No_2(_ sender: Any) {
        btn_Yes_2.backgroundColor = UIColor.clear
        btn_No_2.backgroundColor = UIColor.init(red: 255.0/255.0, green: 98.0/255.0, blue: 101.0/255.0, alpha: 1.0)
        btn_Yes_2.setTitleColor(UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0), for: .normal)
        btn_Yes_2.layer.borderColor = UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 0.7).cgColor
        btn_No_2.layer.borderColor = UIColor.clear.cgColor
        btn_No_2.setTitleColor(UIColor.white, for: .normal)
        count_Flag[1] = 0
        isCheckedAll()
    }
    
    @IBAction func onTapped_No_3(_ sender: Any) {
        btn_Yes_3.backgroundColor = UIColor.clear
        btn_No_3.backgroundColor = UIColor.init(red: 255.0/255.0, green: 98.0/255.0, blue: 101.0/255.0, alpha: 1.0)
        btn_Yes_3.setTitleColor(UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0), for: .normal)
        btn_Yes_3.layer.borderColor = UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 0.7).cgColor
        btn_No_3.layer.borderColor = UIColor.clear.cgColor
        btn_No_3.setTitleColor(UIColor.white, for: .normal)
        count_Flag[2] = 0
        isCheckedAll()
    }
    
    @IBAction func onTapped_No_4(_ sender: Any) {
        btn_Yes_4.backgroundColor = UIColor.clear
        btn_No_4.backgroundColor = UIColor.init(red: 255.0/255.0, green: 98.0/255.0, blue: 101.0/255.0, alpha: 1.0)
        btn_Yes_4.setTitleColor(UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0), for: .normal)
        btn_Yes_4.layer.borderColor = UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 0.7).cgColor
        btn_No_4.layer.borderColor = UIColor.clear.cgColor
        btn_No_4.setTitleColor(UIColor.white, for: .normal)
        count_Flag[3] = 0
        isCheckedAll()
    }
    
    func isCheckedAll() -> Bool {
        
        var Flag: Bool = true
        
        var cnt_1: Int = 0
        var cnt_2: Int = 0
        var cnt_3: Int = 0
        
        
        for i in 0..<4 {
            
            if count_Flag[i] == -1 {

                cnt_1 = cnt_1 + 1
                Flag = false
                
            } else if count_Flag[i] == 0 {
                
                cnt_2 = cnt_2 + 1
                Flag = false
                
            } else {
                if count_Flag[i] == 1 {

                    cnt_3 = cnt_3 + 1
                }
                
            }
            
        }
            
        if cnt_1 == 4 {
            btn_Submit.backgroundColor = UIColor.init(red: 196.0/255.0, green: 207.0/255.0, blue: 212.0/255.0, alpha: 1.0)
            btn_Submit.setTitle("Submit Video", for: .normal)
        }
        
        if cnt_2 > 0 {
            btn_Submit.backgroundColor = UIColor.init(red: 255.0/255.0, green: 98.0/255.0, blue: 101.0/255.0, alpha: 1.0)
            btn_Submit.setTitle("Retake Video", for: .normal)
        }
        
        if cnt_3 == 4 {
            btn_Submit.backgroundColor = UIColor.init(red: 255.0/255.0, green: 98.0/255.0, blue: 101.0/255.0, alpha: 1.0)
            btn_Submit.setTitle("Submit Video", for: .normal)
        }
        
        return Flag
    }
    
    func AddLocalNotification_25min() {
        
        
            // iOS 10 support
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 8 support
        else if #available(iOS 8, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 7 support
        else {
            UIApplication.shared.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }        
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        
        
        let date = Date()
        var localNotification:UILocalNotification = UILocalNotification()
        //let newDate = Date(timeInterval: 10, since: Date())
        //let temp = Date()
        //print(temp)
        localNotification.fireDate = date.addingTimeInterval(90*60)       //25 * 60 = 25min
        localNotification.soundName = "Notification.mp3"
        localNotification.repeatInterval = NSCalendar.Unit.weekOfYear     //NSCalendar.Unit.weekday
        
        //localNotification.alertTitle = ""
        localNotification.alertBody = "Don’t forget to try on some clothing with your newly created personalized mannequin!"
        let app = UIApplication.shared
        app.scheduleLocalNotification(localNotification)
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let strDate = dateFormatter.string(from: date)
        UserDefaults.standard.set("\(strDate)", forKey: "Notification_Time")
    }
    
    
    func rotate2(imageView: UIImageView, aCircleTime: Double) { //UIView
        
        UIView.animate(withDuration: aCircleTime/2, delay: 0.0, options: .curveLinear, animations: {
            imageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }, completion: { finished in
            UIView.animate(withDuration: aCircleTime/2, delay: 0.0, options: .curveLinear, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*2))
            }, completion: { finished in
                self.rotate2(imageView: imageView, aCircleTime: aCircleTime)
            })
        })
    }
    
    
    @IBAction func onTappedTakeAgain(_ sender: Any) {
        
/*
        player4.stop()
        moviePlayer?.pause()
        
        view_uploadingBackground.fadeOut(0.0, delay: 0.0)
        view_failedBackground.fadeOut(0.0, delay: 0.0)
        
        g_current_Pop_Pages = g_current_Pop_Pages - 1
        
        var viewControllers = navigationController?.viewControllers
        viewControllers?.removeLast(2)
        navigationController?.setViewControllers(viewControllers!, animated: true)
 */
        
        player4.stop()
        moviePlayer?.pause()
        
        view_uploadingBackground.fadeOut(0.0, delay: 0.0)
        view_failedBackground.fadeOut(0.0, delay: 0.0)
        
        g_current_Pop_Pages = g_current_Pop_Pages + 1
        self.performSegue(withIdentifier: StorySegues.FromSubmittingVCToVolumeVC.rawValue, sender: self)
       
    }
    
    @IBAction func onTapped_Start_Uploading(_ sender: Any) {
        
        
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
        
        
        player4.stop()

        moviePlayer?.pause()
//      moviePlayer?.stop()
        if isCheckedAll() == true {
            
            
            if g_ProfileInfo.gender == "" {
                //            DispatchQueue.main.async {
                //                self.view.makeToast("No Gender Provided", duration: 3.0, position: .bottom)
                //            }
                self.ShowAlert(str_message: "No Gender Provided.", completionHandler: {
                })
                return
            }
            if g_ProfileInfo.height == "" {
                //            DispatchQueue.main.async {
                //                self.view.makeToast("No Height Provided", duration: 3.0, position: .bottom)
                //            }
                self.ShowAlert(str_message: "No Height Provided.", completionHandler: {
                })
                return
            }
            if g_ProfileInfo.weight == "" {
                //            DispatchQueue.main.async {
                //                self.view.makeToast("No Weight Provided", duration: 3.0, position: .bottom)
                //            }
                self.ShowAlert(str_message: "No Weight Provided.", completionHandler: {
                })
                return
            }
            
            
            
            view_uploadingBackground.fadeIn(0.1, delay: 0.1)
            rotate2(imageView: img_icon, aCircleTime: 1.0)
            
            tryAdduserdetailsv2(api_key: g_ProfileInfo.api_key, email: g_ProfileInfo.email, customer_key: g_ProfileInfo.customer_key, videoUrl: g_ProfileInfo.curVideoUrl, gender: g_ProfileInfo.gender, height: g_ProfileInfo.height, weight: g_ProfileInfo.weight, fx: "\(g_fx)", fy: "\(g_fy)", completionHandler: {success in
                if success == true {
                    
                    self.view_uploadingBackground.fadeOut(0.1, delay: 0.1)
                    
                    self.AddLocalNotification_25min()
                    
                    g_ProfileInfo.submitted = "1"
                    g_current_Pop_Pages = g_current_Pop_Pages + 1
                    
                    
                    let when = DispatchTime.now() + 3
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        self.performSegue(withIdentifier: StorySegues.FromSubmitVCToSuccessVC.rawValue, sender: self)
                    }
                    
                } else {
                    
                    self.view_uploadingBackground.fadeOut(0.0, delay: 0.0)
                    self.view_failedBackground.fadeIn(0.1, delay: 0.1)
                    
                }
            })
            
            
        } else {  //Retake Button
            
/*
            player4.stop()
            moviePlayer?.pause()
            
            g_current_Pop_Pages = g_current_Pop_Pages - 1
            
            var viewControllers = navigationController?.viewControllers
            viewControllers?.removeLast(2)
            navigationController?.setViewControllers(viewControllers!, animated: true)
 
 */
            player4.stop()
            moviePlayer?.pause()
            
            g_current_Pop_Pages = g_current_Pop_Pages + 1
            self.performSegue(withIdentifier: StorySegues.FromSubmittingVCToVolumeVC.rawValue, sender: self)
        }
    }

    //data uploading api call
    func tryAdduserdetailsv2(api_key: String, email: String, customer_key: String, videoUrl: String, gender: String, height: String, weight: String, fx: String, fy: String, completionHandler: @escaping (_ result: Bool)-> Void) {
        
        var params:[String: String]? = nil
        var headers:[String: String]? = nil

        
        let url = try! URLRequest(url: URL(string: GlobalVar.APIHEADER + GlobalVar.ADDUSERDETAILSV2)!, method: .post, headers: headers)
        
            
        params = ["api_key":      api_key,
                  "email":        email,
                  "customer_key": customer_key,
                  "gender":       gender,
                  "height":       height,
                  "weight":       weight,
                  "fx":           fx,
                  "fy":           fy,
                  
        ]

        
        do {
            
            var vURL = URL(fileURLWithPath: videoUrl)
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: videoUrl) {
                vURL = URL(fileURLWithPath: videoUrl)
            }
            
            let videoData = try Data(contentsOf: vURL)
            print("video data : \(videoData)")
            
            
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 1000 // seconds
            self.AFManager = Alamofire.SessionManager(configuration: configuration)
            
            
            let stream = InputStream.init(url: URL(string: videoUrl)!)
            //let stream = InputStream(data: videoData)
            let size = videoData.count
            
            BackendAPIManager.sharedInstance.alamoFireManager.upload(multipartFormData: { (multipartFormData) in
                
                multipartFormData.append(videoData,  withName: "videodata", fileName: "video.mp4", mimeType: "video/mp4")
                
                for (key, value) in params! {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }, with: url, encodingCompletion: { (result) in
                
                switch result {
                    
                case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                    
                    //case .success(let upload, _, _):
                    upload.responseJSON { response in
                        
                        debugPrint(response)
                        
                        if response.response?.statusCode == 200 {
                                    
                            let dict:[String:AnyObject] = response.result.value as! [String:AnyObject]
                            
                            if (dict["success"] as? String) != nil {
                                
                                //"success":  "User details received successfully"
                                let str_success = dict["success"]  as! String
//                                DispatchQueue.main.async {
//                                    self.view.makeToast("\(str_success)", duration: 3.0, position: .bottom)
//                                }

                                completionHandler(true)
                                
//                                self.ShowAlert(str_message: str_success, completionHandler: {
//                                    completionHandler(true)
//                                })
                                
                            } else if (dict["error"] as? String) != nil {
                                
                                //"error": "Username or password incorrect"
                                let str_error = dict["error"]  as! String
//                                DispatchQueue.main.async {
//                                    self.view.makeToast("\(str_error)", duration: 3.0, position: .bottom)
//                                }
//                                completionHandler(false)
                                self.ShowAlert(str_message: str_error, completionHandler: {
                                    completionHandler(false)
                                })
                                
                            } else if (dict["Error"] as? String) != nil {
                                
                                //"Error": "Access denied. Unable to authenticate sss"
                                let str_Error = dict["Error"]  as! String
//                                DispatchQueue.main.async {
//                                    self.view.makeToast("\(str_Error)", duration: 3.0, position: .bottom)
//                                }
//                                completionHandler(false)
                                
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
                    }
                case .failure(let encodingError):
                   completionHandler(false)
                    break
                }
                
            })
            BackendAPIManager.sharedInstance.alamoFireManager.backgroundCompletionHandler = {
                // do something when the request has finished
            }
            
        } catch  {
            completionHandler(false)
            print("exception catch at block - while uploading video")
        }
            
    }
    
}





















