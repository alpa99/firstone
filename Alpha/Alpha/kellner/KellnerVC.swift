//
//  KellnerVC.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 11.11.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Firebase

class KellnerVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    // VARS
    var Bestellungen = [KellnerTVSection]()
    var BestellungenID = [String]()
    var BestellungKategorien = [String: [String]]()
    var BestellungUnterkategorien = [String: [[String]]]()
    var BestellungItemsNamen = [String: [[[String]]]]()
    var BestellungItemsPreise = [[[Int]]]()
    var BestellungItemsMengen = [[[Int]]]()
    // Information
    var Tischnummer = [String: String]()
    var Angenommen = [String: Bool]()
    var FromUserID = [String: String]()
    var TimeStamp = [String: Double]()
    

    
    
    var KellnerID = String()
    var bestellungIDs = [String]()
    var TimeStamps = [Double]()
    var tischnummer = [String]()
    var genres = [String]()
    var bestellunggenres = [String: [String: Int]]()
    var bestellung2 = [String: [String: [String: Int]]]()
    var itemssss = [String: [String: Int]]()
    var cellGenres = [String]()
    var cellItems = [String]()
    var cellMengen = [Int]()
    
    var items = [String]()
    var mengen = [Int]()
    
    
    var bestellungen = [String: [String: [String: Int]]]()
    
    // OUTLETS
    
    @IBOutlet weak var bestellungenTV: UITableView!
    
    
    @IBOutlet weak var logoutBtn: UIButton!
    
    
    
    // ACTIONS
    
//    @IBAction func kellnerLogOutTapped(_ sender: Any) {
//
//            if Auth.auth().currentUser != nil {
//                do {
//                    try Auth.auth().signOut()
//                    performSegue(withIdentifier: "kellnerLoggedOut", sender: self)
//
//                } catch let error as NSError {
//                    print(error.localizedDescription)
//                }
//            }
//        }
    
    // FUNCS
    
    func loadBestellungenKeys(){
                var datref: DatabaseReference!
                datref = Database.database().reference()
        datref.child("userBestellungen").child("KellnerID").observe(.childAdded, with: { (snapshot) in
            self.loadBestellungen(BestellungID: snapshot.key)

                }, withCancel: nil)
    
    }
    
    func loadBestellungen(BestellungID: String){
        self.bestellungIDs.append(BestellungID)
        
        var datref: DatabaseReference!
        datref = Database.database().reference()
        
        
        datref.child("Bestellungen").child("Huqa").child(BestellungID).observeSingleEvent(of: .value) { (snapshot) in
            
            for key in (snapshot.children.allObjects as? [DataSnapshot])! {
                if key.key == "Information" {
                    if let dictionary = key.value as? [String: AnyObject]{
                        
                        let bestellungInfos = BestellungInfos(dictionary: dictionary)
                        self.Tischnummer.updateValue(bestellungInfos.tischnummer!, forKey: BestellungID)
                        self.Angenommen.updateValue(bestellungInfos.angenommen!, forKey: BestellungID)
                        self.FromUserID.updateValue(bestellungInfos.fromUserID!, forKey: BestellungID)
                        self.TimeStamp.updateValue(bestellungInfos.timeStamp!, forKey: BestellungID)
                        
                    }
                    
                } else {
                    let childsnapshotUnterkategorie = snapshot.childSnapshot(forPath: key.key)
                    
                    
                    if self.BestellungKategorien[BestellungID] != nil {
                        
                        
                        self.BestellungKategorien[BestellungID]?.append(key.key)
                        print(self.BestellungKategorien, "kategorien1")
                        print(self.BestellungUnterkategorien, "BestellungUnterkategorien1")

                        
                        for children in (childsnapshotUnterkategorie.children.allObjects as? [DataSnapshot])! {
//                            if self.BestellungUnterkategorien[BestellungID] != nil {
                            var x = self.BestellungUnterkategorien[BestellungID]
                            
                            if x!.count < (self.BestellungKategorien[BestellungID]?.count)!{
                                x!.append([children.key])}
                            else {
                                x![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!].append(children.key)
                            }
                                self.BestellungUnterkategorien.updateValue(x!, forKey: BestellungID)
                                
                                print(self.BestellungUnterkategorien, "BestellungUnterkategorien213")

                        }
                        
                
                    } else {
                        self.BestellungKategorien.updateValue([key.key], forKey: BestellungID)
                        
                        print(self.BestellungKategorien, "kategorien2")
                        for children in (childsnapshotUnterkategorie.children.allObjects as? [DataSnapshot])! {
                            if self.BestellungUnterkategorien[BestellungID] != nil {
                                var x = self.BestellungUnterkategorien[BestellungID]
                                print(x!,key.key, "f5gre2")

                                x![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!].append(children.key)
                                self.BestellungUnterkategorien.updateValue(x!, forKey: BestellungID)

                                print(self.BestellungUnterkategorien, "BestellungUnterkategorien21")

                                
                            } else {
                        self.BestellungUnterkategorien.updateValue([[children.key]], forKey: BestellungID)
                            print(self.BestellungUnterkategorien, "BestellungUnterkategorien22")
                            }
                        }
                    }
                    
                    
                }
            }
        }
    }
    
    
    func setSectionsKellnerBestellung(BestellungID: String, Kategorie: [String], Unterkategorie: [[String]], items: [[[String]]], preis: [[[Int]]], liter: [[[String]]], menge: [[[Int]]], expanded2: [Bool], expanded: Bool){
        self.Bestellungen.append(KellnerTVSection(BestellungID: BestellungID, Kategorie: Kategorie, Unterkategorie: Unterkategorie, items: items, preis: preis, liter: liter, menge: menge, expanded2: expanded2, expanded: expanded))

    }
    
