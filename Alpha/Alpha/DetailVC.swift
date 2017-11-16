//
//  DetailVC.swift
//  Alpha
//
//  Created by Alper Maraz on 15.11.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Pulley
import Firebase

class DetailVC: UIViewController, PulleyDrawerViewControllerDelegate {
 
    var barname = ""
    var bars = [BarInfos]()
    var adresse = String ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var Namelbl: UILabel!
    
    @IBAction func bestellung(_ sender: UIButton) {(parent as? PulleyViewController)?.setDrawerPosition(position: PulleyPosition(rawValue: 2)!)
        let speisekartevc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SpeisekarteVC") as! SpeisekarteVC
        
        speisekartevc.barname = barname
        
        (parent as? PulleyViewController)?.setDrawerContentViewController(controller: speisekartevc, animated: true)
        
        
    }
    
    @IBAction func Backbtn(_ sender: UIButton) {
        (parent as? PulleyViewController)?.setDrawerPosition(position: PulleyPosition(rawValue: 2)!)
        let drawervc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DrawerVC") as! DrawerVC
        
        
        
        (parent as? PulleyViewController)?.setDrawerContentViewController(controller: drawervc, animated: true)
        
     // performSegue(withIdentifier: "drawervc", sender: self)
    }
        
  
        
    
    
    func fetchData () {
        
        print("vgv")
        var ref: DatabaseReference!
        self.Namelbl.text = self.barname
        ref = Database.database().reference()
        ref.child("BarInfo").child("\(barname)").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let bar = BarInfos(dictionary: dictionary)
                
                self.bars.append(bar)
                
            }
        } , withCancel: nil)
        
    }
    
    
        
    // Pulley
        
        
        func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
            return 102.0
        }
        
        func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
            return 340.0
        }
        
        func supportedDrawerPositions() -> [PulleyPosition] {
            return PulleyPosition.all
        }
        
    
    
    
}
