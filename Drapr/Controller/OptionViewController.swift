//
//  OptionViewController.swift
//  Drapr
//
//  Created by Pedro on 12/19/18.
//  Copyright © 2018 Pedro. All rights reserved.
//

import UIKit
import SVProgressHUD

extension Double {
    func round(nearest: Double) -> Double {
        let n = 1/nearest
        let numberToRound = self * n
        return numberToRound.rounded() / n
    }
    
    func floor(nearest: Double) -> Double {
        let intDiv = Double(Int(self / nearest))
        return intDiv * nearest
    }
}


class OptionViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var btn_male: UIButton!
    @IBOutlet weak var btn_female: UIButton!
    
    @IBOutlet weak var btn_inches_lbs: UIButton!
    @IBOutlet weak var btn_cm_km: UIButton!
    
    
    @IBOutlet weak var view_height: UIView!
    @IBOutlet weak var view_weight: UIView!
    
    @IBOutlet weak var txt_Height: UITextField!
    @IBOutlet weak var txt_Weight: UITextField!
    
    
    @IBOutlet weak var btn_continue: UIButton!
    
    fileprivate var picker: TextPicker?
    var cur_index: Int = 0
    var height_picker_array: Array<String>   =  Array<String>()
    var weight_picker_array: Array<String>   =  Array<String>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        InitUI()
        
        picker = TextPicker(parentViewController: self)
        picker?.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if txt_Height.text != "" && txt_Weight.text != "" {

            btn_continue.backgroundColor = UIColor(red: 249.0/255.0, green: 96.0/255.0, blue: 99.0/255.0, alpha: 1.0)
            
        } else {
            btn_continue.backgroundColor = UIColor(red: 196.0/255.0, green: 207.0/255.0, blue: 212.0/255.0, alpha: 1.0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func InitUI() {
        btn_male.layer.cornerRadius = 8.0
        btn_female.layer.cornerRadius = 8.0
        btn_inches_lbs.layer.cornerRadius = 8.0
        btn_cm_km.layer.cornerRadius = 8.0
        view_height.layer.cornerRadius = 8.0
        view_weight.layer.cornerRadius = 8.0
        btn_continue.layer.cornerRadius = 8.0
        
        cur_index = 1
        
        btn_male.backgroundColor = UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        btn_male.setTitleColor(UIColor.white, for: .normal)
        btn_female.backgroundColor = UIColor.init(red: 237.0/255.0, green: 237.0/255.0, blue: 237.0/255.0, alpha: 1.0)
        btn_female.setTitleColor(UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0), for: .normal)
        
        btn_inches_lbs.backgroundColor = UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        btn_inches_lbs.setTitleColor(UIColor.white, for: .normal)
        btn_cm_km.backgroundColor = UIColor.init(red: 237.0/255.0, green: 237.0/255.0, blue: 237.0/255.0, alpha: 1.0)
        btn_cm_km.setTitleColor(UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0), for: .normal)
        
        /*
        g_ProfileInfo.height = "67" //67=5'7", 64=5'4"
        g_ProfileInfo.weight = "190" //
        
        txt_Height.text = "5’7\""
        txt_Weight.text = "190lbs"
        */
        
        
//        txt_Height.text = "cm"
//        txt_Weight.text = "kg"
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onTapped_Back_Method(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTapped_Male_Method(_ sender: Any) {
        btn_male.backgroundColor = UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        btn_male.setTitleColor(UIColor.white, for: .normal)
        btn_female.backgroundColor = UIColor.init(red: 237.0/255.0, green: 237.0/255.0, blue: 237.0/255.0, alpha: 1.0)
        btn_female.setTitleColor(UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0), for: .normal)
        
        g_ProfileInfo.gender = "male"
        
        if btn_inches_lbs.backgroundColor == UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0) {
            if g_ProfileInfo.height == "64" && g_ProfileInfo.weight == "170" {
                
                txt_Height.text = "5’7\""
                txt_Weight.text = "190lbs"
                
                g_ProfileInfo.height = "67"
                g_ProfileInfo.weight = "190"
            }
        } else {
            if g_ProfileInfo.height == "64" && g_ProfileInfo.weight == "170" {
                
                txt_Height.text = "170cm"
                txt_Weight.text = "86.0kg"
                
                g_ProfileInfo.height = "67"
                g_ProfileInfo.weight = "190"
            }
        }
    }
    @IBAction func onTapped_Female_Method(_ sender: Any) {
        btn_male.backgroundColor = UIColor.init(red: 237.0/255.0, green: 237.0/255.0, blue: 237.0/255.0, alpha: 1.0)
        btn_male.setTitleColor(UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0), for: .normal)
        btn_female.backgroundColor = UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        btn_female.setTitleColor(UIColor.white, for: .normal)
        
        g_ProfileInfo.gender = "female"
        
        if btn_inches_lbs.backgroundColor == UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0) {
            if g_ProfileInfo.height == "67" && g_ProfileInfo.weight == "190" {
                
                txt_Height.text = "5’4\""
                txt_Weight.text = "170lbs"
                
                g_ProfileInfo.height = "64"
                g_ProfileInfo.weight = "170"
            }
        } else {
            if g_ProfileInfo.height == "67" && g_ProfileInfo.weight == "190" {
                
                txt_Height.text = "163cm"
                txt_Weight.text = "77.0kg"
                
                g_ProfileInfo.height = "64"
                g_ProfileInfo.weight = "170"
            }
        }
        
    }
    
    //Inches/lbs Button
    @IBAction func onTapped_English_Method(_ sender: Any) {
        btn_inches_lbs.backgroundColor = UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        btn_inches_lbs.setTitleColor(UIColor.white, for: .normal)
        btn_cm_km.backgroundColor = UIColor.init(red: 237.0/255.0, green: 237.0/255.0, blue: 237.0/255.0, alpha: 1.0)
        btn_cm_km.setTitleColor(UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0), for: .normal)
        
        if txt_Height.text == "cm" {
            txt_Height.text = "Inches"
        }
        if txt_Weight.text == "kg" {
            txt_Weight.text = "lbs"
        }
        
        txt_Height.attributedPlaceholder = NSAttributedString(string: "Inches", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        txt_Weight.attributedPlaceholder = NSAttributedString(string: "lbs", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        if g_ProfileInfo.height == "" {
            return
        }
        if g_ProfileInfo.weight == "" {
            return
        }
        
        let cnt: Int = Int(g_ProfileInfo.height)!
        txt_Height.text = "\(cnt/12)'\(cnt%12)\""
        txt_Weight.text = "\(g_ProfileInfo.weight)lbs"
    }
    
    //cm/kg Button
    @IBAction func onTapped_Metric_Method(_ sender: Any) {
        btn_inches_lbs.backgroundColor = UIColor.init(red: 237.0/255.0, green: 237.0/255.0, blue: 237.0/255.0, alpha: 1.0)
        btn_inches_lbs.setTitleColor(UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0), for: .normal)
        btn_cm_km.backgroundColor = UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        btn_cm_km.setTitleColor(UIColor.white, for: .normal)
        
        txt_Height.attributedPlaceholder = NSAttributedString(string: "cm", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        txt_Weight.attributedPlaceholder = NSAttributedString(string: "kg", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        if txt_Height.text == "Inches" {
            txt_Height.text = "cm"
        }
        if txt_Weight.text == "lbs" {
            txt_Weight.text = "kg"
        }
        
        if g_ProfileInfo.height == "" {
            return
        }
        if g_ProfileInfo.weight == "" {
            return
        }
        
        var cnt1: Double = Double(g_ProfileInfo.height)!
        var cnt2: Double = Double(g_ProfileInfo.weight)!
        
        cnt1 = cnt1 * 2.54
        cnt2 = cnt2 * 0.45359237
        
        txt_Height.text = "\(Int(cnt1.round(nearest: 1.0)))cm"
        txt_Weight.text = "\(cnt2.round(nearest: 0.5))kg"
    }
    
    @IBAction func onTapped_Height_Picker_Method(_ sender: Any) {

        cur_index = 1
        height_picker_array.removeAll()
        
        if btn_inches_lbs.backgroundColor == UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0) {
            
            for i in 48..<85 {
                height_picker_array.append("\(i/12)'\(i%12)\"")
            }
            picker?.set(items: [height_picker_array])
            picker?.startPicking()
            
        } else {
            
            for i in 120..<221 {
                height_picker_array.append("\(i)cm")
            }
            picker?.set(items: [height_picker_array])
            picker?.startPicking()
           
        }
        

    }
    
    @IBAction func onTapped_Weight_Picker_Method(_ sender: Any) {
        cur_index = 2
        weight_picker_array.removeAll()
        
        if btn_inches_lbs.backgroundColor == UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0) {
            
            for i in 80..<351 {
                weight_picker_array.append("\(i)lbs")
            }
            picker?.set(items: [weight_picker_array])
            picker?.startPicking()
            
        } else {
            
            for i in 0..<249 {
                weight_picker_array.append("\(36.0 + Double(Double(i) * 0.5))kg")
            }
            picker?.set(items: [weight_picker_array])
            picker?.startPicking()
            
        }
        
    }
    
    
    @IBAction func onTapped_Continue_Method(_ sender: Any) {
        
        if txt_Height.text != "" && txt_Weight.text != "" {
            
//            UserDefaults.standard.set(g_ProfileInfo.height, forKey: "height")
//            UserDefaults.standard.set(g_ProfileInfo.weight, forKey: "weight")
//            UserDefaults.standard.set(g_ProfileInfo.gender, forKey: "gender")
            
            print("********~~~~~~~~~~*********")
            print(g_ProfileInfo.height)
            print(g_ProfileInfo.weight)
            self.performSegue(withIdentifier: StorySegues.FromOptionVCToSignupVC.rawValue, sender: self)
            
            
        } else {
            
//            DispatchQueue.main.async {
//                self.view.makeToast("Require entry for height and weight fields.", duration: 3.0, position: .bottom)
//            }
            self.ShowAlert(str_message: "Require entry for height and weight fields.", completionHandler: {
            })
        }
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if cur_index == 1 {
            return height_picker_array.count
        } else {
            return weight_picker_array.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if cur_index == 1 {
            return height_picker_array[row]
        } else {
            return weight_picker_array[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if cur_index == 1 {
            txt_Height.text = height_picker_array[row]
        } else {
            txt_Weight.text =  weight_picker_array[row]
        }
    }
}

extension OptionViewController: TextPickerDelegate {
    
    /*@objc func pickerCancelAction() {
        
        if txt_Height.text != "" && txt_Weight.text != "" {
            btn_continue.backgroundColor = UIColor(red: 249.0/255.0, green: 96.0/255.0, blue: 99.0/255.0, alpha: 1.0)
            
        } else {
            btn_continue.backgroundColor = UIColor(red: 196.0/255.0, green: 207.0/255.0, blue: 212.0/255.0, alpha: 1.0)
        }
        picker?.endPicking()
    }
    */
    
    @objc func pickerSetAction() {
        if let selectedItems = picker?.selectedItems {
            
            if cur_index == 1 {
                txt_Height.text = "\(selectedItems[0])"
                
                if btn_inches_lbs.backgroundColor == UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0) {
                    
                    for i in 48..<85 {
                        if selectedItems[0] == "\(i/12)'\(i%12)\"" {
                            g_ProfileInfo.height = "\(i)"
                            continue
                        }
                    }
                    
                } else {
                    
                    for i in 120..<221 {

                        if selectedItems[0] == "\(i)cm" {
                            g_ProfileInfo.height = "\(Int(Double(i)/2.54))"
                            continue
                        }
                    }
                    
                }
                
                
            } else {
                txt_Weight.text = "\(selectedItems[0])"
  
                if btn_inches_lbs.backgroundColor == UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0) {
                    
                    for i in 80..<351 {
                        
                        if selectedItems[0] == "\(i)lbs" {
                            g_ProfileInfo.weight = "\(i)"
                            continue
                        }
                    }
                    
                    
                } else {

                    
                    for i in 0..<249 {
                        
                        if selectedItems[0] == "\(36.0 + Double(Double(i) * 0.5))kg" {
                            g_ProfileInfo.weight = "\(Int((36.0 + Double(Double(i) * 0.5))/0.45359237))"
                            continue
                        }
                    }
                    
                }
                
            }
            
            if txt_Height.text != "" && txt_Weight.text != "" {
                btn_continue.backgroundColor = UIColor(red: 249.0/255.0, green: 96.0/255.0, blue: 99.0/255.0, alpha: 1.0)
                
            } else {
                btn_continue.backgroundColor = UIColor(red: 196.0/255.0, green: 207.0/255.0, blue: 212.0/255.0, alpha: 1.0)
            }
            picker?.endPicking()
            
            print(g_ProfileInfo.height)
            print(g_ProfileInfo.weight)
        }
    }
    
    func pickerView(inputAccessoryViewFor pickerView: TextPicker) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
        view.backgroundColor = UIColor.init(red: 249.0/255.0, green: 96.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        let buttonWidth: CGFloat = 100
        
        /*let cancelButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - buttonWidth - 10, y: 0, width: buttonWidth, height: 40))
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.setTitleColor(.lightGray, for: .highlighted)
        cancelButton.addTarget(self, action: #selector(pickerCancelAction), for: .touchUpInside)
        view.addSubview(cancelButton)*/
        
        let setButton = UIButton(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.width - 10, height: 40))
        setButton.setTitle("Save", for: .normal)
        setButton.setTitleColor(.white, for: .normal)
        setButton.setTitleColor(.lightGray, for: .highlighted)
        setButton.addTarget(self, action: #selector(pickerSetAction), for: .touchUpInside)
        view.addSubview(setButton)
        
        return view
    }
    
    func pickerView(didSelect value: String, inRow row: Int, inComponent component: Int, delegatedFrom pickerView: TextPicker) {
        print("\(value)")
        
        if cur_index == 1 {
            
            if btn_inches_lbs.backgroundColor == UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0) {
                txt_Height.text = "\(value)"
                g_ProfileInfo.height = "\(48 + row)"
                
            } else {
                
                let myString = "\(value)"
                let formattedString = myString.replacingOccurrences(of: "cm", with: "")
                g_ProfileInfo.height = "\(Int(Double(formattedString)!/2.54))"
            }
            
        } else {
            
            if btn_inches_lbs.backgroundColor == UIColor.init(red: 56.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0) {
                txt_Weight.text = "\(value)"
                g_ProfileInfo.weight = "\(80 + row)"
                
            } else {
             
                let myString = "\(value)"
                let formattedString = myString.replacingOccurrences(of: "kg", with: "")
                g_ProfileInfo.weight = "\(Int(Double(formattedString)!/0.45359237))"
            }
            
        }
        
        if txt_Height.text != "" && txt_Weight.text != "" {
            
            btn_continue.backgroundColor = UIColor(red: 249.0/255.0, green: 96.0/255.0, blue: 99.0/255.0, alpha: 1.0)
            
        } else {
            btn_continue.backgroundColor = UIColor(red: 196.0/255.0, green: 207.0/255.0, blue: 212.0/255.0, alpha: 1.0)
        }
        
    }
}











