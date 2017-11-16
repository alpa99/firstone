//
//  SpeisekarteVC.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 16.11.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Pulley

class SpeisekarteVC: UIViewController, PulleyDrawerViewControllerDelegate {
    
    var barname = ""
    
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 102.0
    }
    
    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 340.0
    }
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        return PulleyPosition.all
    }
    
    

    
    @IBAction func BackBtn(_ sender: Any) {
        (parent as? PulleyViewController)?.setDrawerPosition(position: PulleyPosition(rawValue: 2)!)
        let drawervc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DrawerVC") as! DrawerVC
        
        
        
        (parent as? PulleyViewController)?.setDrawerContentViewController(controller: drawervc, animated: true)
    }
    @IBAction func toDetailVC(_ sender: Any) {
        (parent as? PulleyViewController)?.setDrawerPosition(position: PulleyPosition(rawValue: 2)!)
        let detvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        
        detvc.barname = barname
        (parent as? PulleyViewController)?.setDrawerContentViewController(controller: detvc, animated: true)
        
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
