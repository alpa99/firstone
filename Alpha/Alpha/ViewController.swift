//
//  ViewController.swift
//  Alpha
//
//  Created by Alper Maraz on 19.10.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    var name = ""

    override func viewDidLoad() {
        super.viewDidLoad()
       fetchData()
    }
    
    func fetchData() {
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("QRBereich").child("1000").observe(.value, with: { (snapshot) in
            
            if let dict = snapshot.value as? [String: AnyObject]{
                
                let qrbar = QRBereich(dictionary: dict)
               // qrbar.setValuesForKeys(dict)
                
                self.name.append(qrbar.Name!)
                
                print(self.name)
                
                
                
            }
        }
            
            , withCancel: nil)
        
        
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

