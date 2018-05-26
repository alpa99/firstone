//
//  KellnerVC.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 11.11.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Firebase

class KellnerVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ExpandableHeaderViewDelegate, kellnerCellDelegate {

    
    
    
    // VARS
    var Bestellungen = [KellnerTVSection]()
    var bestellungIDs = [String]()
    var BestellungKategorien = [String: [String]]()
    var BestellungUnterkategorien = [String: [[String]]]()
    var BestellungExpanded2 = [String: [[Bool]]]()

    var BestellungItemsNamen = [String: [[[String]]]]()
    var BestellungItemsPreise = [String: [[[Double]]]]()
    var BestellungItemsMengen = [String: [[[Int]]]]()
    var Tischnummer = [String: String]()
    var Angenommen = [String: String]()
    var FromUserID = [String: String]()
    var TimeStamp = [String: Double]()
    
    var Barname = String()
    
    var KellnerID = String()
    
    // OUTLETS
    
    @IBOutlet weak var bestellungenTV: UITableView!
    
    @IBOutlet weak var barnameLbl: LabelWhiteS16!
    
    @IBOutlet weak var logoutBtn: UIButton!
    
    
    
    // ACTIONS
    
        @IBAction func kellnerLogOutTapped(_ sender: Any) {
    
                if Auth.auth().currentUser != nil {
                    do {
                        try Auth.auth().signOut()
                        performSegue(withIdentifier: "kellnerLoggedOut", sender: self)
    
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
            }
    
    // FUNCS
    
    func loadBestellungenKeys(){
        var datref: DatabaseReference!
        datref = Database.database().reference()
        datref.child("userBestellungen").child(KellnerID).observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let bestellungInfos = BestellungInfos(dictionary: dictionary)
                if bestellungInfos.Status == "versendet" {
                    self.loadBestellungen(BestellungID: snapshot.key)
                    
                }
            }
            
        }, withCancel: nil)
        
    }
    
    func loadBestellungen(BestellungID: String){
        print(Barname, "kvc")
        self.bestellungIDs.append(BestellungID)
        
        var datref: DatabaseReference!
        datref = Database.database().reference()
        
        
        datref.child("Bestellungen").child(Barname).child(BestellungID).observeSingleEvent(of: .value) { (snapshot) in
            
            for key in (snapshot.children.allObjects as? [DataSnapshot])! {
                if key.key == "Information" {
                    if let dictionary = key.value as? [String: AnyObject]{
                        
                        let bestellungInfos = BestellungInfos(dictionary: dictionary)
                        self.Tischnummer.updateValue(bestellungInfos.tischnummer!, forKey: BestellungID)
                        self.Angenommen.updateValue(bestellungInfos.Status!, forKey: BestellungID)
                        self.FromUserID.updateValue(bestellungInfos.fromUserID!, forKey: BestellungID)
                        self.TimeStamp.updateValue(bestellungInfos.timeStamp!, forKey: BestellungID)
                        
                    }
                    
                } else {
                    let childsnapshotUnterkategorie = snapshot.childSnapshot(forPath: key.key)
                    if self.BestellungKategorien[BestellungID] != nil {
                        self.BestellungKategorien[BestellungID]?.append(key.key)
                        for children in (childsnapshotUnterkategorie.children.allObjects as? [DataSnapshot])! {
                            
                            let childsnapshotItem = childsnapshotUnterkategorie.childSnapshot(forPath: children.key)
                            
                            var x = self.BestellungUnterkategorien[BestellungID]
                            var expandend2 = self.BestellungExpanded2[BestellungID]
                            if x!.count < (self.BestellungKategorien[BestellungID]?.count)!{
                                print(1)
                                x!.append([children.key])
                                expandend2!.append([true])
                                self.BestellungUnterkategorien.updateValue(x!, forKey: BestellungID)
                                self.BestellungExpanded2.updateValue(expandend2!, forKey: BestellungID)
                                
                                if let dictionary = childsnapshotItem.value as? [String: AnyObject]{
                                    
                                    for Item in dictionary {
                                        
                                        if let itemDic = Item.value as? [String: AnyObject]{
                                            let iteminfodic = BestellungInfos(dictionary: itemDic)
                                            var newItems = self.BestellungItemsNamen[BestellungID]
                                            var newPreise = self.BestellungItemsPreise[BestellungID]
                                            var newMengen = self.BestellungItemsMengen[BestellungID]

                                            if (newItems?.count)! < (self.BestellungKategorien[BestellungID]?.count)! {
                                                newItems?.append([[iteminfodic.itemName!]])
                                                newPreise?.append([[Double(iteminfodic.itemPreis!)]])
                                                newMengen?.append([[Int(iteminfodic.itemMenge!)]])
                                                self.BestellungItemsNamen[BestellungID] = newItems
                                                self.BestellungItemsPreise[BestellungID] = newPreise
                                                self.BestellungItemsMengen[BestellungID] = newMengen
                                            } else {
                                                var newnewItem = newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                var newnewPreise = newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                var newnewMengen = newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                let newx = x![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                
                                                newnewItem[newx.index(of: children.key)!].append(iteminfodic.itemName!)
                                                newnewPreise[newx.index(of: children.key)!].append(Double(iteminfodic.itemPreis!))
                                                newnewMengen[newx.index(of: children.key)!].append(iteminfodic.itemMenge!)
                                                
                                                newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewItem
                                                newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreise
                                                newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewMengen
                                                
                                                
                                                self.BestellungItemsNamen[BestellungID] = newItems
                                                self.BestellungItemsPreise[BestellungID] = newPreise
                                                self.BestellungItemsMengen[BestellungID] = newMengen
                                                
                                                
                                            }      }  }     } }
                            else {
                                x![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!].append(children.key)
                                expandend2![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!].append(true)
                                self.BestellungUnterkategorien.updateValue(x!, forKey: BestellungID)
                                self.BestellungExpanded2.updateValue(expandend2!, forKey: BestellungID)
                                
                                if let dictionary = childsnapshotItem.value as? [String: AnyObject]{
                                    
                                    for Item in dictionary {
                                        
                                        if let itemDic = Item.value as? [String: AnyObject]{
                                            let iteminfodic = BestellungInfos(dictionary: itemDic)
                                            var newItems = self.BestellungItemsNamen[BestellungID]
                                            var newPreise = self.BestellungItemsPreise[BestellungID]
                                            var newMengen = self.BestellungItemsMengen[BestellungID]
                                            
                                            var newnewItem = newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                            var newnewPreise = newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                            var newnewMengen = newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                            
                                            let newx = x![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                            
                                            if newnewItem.count < newx.count {
                                                newnewItem.append([iteminfodic.itemName!])
                                                newnewPreise.append([Double(iteminfodic.itemPreis!)])
                                                newnewMengen.append([iteminfodic.itemMenge!])
                                                
                                                newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewItem
                                                newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreise
                                                newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewMengen
                                                
                                                self.BestellungItemsNamen[BestellungID] = newItems
                                                self.BestellungItemsPreise[BestellungID] = newPreise
                                                self.BestellungItemsMengen[BestellungID] = newMengen
                                                
                                            }
                                            else {

                                                newnewItem[newx.index(of: children.key)!].append(iteminfodic.itemName!)
                                                newnewPreise[newx.index(of: children.key)!].append(Double(iteminfodic.itemPreis!))
                                                newnewMengen[newx.index(of: children.key)!].append(iteminfodic.itemMenge!)

                                                newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewItem
                                                newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreise
                                                newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewMengen
                                                
                                                self.BestellungItemsNamen[BestellungID] = newItems
                                                self.BestellungItemsPreise[BestellungID] = newPreise
                                                self.BestellungItemsMengen[BestellungID] = newMengen
                                            }
                                            
//                                            newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewItem
//                                            newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreise
//                                            newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewMengen
//
//                                            self.BestellungItemsNamen[BestellungID] = newItems
//                                            self.BestellungItemsPreise[BestellungID] = newPreise
//                                            self.BestellungItemsMengen[BestellungID] = newMengen
                                        }      }       }
                                
                                
                                
                                
                            }  }} else {
                        
                        self.BestellungKategorien.updateValue([key.key], forKey: BestellungID)
                        
                        for children in (childsnapshotUnterkategorie.children.allObjects as? [DataSnapshot])! {
                            
                            let childsnapshotItem = childsnapshotUnterkategorie.childSnapshot(forPath: children.key)
                            
                            if self.BestellungUnterkategorien[BestellungID] != nil {
                                
                                var x = self.BestellungUnterkategorien[BestellungID]
                                var expanded2 = self.BestellungExpanded2[BestellungID]
                                
                                
                                x![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!].append(children.key)
                                expanded2![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!].append(true)
                                
                                self.BestellungUnterkategorien.updateValue(x!, forKey: BestellungID)
                                self.BestellungExpanded2.updateValue(expanded2!, forKey: BestellungID)
                                
                                
                                if let dictionary = childsnapshotItem.value as? [String: AnyObject]{
                                    
                                    for Item in dictionary {
                                        
                                        if let itemDic = Item.value as? [String: AnyObject]{
                                            let iteminfodic = BestellungInfos(dictionary: itemDic)
                                            if self.BestellungItemsNamen[BestellungID] != nil {
                                                var newItems = self.BestellungItemsNamen[BestellungID]
                                                var newPreise = self.BestellungItemsPreise[BestellungID]
                                                var newMengen = self.BestellungItemsMengen[BestellungID]
                                                
                                                var newnewItems = newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                var newnewPreise = newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                var newnewMengen = newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                
                                                let newx = x![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                
                                                if newnewItems.count < newx.count {
                                                    
                                                    newnewItems.append([iteminfodic.itemName!])
                                                    newnewPreise.append([Double(iteminfodic.itemPreis!)])
                                                    newnewMengen.append([iteminfodic.itemMenge!])
                                                    
                                                    newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewItems
                                                    newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreise
                                                    newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewMengen
                                                    
                                                    self.BestellungItemsNamen[BestellungID] = newItems
                                                    self.BestellungItemsPreise[BestellungID] = newPreise
                                                    self.BestellungItemsMengen[BestellungID] = newMengen
                                                    
                                                    
                                                } else {
                                                    newnewItems[newx.index(of: children.key)!].append(iteminfodic.itemName!)
                                                    newnewPreise[newx.index(of: children.key)!].append(Double(iteminfodic.itemPreis!))
                                                    newnewMengen[newx.index(of: children.key)!].append(iteminfodic.itemMenge!)
                                                    
                                                    newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewItems
                                                    newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreise
                                                    newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewMengen
                                                    
                                                    self.BestellungItemsNamen[BestellungID] = newItems
                                                    self.BestellungItemsPreise[BestellungID] = newPreise
                                                    self.BestellungItemsMengen[BestellungID] = newMengen
                                                    
                                                }
                                            }
                                            
                                        }
                                    }
                                }
                            }
                                
                                
                                
                            else {
                                self.BestellungUnterkategorien.updateValue([[children.key]], forKey: BestellungID)
                                self.BestellungExpanded2.updateValue([[true]], forKey: BestellungID)
                                
                                if let dictionary = childsnapshotItem.value as? [String: AnyObject]{
                                    
                                    for Item in dictionary {
                                        if let itemDic = Item.value as? [String: AnyObject]{
                                            let iteminfodic = BestellungInfos(dictionary: itemDic)
                                            if self.BestellungItemsNamen[BestellungID] != nil {
                                                
                                                var newItems = self.BestellungItemsNamen[BestellungID]
                                                var newPreise = self.BestellungItemsPreise[BestellungID]
                                                var newMengen = self.BestellungItemsMengen[BestellungID]
                                                
                                                var newnewItems = newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                var newnewPreise = newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                var newnewMengen = newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                
                                                newnewItems[(self.BestellungUnterkategorien[BestellungID]?.index(of: [children.key]))!].append(iteminfodic.itemName!)
                                                newnewPreise[(self.BestellungUnterkategorien[BestellungID]?.index(of: [children.key]))!].append(Double(iteminfodic.itemPreis!))
                                                newnewMengen[(self.BestellungUnterkategorien[BestellungID]?.index(of: [children.key]))!].append(iteminfodic.itemMenge!)
                                                
                                                newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewItems
                                                newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreise
                                                newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewMengen
                                                
                                                self.BestellungItemsNamen[BestellungID] = newItems
                                                self.BestellungItemsPreise[BestellungID] = newPreise
                                                self.BestellungItemsMengen[BestellungID] = newMengen
                                                
                                                
                                            } else {
                                                
                                                self.BestellungItemsNamen.updateValue([[[iteminfodic.itemName!]]], forKey: BestellungID)
                                                self.BestellungItemsPreise.updateValue([[[Double(iteminfodic.itemPreis!)]]], forKey: BestellungID)
                                                self.BestellungItemsMengen.updateValue([[[iteminfodic.itemMenge!]]], forKey: BestellungID)
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                            }
                            
                            
                        }
                    }
                    
                    
                }
            }
            print(self.bestellungIDs, "self.bestellungIDs")
            print(self.BestellungKategorien, "self.BestellungKategorien")

            
            if self.bestellungIDs.count == self.BestellungKategorien.count {
                
                for i in 0..<self.bestellungIDs.count {
                    self.setSectionsKellnerBestellung(BestellungID: self.bestellungIDs[i], tischnummer: self.Tischnummer[self.bestellungIDs[i]]!, TimeStamp: self.TimeStamp[self.bestellungIDs[i]]!, Kategorie: self.BestellungKategorien[self.bestellungIDs[i]]!, Unterkategorie: self.BestellungUnterkategorien[self.bestellungIDs[i]]!, items: self.BestellungItemsNamen[self.bestellungIDs[i]]!, preis: self.BestellungItemsPreise[self.bestellungIDs[i]]!, liter: [[["String"]]], menge: self.BestellungItemsMengen[self.bestellungIDs[i]]!, expanded2: self.BestellungExpanded2[self.bestellungIDs[i]]!, expanded: false)
                    if self.Bestellungen.count == self.bestellungIDs.count{
                        self.bestellungenTV.reloadData()
                    }
                    
                }
            }
            
        }
        
    }
    
    
    func setSectionsKellnerBestellung(BestellungID: String, tischnummer: String, TimeStamp: Double, Kategorie: [String], Unterkategorie: [[String]], items: [[[String]]], preis: [[[Double]]], liter: [[[String]]], menge: [[[Int]]], expanded2: [[Bool]], expanded: Bool){
        self.Bestellungen.append(KellnerTVSection(BestellungID: BestellungID, tischnummer: tischnummer, timeStamp: TimeStamp, Kategorie: Kategorie, Unterkategorie: Unterkategorie, items: items, preis: preis, liter: liter, menge: menge, expanded2: expanded2, expanded: expanded))
        print(Bestellungen)
        
        
    }
    
    
        func removeBestellung(KellnerID: String, BestellungID: String){
            var datref: DatabaseReference!
            datref = Database.database().reference()
            print(BestellungID, "BestellungIDBestellungIDBestellungID")
            datref.child("Bestellungen").child(Barname).child(BestellungID).child("Information").updateChildValues(["Status": "angenommen"])
            datref.child("userBestellungen").child(KellnerID).child(BestellungID).updateChildValues(["Status": "angenommen"])

        }
    
//     SWIPE ACTIONS
    
        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let delete = deleteAction(at: indexPath)
    
            return UISwipeActionsConfiguration(actions: [delete])
        }
    
        func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
            let action = UIContextualAction(style: .normal, title: "Problem") { (action, view, completion) in
                completion(true)
                
                
                
        
            }
            return action
        }
    
    
    
    
        func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let annehmen = annehmenAction(at: indexPath)
            annehmen.backgroundColor = UIColor.green
    
    
            return UISwipeActionsConfiguration(actions: [annehmen])
        }
    
    func annehmen(sender: KellnerCell) {
        self.removeBestellung(KellnerID: self.KellnerID, BestellungID:
            self.Bestellungen[sender.Cell1Section].BestellungID)
        print("wjqwlqfwweqd")
        self.reload()
    }
    
        func annehmenAction(at indexPath: IndexPath) -> UIContextualAction {
            let action = UIContextualAction(style: .destructive, title: "annehmen") { (action, view, completion) in
                completion(true)
    
                self.removeBestellung(KellnerID: self.KellnerID, BestellungID:
                self.Bestellungen[indexPath.section].BestellungID)
                self.reload()
    
            }
    
            return action
        }
    
    // TABLE
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print(self.Bestellungen, "bestellungen")
        return self.Bestellungen.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var heightForHeaderInSection: Int?
        
        heightForHeaderInSection = 36
        return CGFloat(heightForHeaderInSection!)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        

        if (Bestellungen[indexPath.section].expanded) {
            let kategorieCount = Bestellungen[indexPath.section].Kategorie.count
            var UnterkategorieCount = 0
            var itemsCount = 0
            for items in  Bestellungen[indexPath.section].items {
                for item in items {
                    itemsCount = itemsCount + item.count
                }
            }
            for unterkategorie in Bestellungen[indexPath.section].Unterkategorie {
                    UnterkategorieCount = UnterkategorieCount + unterkategorie.count
                
            }
            print(itemsCount, "itemscount")
            print(kategorieCount, "kategorieCount")
            print(UnterkategorieCount, "UnterkategorieCount")
            return CGFloat(kategorieCount*40 + UnterkategorieCount*50 + itemsCount*46+50)

            
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
        header.contentView.layer.cornerRadius = 10
        header.contentView.layer.backgroundColor = UIColor.clear.cgColor
        header.layer.cornerRadius = 10
        header.layer.backgroundColor = UIColor.clear.cgColor
        
        header.customInit(tableView: tableView, title: Bestellungen[section].Tischnummer, section: section, delegate: self as ExpandableHeaderViewDelegate)
        return header
    }
    
    
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //
    //print(self.Bestellungen)
    //
    //        return self.Bestellungen.count
    //
    //    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //
        let cell = Bundle.main.loadNibNamed("KellnerCell", owner: self, options: nil)?.first as! KellnerCell
        
        cell.Bestellungen = Bestellungen
        cell.Cell1Section = indexPath.section
        cell.bestellungID = Bestellungen[indexPath.section].BestellungID
        cell.delegate = self
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let DayOne = formatter.date(from: "2018/05/15 12:00")
        let timeStampDate = NSDate(timeInterval: self.Bestellungen[indexPath.section].TimeStamp, since: DayOne!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        cell.timeLbl.text = "\(dateFormatter.string(from: timeStampDate as Date)) Uhr"
        
        if Bestellungen[indexPath.section].expanded == false {
            cell.timeLbl.isHidden = true
        } else {
            cell.timeLbl.isHidden = false
        }
        
        //
        
        //        self.itemssss = bestellung2[bestellungIDs[indexPath.row]]!
        //
        //
        //        for (genre, bestellteitems) in itemssss {
        //
        //            cellGenres.append(genre)
        //
        //            for (item, menge) in bestellteitems {
        //
        //                cellItems.append(item)
        //                cellMengen.append(menge)
        //
        //            }
        //
        //        }
        //
        //        cellGenres.removeAll()
        //        cellItems.removeAll()
        //        cellMengen.removeAll()
        //
        //        cell.bestellungsText.text = "\(itemssss)"
        //
        //        let timeStampDate = NSDate(timeIntervalSince1970: TimeStamps[indexPath.row])
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "HH:mm"
        //        cell.timeLbl.text = "\(dateFormatter.string(from: timeStampDate as Date)) Uhr"
        //        cell.tischnummer.text = "Tischnummer: \(self.tischnummer[indexPath.row])"
        //
        return cell
        
    }
    
    
    func toggleSection(tableView: UITableView, header: ExpandableHeaderView, section: Int) {
        bestellungenTV.beginUpdates()

        for i in 0..<Bestellungen.count{
            if i == section {
                Bestellungen[section].expanded = !Bestellungen[section].expanded
                
            } else {
                Bestellungen[i].expanded = false
                
            }
        }
        
        
        bestellungenTV.reloadRows(at: [IndexPath(row: 0, section: section)], with: .automatic)
        
        bestellungenTV.endUpdates()
    }
    
    
    
    // OTHERS
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        bestellungenTV.estimatedRowHeight = 100
    //        bestellungenTV.rowHeight = UITableViewAutomaticDimension
    //    }
    
    
    func reload(){
         Bestellungen.removeAll()
         bestellungIDs.removeAll()
         BestellungKategorien.removeAll()
         BestellungUnterkategorien.removeAll()
         BestellungExpanded2.removeAll()
         BestellungItemsNamen.removeAll()
         BestellungItemsPreise.removeAll()
         BestellungItemsMengen.removeAll()
         Tischnummer.removeAll()
         Angenommen.removeAll()
         FromUserID.removeAll()
         TimeStamp.removeAll()
        loadBestellungenKeys()
        self.bestellungenTV.reloadData()


    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        barnameLbl.text = Barname
        
        loadBestellungenKeys()
        
                logoutBtn.layer.cornerRadius = 4
                let refreshControl = UIRefreshControl()
                let title = NSLocalizedString("aktualisiere", comment: "Pull to refresh")
                refreshControl.attributedTitle = NSAttributedString(string: title)
                refreshControl.addTarget(self, action: #selector(refreshOptions(sender:)), for: .valueChanged)
                bestellungenTV.refreshControl = refreshControl
        
        
    }
    
    @objc private func refreshOptions(sender: UIRefreshControl) {
            reload()
                sender.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}



