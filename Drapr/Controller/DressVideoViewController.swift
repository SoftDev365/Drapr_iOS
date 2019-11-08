//
//  DressVideoViewController.swift
//  Drapr
//
//  Created by Pedro on 12/21/18.
//  Copyright © 2018 Pedro. All rights reserved.
//

import UIKit

import Foundation
import MediaPlayer
import AVFoundation


class DressVideoViewController: UIViewController {
    @IBOutlet weak var view_back: UIView!
    @IBOutlet weak var view_skip: UIView!
    
    @IBOutlet weak var VideoView: UIView!
    
    var moviePlayer: MPMoviePlayerController?
    
    @IBOutlet weak var img_FrontOfVideo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        InitUI()
        
        //video
        let videoPath = Bundle.main.path(forResource: "instructional-video-v2-part2-compressed-rotated", ofType: "mp4")
        let videoURL = NSURL(fileURLWithPath: videoPath!)
        moviePlayer = MPMoviePlayerController.init(contentURL: videoURL as URL!)
        moviePlayer?.controlStyle = .none        //.none
        moviePlayer?.scalingMode = .aspectFill   //.none
        moviePlayer?.prepareToPlay()
        
//        moviePlayer?.view.frame = VideoView.bounds
//        VideoView.addSubview((moviePlayer?.view)!)

        
        NotificationCenter.default.addObserver(self, selector: #selector(movieFinish), name: NSNotification.Name.MPMoviePlayerPlaybackDidFinish, object: moviePlayer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(moviePlayerPlaybackStateDidChange), name: NSNotification.Name.MPMoviePlayerPlaybackStateDidChange, object: moviePlayer)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        moviePlayer?.view.frame = VideoView.bounds
        VideoView.addSubview((moviePlayer?.view)!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        img_FrontOfVideo.isHidden = false
        //img_FrontOfVideo.image = generateThumbnailForVideoAtURL(filePathLocal: "instructional-video-v2-part2-compressed-rotated.mp4")

        
        moviePlayer?.play()
    }
    
    @objc func moviePlayerPlaybackStateDidChange(notification: NSNotification) {
        let moviePlayerController = notification.object as! MPMoviePlayerController
        
        var playbackState: String = "Unknown"
        switch moviePlayerController.playbackState {
        case .stopped:
            playbackState = "Stopped"
        case .playing:
            playbackState = "Playing"
            //img_FrontOfVideo.isHidden = true
            
            let when = DispatchTime.now() + 0.2 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                // Your code with delay
                self.img_FrontOfVideo.isHidden = true
            }
            
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
        g_current_Pop_Pages = g_current_Pop_Pages + 1
        self.performSegue(withIdentifier: StorySegues.FromHowDressVCToGravityVC.rawValue, sender: self)
    }
    
    func InitUI() {
        view_back.layer.cornerRadius = view_back.bounds.size.height / 2.0
        view_skip.layer.cornerRadius = view_skip.bounds.size.height / 2.0
    }
    
    @IBAction func onTapped_Back_Method(_ sender: Any) {
        moviePlayer?.pause()
        g_current_Pop_Pages = g_current_Pop_Pages - 1
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTapped_Skip_Method(_ sender: Any) {
        moviePlayer?.stop()
    }
}
