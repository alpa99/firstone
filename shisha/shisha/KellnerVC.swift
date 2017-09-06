//
//  KellnerVC.swift
//  shisha
//
//  Created by Ibrahim Akcam on 03.09.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class KellnerVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

//    let list = ["1", "2", "3"]
    
    @IBOutlet weak var bestellungenTV: UITableView!
    

    @IBAction func kellnerLogOutPressed(_ sender: Any) {
        performSegue(withIdentifier: "kellnerLogOut", sender: self)
        kellnerID = ""
    }
    
    var kellnerID = String()
    
    var Shishas = [String]()
    var Getraenke = [String]()
    
    var TimeStamps = [Double]()

    
    
    func handleBestellungen() {
    
        var datref: DatabaseReference!
        datref = Database.database().reference()
        datref.child("Bestellungen").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let bestellungen = BestellungInfos(dictionary: dictionary)
                bestellungen.setValuesForKeys(dictionary)
                let timestamps = BestellungInfos(dictionary: dictionary)
                timestamps.setValuesForKeys(dictionary)
                self.Shishas.append(bestellungen.shishas!)
                self.Getraenke.append(bestellungen.getränke!)
                
                
                self.TimeStamps.append((timestamps.timeStamp?.doubleValue)!)
                
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return(Shishas.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "bestellCell", for: indexPath) as! KellnerVCTVC
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "bestellcell")
        
        let shishas = Shishas[indexPath.row]
        let getränke = Getraenke[indexPath.row]
        let timeStampDate = NSDate(timeIntervalSince1970: TimeStamps[indexPath.row])
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        cell.bestellungView.text = "Tischnummer \n shishas: \(shishas) \n Getränke: \(getränke) \n \(dateFormatter.string(from: timeStampDate as Date))"
        
        
        /*cell.tischnummerLbl.text = "TISCH NUMMER XY"
        cell.bestellungtextLbl.text = bestellung
        let timeStampDate = NSDate(timeIntervalSince1970: TimeStamps[indexPath.row])
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        cell.timeStampLbl.text =  dateFormatter.string(from: timeStampDate as Date)*/
        
        return cell
    } 
    
    override func viewWillAppear(_ animated: Bool) {
        bestellungenTV.estimatedRowHeight = 100
        bestellungenTV.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleBestellungen()
        print(kellnerID)
        // Do any additional setup after loading the view.
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
