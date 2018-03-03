//
//  KellnerAngenommenVC.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 30.12.17.
//  Copyright © 2017 AM. All rights reserved.
//
    
    import UIKit
    import Firebase
    
    class KellnerAngenommenVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
        // VARS
        var KellnerID = String()
        var bestellungIDs = [String]()
        var TimeStamps = [Double]()
        var tischnummer = [String]()
        var genres = [String]()
        var bestellunggenres = [String: [String: Int]]()
        var bestellung2 = [String: [String: [String: Int]]]()
        var itemssss = [String: [String: Int]]()
        
        
        var items = [String]()
        var mengen = [Int]()
        
        
        var bestellungen = [String: [String: [String: Int]]]()
        
        // OUTLETS
        
        @IBOutlet weak var angenommenBestellungenTV: UITableView!
        

        // FUNCS
        
        func loadGenres(){
            var datref: DatabaseReference!
            datref = Database.database().reference()
            datref.child("Speisekarten").child("Huqa").observe(.childAdded, with: { (snapshot) in
                
                if self.genres.contains(snapshot.key) == false {
                    self.genres.append(snapshot.key)
                }
                
                
            }, withCancel: nil)
            
        }
        
        func loadBestellungsID(KellnerID: String){
            var datref: DatabaseReference!
            datref = Database.database().reference()
            datref.child("userBestellungen").child(KellnerID).observe(.childAdded, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let bestellungInfos = BestellungInfos(dictionary: dictionary)
                    if bestellungInfos.angenommen == true {
                        self.loadBestellung(BestellungID: snapshot.key)
                        self.bestellungIDs.append(snapshot.key)
                        
                    }
                }
                
                DispatchQueue.main.async(execute: {
                    self.angenommenBestellungenTV.reloadData()
                } )
                
                
            }, withCancel: nil)
        }
        
        func loadBestellung(BestellungID: String){
            var datref: DatabaseReference!
            datref = Database.database().reference()
            datref.child("Bestellungen").child("Huqa").child(BestellungID).observe(.value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    
                    let bestellungInfos = BestellungInfos(dictionary: dictionary)
                    
                    self.TimeStamps.append((bestellungInfos.timeStamp?.doubleValue)!)
                    self.tischnummer.append(bestellungInfos.tischnummer!)
                    DispatchQueue.main.async(execute: {
                        self.angenommenBestellungenTV.reloadData()
                    } )
                }
                
                for genre in self.genres {
                    if snapshot.hasChild(genre) == true {
                        self.bestellunggenres.updateValue(snapshot.childSnapshot(forPath: genre).value as! [String : Int], forKey: genre)
                        self.bestellung2.updateValue(self.bestellunggenres, forKey: BestellungID)
                        
                    }
                    self.angenommenBestellungenTV.reloadData()
                }
            }, withCancel: nil)
        }
        
        func removeBestellung(KellnerID: String, BestellungID: String){
            var datref: DatabaseReference!
            datref = Database.database().reference()
            datref.child("userBestellungen").child(KellnerID).child(BestellungID).updateChildValues(["angenommen": true])
        }
        
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
        
        func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let annehmen = annehmenAction(at: indexPath)
            annehmen.backgroundColor = UIColor.green
            
            
            return UISwipeActionsConfiguration(actions: [annehmen])
        }
        
        func annehmenAction(at indexPath: IndexPath) -> UIContextualAction {
            let action = UIContextualAction(style: .destructive, title: "annehmen") { (action, view, completion) in
                completion(true)
                
                self.removeBestellung(KellnerID: self.KellnerID, BestellungID: self.bestellungIDs[indexPath.row])
                self.bestellungIDs.removeAll()
                self.itemssss.removeAll()
                self.bestellunggenres.removeAll()
                self.genres.removeAll()
                self.bestellung2.removeAll()
                self.TimeStamps.removeAll()
                self.tischnummer.removeAll()
                self.loadGenres()
                self.loadBestellungsID(KellnerID: self.KellnerID)
                
            }
            
            return action
        }
        
        // TABLE
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return bestellung2.count
            
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = Bundle.main.loadNibNamed("KellnerCell", owner: self, options: nil)?.first as! KellnerCell
            
            self.itemssss = bestellung2[bestellungIDs[indexPath.row]]!
            //        for (genre, itemsDictionary) in itemssss {
            //            for (items, menge) in itemsDictionary {
            //                cell.bestellungsText.text = "\(itemsDictionary) \n"
            //
            //            }
            //        }
            cell.bestellungsText.text = "\(itemssss)"
            
            let timeStampDate = NSDate(timeIntervalSince1970: TimeStamps[indexPath.row])
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            cell.timeLbl.text = "\(dateFormatter.string(from: timeStampDate as Date)) Uhr"
            cell.tischnummer.text = "Tischnummer: \(self.tischnummer[indexPath.row])"
            
            return cell
            
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 170
            
        }
        // OTHERS
        
        override func viewWillAppear(_ animated: Bool) {
            angenommenBestellungenTV.estimatedRowHeight = 100
            angenommenBestellungenTV.rowHeight = UITableViewAutomaticDimension
        }
        
        override func viewDidLoad() {
            
            super.viewDidLoad()
            loadGenres()
            loadBestellungsID(KellnerID: self.KellnerID)
            
            let refreshControl = UIRefreshControl()
            let title = NSLocalizedString("aktualisiere", comment: "Pull to refresh")
            refreshControl.attributedTitle = NSAttributedString(string: title)
            refreshControl.addTarget(self, action: #selector(refreshOptions(sender:)), for: .valueChanged)
            angenommenBestellungenTV.refreshControl = refreshControl
            
            
        }
        
        @objc private func refreshOptions(sender: UIRefreshControl) {
            print(KellnerID)
            bestellungIDs.removeAll()
            itemssss.removeAll()
            bestellunggenres.removeAll()
            genres.removeAll()
            bestellung2.removeAll()
            loadGenres()
            loadBestellungsID(KellnerID: self.KellnerID)
            
            TimeStamps = [Double]()
            tischnummer = [String]()
            
            sender.endRefreshing()
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
}


