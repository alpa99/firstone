//
//  BarDetailVC.swift
//  Alpha
//
//  Created by Alper Maraz on 21.10.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Pulley
import Firebase

class BarDetailVC: UIViewController, PulleyDrawerViewControllerDelegate {
    
    // VARS
    
    var barname = " "
    var bars = [BarInfos]()
    var adresse = String ()
    
    
    // ACTIONS
    
    @IBAction func Back(_ sender: Any) {
        
        let tableVC:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DrawerVC") as UIViewController
        (parent as? PulleyViewController)?.setDrawerContentViewController(controller: tableVC, animated: true)
    }
    
    
    // PULLEY
    
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 102.0
    }
    
    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 340.0
    }
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        return PulleyPosition.all
    }
    
    
    // OTHERS

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }



}
