//
//  SuccessViewController.swift
//  Drapr
//
//  Created by Pedro on 12/24/18.
//  Copyright © 2018 Pedro. All rights reserved.
//

import UIKit

class SuccessViewController: UIViewController {

    @IBOutlet weak var btn_Next: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        InitUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func InitUI() {
         btn_Next.layer.cornerRadius = 8
    }
    
    @IBAction func onTapped_Back_Method(_ sender: Any) {
        g_current_Pop_Pages = g_current_Pop_Pages - 1
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func onTapped_Next_Method(_ sender: Any) {        
        
        g_current_Pop_Pages = g_current_Pop_Pages + 1
        self.performSegue(withIdentifier: StorySegues.FromSuccessVCToWhatsNextVC.rawValue, sender: self)
    }
    
}
