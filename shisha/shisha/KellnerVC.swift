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
    
    var Bestellungen = [String]()
    
    
    func handleBestellungen() {
    
        var datref: DatabaseReference!
        datref = Database.database().reference()
        datref.child("Bestellungen").observe(.childAdded, with: { (snapshot) in

            if let dictionary = snapshot.value as? [String: AnyObject]{
                let bestellungen = BestellungInfos(dictionary: dictionary)
                bestellungen.setValuesForKeys(dictionary)
                self.Bestellungen.append(bestellungen.text!)
                print(self.Bestellungen)
                
                DispatchQueue.main.async(execute: {
                    self.bestellungenTV.reloadData()
                } )
                }
            
            

        
        
        }, withCancel: nil)
    
    
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return(Bestellungen.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "bestellCell", for: indexPath) as! KellnerVCTVC
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "bestellcell")
        
        let bestellung = Bestellungen[indexPath.row]
        cell.tischnummerLbl.text = "TISCH NUMMER XY"
        cell.bestellungtextLbl.text = bestellung
        return cell
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
