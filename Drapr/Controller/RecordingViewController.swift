//
//  RecordingViewController.swift
//  Drapr
//
//  Created by Pedro on 12/22/18.
//  Copyright © 2018 Pedro. All rights reserved.
//

import UIKit
import SwiftyCam
import AVFoundation
import MediaPlayer
import SVProgressHUD

import AVKit

class RecordingViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate, AVAudioPlayerDelegate {

    @IBOutlet weak var view_maskBackground: UIView!
    @IBOutlet weak var btn_maskButton: UIButton!
    
    @IBOutlet weak var btn_backButtonImage: UIButton!
    
    @IBOutlet weak var view_back: UIView!
    @IBOutlet weak var view_recording: UIView!
    @IBOutlet weak var view_circle: UIView!
    
    var player1: AVAudioPlayer = AVAudioPlayer()
    var player2: AVAudioPlayer = AVAudioPlayer()
    var player3: AVAudioPlayer = AVAudioPlayer()

    
    
    var timer: Timer!
    var gravity_timer: Timer!
    
    
    
    @IBOutlet weak var view_whole_VideoBackground: UIView!
    @IBOutlet weak var VideoView: UIView!
    var moviePlayer: MPMoviePlayerController?
    
    @IBOutlet weak var view_back_1: UIView!
    @IBOutlet weak var view_skip: UIView!
    
    
    
    @IBOutlet weak var view_Count: UIView!
    @IBOutlet weak var lbl_count: UILabel!
    var int_count: Int = 15
    
    @IBOutlet weak var img_FrontOfVideo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Recoding #################################################################################
defaultCamera = .front
//defaultCamera = .rear
        
        
        flashEnabled = false //true
        doubleTapCameraSwitch = false
        cameraDelegate = self
        
        allowBackgroundAudio = false
        //maximumVideoDuration = 10.0
        videoQuality = VideoQuality.low
        audioEnabled = false
        
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(RecordingViewController.update), userInfo: nil, repeats: true)
        
        do{
            let audioPath = Bundle.main.path(forResource: "instructional-video-v2-part3", ofType: "m4a")
            player1 = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: audioPath!))
            player1.prepareToPlay()
            player1.delegate = self
        }
        catch{
            print(error)
        }
        
        do{
            let audioPath = Bundle.main.path(forResource: "instructional-video-v2-part5", ofType: "m4a")
            player2 = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: audioPath!))
            player2.prepareToPlay()
            player2.delegate = self
        }
        catch{
            print(error)
        }
        
        do{
            let audioPath = Bundle.main.path(forResource: "instructional-video-v2-part6", ofType: "m4a")
            player3 = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: audioPath!))
            player3.prepareToPlay()
            player3.delegate = self
        }
        catch{
            print(error)
        }
        
        
        gravity_timer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(RecordingViewController.GravityUpdate), userInfo: nil, repeats: true) //0.01
        
        
        //video ####################################################################################
        let videoPath = Bundle.main.path(forResource: "instructional-video-v2-part4-compressed-rotated", ofType: "mp4")
        let videoURL = NSURL(fileURLWithPath: videoPath!)
        moviePlayer = MPMoviePlayerController.init(contentURL: videoURL as URL!)
        moviePlayer?.controlStyle = .none        //.none
        moviePlayer?.scalingMode = .aspectFill   //.none
        //moviePlayer?.prepareToPlay()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(movieFinish), name: NSNotification.Name.MPMoviePlayerPlaybackDidFinish, object: moviePlayer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(moviePlayerPlaybackStateDidChange), name: NSNotification.Name.MPMoviePlayerPlaybackStateDidChange, object: moviePlayer)

