//
//  KellnerLoginVC.swift
//  shisha
//
//  Created by Ibrahim Akcam on 21.08.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import FirebaseDatabase

class KellnerLoginVC: UIViewController {

    var ref: DatabaseReference?
    
    @IBOutlet weak var barIDTextfield: UITextField!
    
    @IBOutlet weak var passwortTextfield: UITextField!
    
    var pws = [KellnerInfos]()
    var passwort = ""
    
    
    @IBAction func kellnerLoginBtnPressed(_ sender: Any) {
        if (barIDTextfield.text != "") && (passwortTextfield.text != ""){
            
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child("Kellner").child(barIDTextfield.text!).observe(.value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let pw = KellnerInfos(dictionary: dictionary)
                    pw.setValuesForKeys(dictionary)
                    self.pws.append(pw)
                    self.passwort = pw.Passwort!
                    
                    if self.passwortTextfield.text == self.passwort {
                    
                        self.segueToKellnerLogin()
                    } else {
                        self.passwortTextfield.text = ""
                        let alert = UIAlertController(title: "KellnerID oder Passwort falsch", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            
                            self.present(alert, animated: true, completion: nil)
                    
                    }
                    
                }
               
                
            }, withCancel: nil)
        }
        
        
    }
    

    func segueToKellnerLogin(){
    performSegue(withIdentifier: "kellnerLogin", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "kellnerLogin"{
            let KVC = segue.destination as! KellnerVC
            KVC.kellnerID = barIDTextfield.text!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barIDTextfield.text = "Kellner1"
        passwortTextfield.text = "hi"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
