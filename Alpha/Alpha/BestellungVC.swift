//
//  BestellungVC.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 22.10.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Firebase
import Pulley

class BestellungVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ExpandableHeaderViewDelegate, PulleyDrawerViewControllerDelegate, CustomTableCellDelegate {

    // VARS
    
    var barname = ""
    
    var bestellungsText = "noch keine Bestellung"
    
    var bars = [BarInfos]()
    var adresse = String ()
    
    var shishas = [String]()
    var shishasPreise = [Int]()
    var getränke = [String]()
    var getränkePreise = [Int]()
    var sections = [ExpandTVSection]()
    
    
    // OUTLETS
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var bestellungLbl: UILabel!
    
    @IBOutlet weak var bestellungTableView: UITableView!

    
    // ACTIONS
    

    @IBAction func Back(_ sender: Any) {
        
        let tableVC:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DrawerVC") as UIViewController
        (parent as? PulleyViewController)?.setDrawerContentViewController(controller: tableVC, animated: true)
    }
    

    

    // FUNCTIONS
    
    func fetchSpeisekarte(){
        var z = [String: Int]()
        var datref: DatabaseReference!
        datref = Database.database().reference()
        
        datref.child("Speisekarten").child("\(self.barname)").observe(.childAdded, with: { (snapshot) in
            
            z.updateValue(Int(snapshot.childrenCount), forKey: snapshot.key)
            print(z, "AFDSFSDF")
            
            
            datref.child("Speisekarten").child("\(self.barname)").child("Shishas").observe(.childAdded, with: { (snapshot) in
                self.label.text = self.barname
                
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let shisha = SpeisekarteInfos(dictionary: dictionary)
                    self.shishas.append(shisha.Name!)
                    self.shishasPreise.append(shisha.Preis!)
                    
                }
                if self.shishas.count == z["Shishas"]{
                    self.setSections(genre: "Shishas", movies: self.shishas, preise: self.shishasPreise)
                }
                
            }, withCancel: nil)
            
            datref.child("Speisekarten").child("\(self.barname)").child("Getränke").observe(.childAdded, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let getränk = SpeisekarteInfos(dictionary: dictionary)
                    self.getränke.append(getränk.Name!)
                    self.getränkePreise.append(getränk.Preis!)
                }
                if self.getränke.count == z["Getränke"]{
                    self.setSections(genre: "Getränke", movies: self.getränke, preise: self.getränkePreise)
                }
                
            }, withCancel: nil)
            
            
        }, withCancel: nil)
        
        
    }
    
    
    func shishaBtn(sender: CustomTableViewCell) {
        print("Button2")
        
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
    
    


    // TABLEVIEW FUNCTIONS
    
    func setSections(genre: String, movies: [String], preise: [Int]){
        self.sections.append(ExpandTVSection(genre: genre, movies: movies, preise: preise, expanded: false))
        self.bestellungTableView.reloadData()
    }
  


    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].movies.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (sections[indexPath.section].expanded){
            return 59
        }
        else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        header.customInit(title: sections[section].genre, section: section, delegate: self as ExpandableHeaderViewDelegate)
        return header
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = bestellungTableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! CustomTableViewCell
        
        cell.delegate = self
        cell.shishaNameLbl.text = "\(sections[indexPath.section].movies[indexPath.row])"
        cell.shishaPreisLbl.text = "\(sections[indexPath.section].preise[indexPath.row]) €"
        
        return cell
    }
    
    
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        sections[section].expanded = !sections[section].expanded
        
        bestellungTableView.beginUpdates()
        for i in 0..<sections[section].movies.count{
            bestellungTableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        bestellungTableView.endUpdates()
        
    }

    // OTHERS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchSpeisekarte()
        bestellungLbl.text = bestellungsText
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}



