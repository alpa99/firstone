//
//  BarDetailVC.swift
//  shisha
//
//  Created by Alper Maraz on 26.07.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit

class BarDetailVC: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()


    setupNavigationBar ()
        
    }
    
    //hier greife ich die nummer von BarIndex auf und gehe in das array Bars und sage das meine neue variable xbar genau dieser Nummer entspricht.
    //ich glaube das doppeln entsteht dadurch dass das array bars jetzt public ist also nicht mehr nur in der class steht

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
