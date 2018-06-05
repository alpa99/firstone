//
//  SpeisekarteVC.swift
//  SMOLO
//
//  Created by Ibrahim Akcam on 16.11.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Pulley
import Firebase
import FirebaseAuth
import CoreLocation



class SpeisekarteVC: UIViewController, UITableViewDataSource, UITableViewDelegate, PulleyDrawerViewControllerDelegate, ExpandableHeaderViewDelegate, PageObservation, SpeisekarteDelegate {
    func reloadUnterkategorie(sender: SpeisekarteCelle) {
        print("jallladflsdf")
        sections = sender.sections
        SpeisekarteTableView.beginUpdates()
        SpeisekarteTableView.reloadRows(at: [IndexPath(row: 0, section: sender.sectioncell)], with: .automatic)
        SpeisekarteTableView.endUpdates()
    }
    

        var parentPageViewController: PageViewController!
    
        var barname = " "
        var baradresse = " "
    
    @IBOutlet weak var barnameLbl: UILabel!
    // TABLEVIEW
        var sections = [ExpandTVSection2]()
        var Kategorien = [String]()
        var Unterkategorien = [String: [String]]()
        var Items = [String: [[String]]]()
        var Preis = [String: [[Double]]]()
        var Liter = [String: [[String]]]()
        var Beschreibung = [String: [[String]]]()
        var Expanded = [String: [Bool]]()

        // OUTLETS
        
        @IBOutlet var SpeiseVCView: UIView!
        @IBOutlet weak var SpeisekarteTableView: UITableView!
        @IBAction func Backbtn(_ sender: UIButton) {
        parentPageViewController.goback()
            }
    
    
        // FUNCTIONS
    func getParentPageViewController(parentRef: PageViewController) {
        parentPageViewController = parentRef
    }
    

    func getKategorien (){
            var datref: DatabaseReference!
            datref = Database.database().reference()

        datref.child("Speisekarten").child("\(self.barname)").observeSingleEvent(of: .value, with: { (snapshotKategorie) in
            for key in (snapshotKategorie.children.allObjects as? [DataSnapshot])! {

                        if !self.Kategorien.contains(key.key) {
                            self.Kategorien.append(key.key)
                            self.getUnterKategorienItems(Kategorie: key.key)
                        }
                    }

        }, withCancel: nil)


        }

    
    func getUnterKategorienItems(Kategorie: String){
        var datref: DatabaseReference!
        datref = Database.database().reference()
        datref.child("Speisekarten").child("\(self.barname)").child(Kategorie).observeSingleEvent(of: .value, with: { (snapshotUnterkategorieItem) in
            
            for key in (snapshotUnterkategorieItem.children.allObjects as? [DataSnapshot])! {
                let snapshotItem = snapshotUnterkategorieItem.childSnapshot(forPath: key.key)

                if self.Unterkategorien[Kategorie] != nil {
                    self.Unterkategorien[Kategorie]?.append(key.key)
                    self.Expanded[Kategorie]?.append(false)
                    for items in (snapshotItem.children.allObjects as? [DataSnapshot])!{
                        if let dictionary = items.value as? [String: AnyObject]{
                            let item = SpeisekarteInformation(dictionary: dictionary)
                            var newitems = self.Items[Kategorie]
                            var newpreis = self.Preis[Kategorie]
                            var newliter = self.Liter[Kategorie]
                            var newbeschreibung = self.Beschreibung[Kategorie]

                            if (self.Items[Kategorie]?.count)! < (self.Unterkategorien[Kategorie]?.count)! {
                                newitems?.append([item.Name!])
                                newpreis?.append([item.Preis!])
                                newliter?.append([item.Liter!])
                                newbeschreibung?.append([item.Beschreibung!])

                                self.Items[Kategorie] = newitems
                                self.Preis[Kategorie] = newpreis
                                self.Liter[Kategorie] = newliter
                                self.Beschreibung[Kategorie] = newbeschreibung


                                
                            }
                            else {
                                newitems![(self.Unterkategorien[Kategorie]?.index(of: key.key))!].append(item.Name!)
                                self.Items[Kategorie] = newitems
                                newpreis![(self.Unterkategorien[Kategorie]?.index(of: key.key))!].append(item.Preis!)
                                self.Preis[Kategorie] = newpreis
                                newliter![(self.Unterkategorien[Kategorie]?.index(of: key.key))!].append(item.Liter!)
                                self.Liter[Kategorie] = newliter
                                newbeschreibung![(self.Unterkategorien[Kategorie]?.index(of: key.key))!].append(item.Beschreibung!)
                                self.Beschreibung[Kategorie] = newbeschreibung
                                

                            }
                            

                        }
                        
                    }
                    
                } else {
                    
                    self.Unterkategorien.updateValue([key.key], forKey: Kategorie)
                    self.Expanded.updateValue([false], forKey: Kategorie)
                    
                    for items in (snapshotItem.children.allObjects as? [DataSnapshot])!{
                        if let dictionary = items.value as? [String: AnyObject]{
                            let item = SpeisekarteInformation(dictionary: dictionary)

                            if self.Items[Kategorie] != nil{
                                var newItems = self.Items[Kategorie]
                                    newItems![(self.Unterkategorien[Kategorie]?.index(of: key.key))!].append(item.Name!)
                                    self.Items[Kategorie] = newItems
                               
                                var newPreis = self.Preis[Kategorie]
                                newPreis![(self.Unterkategorien[Kategorie]?.index(of: key.key))!].append(item.Preis!)
                                self.Preis[Kategorie] = newPreis
                               
                                var newLiter = self.Liter[Kategorie]
                                newLiter![(self.Unterkategorien[Kategorie]?.index(of: key.key))!].append(item.Liter!)
                                self.Liter[Kategorie] = newLiter
                                
                                var newBeschreibung = self.Beschreibung[Kategorie]
                                newBeschreibung![(self.Unterkategorien[Kategorie]?.index(of: key.key))!].append(item.Beschreibung!)
                                self.Beschreibung[Kategorie] = newBeschreibung
                                
                            } else {
                                self.Items.updateValue([[item.Name!]], forKey: Kategorie)
                                self.Preis.updateValue([[item.Preis!]], forKey: Kategorie)
                                self.Liter.updateValue([[item.Liter!]], forKey: Kategorie)
                                self.Beschreibung.updateValue([[item.Beschreibung!]], forKey: Kategorie)




                            }

                        }
                        
                    }
                }
            }

            if self.Unterkategorien.count == self.Kategorien.count {
                for kategorie in self.Kategorien {
                    self.setSectionsSpeisekarte(Kategorie: kategorie, Unterkategorie: self.Unterkategorien[kategorie]!, items: self.Items[kategorie]!, preis: self.Preis[kategorie]!, liter: self.Liter[kategorie]!, beschreibung: self.Beschreibung[kategorie]!, verfuegbarkeit: [self.Expanded[kategorie]!], expanded2: self.Expanded[kategorie]!)
                }
            }
        }, withCancel: nil)
    }

