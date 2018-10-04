//
//  LoginVCViewController.swift
//  SMOLO
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
    
    // Constraints Y-Richtung
    @IBOutlet weak var fo: NSLayoutConstraint!
    @IBOutlet weak var fu: NSLayoutConstraint!
    
    @IBOutlet weak var so: NSLayoutConstraint!
    @IBOutlet weak var su: NSLayoutConstraint!
    
    
    @IBOutlet weak var fh: NSLayoutConstraint!
    
    @IBOutlet weak var sh: NSLayoutConstraint!
    
    @IBOutlet weak var eh: NSLayoutConstraint!
    
    @IBOutlet weak var ph: NSLayoutConstraint!
    
    @IBOutlet weak var pvh: NSLayoutConstraint!
    
    @IBOutlet weak var eah: NSLayoutConstraint!
    
    @IBOutlet weak var stackview: UIStackView!
    
    @IBOutlet weak var stackviewh: NSLayoutConstraint!
    
    
    // Constraints X-Richtung
    
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
                    if !(Auth.auth().currentUser?.isEmailVerified)! {
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
                    print("login fehler")
                    
                        
                    } else {
                        
                        print("You have successfully logged in")

                    
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
    

    @IBAction func unwindSegue(_ sender: UIStoryboardSegue){
        
    }
    @IBAction func registrierenSegue(_ sender: Any) {
        segueToRegistrieren()
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
            

            switch result {
            case .failed(let error):
                print(error.localizedDescription)
            case .cancelled:
                print("cancelled")
            case .success(_,_,_):
                if snapshot.hasChild(FBSDKAccessToken.current().userID) {
                self.getUserInfo {userInfo, error in
                    if let error = error {
                        print(error.localizedDescription, "ERRRRRRRRROR")
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
                            Auth.auth().signInAndRetrieveData(with: credential, completion: { (user, error) in
                                print(Auth.auth().currentUser?.uid ?? "keine uid", "UID")
                                if error != nil {
                                    let alertNichtRegistriert = UIAlertController(title: "Registrierung fehlgeschlagen", message: "Bitte informiere info@madapp.de", preferredStyle: .alert)
                                    alertNichtRegistriert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                    self.present(alertNichtRegistriert, animated: true, completion: nil)
                                                                        return
                                } else {
                                }
                                print("fb user:", user ?? "default user")
                                
                            })


            }
        }
        
    }
    
    
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
        passwortVergessenView.backgroundColor = UIColor(patternImage: UIImage(named: "hintergrund")!)
        passwortVergessenView.center = self.view.center
        passwortVergessenView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        passwortVergessenView.alpha = 0
        passwortTextfield.becomeFirstResponder()
        UIView.animate(withDuration: 0.2) {
            self.passwortVergessenView.alpha = 1
            self.passwortVergessenView.transform = CGAffineTransform.identity
        }
        
    }
    @IBAction func passwortvergessenAbbrechen(_ sender: Any) {
       passwortVergessenViewDismiss()
    }
    
    func passwortVergessenViewDismiss(){
        passwortTextfield.resignFirstResponder()

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
                let alertController = UIAlertController(title: "Fehler", message: "Es ist ein Fehler passiert. \(String(describing: error?.localizedDescription ?? "unbekanterfehler"))", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)            } else {
                
                if loginProvider != nil && loginProvider![0] == "password" {
                    Auth.auth().sendPasswordReset(withEmail: self.passwortVergessenEmail.text!) { (error) in
                if error != nil {

                    self.alert(title: "Fehler", message: "\(String(describing: error?.localizedDescription))", actiontitle: "OK")
                    
                } else {
                    self.passwortVergessenViewDismiss()
                }
                    }} else {
                    self.alert(title: "Fehler", message: "Diese Email existiert nicht", actiontitle: "OK")
                }
                
            }

        }
    }
    
    
    
    // OTHERS


    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == passwortTextfield {
            passwortVergessenViewDismiss()
        }
        
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != passwortVergessenView {
            passwortVergessenViewDismiss()
            emailTextfield.resignFirstResponder()
            passwortTextfield.resignFirstResponder()
        }
        
    }
    
    func alert(title: String, message: String, actiontitle: String) {
        let alertNichtRegistriert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertNichtRegistriert.addAction(UIAlertAction(title: actiontitle, style: .default, handler: nil))
        self.present(alertNichtRegistriert, animated: true, completion: nil)
    }
    
    func userIsEnabled(){
        let user = Auth.auth().currentUser
        var ref: DatabaseReference!
        ref = Database.database().reference()
        print(1234)
        ref.child("Users").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot, 345678)
            if let dictionary = snapshot.value as? [String: AnyObject]{
                print(5678)
                let userinfos = UserInfos(dictionary: dictionary)
                print(userinfos.Enabled!)
            }
        }, withCancel: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        fo.constant = 57/588*self.view.frame.size.height
        fu.constant = 71/588*self.view.frame.size.height
        so.constant = 36/588*self.view.frame.size.height
        su.constant = 113/588*self.view.frame.size.height
        fh.constant = 36/588*self.view.frame.size.height
        sh.constant = 36/588*self.view.frame.size.height
        stackview.spacing = 18/588*self.view.frame.size.height
        stackviewh.constant = 198/588*self.view.frame.size.height
        eh.constant = 36/588*self.view.frame.size.height
        ph.constant = 36/588*self.view.frame.size.height
        pvh.constant = 36/588*self.view.frame.size.height
        eah.constant = 36/588*self.view.frame.size.height

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().languageCode = "de"
        emailTextfield.keyboardType = UIKeyboardType.emailAddress
        emailTextfield.delegate = self
        passwortTextfield.delegate = self
        passwortVergessenEmail.delegate = self
        emailTextfield.keyboardAppearance = UIKeyboardAppearance.dark
        passwortTextfield.keyboardAppearance = UIKeyboardAppearance.dark
        passwortVergessenEmail.keyboardAppearance = UIKeyboardAppearance.dark
        loginBtn.layer.cornerRadius = 4
        kellnerLogin.layer.cornerRadius = 4
        checkIfUserIsSignedIn()

    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func checkIfUserIsSignedIn() {

        
        let sv = UIViewController.displaySpinner(onView: self.view)
        
        DispatchQueue.global(qos: .background).async {

        Auth.auth().addStateDidChangeListener { (auth, user) in
            print("lade anfang")

            if user != nil {
                var ref: DatabaseReference?
                ref = Database.database().reference()
                ref?.child("Kellner").observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.hasChild((user?.uid)!) {

                        DispatchQueue.main.async {
                            // Main thread, called after the previous code:
                            // hide your progress bar here
                            UIViewController.removeSpinner(spinner: sv)
                        }
                        
                    } else {
                        auth.fetchProviders(forEmail: (user?.email)!) { (loginProvider, error) in
                            if error != nil { DispatchQueue.main.async {
                                // Main thread, called after the previous code:
                                // hide your progress bar here
                                UIViewController.removeSpinner(spinner: sv)
                        
                                self.alert(title: "Feler", message: (error?.localizedDescription)!, actiontitle: "Ok")
                                }
                            } else {
                                if loginProvider != nil && loginProvider![0] == "password" {
                                    if (Auth.auth().currentUser?.isEmailVerified)! {

                                        DispatchQueue.main.async {
                                            // Main thread, called after the previous code:
                                            // hide your progress bar here
                                            UIViewController.removeSpinner(spinner: sv)
                                        
                                        self.segueToTabBar()
                                        }
                                    } else {

                                        DispatchQueue.main.async {
                                            // Main thread, called after the previous code:
                                            // hide your progress bar here
                                            UIViewController.removeSpinner(spinner: sv)
                                        self.alert(title: "Email bestätigen", message: "Bitte bestätige deine Email um Smolo zu nutzen.", actiontitle: "Ok")
                                    }
                                    }
                                    
                                } else if loginProvider != nil && loginProvider![0] == "facebook.com"{
                                    DispatchQueue.main.async {
                                        // Main thread, called after the previous code:
                                        // hide your progress bar here
                                        UIViewController.removeSpinner(spinner: sv)
                                    print("facebookuseer")
                                    print("lade ende")
                                    self.userIsEnabled()
                                    self.segueToTabBar()
                                    }
                                }
                            }
                        }
                                     }
                }, withCancel: nil)

            }else {
                DispatchQueue.main.async {
                    // Main thread, called after the previous code:
                    // hide your progress bar here
                    UIViewController.removeSpinner(spinner: sv)
                }
                
            }
            }
        }
    
    }
}

// login geändert

extension UIViewController{
class func displaySpinner(onView : UIView) -> UIView {
    let spinnerView = UIView.init(frame: onView.bounds)
    spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
    let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
    ai.startAnimating()
    ai.center = spinnerView.center
    
    DispatchQueue.main.async {
        spinnerView.addSubview(ai)
        onView.addSubview(spinnerView)
    }
    
    return spinnerView
}

class func removeSpinner(spinner :UIView) {
    DispatchQueue.main.async {
        spinner.removeFromSuperview()
    }
}
}
