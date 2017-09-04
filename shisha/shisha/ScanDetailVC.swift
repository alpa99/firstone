//
//  ScanDetailVC.swift
//  shisha
//
//  Created by Alper Maraz on 15.08.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Firebase



class ScanDetailVC: UIViewController {
    
    var scannummer = Int()
  
    @IBOutlet weak var scanlabel: UILabel!
    var qrbar = [QRBar]()
    var scanbarname = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(scannummer)
        fetchInfos()
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
                let qrbar = QRBar(dictionary: dictionary)
                qrbar.setValuesForKeys(dictionary)
                
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
        scanlabel.text = scanbarname
        
    }

}
