//
//  ViewController.swift
//  shisha
//
//  Created by Alper Maraz on 26.07.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit


class UserVC: UIViewController {

    
    @IBAction func LogoutPressed(_ sender: Any) {
            let loginManager = LoginManager()
        loginManager.logOut()
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

 
