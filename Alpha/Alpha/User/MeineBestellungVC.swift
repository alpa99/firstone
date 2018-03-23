//
//  MeineBestellungVC.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 19.03.18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit
import Firebase

class MeineBestellungVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // OUTLETS
    
    @IBOutlet weak var meineBestellungTV: UITableView!
    
    
    // ACTIONS
    
    
    @IBAction func BackBtn(_ sender: Any) {
        performSegue(withIdentifier: "profilIdentifier", sender: self)
    }
    
    
    
    func loadMeineBestellungen(){
        var datref: DatabaseReference!
        datref = Database.database().reference()
        datref.child("userBestellungen").child((Auth.auth().currentUser?.uid)!).observe(.value, with: { (snapshot) in
            
            print(snapshot)
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                let bestellungInfos = BestellungInfos(dictionary: dictionary)
                
                print(bestellungInfos)
            }
        
        }, withCancel: nil)
    }
    
    
    
    // TABLE
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("angenommenCell", owner: self, options: nil)?.first as! angenommenCell
        cell.bestellungsText.text = "hahfhadsas"
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMeineBestellungen()

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
