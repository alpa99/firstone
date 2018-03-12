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

class LoginVC: UIViewController {
    
    // VARS
    var userFbID = ""
    var userFbName = ""
    var userFbEmail = ""
    
    
    // OUTLETS
    @IBOutlet weak var loginBtn: UIButton!
    
    
    // ACTIONS
    @IBAction func loginTapped(_ sender: UIButton) {
        
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { result in
            
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
                        self.userFbID = "\(id)"
                        self.userFbName = "\(name)"
                        self.userFbEmail = "\(email)"
                    }
                    self.addUserToFirebase()
                    
                }
            }
            
        }
    }
    
    // FUNCS
    
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
                        print("something wrong", error ?? "default error")
                        return
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
        segueToTabBar()
        }
    }
    
    func segueToTabBar(){
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { error in
            if error != nil {
                print("errrorororor")
                
            } else if Auth.auth().currentUser?.uid != nil{
                self.performSegue(withIdentifier: "login", sender: self.loginBtn)
            }
                
        })
    }
    
    // OTHERS
    
    override func viewDidAppear(_ animated: Bool) {

        if Auth.auth().currentUser?.uid != nil {
            print(Auth.auth().currentUser?.uid, "IDDDD")
            segueToTabBar()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginBtn.layer.cornerRadius = 4


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
