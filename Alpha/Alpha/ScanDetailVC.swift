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

    var scannummer = Int()
    var qrbar = [QRBereich]()
    var scanbarname = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchInfos() {
        
        var datref: DatabaseReference!
        datref = Database.database().reference()
        datref.child("QRBereich").child("\(scannummer)").observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let qrbar = QRBereich(dictionary: dictionary)
              //  qrbar.setValuesForKeys(dictionary)
                
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
        print(xbar+"df")
//        scanlabel.text = scanbarname
        
    }

}
