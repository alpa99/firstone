////
////  BewertungVC.swift
////  SMOLO
////
////  Created by Alper Maraz on 09.11.18.
////  Copyright © 2018 AM. All rights reserved.
////
//
//
//  MeineBestellungVC.swift
//  SMOLO
//
//  Created by Ibrahim Akcam on 19.03.18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit
import Firebase


class BewertungVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ExpandableHeaderViewDelegate{
    
    func toggleSection(tableView: UITableView, header: ExpandableHeaderView, section: Int) {
        print("ahhahahah")
    }
    
  
    

    
    var bestelltebar = " "
    var Bestellungen = [KellnerTVSection]()
    var Bewertbar = [BewertungSection]()
    var Matchbar = [BewertungSection]()
    
    
    

//
//    func toggleSection(tableView: UITableView, header: ExpandableHeaderView, section: Int) {
//        
//    }


    // VARS
    var letzteBestellungZeit = Double()
    var userUid = String()

    var bestellungIDs = [String]()
    var BestellungKategorien = [String]()
    var BestellungUnterkategorien =  [[String]]()
    var BestellungExpanded2 = [[Bool]]()
    var Status =  String()

    var BestellungItemsNamen =  [[[String]]]()
    
    var Angenommen = [String: String]()
    var FromUserID = [String: String]()
    var TimeStamp = [String: Double]()
    var extrasString = [String]()
    var extrasPreis = [Double]()

    var KellnerID = String()
    
    var Items = [String: [[String]]]()
    var MatchItems = [String: [[String]]]()
    
    var BewUKat = [String: [String]]()
    var BewKat = [String]()
    var MatchUKat = [String: [String]]()
    var MatchKat = [String]()
    var katcounter = 0
    var fetchcounter = 0
    
    
    var cellIndexPathSection = 0
    var cellIndexPathRow = 0
    
    // OUTLETS

    @IBOutlet weak var BewertungTV: UITableView!
    
    // ACTIONS

    func fetchKategorie(){
        var datref: DatabaseReference!
        datref = Database.database().reference()
        datref.child("Speisekarten").child(bestelltebar).observe(.childAdded, with: { (snapshot) in
            if let uSnapshots = snapshot.value as? [String: AnyObject]{
                for uSnapshot in uSnapshots{
                    if let bewertungValue = uSnapshot.value as? [String: AnyObject]{
                        for bewertbar in bewertungValue {
                            if bewertbar.key == "Bewertbar" {
                                if let bewertbarvalue = bewertbar.value as? Bool {
                                    let bewertbarVar = bewertbarvalue
                                    if bewertbarVar == true {
                                      print(snapshot.key, "lanilani")
                                        if !self.BewKat.contains(snapshot.key){
                                            self.BewKat.append(snapshot.key)
                                            self.getUnterkategorie(Kategorie: snapshot.key)
                                        }
                       
                                    } } } } } } } }, withCancel: nil) }
    
    func getUnterkategorie(Kategorie: String){
        
        var datref: DatabaseReference!
        datref = Database.database().reference()
        datref.child("Speisekarten").child(bestelltebar).child(Kategorie).observeSingleEvent(of: .value, with: { (snapshot) in
            for key in (snapshot.children.allObjects as? [DataSnapshot])! {
                let snapshotItem = snapshot.childSnapshot(forPath: key.key)
                if key.key != "Extras" {
                    if let bewertungValue = key.value as? [String: AnyObject]{
                        for bewertbar in bewertungValue {
                            if bewertbar.key == "Bewertbar" {
                                if let bewertbarvalue = bewertbar.value as? Bool {
                                    let bewertbarVar = bewertbarvalue
                                    if bewertbarVar == true {
                                        
                                        if self.BewUKat[Kategorie] != nil {
                                            self.BewUKat[Kategorie]?.append(key.key)
                                            for items in (snapshotItem.children.allObjects as? [DataSnapshot])!{
                                                if let dictionary = items.value as? [String: AnyObject]{
                                                    let item = SpeisekarteInformation(dictionary: dictionary)
                                                    var newitems = self.Items[Kategorie]
                                                    if (self.Items[Kategorie]?.count)! < (self.BewUKat[Kategorie]?.count)!{
                                                        newitems?.append([item.Name!])
                                                        self.Items[Kategorie] = newitems
                                                    } else{
                                                        newitems![(self.BewUKat[Kategorie]?.index(of: key.key))!].append(item.Name!)
                                                        self.Items[Kategorie] = newitems
                                                    }
                                                }
                                            }
                                            
                                        }else{
                                            self.BewUKat.updateValue([key.key], forKey: Kategorie)
                                            for items in (snapshotItem.children.allObjects as? [DataSnapshot])!{
                                                
                                                if let dictionary = items.value as? [String: AnyObject]{
                                                    let item = SpeisekarteInformation(dictionary: dictionary)
                                                    if self.Items[Kategorie] != nil{
                                                        var newItems = self.Items[Kategorie]
                                                        newItems![(self.BewUKat[Kategorie]?.index(of: key.key))!].append(item.Name!)
                                                        self.Items[Kategorie] = newItems
                                                    } else {
                                                        self.Items.updateValue([[item.Name!]], forKey: Kategorie)
                                                    }
                                                }
                                            }
                                            
                                        }
                                    }}}}}}
            }
            if self.BewUKat.count == self.BewKat.count {
                for kategorie in self.BewKat {
                   
                    
                    self.setSectionsBewertbar(timeStamp: 1234.5, Kategorie: kategorie, Unterkategorie: self.BewUKat[kategorie]!, items: self.Items[kategorie]!)
                }
                self.matchKategorie()
            }
        }, withCancel: nil)
        
    }
    
