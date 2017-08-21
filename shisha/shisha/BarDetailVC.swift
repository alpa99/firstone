//
//  BarDetailVC.swift
//  shisha
//
//  Created by Alper Maraz on 26.07.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Pulley

class BarDetailVC: UIViewController, PulleyDrawerViewControllerDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    
    @IBAction func BackButton(_ sender: Any) {
        let tableVC:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DrawerContentViewController") as UIViewController
        (parent as? PulleyViewController)?.setDrawerContentViewController(controller: tableVC, animated: true)

        
    }
    func collapsedDrawerHeight() -> CGFloat {
        return 102.0
    }
    func partialRevealDrawerHeight() -> CGFloat {
        
        return 340.0
        
        
    }
    func supportedDrawerPositions() -> [PulleyPosition]{
        
        return PulleyPosition.all
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        


    setupNavigationBar ()
        
    }
    @IBAction func verify(_ sender: Any) {
        let scanVC = self.storyboard?.instantiateViewController(withIdentifier: "scanID") as! QRController
        self.present(scanVC, animated: true, completion: nil)
        
//        performSegue(withIdentifier: "verify", sender: self)
    }
    
    

     func setupNavigationBar (){
        let xbar = bars[BarIndex]
        
        navigationItem.title = xbar.Name
        print(xbar.Name!)
        
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

class testseite: UIViewController{
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }

}
