//
//  LogInVC.swift
//  shisha
//
//  Created by Ibrahim Akcam on 31.07.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LogInVC: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width-32, height: 50)
        // Do any additional setup after loading the view.
        
        
        loginButton.delegate = self
    }

 
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Facebook log out")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        } else {
        print("erfolgreich eingeloggt")
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
