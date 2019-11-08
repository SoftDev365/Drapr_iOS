//
//  Global.swift
//  MeToMine
//
//  Created by UnJang on 3/20/18.
//  Copyright © 2018 MeToMine. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

import Foundation
import MediaPlayer
import AVFoundation

import SystemConfiguration

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
}



extension String {
    
    //To check text field or String is blank or not
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    //Validate Email
    
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    //validate Password
    var isValidPassword: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z_0-9\\-_,;.:#+*?=!§$%&/()@]+$", options: .caseInsensitive)
            if(regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil){
                
                if(self.characters.count>=8 && self.characters.count<=20){
                    return true
                }else{
                    return false
                }
            }else{
                return false
            }
        } catch {
            return false
        }
    }
}

extension UIView {
    
    
    func dropShadow(){
        
        let shadowPath : UIBezierPath  = UIBezierPath(rect: self.bounds) //[UIBezierPath bezierPathWithRect:view.bounds];
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowPath = shadowPath.cgPath
    }
    
    
    func applyWhiteBackGround()->Void{
        
        self.backgroundColor = UIColor.white
    }
    
    func applyGrayBackGround()->Void{
        
        self.backgroundColor = UIColor.gray
    }
    
    func applyOutGrow(growColor : UIColor){
        
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.1)
        self.layer.shadowRadius = 3.0
        self.layer.shadowColor = growColor.cgColor
    }
    
    func applyDefOutGrow(){

        applyOutGrow(growColor: UIColor(red: 65, green: 64, blue: 64, alpha: 1.0))
    }
    
    func applyDefBackGradient()->Void{
        
        self.applyGradient(colours: [UIColor(red: 246, green: 247, blue: 250, alpha: 1.0), UIColor(red: 226, green: 230, blue: 234, alpha: 1.0)], isHorizontal: false)
        
    }
    
    func applyGradient(colours: [UIColor], isHorizontal : Bool) -> Void {
        self.applyGradient(colours: colours, isHorizontal: isHorizontal, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], isHorizontal : Bool, locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        if isHorizontal == false{
            
            gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
            
        }else{
            
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    
    static func isInstalled(appScheme:String) -> Bool{
        let appUrl = NSURL(string: appScheme)
        
        if UIApplication.shared.canOpenURL((appUrl! as NSURL) as URL)
        {
            return true
            
        } else {
            return false
        }
    }
}


extension URLSession {
    
    class func downloadImage(atURL url: URL, withCompletionHandler completionHandler: @escaping (Data?, NSError?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            completionHandler(data, nil)
        }
        dataTask.resume()
    }
}

/*@available(iOSApplicationExtension 10.0, *)
func didReceive(_ notification: UNNotification) {
    let content = notification.request.content
    
    if let urlImageString = content.userInfo["urlImageString"] as? String {
        if let url = URL(string: urlImageString) {
            URLSession.downloadImage(atURL: url) { [weak self] (data, error) in
                if let _ = error {
                    return
                }
                guard let data = data else {
                    return
                }
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: data)
                }
            }
        }
    }
}*/


extension UIViewController {
    
    func ShowAlert(str_message: String, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "Drapr Try-On", message: str_message, preferredStyle: .alert)
        //alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            completionHandler()
        }))
        UIApplication.shared.delegate?.window!!.rootViewController?.present(alert, animated: true)
    }
    
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func generateThumbnailForVideoAtURL(filePathLocal: NSString) -> UIImage? {
        
        let vidURL = NSURL(fileURLWithPath:filePathLocal as String)
        let asset = AVURLAsset(url: vidURL as URL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
        
        do {
            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
            return UIImage(cgImage: imageRef)
        }
        catch let error as NSError
        {
            print("Image generation failed with error \(error)")
            return nil
        }
        
    }
}










//******** Profile Infor *********//
struct ProfileInfo{
    var api_key:        String
    
    var id:             String
    var customer_key:   String
    var submitted:      String

    var name:           String
    var accesscode:     String

    var gender:         String
    var height:         String
    var weight:         String
    
    var curVideoUrl:    String //*.mp4
    var email:          String
    
    var old_VideoUrl:    String //*.mov

}
var g_ProfileInfo: ProfileInfo = ProfileInfo(api_key: "93jd9qjaS3SUISHhr39Su3uid0Kew3dsi", id: "", customer_key: "", submitted: "", name: "", accesscode: "", gender: "male", height: "", weight: "", curVideoUrl: "", email: "", old_VideoUrl: "")


var g_Flag_straight_From: Int = 0
var g_current_Pop_Pages: Int = 0 //when submitted already before, Login->whats

var g_fx: Float = 1800.0
var g_fy: Float = 1800.0


















