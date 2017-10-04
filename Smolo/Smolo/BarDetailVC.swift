//
//  BarDetailVC.swift
//  Smolo
//
//  Created by Alper Maraz on 04.10.17.
//  Copyright © 2017 AM. All rights reserved.
//

import Foundation
import Pulley
import Firebase

class BarDetailVC: UIViewController, PulleyDrawerViewControllerDelegate{
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 105.0
    }
    
    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 340.0
    }
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        return PulleyPosition.all
    }
    
    
    var barname = ""
    var bars = [BarInfos] ()
    var Adresse = String()

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    
    
}