//
//    func loadGenres(){
//        var datref: DatabaseReference!
//        datref = Database.database().reference()
//        datref.child("Speisekarten").child("Huqa").observe(.childAdded, with: { (snapshot) in
//
//            if self.genres.contains(snapshot.key) == false {
//                self.genres.append(snapshot.key)
//            }
//
//
//        }, withCancel: nil)
//
//    }
//
//    func loadBestellungsID(KellnerID: String){
//        var datref: DatabaseReference!
//        datref = Database.database().reference()
//        datref.child("userBestellungen").child(KellnerID).observe(.childAdded, with: { (snapshot) in
//
//            if let dictionary = snapshot.value as? [String: AnyObject]{
//                let bestellungInfos = BestellungInfos(dictionary: dictionary)
//                if bestellungInfos.angenommen == false {
//                    self.loadBestellung(BestellungID: snapshot.key)
//                    self.bestellungIDs.append(snapshot.key)
//
//                }
//            }
//
//            DispatchQueue.main.async(execute: {
//                self.bestellungenTV.reloadData()
//            } )
//
//
//        }, withCancel: nil)
//    }
//
//    func loadBestellung(BestellungID: String){
//        var datref: DatabaseReference!
//        datref = Database.database().reference()
//        datref.child("Bestellungen").child("Huqa").child(BestellungID).observe(.value, with: { (snapshot) in
//
//            if let dictionary = snapshot.value as? [String: AnyObject]{
//
//                let bestellungInfos = BestellungInfos(dictionary: dictionary)
//
//                self.TimeStamps.append((bestellungInfos.timeStamp?.doubleValue)!)
//                self.tischnummer.append(bestellungInfos.tischnummer!)
//                DispatchQueue.main.async(execute: {
//                    self.bestellungenTV.reloadData()
//                } )
//            }
//
//            for genre in self.genres {
//                if self.bestellunggenres[genre] != nil  {
//                    self.bestellunggenres.removeValue(forKey: genre)
//                }
//                if snapshot.hasChild(genre) == true {
//
//                    self.bestellunggenres.updateValue(snapshot.childSnapshot(forPath: genre).value as! [String : Int], forKey: genre)
//
//                }
//
//                self.bestellung2.updateValue(self.bestellunggenres, forKey: BestellungID)
//
//                self.bestellungenTV.reloadData()
//            }
//        }, withCancel: nil)
//    }
//
//    func removeBestellung(KellnerID: String, BestellungID: String){
//        var datref: DatabaseReference!
//        datref = Database.database().reference()
//        datref.child("userBestellungen").child(KellnerID).child(BestellungID).updateChildValues(["angenommen": true])
//    }
    
    // SWIPE ACTIONS
    
    //    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    //        let delete = deleteAction(at: indexPath)
    //
    //        return UISwipeActionsConfiguration(actions: [delete])
    //    }
    //
    //    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
    //        let action = UIContextualAction(style: .normal, title: "delete") { (action, view, completion) in
    //            completion(true)
    //
    //
    //        }
    //        return action
    //    }
    
//    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let annehmen = annehmenAction(at: indexPath)
//        annehmen.backgroundColor = UIColor.green
//
//
//        return UISwipeActionsConfiguration(actions: [annehmen])
//    }
//
//    func annehmenAction(at indexPath: IndexPath) -> UIContextualAction {
//        let action = UIContextualAction(style: .destructive, title: "annehmen") { (action, view, completion) in
//            completion(true)
//
//            self.removeBestellung(KellnerID: self.KellnerID, BestellungID:
//                self.bestellungIDs[indexPath.row])
//            self.bestellungIDs.removeAll()
//            self.itemssss.removeAll()
//            self.bestellunggenres.removeAll()
//            self.genres.removeAll()
//            self.bestellung2.removeAll()
//            self.TimeStamps.removeAll()
//            self.tischnummer.removeAll()
//            self.loadGenres()
//            self.loadBestellungsID(KellnerID: self.KellnerID)
//            self.bestellungenTV.reloadData()
//
//        }
//
//        return action
//    }
    
    // TABLE
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bestellung2.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
        let cell = Bundle.main.loadNibNamed("KellnerCell", owner: self, options: nil)?.first as! KellnerCell
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
        
    }
    // OTHERS
    
//    override func viewWillAppear(_ animated: Bool) {
//        bestellungenTV.estimatedRowHeight = 100
//        bestellungenTV.rowHeight = UITableViewAutomaticDimension
//    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        loadBestellungenKeys()
    
//        logoutBtn.layer.cornerRadius = 4
//
//        loadGenres()
//        loadBestellungsID(KellnerID: self.KellnerID)
//
//        let refreshControl = UIRefreshControl()
//        let title = NSLocalizedString("aktualisiere", comment: "Pull to refresh")
//        refreshControl.attributedTitle = NSAttributedString(string: title)
//        refreshControl.addTarget(self, action: #selector(refreshOptions(sender:)), for: .valueChanged)
//        bestellungenTV.refreshControl = refreshControl
//
//
    }
    
    @objc private func refreshOptions(sender: UIRefreshControl) {
//        bestellungIDs.removeAll()
//        itemssss.removeAll()
//        bestellunggenres.removeAll()
//        genres.removeAll()
//        bestellung2.removeAll()
//        loadGenres()
//        loadBestellungsID(KellnerID: self.KellnerID)
//
//        TimeStamps = [Double]()
//        tischnummer = [String]()
//
//        sender.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


