//
//  KellnerAngenommenVC.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 30.12.17.
//  Copyright © 2017 AM. All rights reserved.
//
    
    import UIKit
    import Firebase
    
class KellnerAngenommenVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ExpandableHeaderViewDelegate {

    
        
        // VARS
        var KellnerID = String()
        var bestellungIDs = [String]()
        var TimeStamps = [Double]()
        var tischnummer = [String]()
        var genres = [String]()
        var bestellunggenres = [String: [String: Int]]()
        var bestellung2 = [String: [String: [String: Int]]]()
        var itemssss = [String: [String: Int]]()
    
        var itemsangenommen = [String]()
        var mengenangenommen = [Int]()
    
        var sections = [ExpandTVSection]()
        
        var items = [String]()
        var mengen = [Int]()
        
        
        var bestellungen = [String: [String: [String: Int]]]()
        
        // OUTLETS
        
        @IBOutlet weak var angenommenBestellungenTV: UITableView!
        

        // FUNCS
    
    func setSections(genre: String, items: [String], preise: [Int]) {
        self.sections.append(ExpandTVSection(genre: genre, items: items, preise: preise, expanded: false))
        
    }
        
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
                    if self.bestellunggenres[genre] != nil  {
                        self.bestellunggenres.removeValue(forKey: genre)
                    }
                    if snapshot.hasChild(genre) == true {
                        self.bestellunggenres.updateValue(snapshot.childSnapshot(forPath: genre).value as! [String : Int], forKey: genre)
                        
                            print("hier")
                        }

                    self.bestellung2.updateValue(self.bestellunggenres, forKey: BestellungID)
                    self.angenommenBestellungenTV.reloadData()

                    }
                print(self.bestellunggenres, "bestellunggenres")
                print(self.bestellung2, "DAS hier")
                print(self.bestellung2, "bestellungasasda2")
                
                if self.bestellung2.count == self.bestellungIDs.count {
                    for (a, b) in self.bestellung2 {

                        print(a, "a")
                        print(b, "b")

                        for (c, d) in b {
                            print(c, "c")
                            print(d, "d")

                            for (e,f) in d {
                                print(e, "e")
                                print(f, "f")
                                self.itemsangenommen.append(e)
                                self.mengenangenommen.append(f)
                                print(d, "DDDD")
                                print(self.itemsangenommen, "itemsangenommen")
                                if self.itemsangenommen.count == b.count {
                                    self.setSections(genre: c, items: self.itemsangenommen, preise: self.mengenangenommen)
                                    self.itemsangenommen.removeAll()
                                    self.mengenangenommen.removeAll()
                                    print(self.sections, "sections")
                                }
                            }
                        }
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
        

        // TABLE
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 59
    }
    


        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = Bundle.main.loadNibNamed("bezahlenCell", owner: self, options: nil)?.first as! bezahlenCell
            
            self.itemssss = bestellung2[bestellungIDs[indexPath.row]]!
            
            print(bestellungIDs, "IIIIDDIDIDID")
            print(bestellung2, "bestellugn2")
            print(self.itemssss, "itemssss")
                        
            let timeStampDate = NSDate(timeIntervalSince1970: TimeStamps[indexPath.row])
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            cell.timeLbl.text = "\(dateFormatter.string(from: timeStampDate as Date)) Uhr"
            
            return cell
            
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if (sections[indexPath.section].expanded) {
                return 400
            } else {
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
        print(sections, "SECTIONS")
        print(tischnummer, "tischnummern")
        let header = ExpandableHeaderView()
        
        header.customInit(tableView: tableView, title: "Tisch \(tischnummer[section])", section: section, delegate: self as ExpandableHeaderViewDelegate)

        
        return header
    }
    
    func toggleSection(tableView: UITableView, header: ExpandableHeaderView, section: Int) {
        print(section, "SECtionINT")
        sections[section].expanded = !sections[section].expanded
        angenommenBestellungenTV.beginUpdates()
        angenommenBestellungenTV.reloadSections([section], with: .automatic)
        angenommenBestellungenTV.endUpdates()
    }
    

    
    
    
        // OTHERS
        
        override func viewWillAppear(_ animated: Bool) {
            angenommenBestellungenTV.estimatedRowHeight = 50
            angenommenBestellungenTV.rowHeight = UITableViewAutomaticDimension
        }
        
        override func viewDidLoad() {
            
            super.viewDidLoad()
            angenommenBestellungenTV.reloadData()
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
            sections.removeAll()
            TimeStamps = [Double]()
            tischnummer = [String]()
            
            sender.endRefreshing()
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
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


//
//
//        func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//            let annehmen = annehmenAction(at: indexPath)
//            annehmen.backgroundColor = UIColor.green
//
//
//            return UISwipeActionsConfiguration(actions: [annehmen])
//        }
//
//        func annehmenAction(at indexPath: IndexPath) -> UIContextualAction {
//            let action = UIContextualAction(style: .destructive, title: "annehmen") { (action, view, completion) in
//                completion(true)
//
//                self.removeBestellung(KellnerID: self.KellnerID, BestellungID: self.bestellungIDs[indexPath.row])
//                self.bestellungIDs.removeAll()
//                self.itemssss.removeAll()
//                self.bestellunggenres.removeAll()
//                self.genres.removeAll()
//                self.bestellung2.removeAll()
//                self.TimeStamps.removeAll()
//                self.tischnummer.removeAll()
//                self.loadGenres()
//                self.loadBestellungsID(KellnerID: self.KellnerID)
//
//            }
//
//            return action
//        }



