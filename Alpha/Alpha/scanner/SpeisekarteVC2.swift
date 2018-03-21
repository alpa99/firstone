//
//  SpeisekarteVC.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 16.11.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreLocation

class SpeisekarteVC2: UIViewController, UITableViewDataSource, UITableViewDelegate, ExpandableHeaderViewDelegate, PageObservation2 {

    var parentPageViewController2: PageViewController2!
    
    var barname = " "
    var baradresse = " "
    
    // TABLEVIEW
    var sections = [ExpandTVSection2]()
    
    var KategorienInt = [String: Int]()
    
    
    var unterKategorien = [String]()
    var unterKategorienInt = [String: Int]()
    var unterKategorieArray = [String]()
    var expanded2Array = [Bool]()
    
    var itemsunterkategorie = [String]()
    var preisunterkategorie = [Int]()
    var literunterkategorie = [String]()
    
    
    var itemsUnterkategorie = [[String]]()
    var preisUnterkategorie = [[Int]]()
    var literUnterkategorie = [[String]]()
    
    
    
    
    
    // OUTLETS
        
    @IBOutlet weak var SpeisekarteTableView: UITableView!
    
    

    
    // FUNCTIONS
    func getParentPageViewController2(parentRef2: PageViewController2) {
        parentPageViewController2 = parentRef2
    }
    
    
    func getKategorien (){
        var datref: DatabaseReference!
        datref = Database.database().reference()
        
        datref.child("Speisekarten").child("\(self.barname)").observe(.childAdded, with: { (snapshotKategorie) in
            
            // Anzahl Kategorien: Shishas, Getränke
            self.KategorienInt.updateValue(Int(snapshotKategorie.childrenCount), forKey: snapshotKategorie.key)
            print(self.KategorienInt, "KATEGROIEINT")
            
            self.getUnterKategorienItems(Kategorie: snapshotKategorie.key, KategorieChildrenCount: Int(snapshotKategorie.childrenCount))
            
            
        }, withCancel: nil)

        
    }
    
    // Softdrinks, Classics
    func getUnterkategorien(){
        
        var datref: DatabaseReference!
        datref = Database.database().reference()
        datref.child("Speisekarten").child("\(self.barname)").observe(.childAdded, with: { (snapshotUnterkategorie) in
            print(1)
            
            

        }, withCancel: nil)
        
    }
    
    func getUnterKategorienItems(Kategorie: String, KategorieChildrenCount: Int){
        var datref: DatabaseReference!
        datref = Database.database().reference()
        datref.child("Speisekarten").child("\(self.barname)").child(Kategorie).observe(.childAdded, with: { (snapshotUnterkategorieItem) in
            print(Kategorie, "KATEGORIE")
            
            self.unterKategorien.append(snapshotUnterkategorieItem.key)
            self.unterKategorienInt.updateValue(Int(snapshotUnterkategorieItem.childrenCount), forKey: snapshotUnterkategorieItem.key)
            self.unterKategorieArray.append(snapshotUnterkategorieItem.key)
            self.expanded2Array.append(false)
            
            print(self.unterKategorienInt, "INNNT")
            
            if self.unterKategorienInt.count == KategorieChildrenCount {
                for (Unterkategorie, Int) in self.unterKategorienInt {
                    print(self.unterKategorienInt, "1")
                    print(Kategorie, Unterkategorie, Int, "2")
                    
                    self.fetchSpeisekarte(Kategorie: Kategorie, Unterkategorie: Unterkategorie, UnterkategorieArray: self.unterKategorieArray, expandedArray: self.expanded2Array, UnterKategorieChildrenCount: Int)
                }
                self.unterKategorienInt.removeAll()
                self.unterKategorieArray.removeAll()
                self.expanded2Array.removeAll()
                
            }
            
            
        }, withCancel: nil)
        
        
    }
    
    
    
