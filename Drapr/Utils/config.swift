//
//  config.swift
//  MeToMine
//
//  Created by UnJang on 3/18/18.
//  Copyright © 2018 MeToMine. All rights reserved.
//

import Foundation
import UIKit


enum StorySegues: String {
    
    case FromSwipeVCToLogInVC   =   "SwipeVCToLogInVC"
    case FromSwipeVCToOptionVC  =   "SwipeVCToOptionVC"
    
    case FromOptionVCToSignupVC =   "OptionVCToSignupVC"
    case FromLoginVCToOptionVC  =   "LoginVCToOptionVC"
    case FromLoginVCToResetVC   =   "LoginVCToResetVC"
    case FromLoginVCToVolumeVC  =   "LoginVCToVolumeVC"
    
    case FromSignupVCToLoginVC  =   "SignupVCToLoginVC"
    case FromSignupVCToVolumeVC =   "SignupVCToVolumeVC"
    
    case FromVolumeVCToTutorialVC   =   "VolumeVCToTutorialVC"
    
    case FromHowDressVCToDressVideoVC   =   "HowDressVCToDressVideoVC"
    case FromHowDressVCToGravityVC      =   "HowDressVCToGravityVC"
    case FromTutorialVCToHowDressVC     =   "TutorialVCToHowDressVC"
    
    case FromGravityVCToRecordingVC     =   "GravityVCToRecordingVC"
    case FromRecordingVCToSubmittingVC  =   "RecordingVCToSubmittingVC"
    case FromGravityVCToSubmittingVC    =   "GravityVCToSubmittingVC"
    
    case FromSubmitVCToSuccessVC        =   "SubmitVCToSuccessVC"
    case FromSuccessVCToWhatsNextVC     =   "SuccessVCToWhatsNextVC"
    
    case FromLoginVCToWhatsVC   =   "LoginVCToWhatsVC"
    case FromWhatsVCToGravityVC =   "WhatsVCToGravityVC"
   
    case FromSubmittingVCToVolumeVC     =   "SubmittingVCToVolumeVC"
    case FromWhatsNextVCToVolumeVC      =   "WhatsNextVCToVolumeVC"
}

extension String
{
    func trim() -> String
    {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
}

extension UIView {
    
    func fadeIn(_ duration: TimeInterval = 0.5,
                delay: TimeInterval = 0.0,
                completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: {
                        self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(_ duration: TimeInterval = 0.5,
                 delay: TimeInterval = 0.0,
                 completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: {
                        self.alpha = 0.0
        }, completion: completion)
    }
}

extension UIButton {
    
    func pulsate(completion: @escaping (() -> Void)) {
        
        self.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 0.8)
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: "pulse")
        
        let when = DispatchTime.now() + 0.8 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            completion()
        }
    }
    
    func flash(completion: @escaping (() -> Void)) {
        
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        
        layer.add(flash, forKey: nil)
        
        let when = DispatchTime.now() + 0.8 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            completion()
        }
    }
    
    
    func shake(completion: @escaping (() -> Void)) {
        
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: "position")
        
        let when = DispatchTime.now() + 0.8 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            completion()
        }
    }
}
