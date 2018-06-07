//
//  UserVC.swift
//  SMOLO
//
//  Created by Ibrahim Akcam on 21.10.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import FacebookLogin
import Firebase

class UserVC: UIViewController {

    // ACTIONS
    
    @IBAction func meinebestellungen(_ sender: UIButton) {
        performSegue(withIdentifier: "meinebestellungen", sender: self)
    }
    
    @IBAction func einstellungen(_ sender: Any) {
        performSegue(withIdentifier: "einstellungen", sender: self)
    }

    
    
    // OTHERS
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
