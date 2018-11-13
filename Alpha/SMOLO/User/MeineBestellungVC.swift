//
//  MeineBestellungVC.swift
//  SMOLO
//
//  Created by Ibrahim Akcam on 19.03.18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit
import Firebase


class MeineBestellungVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ExpandableHeaderViewDelegate, kellnerCellDelegate{
    func bewerten(sender: KellnerCell) {
        print("esfdedasxy")
        
        print(aktuelleBar, "difji")
        let bewertvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BewertungVC") as! BewertungVC
        bewertvc.bestelltebar = aktuelleBar
        performSegue(withIdentifier: "BewertungVC", sender: self)
        
    }
     func prepare(for segue: UIStoryboardSegue, sender: KellnerCell) {
        if segue.identifier == "BewertungVC"{
            let vc = segue.destination as! BewertungVC
           vc.bestelltebar = aktuelleBar
            print(aktuelleBar, "difji")
        }
    }
    
    func toggleSection(tableView: UITableView, header: ExpandableHeaderView, section: Int) {
        
    }
    
    
    // VARS
    var delegate: kellnerCellDelegate?
    var aktuelleBar = String()
    var aktuellerTisch = String()
    var letzteBestellungZeit = Double()
    var userUid = String()
    
    var Bestellungen = [KellnerTVSection]()
    var bestellungIDs = [String]()
    var BestellungKategorien = [String: [String]]()
    var BestellungUnterkategorien = [String: [[String]]]()
    var BestellungExpanded2 = [String: [[Bool]]]()
    var Status = [String: String]()
    
    var BestellungItemsNamen = [String: [[[String]]]]()
    var BestellungItemsPreise = [String: [[[Double]]]]()
    var BestellungItemKommentar = [String: [[[String]]]]()
    var BestellungItemsMengen = [String: [[[Int]]]]()
    var BestellungItemsKommentar = [String: [[[String]]]]()
    var BestellungItemsLiter = [String: [[[String]]]]()
    var BestellungenItemsExtrasNamen = [String: [[[[String]]]]]()
    var BestellungenItemsExtrasPreise = [String: [[[[Double]]]]]()
    var Tischnummer = [String: String]()
    var Angenommen = [String: String]()
    var FromUserID = [String: String]()
    var TimeStamp = [String: Double]()
    var extrasString = [String]()
    var extrasPreis = [Double]()
    
    var KellnerID = String()


    // OUTLETS
    
    @IBOutlet weak var meineBestellungTV: UITableView!
    @IBOutlet weak var Bewerten: UIButton!
    
    
    // ACTIONS
    
  
    

    func loadAktuelleBar(){
        var datref: DatabaseReference!
        datref = Database.database().reference()
        datref.child("Users").child(userUid).observeSingleEvent(of: .value, with: { (snapshotAktuell) in
            print(snapshotAktuell, "aktuell")
            if let dictionary = snapshotAktuell.value as? [String: AnyObject]{
                let userinfos = UserInfos(dictionary: dictionary)
                print(self.aktuelleBar)
                print(userinfos.aktuelleBar!)
                print("jetzt")
                self.aktuelleBar = userinfos.aktuelleBar!
                print(self.aktuelleBar)
                print(userinfos.aktuelleBar!)
                self.aktuellerTisch = userinfos.aktuellerTisch!
                self.letzteBestellungZeit = userinfos.letzteBestellungZeit!
                self.loadBestellungenKeys(userUid: self.userUid)

            }
        }, withCancel: nil)
    }
    
    
    func loadBestellungenKeys(userUid: String){
        var datref: DatabaseReference!
        datref = Database.database().reference()
        datref.child("userBestellungen").child(userUid).observe(.childAdded, with: { (snapshot) in

            if let dictionary = snapshot.value as? [String: AnyObject]{
                let bestellungInfos = BestellungInfos(dictionary: dictionary)
                print(snapshot.value, "jsdfkjsdkklsdfds")
                print(snapshot.key, "jsdfkjsdkklsdfds")

                if bestellungInfos.Status == "versendet" {
                    print("jhgewfew1")
                    self.bestellungIDs.append(snapshot.key)
                    self.loadBestellungen(BestellungID: snapshot.key)
                }
            }
        }, withCancel: nil)

    }
    
