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
import FBSDKLoginKit

class BestellungTestVC: UIViewController {
    
    var ref: DatabaseReference?
    
    @IBOutlet weak var bestellungTextfield: UITextField!
    
    
    @IBAction func bestellenPressed(_ sender: Any) {
        
        handleBestellung()
    }
    
    var bestellung = ""
    var bestellungen = [KellnerInfos]()
    
    func handleBestellung(){
        
              
        if bestellungTextfield.text != nil{
            let values = ["text:": bestellungTextfield.text!, "User": "ibo"]
        self.ref = Database.database().reference().child("Bestellungen")
        let childRef = ref?.childByAutoId()
        childRef?.updateChildValues(values)
            
        }
          /*  childByAutoId().child("text").setValue("\(bestellungTextfield.text ?? "")")
            
            
       self.refff?.child("Bestellungen").child("-KsDpzzOuVFFanYnQykH").observe(.value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let bs = KellnerInfos(dictionary: dictionary)
                    bs.setValuesForKeys(dictionary)
                    self.bestellungen.append(bs)
                    self.bestellung = bs.Bestellung!
                    print(self.bestellung)
                  
                    
                }
                
                
            }, withCancel: nil)
            
            
            
       self.refff?.child("Kellner").child("Kellner1").child("Bestellungen").childByAutoId().setValue("\(bestellungTextfield.text!)")
            }*/
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
