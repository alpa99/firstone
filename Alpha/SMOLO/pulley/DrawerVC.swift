//
//  DrawerVC.swift
//  SMOLO
//
//  Created by Alper Maraz on 19.10.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Pulley
import Firebase
import CoreLocation

class DrawerVC: UIViewController, PulleyDrawerViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate, PulleyCellDelegate, CLLocationManagerDelegate {
    
    // VARS
    var bars = [BarInfos]()
    var filteredbars = [BarInfos]()
    var barIndex = 0
    let cellID = "cellID"
    let searchController = UISearchController(searchResultsController: nil)
    var locationManager = CLLocationManager()
    var entf = [Double]()


    
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
        return (self.pulleyViewController?.setDrawerPosition(position: .open, animated: true) != nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    self.pulleyViewController?.setDrawerPosition(position: .open, animated: true)
    }
    
    func filteredContent (searchText: String, scope: String = "All"){
        
        filteredbars = bars.filter { bar in

            return ((bar.Name?.lowercased().contains(searchText.lowercased()))! || (bar.Stadtteil?.lowercased().contains(searchText.lowercased()))!)
            
        }
        BarTV.reloadData()

    }

    
    func updateSearchResults(for: UISearchController){
        filteredContent(searchText: searchController.searchBar.text!)
        print(4)
    }
    
    // TABLEVIEW FUNCS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive == true && searchController.searchBar.text != ""{

            return filteredbars.count
            
        }

        
       return bars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("PulleyCell", owner: self, options: nil)?.first as! PulleyCell
        
        cell.delegate = self
        
        cell.backgroundColor = UIColor.clear
        
        let bar : BarInfos
        
        if searchController.isActive == true && searchController.searchBar.text != ""{
            bar = filteredbars[indexPath.row]


            
        } else {
            bar = bars[indexPath.row]

        }
        print(bar, "BARS")
        CLGeocoder().geocodeAddressString(bar.Adresse!, completionHandler: { (placemarks, error) -> Void in

            if let placemark = placemarks?[0] {
                let location = placemark.location
                let distancebar = self.locationManager.location?.distance(from: location!)
                
                if distancebar == nil {
                    cell.distanzName.text = ""
                } else {
                    let strecke = Double(distancebar!)/1000.0
                    let dist = String(format: "%.2f", strecke)
                    
                    cell.distanzName.text = "\(dist) km"
                }

            }})

        cell.barName.text = bar.Name
        cell.stadtName.text = bar.Stadtteil
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
 
        return 90.0
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
        
        
        self.pulleyViewController?.setDrawerPosition(position: .open, animated: true)
       
        
        let pagevc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageVC") as! PageViewController
        pagevc.name = selBarName

        (parent as? PulleyViewController)?.setDrawerContentViewController(controller: pagevc, animated: true)

        
        
    }
    
   
    // PULLEY
    
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 102.0
     
    }
    
    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 240
    }
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        return PulleyPosition.all
    }
    

    
    // OTHERS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.gray

        BarTV.delegate = self
        BarTV.dataSource = self
        BarTV.register(barCell.self, forCellReuseIdentifier: cellID)
        bars = [BarInfos]()
        
        searchController.searchBar.placeholder = "Finde deine SMOLO"
        searchController.searchBar.barTintColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.0)
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.tintColor = .white

        if let txfSearchField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            txfSearchField.textColor = .white
            txfSearchField.borderStyle = .roundedRect
            txfSearchField.backgroundColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.0)
        }
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
        
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
        fetchBars()

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.BarTV.reloadData()
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
