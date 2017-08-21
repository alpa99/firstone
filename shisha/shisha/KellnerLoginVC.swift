//
//  KellnerLoginVC.swift
//  shisha
//
//  Created by Ibrahim Akcam on 21.08.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit

class KellnerLoginVC: UIViewController {

    
    @IBOutlet weak var barIDTextfield: UITextField!
    
    @IBOutlet weak var passwortTextfield: UITextField!
    
    
    @IBAction func kellnerLoginBtnPressed(_ sender: Any) {
        if (barIDTextfield.text != "") && (passwortTextfield.text != ""){
            print("\(barIDTextfield.text!)" + "\(passwortTextfield.text!)")
            
        }
        else{
        print("bitte daten eingeben")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
