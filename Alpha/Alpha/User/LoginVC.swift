//
//  LoginVCViewController.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 19.10.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Firebase
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth
import SafariServices

class LoginVC: UIViewController {
    
    // VARS
    var userFbID = ""
    var userFbName = ""
    var userFbEmail = ""
    
    
    // OUTLETS
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var kellnerLogin: UIButton!
    
    // ACTIONS
    
    @IBAction func registrierenSegue(_ sender: Any) {
        segueToRegistrieren()
    }
    
    @IBAction func openAGBs(_ sender: Any) {
        let agbsLink = SFSafariViewController(url: URL(string: "http://www.madapp.de/books/agbs.html")!)
        self.present(agbsLink, animated: true, completion: nil)
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        print("1")
        if (FBSDKAccessToken.current() == nil) {
            print("nil")
        } else {
            print(FBSDKAccessToken.current())
        }
        let loginManager = LoginManager()
        var ref: DatabaseReference?
        ref = Database.database().reference()
        ref?.child("FacebookUsers").observeSingleEvent(of: .value, with: { (snapshot) in
            
        loginManager.logOut()
                if Auth.auth().currentUser?.uid != nil {
                    do
                    { try Auth.auth().signOut()            }
                    catch let error as NSError
                    { print(error.localizedDescription) }
                }
        loginManager.logIn(readPermissions: [.publicProfile, .email, .userBirthday], viewController: self) { result in
            

            if snapshot.hasChild(FBSDKAccessToken.current().userID) {
            switch result {
            case .failed(let error):
                print(error.localizedDescription)
            case .cancelled:
                print("cancelled")
            case .success(_,_,_):
                print(2)
                self.getUserInfo {userInfo, error in
                    if let error = error {
                        print(error.localizedDescription, "ERRRRRRRRROR")
                    }
                            self.segueToTabBar()

                }
            }
            } else {
                let alertNichtRegistriert = UIAlertController(title: "Login fehlgeschlagen", message: "Bitte registriere dich zunächst.", preferredStyle: .alert)
                alertNichtRegistriert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                alertNichtRegistriert.addAction(UIAlertAction(title: "registrieren", style: .default, handler: { (action) in
                    self.segueToRegistrieren()
                }))
                self.present(alertNichtRegistriert, animated: true, completion: nil)                                       }
                }
           
        }, withCancel: nil)
        
    }
    
    // FUNCS
    
    func getUserInfo(completion: @escaping (_ : [String: Any]?, _ : Error?) -> Void) {
        
        print(5)
        let request = GraphRequest(graphPath: "me", parameters: ["fields": "id,name,email"])

        request.start{ response, result in
            switch result {
            case .failed(let error):
                completion(nil, error)
            case .success(let graphResponse):
                print(6)
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
                                    self.segueToTabBar()
                                }
                                print("fb user:", user ?? "default user")
                                
                            })


            }
        }
        
    }
    
    
//    func addUserToFirebase(){
//        var ref: DatabaseReference?
//
//        ref = Database.database().reference()
//
//        if let uid = Auth.auth().currentUser?.uid {
//
//        ref?.child("Users").child("\(uid)").child("Name").setValue(self.userFbName)
//        ref?.child("Users").child("\(uid)").child("Email").setValue(self.userFbEmail)
//
//        segueToTabBar()
//        }
//    }
    
    func segueToRegistrieren() {
        performSegue(withIdentifier: "registrieren", sender: self)
        
    }

    
    func segueToTabBar(){
        self.performSegue(withIdentifier: "login", sender: self.loginBtn)
    }
    
    // OTHERS

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginBtn.layer.cornerRadius = 4
        kellnerLogin.layer.cornerRadius = 4
        if Auth.auth().currentUser?.uid != nil {
            let accessToken = FBSDKAccessToken.current()
            guard let accessTokenString = accessToken?.tokenString else {
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                print(Auth.auth().currentUser?.uid ?? "keine uid", "UID")
                if error != nil {
                    let alertNichtRegistriert = UIAlertController(title: "Login fehlgeschlagen", message: "Bitte informiere info@madapp.de", preferredStyle: .alert)
                    alertNichtRegistriert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertNichtRegistriert, animated: true, completion: nil)
                    return
                } else {
                    self.segueToTabBar()
                }
                print("fb user:", user ?? "default user")
                
            })        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
