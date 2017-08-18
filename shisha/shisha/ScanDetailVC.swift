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
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        

    //    fetchInfos()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func fetchInfos() {
//        
//        var datref: DatabaseReference!
//        datref = Database.database().reference()
//        datref.child("QRBereich").child("\(barnummer)").observe(.childAdded, with: { (snapshot) in
//            
//            if let dictionary = snapshot.value as? [String: AnyObject]{
//                let qrbarname = BarInfos(dictionary: dictionary)
//                qrbarname.setValuesForKeys(dictionary)
//                print(qrbarname.Name!)
//                self.qrbarnamen.append(qrbarname.Name!)
//                
//               
//                }
//            }
//            
//        
//        , withCancel: nil)
//
//        }
    
    func setupNavigationBar (){
        
        navigationItem.title = qrbarname[0]
        print(qrbarname)
        
    }
//
}
