//
//  LoginKellnerVC.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 11.11.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Firebase

class LoginKellnerVC: UIViewController {

    // VARS
    
    var passwort = String()
    
    // OUTLETS
    
    @IBOutlet weak var KellnerIdTextfield: UITextField!
    
    @IBOutlet weak var PasswortTextfield: UITextField!

    
    
    // Actions
    
    @IBAction func LoginBtnTapped(_ sender: Any) {
        if (KellnerIdTextfield.text != "") && (PasswortTextfield.text != ""){
            
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child("Kellner").child(KellnerIdTextfield.text!).observe(.value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let pw = KellnerInfos(dictionary: dictionary)
                    self.passwort = pw.Passwort!
                    
                    if self.PasswortTextfield.text == self.passwort {
                        
                        self.segueToKellnerVC()
                    } else {
                        let alert = UIAlertController(title: "KellnerID oder Passwort falsch", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                }
                
                
            }, withCancel: nil)
        }
    }
    
    // FUNC
    
    func segueToKellnerVC(){
        performSegue(withIdentifier: "kellnerLoggedIn", sender: self)
        
    }
    
    // OTHERS

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "kellnerLoggedIn" {
            let KTBC = segue.destination as! KellnerTabBarController
            let KCV = KTBC.viewControllers![0] as! KellnerVC
            KCV.KellnerID = KellnerIdTextfield.text!
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        KellnerIdTextfield.text = "Kellner1"
        PasswortTextfield.text = "hi"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
