//
//  BestellungTestVC.swift
//  shisha
//
//  Created by Ibrahim Akcam on 23.08.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class BestellungTestVC: UIViewController {
    
    var refff: DatabaseReference?
    
    @IBOutlet weak var bestellungTextfield: UITextField!
    
    @IBAction func bestellenPressed(_ sender: Any) {
        
        addBestellungToFirebase()
    }
    
    func addBestellungToFirebase(){
        if bestellungTextfield.text != nil{
        self.refff = Database.database().reference()
        self.refff?.child("Bestellungen").childByAutoId().child("text").setValue("\(bestellungTextfield.text ?? "")")
            
            // childbyauthID unterschiedlich!!!!! WICHTIG?
            
        self.refff?.child("Kellner").child("Kellner1").child("Bestellungen").childByAutoId().setValue("\(bestellungTextfield.text!)")
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
