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
    
    // VARS
    var bars = [BarInfos]()
    var filteredbars = [BarInfos]()
    var barIndex = 0
    let cellID = "cellID"
    let searchController = UISearchController(searchResultsController: nil)
    
    
    // OUTLETS
    @IBOutlet weak var BarTV: UITableView!
    @IBOutlet weak var topView: UIView!

    
    // FUNS
    
    func fetchBars () {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("BarInfo").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let bar = BarInfos(dictionary: dictionary)
                
                self.bars.append(bar)
                
                DispatchQueue.main.async(execute: {
                    self.BarTV.reloadData()
                } )
            }
        }, withCancel: nil)

    }
    
    // SEARCHBAR FUNCS
    
     func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.searchController.searchBar.endEditing(true)
    }
    
    func drawerPositionDidChange(drawer: PulleyViewController, bottomSafeArea: CGFloat) {
        self.searchController.searchBar.endEditing(true)
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
    
    // TABLEVIEW FUNCS
    
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
       
        
        let pagevc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageVC") as! PageViewController
        pagevc.name = selBarName

        (parent as? PulleyViewController)?.setDrawerContentViewController(controller: pagevc, animated: true)
//        let detvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
//        detvc.barname = selBarName
//        
//        let speisevc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SpeisekarteVC") as! SpeisekarteVC
//        
//        speisevc.barname = selBarName
        
        //  performSegue(withIdentifier: "bardetail", sender: self)
        
    }
    
   
    // PULLEY
    
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 102.0
     
    }
    
    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 340.0
    }
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        return PulleyPosition.all
    }
    

    
    // OTHERS
    
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
        //BarTV.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
        
        // Add the search bar as a subview of the UIView you added above the table view
        self.topView.addSubview(self.searchController.searchBar)
        // Call sizeToFit() on the search bar so it fits nicely in the UIView
        self.searchController.searchBar.sizeToFit()
        // For some reason, the search bar will extend outside the view to the left after calling sizeToFit. This next line corrects this.
        self.searchController.searchBar.frame.size.width = self.view.frame.size.width
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}

// NEW CLASS

class barCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

