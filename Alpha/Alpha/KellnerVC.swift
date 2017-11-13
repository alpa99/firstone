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
    
    var KellnerID = String()
    
    var bestellteShishas = [String]()
    var bestellteGetränke = [String]()
    var TimeStamps = [Double]()
    var tischnummer = [String]()
    
    var bestellungen = [BestellungInfos]()
    
    @IBOutlet weak var bestellungenTV: UITableView!
    
    
    // OUTLETS
    
    
    
    // ACTIONS
    
    @IBAction func kellnerLogOutTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "kellnerLoggedOut", sender: self)
    }
    
    // FUNCS
    
    func loadBestellungen(){
        
        var datref: DatabaseReference!
        datref = Database.database().reference()
        datref.child("Bestellungen").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let bestellung = BestellungInfos(dictionary: dictionary)
                self.bestellungen.append(bestellung)
                
                let bestellungInfos = BestellungInfos(dictionary: dictionary)
                if case self.KellnerID? = bestellungInfos.toKellnerID {
                self.bestellteShishas.append(bestellungInfos.shishas!)
                self.bestellteGetränke.append(bestellungInfos.getränke!)
                self.TimeStamps.append((bestellungInfos.timeStamp?.doubleValue)!)
                self.tischnummer.append(bestellungInfos.tischnummer!)
                }
                
                /*         self.Bestellungen.sort(by: { (time1, time2) -> Bool in
                 
                 return (time1.timestamps.timeStamp?.intValue)! > (time2.timestamps.timeStamp?.intValue)!
                 })
                 self.TimeStamps.sort(by: { (time1, time2) -> Bool in
                 
                 return time1.description > time2.description
                 })*/
                
                DispatchQueue.main.async(execute: {
                    self.bestellungenTV.reloadData()
                } )
            }
        
        }, withCancel: nil)
    }
    
    
    // TABLE

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TimeStamps.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("KellnerCell", owner: self, options: nil)?.first as! KellnerCell
        let timeStampDate = NSDate(timeIntervalSince1970: TimeStamps[indexPath.row])
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        cell.timeLbl.text = "\(dateFormatter.string(from: timeStampDate as Date))"
        cell.bestellungsText.text = "shishas: \(bestellteShishas[indexPath.row])\n getränke: \(bestellteGetränke[indexPath.row])"
        cell.tischnummer.text = "Tischnummer: \(tischnummer[indexPath.row])"
        
            return cell

        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
        
    }
    
    
    
    // OTHERS
    
    override func viewWillAppear(_ animated: Bool) {
        bestellungenTV.estimatedRowHeight = 100
        bestellungenTV.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBestellungen()
        print(KellnerID)
        
        if #available(iOS 10.0, *) {
            let refreshControl = UIRefreshControl()
            let title = NSLocalizedString("aktualisiere", comment: "Pull to refresh")
            refreshControl.attributedTitle = NSAttributedString(string: title)
            refreshControl.addTarget(self, action: #selector(refreshOptions(sender:)), for: .valueChanged)
            bestellungenTV.refreshControl = refreshControl
        }

    }
    
    @objc private func refreshOptions(sender: UIRefreshControl) {
        loadBestellungen()
        bestellteShishas = [String]()
        bestellteGetränke = [String]()
        TimeStamps = [Double]()
        tischnummer = [String]()
        
        bestellungen = [BestellungInfos]()
        sender.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}