    func matchKategorie (){
        print("Bestellungen loo", BewKat)
        var counter = 0
        for kat in Bestellungen[0].Kategorie{
            counter += 1
            if BewKat.contains(kat){
                let index = Bestellungen[0].Kategorie.index(of: kat)
                let a = Bestellungen[0].Unterkategorie[index!]
                for u in a{
                    if (BewUKat[kat]?.contains(u))!{
                        self.MatchKat.append(kat)

                    }
                }
                if counter == Bestellungen[0].Kategorie.count{
                    self.matchUnterkategorie(Kategorie: MatchKat)}
            } } }
    
    func matchUnterkategorie (Kategorie: [String]){
        for k in Kategorie{
        let index = Bestellungen[0].Kategorie.index(of: k)
        let a = Bestellungen[0].Unterkategorie[index!]
            
        for ukat in a{
            let indexBB = a.index(of: ukat)
            if (BewUKat[k]?.contains(ukat))!{
                if self.MatchUKat[k] != nil {

                    self.MatchUKat[k]?.append(ukat)
                if self.MatchItems[k] != nil{
                    let AAA = Bestellungen[0].items
                    let BBB = AAA[index!]
                    let CCC = BBB[indexBB!]

                    self.MatchItems[k]?.append(CCC)
                }else{
                    let DDD = Bestellungen[0].items
                    let EEE = DDD[index!]
                    let FFF = EEE[indexBB!]

                    self.MatchItems.updateValue([FFF], forKey: k) }
                }else{
                    self.MatchUKat.updateValue([ukat], forKey: k)
                    if self.MatchItems[k] != nil{
                        let AAA = Bestellungen[0].items
                        let BBB = AAA[index!]
                        let CCC = BBB[indexBB!]
                         self.MatchItems[k]?.append(CCC) }else{
                        let DDD = Bestellungen[0].items
                        let EEE = DDD[index!]
                        let FFF = EEE[indexBB!]
                        print("test4")

                        self.MatchItems.updateValue([FFF], forKey: k)
                    } }  }  }
        }
        print(MatchUKat.count, MatchKat.count, "Test5")
        print(MatchUKat, MatchKat, "test3")
        if self.MatchUKat.count == self.MatchKat.count {
            for kategorie in self.MatchUKat.keys {
                self.setSectionsMatchbar(timeStamp: 1234.5, Kategorie: kategorie, Unterkategorie: self.MatchUKat[kategorie]!, items: self.MatchItems[kategorie]!)
                print(Matchbar, "dieWahrheit")
            }
        
    }
        
    }

    
    
    func setSectionsBewertbar(timeStamp: Double, Kategorie: String, Unterkategorie: [String], items: [[String]]){
        self.Bewertbar.append(BewertungSection(timeStamp: timeStamp, Kategorie: Kategorie, Unterkategorie: Unterkategorie, items: items))
        
    }
    func setSectionsMatchbar(timeStamp: Double, Kategorie: String, Unterkategorie: [String], items: [[String]]){
        self.Matchbar.append(BewertungSection(timeStamp: timeStamp, Kategorie: Kategorie, Unterkategorie: Unterkategorie, items: items))
        BewertungTV.reloadData()
    }
    

//  TABLEVIEW
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let header = ExpandableHeaderView()
        header.contentView.layer.cornerRadius = 5
        header.contentView.layer.backgroundColor = UIColor.clear.cgColor

        header.layer.cornerRadius = 5
        header.layer.backgroundColor = UIColor.clear.cgColor
        header.customInit(tableView: tableView, title: MatchKat[section], section: section, delegate: self as ExpandableHeaderViewDelegate)


        return header
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return MatchKat.count

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("BewertungTVCell", owner: self, options: nil)?.first as! BewertungTVCell
        cell.backgroundColor = UIColor.clear
//
        cell.unterkategorien = Matchbar
        print(Matchbar, "matchbar222")
        print(indexPath.section, indexPath)
        cell.items = Matchbar[indexPath.section].items


        cell.cellIndexPathSection = indexPath.section
//
//        cell.delegate = self
        cellIndexPathRow = indexPath.row
        cellIndexPathSection = indexPath.section
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var heightForHeaderInSection: Int?
            heightForHeaderInSection = 36
    
        return CGFloat(heightForHeaderInSection!)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       print(Matchbar[indexPath.section].Unterkategorie[indexPath.row].count,"somerice")
        
        return CGFloat(Matchbar[indexPath.section].items[indexPath.row].count*200)
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        var heightForFooterInSection: Int?
        heightForFooterInSection = 15
     
        return CGFloat(heightForFooterInSection!)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        userUid = (Auth.auth().currentUser?.uid)!
//        loadAktuelleBar()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "hintergrund")!)
        fetchKategorie()

    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false

    }

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }


}

