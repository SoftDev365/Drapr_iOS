//
//  VolumeControlViewController.swift
//  Drapr
//
//  Created by Pedro on 12/21/18.
//  Copyright © 2018 Pedro. All rights reserved.
//

import UIKit
import Foundation
import MediaPlayer
import AVFoundation

var g_GoneNextPageFromVolue: Int = 0

class VolumeControlViewController: UIViewController {

    @IBOutlet weak var btn_Continue: UIButton!
    
    @IBOutlet weak var sld_Volume: UISlider!
    
    let audioSession = AVAudioSession.sharedInstance()
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
        InitUI()
        //btn_Continue.backgroundColor = UIColor(red: 196.0/255.0, green: 207.0/255.0, blue: 212.0/255.0, alpha: 1.0)
        // Do any additional setup after loading the view.
        
        //g_GoneNextPageFromVolue = 0
        
        do {
            try audioSession.setActive(true)
            startObservingVolumeChanges()
        }
        catch {
            print("Failed to activate audio session")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func InitUI() {
        btn_Continue.layer.cornerRadius = 8.0
    }

    override func viewWillAppear(_ animated: Bool) {
        if sld_Volume.value > 0.7 {
            btn_Continue.backgroundColor = UIColor(red: 249.0/255.0, green: 96.0/255.0, blue: 99.0/255.0, alpha: 1.0)
            
        } else {
            btn_Continue.backgroundColor = UIColor(red: 196.0/255.0, green: 207.0/255.0, blue: 212.0/255.0, alpha: 1.0)
        }
    }
    
    
    
    private struct Observation {
        static let VolumeKey = "outputVolume"
        static var Context = 0
    }
    
    func startObservingVolumeChanges() {
        audioSession.addObserver(self, forKeyPath: Observation.VolumeKey, options: [.initial, .new], context: &Observation.Context)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &Observation.Context {
            if keyPath == Observation.VolumeKey, let volume = (change?[NSKeyValueChangeKey.newKey] as? NSNumber)?.floatValue {
                // `volume` contains the new system output volume...
                print("Volume: \(volume)")
                
                sld_Volume.setValue(volume, animated: true)
                
                if g_GoneNextPageFromVolue == 0 {
                    
                    if volume > 0.7 {
                        
                        g_current_Pop_Pages = g_current_Pop_Pages + 1
                        g_GoneNextPageFromVolue = 1
                        btn_Continue.backgroundColor = UIColor(red: 249.0/255.0, green: 96.0/255.0, blue: 99.0/255.0, alpha: 1.0)
                        self.performSegue(withIdentifier: StorySegues.FromVolumeVCToTutorialVC.rawValue, sender: self)
                        
                    } else {
                        btn_Continue.backgroundColor = UIColor(red: 196.0/255.0, green: 207.0/255.0, blue: 212.0/255.0, alpha: 1.0)
                    }
                    
                    let currentValue = String(volume)
                    print(currentValue)
                    
                }
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    @IBAction func sliderValueChanged(_ sender: UISlider) {
//        if sender.value > 0.7 {
//            btn_Continue.backgroundColor = UIColor(red: 249.0/255.0, green: 96.0/255.0, blue: 99.0/255.0, alpha: 1.0)
//            //self.performSegue(withIdentifier: StorySegues.FromVolumeVCToTutorialVC.rawValue, sender: self)
//        } else {
//            btn_Continue.backgroundColor = UIColor(red: 196.0/255.0, green: 207.0/255.0, blue: 212.0/255.0, alpha: 1.0)
//        }
//        let currentValue = String(sender.value)
//        print(currentValue)
        
    }
    
    @IBAction func onTapped_Continue_Method(_ sender: Any) {
        
        if btn_Continue.backgroundColor == UIColor(red: 196.0/255.0, green: 207.0/255.0, blue: 212.0/255.0, alpha: 1.0) {
//            DispatchQueue.main.async {
//                self.view.makeToast("It must require starting minimum volume.", duration: 3.0, position: .bottom)
//            }

            self.ShowAlert(str_message: "It must require starting minimum volume.", completionHandler: {
            })
            
        } else {
            self.performSegue(withIdentifier: StorySegues.FromVolumeVCToTutorialVC.rawValue, sender: self)
        }
 
    }
}

