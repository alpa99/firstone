//
//  LogInVC.swift
//  shisha
//
//  Created by Ibrahim Akcam on 31.07.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class LogInVC: UIViewController, FBSDKLoginButtonDelegate {
    
   // @IBOutlet weak var testlbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width-32, height: 50)
        // Do any additional setup after loading the view.
        
        
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
    
        let customFbBtn = UIButton(type: .system)
        customFbBtn.backgroundColor = .blue
        customFbBtn.frame = CGRect(x: 16, y: 150, width: view.frame.width-32, height: 50)
        customFbBtn.setTitle("facebook login here", for: .normal)
        customFbBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        customFbBtn.setTitleColor(.white, for: .normal)
        view.addSubview(customFbBtn)
        
        customFbBtn.addTarget(self, action: #selector(handleCustomFbLogIn), for: .touchUpInside)

    }

    
    func handleCustomFbLogIn(){
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, err) in
            if err != nil {
            
            print("custon fb login failed:", err!)
                return
            }
            // self.testlbl.text = result?.token.tokenString

        self.showEmailAdress()
        
            
        }
    
    }
    
 
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Facebook log out")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
            }
        
        showEmailAdress()
        
    }
    
    
    func showEmailAdress(){
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else
        { return }
        /*let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signIn(with: credentials) { (user, error) in*/
        
        let credentials = OAuthProvider.credential(withProviderID: (Auth.auth().currentUser?.providerID)!, accessToken: accessTokenString)
Auth.auth().signIn(with: credentials) { (user, error) in
    
    if error != nil {
    
        print("something went wrong", error ?? "hi1")
        return
    }
    
    print("user logged in:", user ?? "hi2")
        }
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, email, name"]).start{ (connection, result, err) in
            
            if err != nil {
                print("failed graph request", err ?? "hi3")
                return
            }
            print(result ?? "hi4")
            
        }
    
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
