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

class LoginVC: UIViewController, UITextFieldDelegate {
    
    // VARS
    var userFbID = ""
    var userFbName = ""
    var userFbEmail = ""
    
    
    // OUTLETS
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var kellnerLogin: UIButton!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwortTextfield: UITextField!
    
    @IBOutlet weak var visualEffect: UIView!
    @IBOutlet var passwortVergessenView: UIView!
    @IBOutlet weak var passwortVergessenLbl: UILabel!
    @IBOutlet weak var passwortVergessenEmail: UITextField!
    
    
    // ACTIONS
    

    @IBAction func EmailLoginTapped(_ sender: Any) {
        
        if self.emailTextfield.text == "" || self.passwortTextfield.text == "" {
            
            let alertController = UIAlertController(title: "Fehler", message: "Bitte geben Sie ihre Email und ihre Passwort ein.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            Auth.auth().signIn(withEmail: self.emailTextfield.text!, password: self.passwortTextfield.text!) { (user, error) in
                
                
                if error == nil {
                    if (Auth.auth().currentUser?.isEmailVerified)! {
                    print("You have successfully logged in")
                    
                        self.segueToTabBar()
                        
                    } else {
                        if Auth.auth().currentUser?.uid != nil {
                            do
                            { try Auth.auth().signOut()            }
                            catch let error as NSError
                            { print(error.localizedDescription) }
                        }
                        let alertController = UIAlertController(title: "Fehler", message: "Bitte bestätige deine Email-Adresse um fortzufahren", preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                    
                } else {
                    
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    
//    @IBAction func unwindSegue(_ sender: UIStoryboardSegue){
//
//    }
//
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
    
    // Passwortvergessen
    @IBAction func passwortvergessen(_ sender: Any) {
        
        self.view.addSubview(visualEffect)
        visualEffect.center = self.view.center
        visualEffect.bounds.size = self.view.bounds.size
        self.view.addSubview(passwortVergessenView)
        passwortVergessenView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        passwortVergessenView.alpha = 0
        
        UIView.animate(withDuration: 0.2) {
            self.passwortVergessenView.alpha = 1
            self.passwortVergessenView.transform = CGAffineTransform.identity
        }
        
    }
    @IBAction func passwortvergessenAbbrechen(_ sender: Any) {
       passwortVergessenViewDismiss()
    }
    
    func passwortVergessenViewDismiss(){
        UIView.animate(withDuration: 0.1, animations: {
            self.passwortVergessenView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.passwortVergessenView.alpha = 0
        }) { (sucess:Bool) in
            self.passwortVergessenView.removeFromSuperview()
            self.visualEffect.removeFromSuperview()
        }
    }
    @IBAction func passwortResetTapped(_ sender: Any) {
        Auth.auth().fetchProviders(forEmail: passwortVergessenEmail.text!) { (loginProvider, error) in
            if error != nil {
                let alertController = UIAlertController(title: "Fehler", message: "Es ist ein Fehler passiert. \(String(describing: error))", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)            } else {
                if loginProvider![0] == "password" {
                    Auth.auth().sendPasswordReset(withEmail: self.passwortVergessenEmail.text!) { (error) in
                if error != nil {
                    print(error?.localizedDescription ?? "anderer error", "passwort reset")
                } else {
                    self.passwortVergessenViewDismiss()
                }
                    }} else {
                    
                }
                
            }

        }
    }
    
    
    
    // OTHERS


    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextfield.keyboardType = UIKeyboardType.emailAddress
        emailTextfield.delegate = self
        passwortTextfield.delegate = self
        loginBtn.layer.cornerRadius = 4
        kellnerLogin.layer.cornerRadius = 4
        checkIfUserIsSignedIn()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func checkIfUserIsSignedIn() {
        print("jvvzbjhbhjhbj")
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                print("yes")
                self.segueToTabBar()
            } else {
                print("no")
            }
        }
    }

}
