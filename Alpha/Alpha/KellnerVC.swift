//
//  KellnerVC.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 11.11.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit

class KellnerVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // VARS
    
    var KellnerID = String()
    
    var testData = ["1adds","2sdcsd","3sdffds"]
    
    // OUTLETS
    
    // FUNCS
    
    // TABLE

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("KellnerCell", owner: self, options: nil)?.first as! KellnerCell
        cell.Label1.text = "test1"
        cell.Label2.text = "test2"
            return cell

        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    
    // OTHERS

    override func viewDidLoad() {
        super.viewDidLoad()
        print(KellnerID)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