        // TABLEVIEW FUNCTIONS
        
    func setSectionsSpeisekarte(Kategorie: String, Unterkategorie: [String], items: [[String]], preis: [[Double]], liter: [[String]], beschreibung: [[String]], verfuegbarkeit: [[Bool]], expanded2: [Bool]){
        self.sections.append(ExpandTVSection2(Kategorie: Kategorie, Unterkategorie: Unterkategorie, items: items, preis: preis, liter: liter, beschreibung: beschreibung, verfuegbarkeit: verfuegbarkeit, expanded2: expanded2, expanded: false))
            self.SpeisekarteTableView.reloadData()
        }

        
        func numberOfSections(in tableView: UITableView) -> Int {

            return sections.count
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return 1
            
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 36
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            var heightForRowAt: Int?

            if (sections[indexPath.section].expanded) {
                
                heightForRowAt = (sections[indexPath.section].Unterkategorie.count*60)
                for expandend in sections[indexPath.section].expanded2 {
                    if expandend == true {
                        heightForRowAt = heightForRowAt! + sections[indexPath.section].items[indexPath.row].count*36
                    }
                }
                
            }
            else {
                heightForRowAt = 0
            }
            return CGFloat(heightForRowAt!)

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
        header.contentView.layer.cornerRadius = 5
        header.contentView.layer.backgroundColor = UIColor.clear.cgColor
        
        header.layer.cornerRadius = 5
        header.layer.backgroundColor = UIColor.clear.cgColor
            header.customInit(tableView: tableView, title: sections[section].Kategorie, section: section, delegate: self as ExpandableHeaderViewDelegate)
        
        
        return header
    }
    
        
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("SpeisekarteCelle", owner: self, options: nil)?.first as! SpeisekarteCelle
        cell.backgroundColor = UIColor.clear
        cell.delegate = self
        cell.sections = sections
        cell.items = sections[indexPath.section].items
        cell.preise = sections[indexPath.section].preis
        cell.liters = sections[indexPath.section].liter
        cell.beschreibungen = sections[indexPath.section].beschreibung
        cell.sectioncell = indexPath.section
        return cell
    }

        
        
        func toggleSection(tableView: UITableView, header: ExpandableHeaderView, section: Int) {

            
                for i in 0..<sections.count{
                    if i == section {
                        sections[section].expanded = !sections[section].expanded
                    } else {
                        sections[i].expanded = false
                        
                    }
                }
                
                SpeisekarteTableView.beginUpdates()

                    SpeisekarteTableView.reloadRows(at: [IndexPath(row: 0, section: section)], with: .automatic)
                
                SpeisekarteTableView.endUpdates()

        }
   
    // PULLEY
    
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 102.0
    }
    
    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 240.0
    }
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        return PulleyPosition.all
    }

    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SpeisekarteTableView.reloadData()
        self.barname = parentPageViewController.name
      barnameLbl.text = barname
       
       getKategorien()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
