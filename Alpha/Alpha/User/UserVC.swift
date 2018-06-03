//
//  UserVC.swift
//  Alpha
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
    
    @IBAction func logOutTapped(_ sender: Any){
//        let loginManager = LoginManager()
//        loginManager.logOut()
        if Auth.auth().currentUser?.uid != nil {
            do
            { try Auth.auth().signOut()

            }
            catch let error as NSError
            { print(error.localizedDescription) }
        }
        performSegue(withIdentifier: "logout", sender: self)
    }
    
    
    @IBAction func accloeschenTapped(_ sender: Any) {
        
    }
    
    @IBAction func passwortaenddern(_ sender: Any) {
    }
    
    
    // OTHERS
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