    func fetchSpeisekarte(Kategorie: String, Unterkategorie: String, UnterkategorieArray: [String], expandedArray: [Bool], UnterKategorieChildrenCount: Int){
        var datref: DatabaseReference!
        datref = Database.database().reference()
        print(UnterKategorieChildrenCount, "UnterKategorieChildrenCount")
        datref.child("Speisekarten").child("\(self.barname)").child(Kategorie).child(Unterkategorie).observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let item = SpeisekarteInformation(dictionary: dictionary)
                self.itemsunterkategorie.append(item.Name!)
                self.preisunterkategorie.append(item.Preis!)
                if item.Liter != "keine Literangabe möglich" {
                    self.literunterkategorie.append(item.Liter!)
                } else {
                    self.literunterkategorie.append("0,0l")
                }
                
                
                
                if self.itemsunterkategorie.count == UnterKategorieChildrenCount {
                    
                    self.itemsUnterkategorie.append(self.itemsunterkategorie)
                    self.preisUnterkategorie.append(self.preisunterkategorie)
                    self.literUnterkategorie.append(self.literunterkategorie)
                    
                    self.itemsunterkategorie.removeAll()
                    self.preisunterkategorie.removeAll()
                    self.literunterkategorie.removeAll()
                }
                
                if self.itemsUnterkategorie.count == snapshot.childrenCount {
                    
                    self.setSectionsSpeisekarte(Kategorie: Kategorie, Unterkategorie: UnterkategorieArray, items: self.itemsUnterkategorie, preis: self.preisUnterkategorie, liter: self.literUnterkategorie, expanded2: expandedArray)
                    self.itemsUnterkategorie.removeAll()
                    self.preisUnterkategorie.removeAll()
                    self.literUnterkategorie.removeAll()
                    
                    
                }
                
            }
            
            
            
        }, withCancel: nil)
        
        
        
    }
    
    
    
    
    // TABLEVIEW FUNCTIONS
    
    func setSectionsSpeisekarte(Kategorie: String, Unterkategorie: [String], items: [[String]], preis: [[Int]], liter: [[String]], expanded2: [Bool]){
        self.sections.append(ExpandTVSection2(Kategorie: Kategorie, Unterkategorie: Unterkategorie, items: items, preis: preis, liter: liter, expanded2: expanded2, expanded: false))
        print(self.sections)
        self.SpeisekarteTableView.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //            return sections[section].Unterkategorie.count
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 59
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (sections[indexPath.section].expanded) {
            return CGFloat(sections[indexPath.section].items.count * 44 + sections[indexPath.section].Unterkategorie.count*50)
        }
        else {
            
            
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        
        header.customInit(tableView: tableView, title: sections[section].Kategorie, section: section, delegate: self as ExpandableHeaderViewDelegate)
        
        
        return header
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("SpeisekarteCelle", owner: self, options: nil)?.first as! SpeisekarteCelle
        cell.backgroundColor = UIColor.clear
    
        cell.unterkategorien.append(sections[indexPath.section])
        cell.items = sections[indexPath.section].items
        cell.preise = sections[indexPath.section].preis
        cell.liters = sections[indexPath.section].liter
        cell.section = indexPath.section
        return cell
        
        
        //            cell.delegate = self
        //            cell.backgroundColor = UIColor.clear
        //
        //
        //            if (sections[indexPath.section].expanded){
        //                cell.itemNameLbl.text = "\(sections[indexPath.section].items[indexPath.row])"
        //                cell.itemPreisLbl.text = "\(sections[indexPath.section].preise[indexPath.row]) €"
        //                return cell
        //
        //            }
        //            else {
        //                cell.itemNameLbl.isHidden = true
        //                cell.itemPreisLbl.isHidden = true
        //                cell.itemAddBtn.isHidden = true
        //                cell.backgroudn2.isHidden = true
        //                cell.strich.isHidden = true
        //                cell.liter.isHidden = true
        //
        //                return cell
        //
        //            }
        
        
    }
    
    
    
    func toggleSection(tableView: UITableView, header: ExpandableHeaderView, section: Int) {
        sections[section].expanded = !sections[section].expanded
        
        SpeisekarteTableView.beginUpdates()
        
        SpeisekarteTableView.reloadRows(at: [IndexPath(row: 0, section: section)], with: .automatic)
        
        SpeisekarteTableView.endUpdates()
        
    }
    
    
    
    // OTHERS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SpeisekarteTableView.reloadData()
        self.barname = parentPageViewController2.name
        
        print(self.baradresse, "viewload")
        
        getKategorien()
        //    getUnterkategorien()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}
