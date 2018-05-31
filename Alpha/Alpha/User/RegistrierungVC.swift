//
//  RegistrierungVC.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 30.05.18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit
import Firebase
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth
import SafariServices


class RegistrierungVC: UIViewController {
    // Vars
    
    var userFbID = ""
    var userFbName = ""
    var userFbEmail = ""
    
    // Outlets
    @IBOutlet weak var FacebookLoginBtn: UIButton!
    @IBOutlet weak var AlterBtn: UIButton!
    @IBOutlet weak var agbsAkzeptiert: UIButton!
    
    // Actions
    
    @IBAction func facebookLoginTapped(_ sender: Any) {
        if AlterBtn.isSelected == true &&  agbsAkzeptiert.isSelected == true {
        let loginManager = LoginManager()
        loginManager.logOut()
            if Auth.auth().currentUser?.uid != nil {
            do
            { try Auth.auth().signOut()            }
            catch let error as NSError
            { print(error.localizedDescription) }
            }
        loginManager.logIn(readPermissions: [.publicProfile, .email, .userBirthday], viewController: self) { result in
            
            switch result {
            case .failed(let error):
                print(error.localizedDescription)
            case .cancelled:
                print("cancelled")
            case .success(_,_,_):
                self.getUserInfo {userInfo, error in
                    if let error = error {
                        print(error.localizedDescription, "ERRRRRRRRROR")
                    }
                    
                    if let userInfo = userInfo, let id = userInfo["id"], let name = userInfo["name"], let email = userInfo["email"]{
                        print("successful")
                        self.userFbID = "\(id)"
                        self.userFbName = "\(name)"
                        self.userFbEmail = "\(email)"

                    }
                }
            }
            
        }
        } else {
            let alertNichtRegistriert = UIAlertController(title: "Registrierung fehlgeschlagen", message: "Du musst die Allgemeinen Geschäftbedingungen und Datenschutzrechtlienen akzeptieren, bevor du dich registrieren kannst.", preferredStyle: .alert)
            alertNichtRegistriert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertNichtRegistriert, animated: true, completion: nil)
        }
    }
    
    @IBAction func agbsAkzeptieren(_ sender: Any) {
        agbsAkzeptiert.isSelected = !agbsAkzeptiert.isSelected
    }
    
    
    @IBAction func AlterBtnTapped(_ sender: Any) {
        AlterBtn.isSelected = !AlterBtn.isSelected
    }
    
    
    
    
    @IBAction func agbsBtnTapped(_ sender: Any) {
        let agbsLink = SFSafariViewController(url: URL(string: "http://www.madapp.de/books/agbs.html")!)
        self.present(agbsLink, animated: true, completion: nil)
    }
    
    // Other
    
    func getUserInfo(completion: @escaping (_ : [String: Any]?, _ : Error?) -> Void) {
        
        
        let request = GraphRequest(graphPath: "me", parameters: ["fields": "id,name,email"])
        
        request.start{ response, result in
            switch result {
            case .failed(let error):
                completion(nil, error)
            case .success(let graphResponse):
                completion(graphResponse.dictionaryValue, nil)
                let accessToken = FBSDKAccessToken.current()
                guard let accessTokenString = accessToken?.tokenString else {
                    return
                }
                
                let credential = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
                Auth.auth().signIn(with: credential, completion: { (user, error) in
                    print(Auth.auth().currentUser?.uid ?? "keine uid", "UID")
                    if error != nil {
                        let alertNichtRegistriert = UIAlertController(title: "Registrierung fehlgeschlagen", message: "Bitte informiere info@madapp.de", preferredStyle: .alert)
                        alertNichtRegistriert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertNichtRegistriert, animated: true, completion: nil)
                        return
                    } else {
                        self.addUserToFirebase()
                        self.AddFacebookUser()


                    }
                    print("fb user:", user ?? "default user")
                    
                })
            }
        }
    }
    
    func addUserToFirebase(){
        var ref: DatabaseReference?
        ref = Database.database().reference()
        
        if let uid = Auth.auth().currentUser?.uid {
            ref?.child("Users").child("\(uid)").child("Name").setValue(self.userFbName)
            ref?.child("Users").child("\(uid)").child("Email").setValue(self.userFbEmail)
            ref?.child("Users").child("\(uid)").child("AGBSAkzeptiert").setValue(true)
            ref?.child("Users").child("\(uid)").child("DatenschutzAkzeptiert").setValue(true)
            
            segueToTabBar()
        }
    }
    
    func AddFacebookUser(){
        var ref: DatabaseReference?
        ref = Database.database().reference()
        ref?.child("FacebookUsers").child(FBSDKAccessToken.current().userID).child("Name").setValue(self.userFbName)
        ref?.child("FacebookUsers").child(FBSDKAccessToken.current().userID).child("Email").setValue(self.userFbEmail)
        }
    
    func segueToTabBar(){
//        let accessToken = FBSDKAccessToken.current()
//        guard let accessTokenString = accessToken?.tokenString else {
//            return
//        }
        
                        self.performSegue(withIdentifier: "registriert", sender: self.FacebookLoginBtn)



        
//        let credential = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
//        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { error in
//            if error != nil {
//                self.performSegue(withIdentifier: "registriert", sender: self.FacebookLoginBtn)
//            } else {
//                let alertNichtRegistriert = UIAlertController(title: "Registrierung fehlgeschlagen", message: "Bitte informiere info@madapp.de", preferredStyle: .alert)
//                alertNichtRegistriert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                self.present(alertNichtRegistriert, animated: true, completion: nil)
//            }
//
//        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        agbsAkzeptiert.setImage(UIImage(named: "essen"), for: .selected)
        agbsAkzeptiert.setImage(UIImage(named: "essen-i"), for: .normal)
        AlterBtn.setImage(UIImage(named: "alkohol"), for: .selected)
        AlterBtn.setImage(UIImage(named: "alkohol-i"), for: .normal)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "hintergrund")!)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
