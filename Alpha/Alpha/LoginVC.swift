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
                        print(error.localizedDescription)
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
        ref?.child("Users").child("\(self.userFbID)").child("Name").setValue(self.userFbName)
        ref?.child("Users").child("\(self.userFbID)").child("Email").setValue(self.userFbEmail)
        print(self.userFbID)
        segueToTabBar()
    }
    
    func segueToTabBar(){
        
        
        performSegue(withIdentifier: "login", sender: self)
        
    }
    
    // OTHERS
    
    override func viewDidAppear(_ animated: Bool) {
        if FBSDKAccessToken.current() != nil {
            segueToTabBar()
            print(FBSDKAccessToken.current(), "holaaa")
        } else {
            print("holaaaaaaaaa")
            print(FBSDKAccessToken.current(), "access")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