//        if let devices = AVCaptureDevice.devices(for: AVMediaType(rawValue: AVMediaType.video.rawValue)) as? [AVCaptureDevice] {
//            do {
//                let input = try AVCaptureDeviceInput(device: devices.filter({ $0.position == AVCaptureDevice.Position.front }).first!)
//                print(getCamMatrix(deviceInput: input))
//            } catch {
//
//            }
//        }
    }

    func getCamMatrix(deviceInput:AVCaptureDeviceInput)->(String,Float,String, Float, String,Float, String,Float)
    {
        
        let format:AVCaptureDevice.Format? = deviceInput.device.activeFormat
        let fDesc:CMFormatDescription = format!.formatDescription
        
        let dim:CGSize = CMVideoFormatDescriptionGetPresentationDimensions(fDesc, true, true)
        
        // dim = dimensioni immagine finale
        let cx:Float = Float(dim.width) / 2.0;
        let cy:Float = Float(dim.height) / 2.0;
        
        let HFOV : Float = format!.videoFieldOfView
        let VFOV : Float = ((HFOV)/cx)*cy
        
        let fx:Float = abs(Float(dim.width) / (2 * tan(HFOV / 180 * Float(M_PI) / 2)));
        let fy:Float = abs(Float(dim.height) / (2 * tan(VFOV / 180 * Float(M_PI) / 2)));
        
        g_fx = fx
        g_fy = fy
        
        return ("Fx",fx,"Fy",fy,"Cx",cx,"Cy",cy)
    }

    override func viewDidLayoutSubviews() {
        moviePlayer?.view.frame = VideoView.bounds
        VideoView.addSubview((moviePlayer?.view)!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        img_FrontOfVideo.isHidden = false
        //img_FrontOfVideo.image = generateThumbnailForVideoAtURL(filePathLocal: "instructional-video-v2-part4-compressed-rotated.mp4")

        
g_GoneNextPageFrom_Gravity = 1
        
        InitUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    func InitUI() {
        self.stopVideoRecording()
        
        int_count = 15
        view_Count.isHidden = true
        
        view_whole_VideoBackground.isHidden = true
        view_back_1.layer.cornerRadius = view_back.bounds.size.height / 2.0
        view_skip.layer.cornerRadius = view_skip.bounds.size.height / 2.0
        moviePlayer?.pause()
        
        player1.play()
        //player1.currentTime=14*60-10
        print(player1.currentTime)
        //player1.volume = 0
        
        
        view_maskBackground.isHidden = false

        btn_maskButton.layer.borderColor = UIColor.init(red: 48.0/255.0, green: 147.0/255.0, blue: 224.0/255.0, alpha: 0.8).cgColor
        btn_maskButton.layer.borderWidth = 3
        
        btn_backButtonImage.setImage(UIImage(named: "back_white.png"), for: .normal)
        view_back.backgroundColor = UIColor.clear
        view_recording.isHidden = true
        
        
        view_back.layer.cornerRadius = view_back.bounds.size.height / 2.0
        view_recording.layer.cornerRadius = view_recording.bounds.size.height / 2.0
        view_circle.layer.cornerRadius = view_circle.bounds.size.height / 2.0
        
        
    }

    @IBAction func onTapped_Back_1_Method(_ sender: Any) {
        int_count = 15
        view_Count.isHidden = true
        
        view_whole_VideoBackground.isHidden = true
        moviePlayer?.pause()
        
        player1.pause()
        player2.pause()
        player3.pause()
        
        InitUI()
    }
    
    @IBAction func onTapped_Skip_Method(_ sender: Any) {
        moviePlayer?.stop()
    }
    
    @objc func moviePlayerPlaybackStateDidChange(notification: NSNotification) {
        let moviePlayerController = notification.object as! MPMoviePlayerController
        
        var playbackState: String = "Unknown"
        switch moviePlayerController.playbackState {
        case .stopped:
            playbackState = "Stopped"
        case .playing:
            playbackState = "Playing"

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
        view_whole_VideoBackground.isHidden = true
        moviePlayer?.pause()

        //player2.volume = 0
        player2.play()
        print(player2.currentTime)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        
        if player == player1 {
            
            print(flag)

            if flag == true {

                view_whole_VideoBackground.isHidden = false
                moviePlayer?.play()
            }
        }
        
        else if player == player2 {
            
            //disable the phone tilt check 3 seconds before it finishes recording (my mom picked up the phone when it said "you're all done" and it went backwards to the tilt angle check screen instead of continuing even though the video was actually done)
            
//            let when = DispatchTime.now() + 10
//            DispatchQueue.main.asyncAfter(deadline: when) {
//                g_GoneNextPageFrom_Gravity = 2
//            }
            
            onTapped_Mask_Method(self)
        }
            
        else {
            self.stopVideoRecording()
        }
    }
    
    @IBAction func onTapped_Back_Method(_ sender: Any) {

        gravity_timer.invalidate()
        gravity_timer = nil
        
        
        g_current_Pop_Pages = g_current_Pop_Pages - 1
        
        player1.pause()
        player2.pause()
        player3.pause()
        
        int_count = 15
        view_Count.isHidden = true
        
        view_whole_VideoBackground.isHidden = true
        moviePlayer?.pause()
        
        g_GoneNextPageFrom_Gravity = 2
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func onTapped_Mask_Method(_ sender: Any) {
     
        int_count = 13
        view_Count.isHidden = false
        
        player3.play()
        print(player3.currentTime)
        
//player3.volume = 0
        
        
        view_maskBackground.isHidden = true
        
        view_recording.isHidden = false
        btn_backButtonImage.setImage(UIImage(named: "back.png"), for: .normal)
        view_back.backgroundColor = UIColor.white
        
        
        if let devices = AVCaptureDevice.devices(for: AVMediaType(rawValue: AVMediaType.video.rawValue)) as? [AVCaptureDevice] {
            do {
                let input = try AVCaptureDeviceInput(device: devices.filter({ $0.position == AVCaptureDevice.Position.front }).first!)
                print(getCamMatrix(deviceInput: input))
                
                print("=============================================")
                print(g_fx)
                print(g_fy)
                print("=============================================")
                
            } catch {
                
            }
        }
        
        startVideoRecording()
        
    }
    
    @objc func GravityUpdate() {
        
        if g_current_Gravity_Flag == false {
//            if g_GoneNextPageFrom_Gravity == 1 {
        
        
                
                player1.pause()
                player2.pause()
                player3.pause()
                

                gravity_timer.invalidate()
                gravity_timer = nil
                
                g_GoneNextPageFrom_Gravity = 2
                self.stopVideoRecording()
        
            
                int_count = 15
                view_Count.isHidden = true

            
                view_whole_VideoBackground.isHidden = true
                moviePlayer?.pause()
            
            
                g_current_Pop_Pages = g_current_Pop_Pages - 1
                //self.navigationController?.popViewController(animated: true)
        
                var viewControllers = self.navigationController?.viewControllers
                viewControllers?.removeLast(1)
                self.navigationController?.setViewControllers(viewControllers!, animated: true)
             
                
//            }
        }
    }
    
    
    @objc func update() {
        
        if view_circle.backgroundColor == UIColor.init(red: 239.0/255.0, green: 86.0/255.0, blue: 94.0/255.0, alpha: 1.0) {
            
            view_circle.backgroundColor = UIColor.init(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0, alpha: 0.7)
        } else {
            
            view_circle.backgroundColor = UIColor.init(red: 239.0/255.0, green: 86.0/255.0, blue: 94.0/255.0, alpha: 1.0)
            
            if int_count != 15 {
                self.lbl_count.text = "\(int_count)"
                self.int_count = self.int_count - 1
                
                if int_count == -1 {
                    int_count = 15
                    view_Count.isHidden = true
                }
            }
        }
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        // Called when takePhoto() is called or if a SwiftyCamButton initiates a tap gesture
        // Returns a UIImage captured from the current session
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        // Called when startVideoRecording() is called
        // Called if a SwiftyCamButton begins a long press gesture
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        // Called when stopVideoRecording() is called
        // Called if a SwiftyCamButton ends a long press gesture
        //InitUI()
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        // Called when stopVideoRecording() is called and the video is finished processing
        // Returns a URL in the temporary directory where video is stored
        print(url)

        
        g_ProfileInfo.old_VideoUrl = url.absoluteString
        
        if g_GoneNextPageFrom_Gravity == 1 {
            
            SVProgressHUD.show()
            convertVideoToMP4(URL(string: g_ProfileInfo.old_VideoUrl)! , completionHandler: {success in
                
                SVProgressHUD.dismiss()
                
                if success != "" {
                    
                    g_current_Pop_Pages = g_current_Pop_Pages + 1
                    g_GoneNextPageFrom_Gravity = 2
                    
                    print(success)
                    g_ProfileInfo.curVideoUrl = success
                    
                    g_motionManager.stopAccelerometerUpdates()
                    g_motionManager.stopDeviceMotionUpdates()
                    self.gravity_timer.invalidate()
                    self.gravity_timer = nil
                    
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: StorySegues.FromRecordingVCToSubmittingVC.rawValue, sender: self)
                    }
                    
                } else {
                    print(success)
                    g_ProfileInfo.curVideoUrl = ""
                    
                    g_current_Pop_Pages = g_current_Pop_Pages - 1
                    
                    self.player1.pause()
                    self.player2.pause()
                    self.player3.pause()
                    
                    g_GoneNextPageFrom_Gravity = 2
                    self.navigationController?.popViewController(animated: true)
                    
//                    DispatchQueue.main.async {
//                        self.view.makeToast("Please try to record video again, it happened some problem while converting to MP4", duration: 3.0, position: .bottom)
//                    }

                    self.ShowAlert(str_message: "Please try to record video again, it happened some problem while converting to MP4.", completionHandler: {
                    })
                    
                }
            })
            
        }
        
        
        
        /*DispatchQueue.main.async {
            var videoURL = URL(fileURLWithPath: g_ProfileInfo.curVideoUrl)
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: g_ProfileInfo.curVideoUrl) {
                videoURL = URL(fileURLWithPath: g_ProfileInfo.curVideoUrl)
            }
            let player = AVPlayer(url: videoURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
        */
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        // Called when a user initiates a tap gesture on the preview layer
        // Will only be called if tapToFocus = true
        // Returns a CGPoint of the tap location on the preview layer
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
        // Called when a user initiates a pinch gesture on the preview layer
        // Will only be called if pinchToZoomn = true
        // Returns a CGFloat of the current zoom level
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
        // Called when user switches between cameras
        // Returns current camera selection
    }

    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        //print(fileURL)
    }

}

    
func convertVideoToMP4(_ videoURL: URL, completionHandler: @escaping (String) -> Void) {
    
    let avAsset = AVURLAsset(url: videoURL, options: nil)
    
    let startDate = Foundation.Date()
    
    //Create Export session
    let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough)
    let documentsDirectory2 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
    
    let filePath = documentsDirectory2.appendingPathComponent("rendered-Video.mp4")
    
    deleteFile(filePath: filePath as NSURL)
    
    exportSession!.outputURL = filePath
    exportSession!.outputFileType = AVFileType.mp4
    exportSession!.shouldOptimizeForNetworkUse = true
    let start = CMTimeMakeWithSeconds(0.0, 0)
    let range = CMTimeRangeMake(start, avAsset.duration)
    exportSession?.timeRange = range
    
    exportSession!.exportAsynchronously(completionHandler: {() -> Void in
        switch exportSession!.status {
        case .failed:
            
            completionHandler("")
            print("Export failed: \(String(describing: exportSession?.error?.localizedDescription))")
            
        case .cancelled:
            
            completionHandler("")
            print("Export canceled")
            
        case .completed:
            
            completionHandler(filePath.path)  //(filePath.absoluteString)
            //Video conversion finished
            print("Successful!")
            
        default:
            break
        }
    })
}

func deleteFile(filePath:NSURL) {
    guard FileManager.default.fileExists(atPath: filePath.path!) else {
        return
    }
    
    do {
        try FileManager.default.removeItem(atPath: filePath.path!)
    }catch{
        fatalError("Unable to delete file: \(error) : \(#function).")
    }
}









