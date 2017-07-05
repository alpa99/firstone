//
//  BarListVC.swift
//  Smolo
//
//  Created by Alper Maraz on 05.07.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Firebase

class BarListVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
   
    @IBOutlet weak var BarListTV: UITableView!
    
    var bar = [BarInfos]()
    let cellID = "cellID"
    


    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBars ()
        searchBar()

    }
    // kokokokokoko
    func fetchBars() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("Barliste").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let bar  = BarInfos(dictionary: dictionary)
                self.bar.append(bar)
                
                DispatchQueue.main.async(execute: {
                    self.BarListTV.reloadData()
                })
            }
            
        }, withCancel: nil)
        
    }
    

    
    func searchBar () {
        
        let searchBar = UISearchBar(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 50.0))
        searchBar.delegate = self
        searchBar.showsScopeBar = true
        searchBar.tintColor = UIColor.lightGray
        searchBar.scopeButtonTitles = ["Bar suche", "Stadt suche"]
        self.BarListTV.tableHeaderView = searchBar
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            fetchBars()
        }else {
            if searchBar.selectedScopeButtonIndex == 0 {
                bar = bar.filter({(bars) -> Bool in
                    return (bars.Name?.lowercased().contains(searchText.lowercased()))!
                }  )
            }else{
                bar = bar.filter({(bars) -> Bool in
                    return (bars.Stadt?.lowercased().contains(searchText.lowercased()))!
                })
            }
            
        }
        self.BarListTV.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let bars = bar[indexPath.row]
        
        cell.textLabel?.text =  bars.Name
        cell.detailTextLabel?.text = bars.Stadt
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bar.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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

