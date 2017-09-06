//
//  BestellungTestVC.swift
//  shisha
//
//  Created by Ibrahim Akcam on 23.08.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FBSDKLoginKit

class BestellungTestVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ExpandableHeaderViewDelegate {
    
    var ref: DatabaseReference?
    
    @IBOutlet weak var bestellungTextfield: UITextField!
    
    @IBOutlet weak var bestellTableView: UITableView!
    
    var sections = [
        ExpandTVSection(genre: "😚💨 Shishas", movies: ["Lemon Fresh", "Wild Berry Chill","Acai Zitrone"], expanded: false),
        ExpandTVSection(genre: " 🍹  Getränke", movies: ["Jacky Cola", "Long Island Icetea","Cay"], expanded: false),
        ExpandTVSection(genre: " 🍔  Snacks", movies: ["Körner", "gerösteter Mais","Erdnüsse"], expanded: false)
    ]
    
    
    
    
    
    @IBAction func bestellenPressed(_ sender: Any) {
        
        handleBestellung()
    }
    
  
    var bestellung = ""
    var bestellungen = [KellnerInfos]()
    
    
    func handleBestellung(){
        
              
        if bestellungTextfield.text != nil{
            let timestamp = Double(NSDate().timeIntervalSince1970)
            let values = ["shishas": bestellungTextfield.text!, "getränke": "cola", "toKellnerID": "Kellner1", "fromUserID": FBSDKAccessToken.current().userID, "timeStamp": timestamp] as [String : Any]
        self.ref = Database.database().reference().child("Bestellungen")
        let childRef = ref?.childByAutoId()
        childRef?.updateChildValues(values)
            print(Date(timeIntervalSince1970: timestamp))
     
            
    
        }
        
        
          /*  childByAutoId().child("text").setValue("\(bestellungTextfield.text ?? "")")
            
            
       self.refff?.child("Bestellungen").child("-KsDpzzOuVFFanYnQykH").observe(.value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let bs = KellnerInfos(dictionary: dictionary)
                    bs.setValuesForKeys(dictionary)
                    self.bestellungen.append(bs)
                    self.bestellung = bs.Bestellung!
                    print(self.bestellung)
                  
                    
                }
                
                
            }, withCancel: nil)
            
            
            
       self.refff?.child("Kellner").child("Kellner1").child("Bestellungen").childByAutoId().setValue("\(bestellungTextfield.text!)")
            }*/
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return sections[section].movies.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (sections[indexPath.section].expanded){
        return 44
        }
        else {
        return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        header.customInit(title: sections[section].genre, section: section, delegate: self as ExpandableHeaderViewDelegate)
        return header
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell")!
        cell.textLabel?.text = sections[indexPath.section].movies[indexPath.row]
        return cell
    }
    
    
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        sections[section].expanded = !sections[section].expanded
        
        bestellTableView.beginUpdates()
        for i in 0..<sections[section].movies.count{
            bestellTableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        bestellTableView.endUpdates()
    
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