    func loadBestellungen(BestellungID: String){
        var datref: DatabaseReference!
        datref = Database.database().reference()
        datref.child("Bestellungen").child(aktuelleBar).child(BestellungID).observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot)

        for key in (snapshot.children.allObjects as? [DataSnapshot])! {
            if key.key == "Information" {
                print("jhgewfew2")

                if let dictionary = key.value as? [String: AnyObject]{
                    
                    let bestellungInfos = BestellungInfos(dictionary: dictionary)
                    self.Tischnummer.updateValue(bestellungInfos.tischnummer!, forKey: BestellungID)
                    self.Status.updateValue(bestellungInfos.Status!, forKey: BestellungID)
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
                                        var newKommentare = self.BestellungItemsKommentar[BestellungID]
                                        var newLiters = self.BestellungItemsLiter[BestellungID]
                                        
                                        
                                        if (newItems?.count)! < (self.BestellungKategorien[BestellungID]?.count)! {
                                            newItems?.append([[iteminfodic.itemName!]])
                                            newPreise?.append([[Double(iteminfodic.itemPreis!)]])
                                            newMengen?.append([[Int(iteminfodic.itemMenge!)]])
                                            newKommentare?.append([[iteminfodic.itemKommentar!]])
                                            newLiters?.append([[iteminfodic.itemLiter!]])
                                            self.BestellungItemsNamen[BestellungID] = newItems
                                            self.BestellungItemsPreise[BestellungID] = newPreise
                                            self.BestellungItemsMengen[BestellungID] = newMengen
                                            self.BestellungItemsKommentar[BestellungID] = newKommentare
                                            self.BestellungItemsLiter[BestellungID] = newLiters
                                        } else {
                                            var newnewItem = newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                            var newnewPreise = newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                            var newnewMengen = newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                            var newnewKommentare = newKommentare![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                            var newnewLiters = newLiters![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                            let newx = x![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                            
                                            newnewItem[newx.index(of: children.key)!].append(iteminfodic.itemName!)
                                            newnewPreise[newx.index(of: children.key)!].append(Double(iteminfodic.itemPreis!))
                                            newnewMengen[newx.index(of: children.key)!].append(iteminfodic.itemMenge!)
                                            newnewKommentare[newx.index(of: children.key)!].append(iteminfodic.itemKommentar!)
                                            newnewLiters[newx.index(of: children.key)!].append(iteminfodic.itemLiter!)
                                            
                                            
                                            newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewItem
                                            newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreise
                                            newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewMengen
                                            newKommentare![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewKommentare
                                            newLiters![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewLiters
                                            
                                            
                                            self.BestellungItemsNamen[BestellungID] = newItems
                                            self.BestellungItemsPreise[BestellungID] = newPreise
                                            self.BestellungItemsMengen[BestellungID] = newMengen
                                            self.BestellungItemsKommentar[BestellungID] = newKommentare
                                            self.BestellungItemsLiter[BestellungID] = newLiters
                                            
                                            
                                            
                                            
                                        }      }  }
                                for Itemssnap in (childsnapshotItem.children.allObjects as? [DataSnapshot])! {
                                            let childsnapshotExtras = childsnapshotItem.childSnapshot(forPath: Itemssnap.key)
                                            for extras in (childsnapshotExtras.children.allObjects as? [DataSnapshot])! {
                                                let extrasSnap = childsnapshotExtras.childSnapshot(forPath: extras.key)
                                                if extrasSnap.key == "Extras" {
                                                    let childsnapshotExtra = childsnapshotExtras.childSnapshot(forPath: extrasSnap.key)
                                                    for extra in (childsnapshotExtra.children.allObjects as? [DataSnapshot])! {
                                                        if let dictionary = extra.value as? [String: AnyObject]{
                                                            let extraInfo = BestellungInfos(dictionary: dictionary)
                                                            var newExtras = self.BestellungenItemsExtrasNamen[BestellungID]
                                                            self.extrasString.append(extraInfo.itemName!)
                                                            var newPreis = self.BestellungenItemsExtrasPreise[BestellungID]
                                                            self.extrasPreis.append(extraInfo.itemPreis!)
                                                            if (newExtras?.count)! < (self.BestellungKategorien[BestellungID]?.count)! {
                                                                if self.extrasString.count == extrasSnap.childrenCount && self.extrasPreis.count == extrasSnap.childrenCount{
                                                                    newExtras?.append([[self.extrasString]])
                                                                    self.BestellungenItemsExtrasNamen[BestellungID] = newExtras
                                                                    self.extrasString.removeAll()
                                                                    newPreis?.append([[self.extrasPreis]])
                                                                    self.BestellungenItemsExtrasPreise[BestellungID] = newPreis
                                                                    self.extrasPreis.removeAll()
                                                                    
                                                                }
                                                                
                                                            } else {
                                                                var newnewExtras = newExtras![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                                var newnewPreis = newPreis![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                                
                                                                if self.extrasString.count == extrasSnap.childrenCount && self.extrasPreis.count == extrasSnap.childrenCount {
                                                                    let newx = x![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                                    newnewExtras[newx.index(of: children.key)!].append(self.extrasString)
                                                                    newnewPreis[newx.index(of: children.key)!].append(self.extrasPreis)
                                                                    newExtras![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewExtras
                                                                    newPreis![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreis
                                                                    self.BestellungenItemsExtrasPreise[BestellungID] = newPreis
                                                                    self.BestellungenItemsExtrasNamen[BestellungID] = newExtras
                                                                    newnewPreis[newx.index(of: children.key)!].append(self.extrasPreis)
                                                                    newnewExtras[newx.index(of: children.key)!].append(self.extrasString)
                                                                    newExtras![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewExtras
                                                                    newPreis![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreis
                                                                    self.BestellungenItemsExtrasPreise[BestellungID] = newPreis
                                                                    self.BestellungenItemsExtrasNamen[BestellungID] = newExtras
                                                                    self.extrasString.removeAll()
                                                                    self.extrasPreis.removeAll()
                                                                    
                                                                }}}}}}} } }
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
                                        var newKommentare = self.BestellungItemsKommentar[BestellungID]
                                        var newLiter = self.BestellungItemsLiter[BestellungID]
                                        
                                        
                                        var newnewItem = newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                        var newnewPreise = newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                        var newnewMengen = newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                        var newnewKommentare = newKommentare![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                        var newnewLiters = newLiter![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                        
                                        
                                        let newx = x![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                        
                                        if newnewItem.count < newx.count {
                                            newnewItem.append([iteminfodic.itemName!])
                                            newnewPreise.append([Double(iteminfodic.itemPreis!)])
                                            newnewMengen.append([iteminfodic.itemMenge!])
                                            newnewKommentare.append([iteminfodic.itemKommentar!])
                                            newnewLiters.append([iteminfodic.itemLiter!])
                                            
                                            
                                            newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewItem
                                            newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreise
                                            newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewMengen
                                            newKommentare![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewKommentare
                                            newLiter![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewLiters
                                            
                                            
                                            self.BestellungItemsNamen[BestellungID] = newItems
                                            self.BestellungItemsPreise[BestellungID] = newPreise
                                            self.BestellungItemsMengen[BestellungID] = newMengen
                                            self.BestellungItemsKommentar[BestellungID] = newKommentare
                                            self.BestellungItemsLiter[BestellungID] = newLiter
                                            
                                            
                                        }
                                        else {
                                            
                                            newnewItem[newx.index(of: children.key)!].append(iteminfodic.itemName!)
                                            newnewPreise[newx.index(of: children.key)!].append(Double(iteminfodic.itemPreis!))
                                            newnewMengen[newx.index(of: children.key)!].append(iteminfodic.itemMenge!)
                                            newnewKommentare[newx.index(of: children.key)!].append(iteminfodic.itemKommentar!)
                                            newnewLiters[newx.index(of: children.key)!].append(iteminfodic.itemLiter!)
                                            
                                            newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewItem
                                            newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreise
                                            newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewMengen
                                            newKommentare![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewKommentare
                                            newLiter![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewLiters
                                            
                                            
                                            self.BestellungItemsNamen[BestellungID] = newItems
                                            self.BestellungItemsPreise[BestellungID] = newPreise
                                            self.BestellungItemsMengen[BestellungID] = newMengen
                                            self.BestellungItemsKommentar[BestellungID] = newKommentare
                                            self.BestellungItemsLiter[BestellungID] = newLiter
                                            
                                            
                                        }
                                        
                                    }      }       }
                            
                            for Itemssnap in (childsnapshotItem.children.allObjects as? [DataSnapshot])! {
                                let childsnapshotExtras = childsnapshotItem.childSnapshot(forPath: Itemssnap.key)
                                for extras in (childsnapshotExtras.children.allObjects as? [DataSnapshot])! {
                                    let extrasSnap = childsnapshotExtras.childSnapshot(forPath: extras.key)
                                    if extrasSnap.key == "Extras" {
                                        let childsnapshotExtra = childsnapshotExtras.childSnapshot(forPath: extrasSnap.key)
                                        for extra in (childsnapshotExtra.children.allObjects as? [DataSnapshot])! {
                                            if let dictionary = extra.value as? [String: AnyObject]{
                                                let extraInfo = BestellungInfos(dictionary: dictionary)
                                                var newExtras = self.BestellungenItemsExtrasNamen[BestellungID]
                                                var newnewExtras = newExtras![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                var newPreis = self.BestellungenItemsExtrasPreise[BestellungID]
                                                var newnewPreis = newPreis![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                let newx = x![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                if newnewExtras.count  < newx.count{
                                                    self.extrasString.append(extraInfo.itemName!)
                                                    newnewExtras.append([self.extrasString])
                                                    newExtras![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewExtras
                                                    self.BestellungenItemsExtrasNamen[BestellungID] = newExtras
                                                    self.extrasPreis.append(extraInfo.itemPreis!)
                                                    newnewPreis.append([self.extrasPreis])
                                                    newPreis![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreis
                                                    self.BestellungenItemsExtrasPreise[BestellungID] = newPreis
                                                } else {
                                                    self.extrasString.append(extraInfo.itemName!)
                                                    self.extrasPreis.append(extraInfo.itemPreis!)
                                                    if self.extrasString.count == extrasSnap.childrenCount && self.extrasPreis.count == extrasSnap.childrenCount{
                                                        newnewExtras[newx.index(of: children.key)!].append(self.extrasString)
                                                        newExtras![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewExtras
                                                        self.BestellungenItemsExtrasNamen[BestellungID] = newExtras
                                                        self.extrasString.removeAll()
                                                        newnewPreis[newx.index(of: children.key)!].append(self.extrasPreis)
                                                        newPreis![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreis
                                                        self.BestellungenItemsExtrasPreise[BestellungID] = newPreis
                                                        self.extrasPreis.removeAll()
                                                    }
                                                    
                                                }}}}}}
                            
                            
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
                                            var newKommentare = self.BestellungItemsKommentar[BestellungID]
                                            var newLiters = self.BestellungItemsLiter[BestellungID]
                                            
                                            
                                            var newnewItems = newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                            var newnewPreise = newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                            var newnewMengen = newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                            var newnewKommentare = newKommentare![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                            var newnewLiters = newLiters![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                            
                                            let newx = x![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                            
                                            if newnewItems.count < newx.count {
                                                
                                                newnewItems.append([iteminfodic.itemName!])
                                                newnewPreise.append([Double(iteminfodic.itemPreis!)])
                                                newnewMengen.append([iteminfodic.itemMenge!])
                                                newnewKommentare.append([iteminfodic.itemKommentar!])
                                                newnewLiters.append([iteminfodic.itemLiter!])
                                                
                                                
                                                newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewItems
                                                newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreise
                                                newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewMengen
                                                newKommentare![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewKommentare
                                                newLiters![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewLiters
                                                
                                                self.BestellungItemsNamen[BestellungID] = newItems
                                                self.BestellungItemsPreise[BestellungID] = newPreise
                                                self.BestellungItemsMengen[BestellungID] = newMengen
                                                self.BestellungItemsKommentar[BestellungID] = newKommentare
                                                self.BestellungItemsLiter[BestellungID] = newLiters
                                                
                                                
                                            } else {
                                                newnewItems[newx.index(of: children.key)!].append(iteminfodic.itemName!)
                                                newnewPreise[newx.index(of: children.key)!].append(Double(iteminfodic.itemPreis!))
                                                newnewMengen[newx.index(of: children.key)!].append(iteminfodic.itemMenge!)
                                                newnewKommentare[newx.index(of: children.key)!].append(iteminfodic.itemKommentar!)
                                                newnewLiters[newx.index(of: children.key)!].append(iteminfodic.itemLiter!)
                                                
                                                
                                                newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewItems
                                                newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreise
                                                newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewMengen
                                                newKommentare![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewKommentare
                                                newLiters![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewLiters
                                                
                                                self.BestellungItemsNamen[BestellungID] = newItems
                                                self.BestellungItemsPreise[BestellungID] = newPreise
                                                self.BestellungItemsMengen[BestellungID] = newMengen
                                                self.BestellungItemsKommentar[BestellungID] = newKommentare
                                                self.BestellungItemsLiter[BestellungID] = newLiters
                                                
                                                
                                            }
                                        }
                                        
                                    }
                                }
                            }
                            for Itemssnap in (childsnapshotItem.children.allObjects as? [DataSnapshot])! {
                                let childsnapshotExtras = childsnapshotItem.childSnapshot(forPath: Itemssnap.key)
                                for extras in (childsnapshotExtras.children.allObjects as? [DataSnapshot])! {
                                    let extrasSnap = childsnapshotExtras.childSnapshot(forPath: extras.key)
                                    if extrasSnap.key == "Extras" {
                                        let childsnapshotExtra = childsnapshotExtras.childSnapshot(forPath: extrasSnap.key)
                                        for extra in (childsnapshotExtra.children.allObjects as? [DataSnapshot])! {
                                            if let dictionary = extra.value as? [String: AnyObject]{
                                                let extraInfo = BestellungInfos(dictionary: dictionary)
                                                var newExtras = self.BestellungenItemsExtrasNamen[BestellungID]
                                                var newnewExtras = newExtras![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                var newPreis = self.BestellungenItemsExtrasPreise[BestellungID]
                                                var newnewPreis = newPreis![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                self.extrasString.append(extraInfo.itemName!)
                                                self.extrasPreis.append(extraInfo.itemPreis!)
                                                if self.extrasString.count == extrasSnap.childrenCount && self.extrasPreis.count == extrasSnap.childrenCount {
                                                    newnewExtras.append([self.extrasString])
                                                    newExtras![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewExtras
                                                    self.BestellungenItemsExtrasNamen[BestellungID] = newExtras
                                                    self.extrasString.removeAll()
                                                    newnewPreis.append([self.extrasPreis])
                                                    newPreis![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreis
                                                    self.BestellungenItemsExtrasPreise[BestellungID] = newPreis
                                                    self.extrasPreis.removeAll()
                                                }
                                                
                                            }}}}}
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
                                            var newKommentare = self.BestellungItemsKommentar[BestellungID]
                                            var newLiters = self.BestellungItemsLiter[BestellungID]
                                            
                                            var newnewItems = newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                            var newnewPreise = newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                            var newnewMengen = newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                            var newnewKommentare = newKommentare![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                            var newnewLiters = newLiters![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                            
                                            newnewItems[(self.BestellungUnterkategorien[BestellungID]?.index(of: [children.key]))!].append(iteminfodic.itemName!)
                                            newnewPreise[(self.BestellungUnterkategorien[BestellungID]?.index(of: [children.key]))!].append(Double(iteminfodic.itemPreis!))
                                            newnewMengen[(self.BestellungUnterkategorien[BestellungID]?.index(of: [children.key]))!].append(iteminfodic.itemMenge!)
                                            newnewKommentare[(self.BestellungUnterkategorien[BestellungID]?.index(of: [children.key]))!].append(iteminfodic.itemKommentar!)
                                            newnewLiters[(self.BestellungUnterkategorien[BestellungID]?.index(of: [children.key]))!].append(iteminfodic.itemLiter!)
                                            
                                            newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewItems
                                            newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreise
                                            newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewMengen
                                            newKommentare![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewKommentare
                                            newLiters![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewLiters
                                            
                                            self.BestellungItemsNamen[BestellungID] = newItems
                                            self.BestellungItemsPreise[BestellungID] = newPreise
                                            self.BestellungItemsMengen[BestellungID] = newMengen
                                            self.BestellungItemsKommentar[BestellungID] = newKommentare
                                            self.BestellungItemsLiter[BestellungID] = newLiters
                                            
                                            
                                            
                                        } else {
                                            
                                            self.BestellungItemsNamen.updateValue([[[iteminfodic.itemName!]]], forKey: BestellungID)
                                            self.BestellungItemsPreise.updateValue([[[Double(iteminfodic.itemPreis!)]]], forKey: BestellungID)
                                            self.BestellungItemsMengen.updateValue([[[iteminfodic.itemMenge!]]], forKey: BestellungID)
                                            self.BestellungItemsKommentar.updateValue([[[iteminfodic.itemKommentar!]]], forKey: BestellungID)
                                            self.BestellungItemsLiter.updateValue([[[iteminfodic.itemLiter!]]], forKey: BestellungID)
                                            
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                                for Itemssnap in (childsnapshotItem.children.allObjects as? [DataSnapshot])! {
                                    let childsnapshotExtras = childsnapshotItem.childSnapshot(forPath: Itemssnap.key)
                                    for extras in (childsnapshotExtras.children.allObjects as? [DataSnapshot])! {
                                        let extrasSnap = childsnapshotExtras.childSnapshot(forPath: extras.key)
                                        if extrasSnap.key == "Extras" {
                                            let childsnapshotExtra = childsnapshotExtras.childSnapshot(forPath: extrasSnap.key)
                                            for extra in (childsnapshotExtra.children.allObjects as? [DataSnapshot])! {
                                                if let dictionary = extra.value as? [String: AnyObject]{
                                                    let extraInfo = BestellungInfos(dictionary: dictionary)
                                                    
                                                    if self.BestellungenItemsExtrasNamen[BestellungID] != nil {
                                                        var newExtras = self.BestellungenItemsExtrasNamen[BestellungID]
                                                        var newnewExtras = newExtras![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                        self.extrasString.append(extraInfo.itemName!)
                                                        var newPreis = self.BestellungenItemsExtrasPreise[BestellungID]
                                                        var newnewPreis = newPreis![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                        self.extrasPreis.append(extraInfo.itemPreis!)
                                                        
                                                        if self.extrasString.count == extrasSnap.childrenCount && self.extrasPreis.count == extrasSnap.childrenCount{
                                                            
                                                            newnewExtras[(self.BestellungUnterkategorien[BestellungID]?.index(of: [children.key]))!].insert(self.extrasString, at: 0)
                                                            newExtras![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewExtras
                                                            self.BestellungenItemsExtrasNamen[BestellungID] = newExtras
                                                            newnewPreis[(self.BestellungUnterkategorien[BestellungID]?.index(of: [children.key]))!].insert(self.extrasPreis, at: 0)
                                                            newPreis![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreis
                                                            self.BestellungenItemsExtrasPreise[BestellungID] = newPreis
                                                            
                                                            self.extrasString.removeAll()
                                                            self.extrasPreis.removeAll()
                                                        }} else {
                                                        self.extrasString.append(extraInfo.itemName!)
                                                        self.extrasPreis.append(extraInfo.itemPreis!)
                                                        
                                                        if self.extrasString.count == extrasSnap.childrenCount && self.extrasPreis.count == extrasSnap.childrenCount {
                                                            self.BestellungenItemsExtrasNamen.updateValue([[[self.extrasString]]], forKey: BestellungID)
                                                            self.BestellungenItemsExtrasPreise.updateValue([[[self.extrasPreis]]], forKey: BestellungID)
                                                            self.extrasPreis.removeAll()
                                                            self.extrasString.removeAll()
                                                        }}
                                                    
                                                    
                                                }}}}}
                            }
                            
                        }
                        
                        
                    }
                }
                
                
            }
        }

            if self.bestellungIDs.count == self.BestellungKategorien.count {
                for id in self.bestellungIDs {
                    self.setSectionsKellnerBestellung(BestellungID: id, tischnummer: self.Tischnummer[id]!, fromUserID: self.FromUserID[id]!, TimeStamp: self.TimeStamp[id]!, Kategorie: self.BestellungKategorien[id]!, Unterkategorie: self.BestellungUnterkategorien[id]!, items: self.BestellungItemsNamen[id]!, preis: self.BestellungItemsPreise[id]!, liter: self.BestellungItemsLiter[id]!, extras: self.BestellungenItemsExtrasNamen[id]!, extrasPreis: self.BestellungenItemsExtrasPreise[id]!, kommentar: self.BestellungItemsKommentar[id]!, menge: self.BestellungItemsMengen[id]!, expanded2: self.BestellungExpanded2[id]!, expanded: true)
                    if self.Bestellungen.count == self.bestellungIDs.count{
                        self.meineBestellungTV.reloadData()
//                        if self.bestellungIDs.count != 0 {
//                            self.Bewerten.setTitle("Bitte bewerte deine Produkte", for: UIControlState.normal)
//                        } else{
//                            self.Bewerten.setTitle("empty", for: UIControlState.normal)
//                        }
                        
                    }
                    
                }
            }
            
        }
        
    }
    
    
    func setSectionsKellnerBestellung(BestellungID: String, tischnummer: String, fromUserID: String, TimeStamp: Double, Kategorie: [String], Unterkategorie: [[String]], items: [[[String]]], preis: [[[Double]]], liter: [[[String]]], extras: [[[[String]]]], extrasPreis: [[[[Double]]]], kommentar: [[[String]]], menge: [[[Int]]], expanded2: [[Bool]], expanded: Bool){
        self.Bestellungen.append(KellnerTVSection(BestellungID: BestellungID, tischnummer: tischnummer, fromUserID: fromUserID, timeStamp: TimeStamp, Kategorie: Kategorie, Unterkategorie: Unterkategorie, items: items, preis: preis, liter: liter, extras: extras, extrasPreis: extrasPreis, kommentar: kommentar, menge: menge, expanded2: expanded2, expanded: expanded))
        self.meineBestellungTV.reloadData()
    }
    
    
    
    // TABLE
    func numberOfSections(in tableView: UITableView) -> Int {
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
            return CGFloat(kategorieCount*40 + UnterkategorieCount*50 + itemsCount*86+50)
            
            
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("KellnerCell", owner: self, options: nil)?.first as! KellnerCell
        print(Bestellungen, "Bestellungen")
        cell.Bestellungen = Bestellungen
        cell.Cell1Section = indexPath.section
        cell.bestellungID = Bestellungen[indexPath.section].BestellungID
        cell.annehmen.setTitle("Status: \(Status[Bestellungen[indexPath.section].BestellungID]!)", for: .normal)
        cell.delegate = self
        
        if Status[Bestellungen[indexPath.section].BestellungID] != "versendet" {
            cell.annehmen.backgroundColor = UIColor.green
        } else {
            cell.annehmen.backgroundColor = UIColor.gray
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let DayOne = formatter.date(from: "2018/05/15 12:00")
        let timeStampDate = NSDate(timeInterval: self.Bestellungen[indexPath.section].TimeStamp, since: DayOne!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        cell.timeLbl.text = "\(dateFormatter.string(from: timeStampDate as Date)) Uhr"
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Auth.auth().currentUser?.uid ?? "keineuid")
        userUid = (Auth.auth().currentUser?.uid)!
        loadAktuelleBar()


    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
