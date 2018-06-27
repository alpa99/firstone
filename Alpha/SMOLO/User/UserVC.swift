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

    @IBAction func feedback(_ sender: Any) {
        performSegue(withIdentifier: "feedback", sender: self)

    }
    
    
    // OTHERS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = "Dein Account"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
