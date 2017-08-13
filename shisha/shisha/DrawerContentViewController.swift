//
//  DrawerContentVC.swift
//  shisha
//
//  Created by Alper Maraz on 07.08.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Pulley
import Firebase

var BarIndex = 0
var bars = [BarInfos] ()



class DrawerContentViewController: UIViewController, PulleyDrawerViewControllerDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var SearchTV: UITableView!
    
     let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SearchTV.delegate = self
        SearchTV.dataSource = self
        SearchTV.register(barCell.self, forCellReuseIdentifier: cellID)
        bars = [BarInfos]()
        fetchBars()

    
    }

    func fetchBars () {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("Barliste").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let bar = BarInfos(dictionary: dictionary)
                bar.setValuesForKeys(dictionary)
                print(bar.Name!, bar.Stadt!)
                bars.append(bar)
                
                DispatchQueue.main.async(execute: {
                    self.SearchTV.reloadData()
                } )
            }
            
            //  print(snapshot)
            
            
            
            
        }, withCancel: nil)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellID)
        let bar = bars[indexPath.row]
        
        
        cell.textLabel?.text = bar.Name
        cell.detailTextLabel?.text = bar.Stadt
        
        return cell

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collapsedDrawerHeight() -> CGFloat {
        return 100.0
    }
    func partialRevealDrawerHeight() -> CGFloat {
        
        return 264.0
        
        
    }
    func supportedDrawerPositions() -> [PulleyPosition]{
       
            return PulleyPosition.all
        
}
}

class barCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

