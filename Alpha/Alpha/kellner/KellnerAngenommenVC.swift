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
        var bestellung3 = [String: [String: [String: Int]]]()

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
                    
                    self.TimeStamps.append(bestellungInfos.timeStamp!)
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
                        
                        }

                    self.bestellung2.updateValue(self.bestellunggenres, forKey: BestellungID)
                    self.angenommenBestellungenTV.reloadData()

                    }


                
                if self.bestellung2.count == self.bestellungIDs.count {
                    for (a, b) in self.bestellung2 {


                        for d in b.values {

                            for (e,f) in d {

                                self.itemsangenommen.append(e)
                                self.mengenangenommen.append(f)


                            }
                        }
                        self.setSections(genre: a, items: self.itemsangenommen, preise: self.mengenangenommen)
                        self.itemsangenommen.removeAll()
                        self.mengenangenommen.removeAll()
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
            if (sections[indexPath.section].expanded){

            cell.bestellteItems = bestellung2
            cell.section = indexPath.section

            let timeStampDate = NSDate(timeIntervalSince1970: TimeStamps[indexPath.row])
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
                cell.loadBestellung(id: bestellungIDs[indexPath.section])
            print(indexPath, bestellungIDs, bestellung2)
            cell.timeLbl.text = "\(dateFormatter.string(from: timeStampDate as Date)) Uhr"
                return cell
                
            }
            else {
                cell.timeLbl.isHidden = true
                cell.testTabelle.isHidden = true
                cell.gesamtLbl.isHidden = true
                cell.gesamtPreisLbl.isHidden = true
                cell.bezahlenBtn.isHidden = true
                return cell
                
            }
            
        
            
            
        }
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if (sections[indexPath.section].expanded) {
//                print(sections[indexPath.section].items)
//                let height = 361 - 215 + sections[indexPath.section].items.count*44
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

        let header = ExpandableHeaderView()
        
        header.customInit(tableView: tableView, title: "Tisch \(tischnummer[section])", section: section, delegate: self as ExpandableHeaderViewDelegate)

        
        return header
    }
    
    func toggleSection(tableView: UITableView, header: ExpandableHeaderView, section: Int) {
        sections[section].expanded = !sections[section].expanded
        angenommenBestellungenTV.beginUpdates()
        DispatchQueue.main.async(execute: {
            self.angenommenBestellungenTV.reloadData()
        } )
        angenommenBestellungenTV.reloadSections([section], with: .automatic)
        angenommenBestellungenTV.endUpdates()


        
    }
    

    
    
    
        // OTHERS
        
        override func viewWillAppear(_ animated: Bool) {
            angenommenBestellungenTV.estimatedRowHeight = 50
            angenommenBestellungenTV.rowHeight = UITableViewAutomaticDimension
//            loadBestellungsID(KellnerID: self.KellnerID)
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
            bestellungIDs.removeAll()
            itemssss.removeAll()
            bestellunggenres.removeAll()
            genres.removeAll()
            bestellung2.removeAll()
            sections.removeAll()
            TimeStamps = [Double]()
            tischnummer = [String]()
            itemsangenommen.removeAll()
            mengenangenommen.removeAll()
            items.removeAll()
            loadGenres()
            loadBestellungsID(KellnerID: self.KellnerID)


            
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

//[3, 0] ["-L6vpnOnctGKW4dxVrK6", "-L6xj8lKdC4EzwvaftzR", "-L70YMCeCC6IpDxXDP7t", "-L7Vs_pD4Wo_NbIm2x4q", "-L7sYhutqJrUHmoVPThM"] ["-L7sYhutqJrUHmoVPThM": ["Shishas": ["Lemon Fresh": 70, "Water Melon Chill": 90, "Vanille": 90], "Getränke": ["Moloko": 90, "Schwarze Dose": 90]], "-L6vpnOnctGKW4dxVrK6": ["Getränke": ["Moloko": 2]], "-L6xj8lKdC4EzwvaftzR": ["Shishas": ["Lemon Fresh": 3, "Water Melon Chill": 2], "Getränke": ["Moloko": 4]], "-L70YMCeCC6IpDxXDP7t": ["Getränke": ["Schwarze Dose": 8]], "-L7Vs_pD4Wo_NbIm2x4q": ["Getränke": ["Moloko": 3]]]

//[0, 0] ["-L6vpnOnctGKW4dxVrK6", "-L6xj8lKdC4EzwvaftzR", "-L70YMCeCC6IpDxXDP7t", "-L7Vs_pD4Wo_NbIm2x4q", "-L7sYhutqJrUHmoVPThM"] ["-L7sYhutqJrUHmoVPThM": ["Shishas": ["Lemon Fresh": 70, "Water Melon Chill": 90, "Vanille": 90], "Getränke": ["Moloko": 90, "Schwarze Dose": 90]], "-L6vpnOnctGKW4dxVrK6": ["Getränke": ["Moloko": 2]], "-L6xj8lKdC4EzwvaftzR": ["Shishas": ["Lemon Fresh": 3, "Water Melon Chill": 2], "Getränke": ["Moloko": 4]], "-L70YMCeCC6IpDxXDP7t": ["Getränke": ["Schwarze Dose": 8]], "-L7Vs_pD4Wo_NbIm2x4q": ["Getränke": ["Moloko": 3]]]


