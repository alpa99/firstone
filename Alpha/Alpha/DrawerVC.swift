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

class DrawerVC: UIViewController, PulleyDrawerViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet weak var BarTV: UITableView!
    
    var bars = [BarInfos]()
    var filteredbars = [BarInfos]()
    var barIndex = 0
    let cellID = "cellID"
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        BarTV.delegate = self
        BarTV.dataSource = self
        BarTV.register(barCell.self, forCellReuseIdentifier: cellID)
        bars = [BarInfos]()
        fetchBars()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation  = false
        definesPresentationContext = true
        BarTV.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
        
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return (((parent as? PulleyViewController)?.setDrawerPosition(position: PulleyPosition(rawValue: 2)!)) != nil)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        (parent as? PulleyViewController)?.setDrawerPosition(position: PulleyPosition(rawValue: 2)!)
    }
    
    func filteredContent (searchText: String, scope: String = "All"){
        
        filteredbars = bars.filter{ bar in
            
            return (bar.Name?.lowercased().contains(searchText.lowercased()))!
        }
        BarTV.reloadData()
    }

    
    func updateSearchResults(for: UISearchController){
        filteredContent(searchText: searchController.searchBar.text!)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive == true && searchController.searchBar.text != ""{
            return filteredbars.count
            
        }
        
       return bars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
      //  let bar = bars[indexPath.row]
        
        let bar : BarInfos
        
        if searchController.isActive == true && searchController.searchBar.text != ""{
            bar = filteredbars[indexPath.row]
        } else {
            bar = bars[indexPath.row]
        }
            
        
        cell.textLabel?.text = bar.Name
        
        return cell
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
        
        //let selBar = bars[barIndex]
        
        let selBar : BarInfos
        if searchController.isActive == true && searchController.searchBar.text != ""{
            selBar = filteredbars[barIndex]
        } else {
            selBar = bars[barIndex]
        }
        
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
    

   
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

