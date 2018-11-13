//
//  BestellungAbschickenVC.swift
//  SMOLO
//
//  Created by Ibrahim Akcam on 03.03.18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit

class BestellungAbschickenVC: UIViewController {
        
    @IBAction func zuMeinenBestellungenSegue(_ sender: Any) {
        self.tabBarController?.selectedIndex = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.selectedIndex = 2
        self.navigationController?.popToRootViewController(animated: true)

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
