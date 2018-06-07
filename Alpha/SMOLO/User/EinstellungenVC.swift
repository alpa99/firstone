//
//  EinstellungenVCViewController.swift
//  SMOLO
//
//  Created by Alper Maraz on 07.06.18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit
import Firebase
import FacebookLogin

class EinstellungenVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
        if Auth.auth().currentUser?.uid != nil {
            do
            { try Auth.auth().signOut()
                
            }
            catch let error as NSError
            { print(error.localizedDescription) }
        }
    }
    @IBAction func accloeschenTapped(_ sender: Any) {
    }
    
    @IBAction func passwortaendernTapped(_ sender: Any) {
    }
   

}
