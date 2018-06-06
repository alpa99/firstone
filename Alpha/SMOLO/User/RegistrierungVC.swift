//
//  RegistrierungVC.swift
//  SMOLO
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


class RegistrierungVC: UIViewController, UITextFieldDelegate {
    // Vars
    
    var userFbID = ""
    var userFbName = ""
    var userFbEmail = ""
    
    // Outlets
    @IBOutlet weak var FacebookLoginBtn: UIButton!
    @IBOutlet weak var AlterBtn: UIButton!
    @IBOutlet weak var agbsAkzeptiert: UIButton!
    @IBOutlet weak var datenschutzAkzeptiert: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var benutzerName: UITextField!
    
    
    // Actions
    
    @IBAction func createEmailAcc(_ sender: Any) {
        if AlterBtn.isSelected == true &&  agbsAkzeptiert.isSelected == true && datenschutzAkzeptiert.isSelected == true{

        if emailTextField.text == "" || passwordTextField.text == "" || benutzerName.text == "" {
            let alertController = UIAlertController(title: "Fehler", message: "Bitte Email, Passwort und Benutzernamen angeben", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if error == nil {

                    self.addUserToFirebase(name: self.benutzerName.text!, email: self.emailTextField.text!)
                    Auth.auth().currentUser?.sendEmailVerification(completion: nil)
                    let firebaseAuth = Auth.auth()
                    do {
                        try firebaseAuth.signOut()
                    } catch let signOutError as NSError {
                        print ("Error signing out: %@", signOutError)
                    }
                    let alertController = UIAlertController(title: "Registriert", message: "Wir haben dir eine Bestätigungs Email geschickt.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "zum Login", style: .cancel, handler: { (action) in
                       
                        self.segueToLoginVC()
                    })
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        } else {
            let alertNichtRegistriert = UIAlertController(title: "Registrierung fehlgeschlagen", message: "Du musst die Allgemeinen Geschäftbedingungen und Datenschutzrechtlienen akzeptieren, bevor du dich registrieren kannst.", preferredStyle: .alert)
            alertNichtRegistriert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertNichtRegistriert, animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func facebookLoginTapped(_ sender: Any) {
        if AlterBtn.isSelected == true &&  agbsAkzeptiert.isSelected == true && datenschutzAkzeptiert.isSelected == true{
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
    
    @IBAction func datenschutzAkzeptiert(_ sender: Any) {
        datenschutzAkzeptiert.isSelected = !datenschutzAkzeptiert.isSelected
    }
    
    
    
    @IBAction func agbsBtnTapped(_ sender: Any) {
        let agbsLink = SFSafariViewController(url: URL(string: "http://www.madapp.de/books/agbs.html")!)
        self.present(agbsLink, animated: true, completion: nil)
    }
    
    // Other
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            textField.keyboardType = UIKeyboardType.emailAddress }
        else {
            textField.keyboardType = UIKeyboardType.default
        }
        textField.becomeFirstResponder()
    }
    
    
    
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
                Auth.auth().signInAndRetrieveData(with: credential, completion: { (user, error) in
                    print(Auth.auth().currentUser?.uid ?? "keine uid", "UID")
                    if error != nil {
                        let alertNichtRegistriert = UIAlertController(title: "Registrierung fehlgeschlagen", message: "Diese Email wird eventuell bereits von einem Account benutzt. Bitte informiere info@madapp.de für genauere Informationen", preferredStyle: .alert)
                        alertNichtRegistriert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertNichtRegistriert, animated: true, completion: nil)
                        return
                    } else {
                        
                        var ref: DatabaseReference?
                        ref = Database.database().reference()
                        ref?.child("FacebookUsers").observeSingleEvent(of: .value, with: { (snapshot) in
                        
                                
                            if snapshot.hasChild(FBSDKAccessToken.current().userID) {
                                let alertSchonRegistriert = UIAlertController(title: "Registrierung fehlgeschlagen", message: "Du bist bereits registriert.", preferredStyle: .alert)
                                alertSchonRegistriert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                alertSchonRegistriert.addAction(UIAlertAction(title: "zum Login", style: .default, handler: { (action) in
                                    self.segueToLoginVC()
                                }))
                                self.present(alertSchonRegistriert, animated: true, completion: nil)
                            } else {
                                self.addUserToFirebase(name: self.userFbName, email: self.userFbEmail)
                                self.AddFacebookUser(name: self.userFbName, email: self.userFbEmail)
                            }
                                
                            
                        }, withCancel: nil)

                    }
                    print("fb user:", user ?? "default user")
                    
                })
            }
        }
    }
    
    func addUserToFirebase(name: String, email: String){
        var ref: DatabaseReference?
        ref = Database.database().reference()
        
        if let uid = Auth.auth().currentUser?.uid {
            ref?.child("Users").child("\(uid)").child("Name").setValue(name)
            ref?.child("Users").child("\(uid)").child("Email").setValue(email)
            ref?.child("Users").child("\(uid)").child("über18Jahre").setValue(true)
            ref?.child("Users").child("\(uid)").child("AGBSAkzeptiert").setValue(true)
            ref?.child("Users").child("\(uid)").child("DatenschutzAkzeptiert").setValue(true)
                    }
    }
    
    func AddFacebookUser(name: String, email: String){
        var ref: DatabaseReference?
        ref = Database.database().reference()
        ref?.child("FacebookUsers").child(FBSDKAccessToken.current().userID).child("FacebookID").setValue(FBSDKAccessToken.current().userID)
        ref?.child("FacebookUsers").child(FBSDKAccessToken.current().userID).child("FirebaseUid").setValue(Auth.auth().currentUser?.uid)
        ref?.child("FacebookUsers").child(FBSDKAccessToken.current().userID).child("Name").setValue(name)
        ref?.child("FacebookUsers").child(FBSDKAccessToken.current().userID).child("Email").setValue(email)
        segueToTabBar()

        }
    
    func segueToTabBar(){
//        let accessToken = FBSDKAccessToken.current()
//        guard let accessTokenString = accessToken?.tokenString else {
//            return
//        }
        
                        self.performSegue(withIdentifier: "registriert", sender: self.FacebookLoginBtn)


    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    @IBAction func backToLoginVC(_ sender: Any) {
        segueToLoginVC()
    }
    
    func segueToLoginVC() {
       performSegue(withIdentifier: "loginVC", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().languageCode = "de"
        benutzerName.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        benutzerName.keyboardAppearance = UIKeyboardAppearance.dark
        emailTextField.keyboardAppearance = UIKeyboardAppearance.dark
        passwordTextField.keyboardAppearance = UIKeyboardAppearance.dark
        agbsAkzeptiert.setImage(UIImage(named: "essen"), for: .selected)
        agbsAkzeptiert.setImage(UIImage(named: "essen-i"), for: .normal)
        AlterBtn.setImage(UIImage(named: "alkohol"), for: .selected)
        AlterBtn.setImage(UIImage(named: "alkohol-i"), for: .normal)
        datenschutzAkzeptiert.setImage(UIImage(named: "parken"), for: .selected)
        datenschutzAkzeptiert.setImage(UIImage(named: "parken-i"), for: .normal)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "hintergrund")!)


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
