//
//  ScanDetailVC.swift
//  Alpha
//
//  Created by Alper Maraz on 23.10.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Firebase

class ScanDetailVC: UIViewController {

    // VARS
    
    var scannummer = Int()
    var qrbar = [QRBereich]()
    var scanbarname = ""
    
    // FUNCTIONS 
    
    func fetchInfos() {
        
        var datref: DatabaseReference!
        datref = Database.database().reference()
        datref.child("QRBereich").child("\(scannummer)").observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let qrbar = QRBereich(dictionary: dictionary)                
                self.scanbarname.append(qrbar.Name!)
                print(self.scanbarname)
                self.setupNavigationBar()
            }
        }
            , withCancel: nil)
    }
    
    
    
    func setupNavigationBar (){
        let xbar = scanbarname
        self.navigationItem.title = xbar
    }
    
    
    // OTHERS

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
