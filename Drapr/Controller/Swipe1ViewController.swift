//
//  ViewController.swift
//  Drapr
//
//  Created by Pedro on 12/18/18.
//  Copyright © 2018 Pedro. All rights reserved.
//

import UIKit
import AVFoundation

import Foundation
import MediaPlayer


@available(iOS 10.0, *)
class Swipe1ViewController: UIViewController {
    
    
    @IBOutlet weak var btn_CreateAvatar: UIButton!
    
    @IBOutlet weak var Swiped_View: UIView!
    @IBOutlet weak var view_swipe1: UIView!
    @IBOutlet weak var view_swipe2: UIView!
    @IBOutlet weak var view_swipe3: UIView!
    @IBOutlet weak var view_swipe4: UIView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var VideoView: UIView!
    var moviePlayer: MPMoviePlayerController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        InitUI()
        
        // Swipe View
        let swiperight = UISwipeGestureRecognizer(target: self, action: #selector(self.getSwipeAction(_:)))
        swiperight.direction = .right
        Swiped_View.addGestureRecognizer(swiperight)
        let swipeleft = UISwipeGestureRecognizer(target: self, action: #selector(self.getSwipeAction(_:)))
        swiperight.direction = .left
        Swiped_View.addGestureRecognizer(swipeleft)
        
        /*AVCaptureDevice.requestAccess(for: .video) { success in
            if success { // if request is granted (success is true)

                
            } else { // if request is denied (success is false)
                // Create Alert
                let alert = UIAlertController(title: "Drapr Try-On", message: "Camera access is absolutely necessary to use this app", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { action in
                    UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
                }))
                // Show the alert with animation
                self.present(alert, animated: true)
            }
        }*/
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        
        //video
        let videoPath = Bundle.main.path(forResource: "first", ofType: "mp4")
        let videoURL = NSURL(fileURLWithPath: videoPath!)
        moviePlayer = MPMoviePlayerController.init(contentURL: videoURL as URL!)
        moviePlayer?.controlStyle = .none        //.none
        moviePlayer?.scalingMode = .aspectFill   //.none
        moviePlayer?.prepareToPlay()
        
        //moviePlayer?.view.frame = VideoView.bounds
        //VideoView.addSubview((moviePlayer?.view)!)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(movieFinish), name: NSNotification.Name.MPMoviePlayerPlaybackDidFinish, object: moviePlayer)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        moviePlayer?.play()
    }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews() {
        
        moviePlayer?.view.frame = VideoView.bounds
        VideoView.addSubview((moviePlayer?.view)!)
    }
    
    
    @objc func movieFinish() {
        moviePlayer?.play()
    }
    
    func InitUI() {
        
VideoView.isHidden = false
view_swipe1.backgroundColor = UIColor.clear
        
//VideoView.isHidden = true
//view_swipe1.backgroundColor = UIColor.white

        
        btn_CreateAvatar.layer.cornerRadius = 8.0
        
        self.pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        view_swipe1.isHidden = true
        view_swipe2.isHidden = true
        view_swipe3.isHidden = true
        view_swipe4.isHidden = true
        view_swipe1.isHidden = false
        let scaleX: Int = (4 - pageControl.numberOfPages) * 8
        pageControl.transform = CGAffineTransform(translationX: CGFloat(scaleX), y: 0)
    }
    
    @objc func getSwipeAction( _ recognizer : UISwipeGestureRecognizer){
        
        VideoView.isHidden = true
        view_swipe1.backgroundColor = UIColor.white
        moviePlayer?.pause()
        
//        if pageControl.numberOfPages == 0 || pageControl.numberOfPages == 1 {
//            return
//        }
        var index = (recognizer.direction == .right) ? -1 : 1
        index = (pageControl.currentPage + index < 0) ? pageControl.numberOfPages - 1 : index
        pageControl.currentPage = (pageControl.currentPage + index) % pageControl.numberOfPages
        let direction = (recognizer.direction == .right) ? kCATransitionFromLeft :  kCATransitionFromRight
        animateImageView(direction: direction)
        
        switch pageControl.currentPage {
        case 0:
            view_swipe1.isHidden = true
            view_swipe2.isHidden = true
            view_swipe3.isHidden = true
            view_swipe4.isHidden = true
            
            view_swipe1.isHidden = false
            VideoView.isHidden = false
            view_swipe1.backgroundColor = UIColor.clear
            moviePlayer?.play()
        case 1:
            view_swipe1.isHidden = true
            view_swipe2.isHidden = true
            view_swipe3.isHidden = true
            view_swipe4.isHidden = true
            
            view_swipe2.isHidden = false
        case 2:
            view_swipe1.isHidden = true
            view_swipe2.isHidden = true
            view_swipe3.isHidden = true
            view_swipe4.isHidden = true
            
            view_swipe3.isHidden = false
        case 3:
            view_swipe1.isHidden = true
            view_swipe2.isHidden = true
            view_swipe3.isHidden = true
            view_swipe4.isHidden = true
            
            view_swipe4.isHidden = false
        default: break
        }
    }

    func animateImageView(direction: String) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.25)
        let transition = CATransition()
        transition.type = kCATransitionPush
        transition.subtype = direction
        self.Swiped_View.layer.add(transition, forKey: kCATransition)
        CATransaction.commit()
    }
    @IBAction func onTapped_LogIn_Method(_ sender: Any) {
        
//        VideoView.isHidden = true
//        view_swipe1.backgroundColor = UIColor.white
        
        moviePlayer?.pause()
        self.performSegue(withIdentifier: StorySegues.FromSwipeVCToLogInVC.rawValue, sender: self)
    }
    
    @IBAction func onTapped_Create_Method(_ sender: Any) {
        
//        VideoView.isHidden = true
//        view_swipe1.backgroundColor = UIColor.white
        
        moviePlayer?.pause()
        self.performSegue(withIdentifier: StorySegues.FromSwipeVCToOptionVC.rawValue, sender: self)
    }
    
}

