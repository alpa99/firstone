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

class NavController: UINavigationController, PulleyDrawerViewControllerDelegate{
    
    func collapsedDrawerHeight() -> CGFloat {
        return 102.0
    }
    func partialRevealDrawerHeight() -> CGFloat {
        
        return 340.0
        
        
    }
    func supportedDrawerPositions() -> [PulleyPosition]{
        
        return PulleyPosition.all
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)

    }

}

class DrawerContentViewController: UIViewController, PulleyDrawerViewControllerDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var SearchTV: UITableView!
    
     let cellID = "cellID"
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)

    }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        BarIndex = indexPath.row
        (parent as? PulleyViewController)?.setDrawerPosition(position: PulleyPosition(rawValue: 2)!)
        
        let detailVC:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BarDetailVC") as UIViewController
        (parent as? PulleyViewController)?.setDrawerContentViewController(controller: detailVC, animated: true)
        
     //  performSegue(withIdentifier: "bardetail", sender: self)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collapsedDrawerHeight() -> CGFloat {
        return 102.0
    }
    func partialRevealDrawerHeight() -> CGFloat {
        
        return 304.0
        
        
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

