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
    
    var kellnerID = String()
    var barname = String()

    // OUTLETS
    
    @IBOutlet weak var KellnerIdTextfield: UITextField!
    
    @IBOutlet weak var PasswortTextfield: UITextField!

    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var GastLogin: UIButton!
    
    // Actions
    
    @IBAction func LoginBtnTapped(_ sender: Any) {
        
        if self.KellnerIdTextfield.text == "" || self.PasswortTextfield.text == "" {
            
            let alertController = UIAlertController(title: "Fehler", message: "Bitte E-Mail und Passwort eingeben.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            Auth.auth().signIn(withEmail: self.KellnerIdTextfield.text!, password: self.PasswortTextfield.text!) { (user, error) in
                
            
                if error == nil {
                    var ref: DatabaseReference?
                    ref = Database.database().reference()
                    ref?.child("Kellner").observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        if snapshot.hasChild((Auth.auth().currentUser?.uid)!) {
                            self.kellnerID = (Auth.auth().currentUser?.uid)!
    
                            self.segueToKellnerVC(KellnerID: self.kellnerID)
                        } else {
                            
                            if Auth.auth().currentUser?.uid != nil {
                                do
                                { try Auth.auth().signOut()            }
                                catch let error as NSError
                                {
    
                                    print(error.localizedDescription) }
                            }
                            print("kein Kellner Login")
                        }

                    }, withCancel: nil)

                } else {
                        //Tells the user that there is an error and then gets firebase to tell them the error
                        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
            }
        }
    }
    
    // FUNC

    
    func segueToKellnerVC(KellnerID: String){
        var datref: DatabaseReference!
        datref = Database.database().reference()
        datref.child("Kellner").child(KellnerID).observe(.value, with: { (snapshot) in

            if let dictionary = snapshot.value as? [String: AnyObject]{
                let KellnerInfo = KellnerInfos(dictionary: dictionary)
                self.barname = KellnerInfo.Barname!
                self.performSegue(withIdentifier: "kellnerLoggedIn", sender: self)
            }
            
        }, withCancel: nil)
        
    }
    
    // OTHERS
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "kellnerLoggedIn" {
            
            let KTBC = segue.destination as! KellnerTabBarController
            let KCV = KTBC.viewControllers![0] as! KellnerVC
            KCV.KellnerID = (Auth.auth().currentUser?.uid)!
            KCV.Barname = barname
            let KACV = KTBC.viewControllers![1] as! KellnerAngenommenVC
            KACV.KellnerID = (Auth.auth().currentUser?.uid)!
            KACV.Barname = barname
            let KABCV = KTBC.viewControllers![2] as! KellnerAlleBestellungenVC
            KABCV.KellnerID = (Auth.auth().currentUser?.uid)!
            KABCV.Barname = barname
            let PVVC = KTBC.viewControllers![3] as! ProdukteVC
            PVVC.KellnerID = (Auth.auth().currentUser?.uid)!
            PVVC.Barname = barname
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        KellnerIdTextfield.text = "i.akcam@gmx.de"
        PasswortTextfield.text = "123456"
        Auth.auth().languageCode = "de"
        loginBtn.layer.cornerRadius = 4
        GastLogin.layer.cornerRadius = 4
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
