//
//  DrawerVC.swift
//  Alpha
//
//  Created by Alper Maraz on 19.10.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Pulley
import Firebase

class DrawerVC: UIViewController, PulleyDrawerViewControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var BarTV: UITableView!
    
    var bars = [BarInfos]()
    var barIndex = 0
    let cellID = "cellID"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return bars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let bar = bars[indexPath.row]
        
        cell.textLabel?.text = bar.Name
        
        return cell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BarTV.delegate = self
        BarTV.dataSource = self
        BarTV.register(barCell.self, forCellReuseIdentifier: cellID)
        bars = [BarInfos]()
        fetchBars()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func fetchBars () {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("BarInfo").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let bar = BarInfos(dictionary: dictionary)
               // bar.setValuesForKeys(dictionary)
                // print(bar.Name!, bar.Stadt!)
                self.bars.append(bar)
                
                DispatchQueue.main.async(execute: {
                    self.BarTV.reloadData()
                } )
            }
            
            //  print(snapshot)
            
            
            
            
        }, withCancel: nil)
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        barIndex = indexPath.row
        
        let selBar = bars[barIndex]
        var selBarName = ""
        selBarName = selBar.Name!
        print(selBarName)
        
        
        (parent as? PulleyViewController)?.setDrawerPosition(position: PulleyPosition(rawValue: 2)!)
        let detvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BestellungVC") as! BestellungVC
        detvc.barname = selBarName
        
        
        
        (parent as? PulleyViewController)?.setDrawerContentViewController(controller: detvc, animated: true)
        
        //  performSegue(withIdentifier: "bardetail", sender: self)
        
    }
    
   
    
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

class barCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

