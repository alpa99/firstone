//
//  ScanDetailVC.swift
//  SMOLO
//
//  Created by Alper Maraz on 23.10.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Firebase

class ScanDetailVC: UIViewController {

    // VARS
    
   // var scannummer = Int()
     var scannummer = 1010
    var qrbar = [QRBereich]()
    var scanbarname = "Barracuda"
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    // FUNCTIONS 
    
//    func fetchInfos() {
//
//        var datref: DatabaseReference!
//        datref = Database.database().reference()
//        datref.child("QRBereich").child("\(scannummer)").observe(.value, with: { (snapshot) in
//
//            if let dictionary = snapshot.value as? [String: AnyObject]{
//                let qrbar = QRBereich(dictionary: dictionary)
//                self.scanbarname.append(qrbar.Name!)
//                print(self.scanbarname)
//                self.setupNavigationBar()
//            }
//        }
//            , withCancel: nil)
//    }
//
    
    
    func setupNavigationBar (){
        let xbar = scanbarname
        self.navigationItem.title = xbar
        navigationController?.navigationBar.isHidden = true
    }
    
    
    // OTHERS

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        print(scanbarname,"dfadffdjidf")
        let detVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        detVC.barname = scanbarname
        self.addChild(detVC)
        self.scrollView.addSubview(detVC.view)
        detVC.didMove(toParent: self)
        detVC.view.frame = scrollView.bounds

        
        let speiseVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SpeisekarteVC") as! SpeisekarteVC
        
        speiseVC.barname = scanbarname
        self.addChild(speiseVC)
        self.scrollView.addSubview(speiseVC.view)
        speiseVC.didMove(toParent: self)
        speiseVC.view.frame = scrollView.bounds
        
        var speiseFrame: CGRect = speiseVC.view.frame
        speiseFrame.origin.x = self.view.frame.width
        speiseVC.view.frame = speiseFrame
      
        

        self.scrollView.contentSize = CGSize(width: self.view.frame.width*3, height: self.view.frame.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
