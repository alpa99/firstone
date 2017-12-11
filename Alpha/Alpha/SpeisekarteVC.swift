//
//  SpeisekarteVC.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 16.11.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Pulley
import Firebase

class SpeisekarteVC: UIViewController, UITableViewDataSource, UITableViewDelegate, PulleyDrawerViewControllerDelegate, ExpandableHeaderViewDelegate, PageObservation {


    // VARS
    var barname = ""
    
    var shishas = [String]()
    var shishasPreise = [Int]()
    var getränke = [String]()
    var getränkePreise = [Int]()
    var quantitiy = [Double]()
    var quality = [Double]()
    var voteresult = [Double]()

    
    var sections = [ExpandTVSection]()
    
    var parentPageViewController: PageViewController!
    func getParentPageViewController(parentRef: PageViewController) {
        parentPageViewController = parentRef
    }
    
    @IBOutlet weak var speisekarteTV: UITableView!
    
    // ACTIONS
    

    
    @IBAction func BackBtn(_ sender: Any) {
        (parent as? PulleyViewController)?.setDrawerPosition(position: PulleyPosition(rawValue: 2)!)
        let drawervc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DrawerVC") as! DrawerVC
        
        
        
        (parent as? PulleyViewController)?.setDrawerContentViewController(controller: drawervc, animated: true)
    }
    @IBAction func toDetailVC(_ sender: Any) {
        (parent as? PulleyViewController)?.setDrawerPosition(position: PulleyPosition(rawValue: 2)!)
        let detvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        
        detvc.barname = barname
        (parent as? PulleyViewController)?.setDrawerContentViewController(controller: detvc, animated: true)
        
    }
    
    // FUNCS
    
    func fetchSpeisekarte(){
        var z = [String: Int]()
        var datref: DatabaseReference!
        datref = Database.database().reference()
        
        datref.child("Speisekarten").child("\(self.barname)").observe(.childAdded, with: { (snapshot) in
            
            z.updateValue(Int(snapshot.childrenCount), forKey: snapshot.key)
            print(z, "AFDSFSDF")
            
            
            datref.child("Speisekarten").child("\(self.barname)").child("Shishas").observe(.childAdded, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let shisha = SpeisekarteInfos(dictionary: dictionary)
                    self.shishas.append(shisha.Name!)
                    self.shishasPreise.append(shisha.Preis!)
                    
                    
                }
                if self.shishas.count == z["Shishas"]{
                    self.setSections(genre: "Shishas", items: self.shishas, preise: self.shishasPreise)
                }

            }, withCancel: nil)
            
            datref.child("Speisekarten").child("\(self.barname)").child("Getränke").observe(.childAdded, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let getränk = SpeisekarteInfos(dictionary: dictionary)
                    self.getränke.append(getränk.Name!)
                    self.getränkePreise.append(getränk.Preis!)
                }
                if self.getränke.count == z["Getränke"]{
                    self.setSections(genre: "Getränke", items: self.getränke, preise: self.getränkePreise)
                }
                
            }, withCancel: nil)
            
            
        }, withCancel: nil)
        
        
    }
    
    
    func setSections(genre: String, items: [String], preise: [Int]){
        self.sections.append(ExpandTVSection(genre: genre, items: items, preise: preise, expanded: false))
        self.speisekarteTV.reloadData()
    }
    
    
    // TABLE
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if (sections[indexPath.section].expanded){
            
            return 115
        }
        else {
            return 0
            
        }
    }
        
        func tableView(_ tableView: UITableView, heightForFooterInSection: Int) -> CGFloat {
            return 2
        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let header = ExpandableHeaderView()
            header.customInit(tableView: tableView, title: sections[section].genre, section: section, delegate: self as ExpandableHeaderViewDelegate)
            return header
        }
        
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("SpeisekarteCell", owner: self, options: nil)?.first as! SpeisekarteCell
        if (sections[indexPath.section].expanded){
            cell.itemNameLbl.text = "\(sections[indexPath.section].items[indexPath.row])"
            cell.itemPreisLbl.text = "\(sections[indexPath.section].preise[indexPath.row]) €"
        }
        else {
            cell.itemNameLbl.isHidden = true
            cell.itemPreisLbl.isHidden = true
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (sections[indexPath.section].expanded){
            return 71
        }
        else {
            return 0
        
        }
    }

    

    
    func toggleSection(tableView: UITableView, header: ExpandableHeaderView, section: Int) {
        sections[section].expanded = !sections[section].expanded
        
        speisekarteTV.beginUpdates()
        for i in 0..<sections[section].items.count{
            speisekarteTV.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        speisekarteTV.endUpdates()
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
         self.barname = parentPageViewController.name
        fetchSpeisekarte()
       

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
