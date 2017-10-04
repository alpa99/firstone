//
//  DrawerVC.swift
//  Smolo
//
//  Created by Alper Maraz on 04.10.17.
//  Copyright © 2017 AM. All rights reserved.
//

import Foundation
import Firebase
import Pulley


class DrawerVC: UIViewController, PulleyDrawerViewControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 102.0
    }
    
    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 340.0
    }
    
    
    @IBOutlet weak var SearchTV: UITableView!
    
    let cellID = "cellID"
    
    var BarIndex = 0
    var bars = [BarInfos] ()
    
    
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
                // print(bar.Name!, bar.Stadt!)
                self.bars.append(bar)
                
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
        
        let selBar = bars[BarIndex]
        var selBarName = ""
        selBarName = selBar.Name!
        print(selBarName)
        
        
        (parent as? PulleyViewController)?.setDrawerPosition(position: PulleyPosition(rawValue: 2)!)
        let detvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BarDetailVC") as! BarDetailVC
        detvc.barname = selBarName
        
        
        
        (parent as? PulleyViewController)?.setDrawerContentViewController(controller: detvc, animated: true)
        
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
        
        return 340.0
        
        
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
