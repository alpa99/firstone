//
//  UserVC.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 21.10.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import FacebookLogin

class UserVC: UIViewController {

    // ACTIONS
    
    @IBAction func meinebestellungen(_ sender: UIButton) {
        performSegue(withIdentifier: "meinebestellungen", sender: self)
    }
    
    @IBAction func logOutTapped(_ sender: Any){
    let loginManager = LoginManager()
        loginManager.logOut()
        performSegue(withIdentifier: "logout", sender: self)
    }
    
    
    // OTHERS
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
