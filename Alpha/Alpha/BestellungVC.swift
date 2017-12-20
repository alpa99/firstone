//
//  BestellungVC.swift
//  Alpha
//
//  Created by Alper Maraz on 15.12.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Firebase
import Pulley
import FBSDKLoginKit
import FirebaseAuth


class BestellungVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ExpandableHeaderViewDelegate, BestellenCellDelegate, PageObservation, PulleyDrawerViewControllerDelegate {
    
    // VARS

    var keys = [String: Int]()
    var bestellteItemsDictionary = [String: [String: Int]]()
    var yy = [String]()
    var genres = [String]()
    var itemss = [String]()
    var values = [Int]()

    
    var parentPageViewController: PageViewController!
    
    var barname = "Barracuda"
    
    var items = [String]()
    var itemsPreise = [Int]()

    var sections = [ExpandTVSection]()
    
    var cellIndexPathSection = 0
    var cellIndexPathRow = 0
    var i = Int()
    
    
    var bestellteShishas  = [String: Int]()
    var bestellteGetränke  = [String: Int]()
    
    var bestellung = [ExpandTVSection]()
    
    var effect: UIVisualEffect!
    
    
    @IBOutlet weak var label: UILabel!
    
    
    // OUTLETS
    
    @IBOutlet var bestellungVCView: UIView!
    
    
    
    @IBOutlet var addItemView: UIView!
    @IBOutlet weak var itemNameLbl: UILabel!
    
    @IBOutlet weak var itemCountLbl: UILabel!
    
    @IBOutlet weak var myBestellungTV: UITableView!
    
    @IBOutlet weak var bestellungTableView: UITableView!
    
    @IBOutlet var myBestellungView: UIView!
    
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var dismissPopUp: UIButton!
    
    @IBOutlet weak var myBestellungAbschickenBtn: UIButton!
    // ACTIONS
    
    
    @IBAction func myBestellungAbschicken(_ sender: Any) {
        handleBestellung()
        print("get ready for qrcodes")
    }
    
    @IBAction func dismissPopUp(_ sender: Any) {
        animateOut()
    }
    
//    func myBestellungPruefen(){
//        setSectionsBestellung(genre: <#T##String#>, items: <#T##[String]#>, preise: <#T##[Int]#>)
//    }
    
    @IBAction func sendToFirebase(_ sender: Any) {

        print(bestellteItemsDictionary)
        
        for (genre, itemDictionary) in bestellteItemsDictionary {

            if self.genres.contains(genre) == false {
                self.genres.append(genre)

                for (item, value) in itemDictionary {
                    
                    self.itemss.append(item)
                    self.values.append(value)
                    if itemss.count == itemDictionary.count{

                    setSectionsBestellung(genre: genre, items: itemss, preise: values)
                        print(self.genres, "GENRES")
                        print(self.bestellung, "bestllungen")
                        self.itemss.removeAll()
                        self.values.removeAll()
                    }
                }
            } else {
                for (item, value) in itemDictionary {
                    
                    self.itemss.append(item)
                    self.values.append(value)
                    if itemss.count == itemDictionary.count{
                        if let g = genres.index(of: genre) {
                            print(self.genres[g], "genres g")
                            print(self.bestellung[g], "bestelung g")
                            self.bestellung[g].items = self.itemss
                            self.bestellung[g].preise = self.values
                            self.myBestellungTV.reloadData()

                            print(self.bestellung, "BEST")
                        }
                        self.itemss.removeAll()
                        self.values.removeAll()
                    }
                }
            }
        }
        UIView.animate(withDuration: 1) {
            self.myBestellungView.isHidden = false
            
            //            self.myBestellungView.center = self.view.center
            self.myBestellungView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.myBestellungView.alpha = 0
            self.visualEffectView.isHidden = false
            self.view.addSubview(self.myBestellungView)
            self.visualEffectView.effect = self.effect
            self.myBestellungView.alpha = 1
            self.myBestellungView.transform = CGAffineTransform.identity
        }
        
    }
    
    
    @IBAction func dismissMyBestellungView(_ sender: Any) {
        dismissMyBestellungView()
        bestellung = [ExpandTVSection]()
    }
    
    
    
    

    // FUNCTIONS
    
    func getValue (){
        var datref: DatabaseReference!
        datref = Database.database().reference()
        
        datref.child("Speisekarten").child("\(self.barname)").observe(.value, with: { (snapshotValue) in
            
            self.getKeys(value: Int(snapshotValue.childrenCount))
            
        }, withCancel: nil)
        
    }
            
    func getKeys(value: Int){
        
        var datref: DatabaseReference!
        datref = Database.database().reference()
        
        
        datref.child("Speisekarten").child("\(self.barname)").observe(.childAdded, with: { (snapshotKey) in
            self.keys.updateValue(Int(snapshotKey.childrenCount), forKey: snapshotKey.key)
            
            if self.keys.count == value {
                for (key, value) in self.keys {
                    
                    self.fetchSpeisekarte(ii: key, z: value)
                }
            }
            
            
        }, withCancel: nil)
        
        
    }
            

    func fetchSpeisekarte(ii: String, z: Int){

        var datref: DatabaseReference!
        datref = Database.database().reference()
        
        
        datref.child("Speisekarten").child("\(self.barname)").child(ii).observe(.childAdded, with: { (snapshot) in
            self.label.text = self.barname
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let shisha = SpeisekarteInfos(dictionary: dictionary)
                
                
                self.items.append(shisha.Name!)
                self.itemsPreise.append(shisha.Preis!)

                if self.items.count == z{
                    
                    self.setSectionsSpeisekarte(genre: ii, items: self.items, preise: self.itemsPreise)
                    self.items.removeAll()
                    self.itemsPreise.removeAll()
                }
            }
        }, withCancel: nil)
    }
            
    
    func handleBestellung(){
        
        var ref: DatabaseReference!
        
        if self.bestellteItemsDictionary.count>0{
            let timestamp = Double(NSDate().timeIntervalSince1970)
            let fromUserID = Auth.auth().currentUser!.uid
            var values = ["toKellnerID": "Kellner1", "tischnummer": "3", "fromUserID": fromUserID , "timeStamp": timestamp, "angenommen": false] as [String : Any]
            
            for (genre, itemDictionary) in bestellteItemsDictionary {
                values.updateValue(itemDictionary, forKey: genre)
            }
            ref = Database.database().reference().child("Bestellungen").child(self.barname)
            let childRef = ref?.childByAutoId()
            
            print(self.bestellteItemsDictionary, "NO")
            
                print("yes")
                childRef?.updateChildValues(values)
                let userBestellungenRef = Database.database().reference().child("userBestellungen").child(fromUserID)
                let bestellungID = childRef?.key
                userBestellungenRef.updateChildValues([bestellungID!: 1])
                let kellnerBestellungenRef = Database.database().reference().child("userBestellungen").child("Kellner1")
                kellnerBestellungenRef.updateChildValues([bestellungID!: 1])
                print(Date(timeIntervalSince1970: timestamp)) }
            else {
                let alert = UIAlertController(title: "Deine Bestellung ist leer", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    

    
    func cellItemAddTapped(sender: BestellenCell){
        i = 0
        itemCountLbl.text = "\(i)"
        let indexPath = self.bestellungTableView.indexPathForRow(at: sender.center)!
        cellIndexPathRow = indexPath.row
        cellIndexPathSection = indexPath.section
        animateIn()
    }
    
    
    @IBAction func funcItemPlusTapped(_ sender: Any) {
        i = i+1
        itemCountLbl.text = "\(i)"
    }
    
    @IBAction func funcItemMinusTapped(_ sender: Any) {
        if i > 0{
            i = i-1
            itemCountLbl.text = "\(i)" }
    }
    
    func animateIn(){
        itemNameLbl.text = "\(sections[cellIndexPathSection].items[cellIndexPathRow])"
        //        self.inputView?.addSubview(addItemView)
        //        addItemView.center = (self.inputView?.center)!
        addItemView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        addItemView.alpha = 0
        UIView.animate(withDuration: 1) {
            self.visualEffectView.isHidden = false
            self.addItemView.isHidden = false
            self.visualEffectView.effect = self.effect
            
            self.addItemView.alpha = 1
            self.addItemView.transform = CGAffineTransform.identity
        }
        
    }

    func animateOut(){
        
        UIView.animate(withDuration: 0.5, animations: {
            self.addItemView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.addItemView.alpha = 0
            self.visualEffectView.effect = nil
            
            
        }){ (success:Bool) in
            self.visualEffectView.isHidden = true
            self.addItemView.isHidden = false
            
            
        }
        if i > 0 {
            if bestellteItemsDictionary.index(forKey: sections[cellIndexPathSection].genre) != nil {
                var dic = bestellteItemsDictionary[sections[cellIndexPathSection].genre]
                dic?.updateValue(i, forKey: itemNameLbl.text!)
                bestellteItemsDictionary.updateValue(dic!, forKey: sections[cellIndexPathSection].genre)
            } else {
            bestellteItemsDictionary.updateValue([itemNameLbl.text! : i], forKey: sections[cellIndexPathSection].genre)
            }
        }

    }
    
    func dismissMyBestellungView() {
        
        UIView.animate(withDuration: 0.5, animations: {
            //            self.myBestellungView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            //            self.myBestellungView.alpha = 0
            self.myBestellungView.isHidden = true
            
            self.visualEffectView.effect = nil
            
            
        }){ (success:Bool) in
            //            self.myBestellungView.removeFromSuperview()
            self.myBestellungView.isHidden = true
            
            self.visualEffectView.isHidden = true
        }
    }
    func getParentPageViewController(parentRef: PageViewController) {
        parentPageViewController = parentRef
    }
    
    
    
    // TABLEVIEW FUNCTIONS
    
    func setSectionsSpeisekarte(genre: String, items: [String], preise: [Int]){
        self.sections.append(ExpandTVSection(genre: genre, items: items, preise: preise, expanded: false))
        self.bestellungTableView.reloadData()
    }
    
    func setSectionsBestellung(genre: String, items: [String], preise: [Int]){
        self.bestellung.append(ExpandTVSection(genre: genre, items: items, preise: preise, expanded: true))
        self.myBestellungTV.reloadData()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == bestellungTableView {
            return sections.count }
        else {
            
            return bestellung.count
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == bestellungTableView {
            return sections[section].items.count }
        else {
            
            return bestellung[section].items.count
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (sections[indexPath.section].expanded) {
            return 71
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
        
        if tableView == bestellungTableView {
            
        header.customInit(tableView: tableView, title: sections[section].genre, section: section, delegate: self as ExpandableHeaderViewDelegate)
        } else {
            
        header.customInit(tableView: tableView, title: bestellung[section].genre, section: section, delegate: self as ExpandableHeaderViewDelegate)
        }
        
        return header
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == bestellungTableView {
            let cell = Bundle.main.loadNibNamed("BestellenCell", owner: self, options: nil)?.first as! BestellenCell
            cell.delegate = self
            
            if (sections[indexPath.section].expanded){
                cell.itemNameLbl.text = "\(sections[indexPath.section].items[indexPath.row])"
                cell.itemPreisLbl.text = "\(sections[indexPath.section].preise[indexPath.row]) €"
                return cell
                
            }
            else {
                cell.itemNameLbl.isHidden = true
                cell.itemPreisLbl.isHidden = true
                cell.itemAddBtn.isHidden = true
                return cell
                
            }
        } else {

            let cell = self.myBestellungTV.dequeueReusableCell(withIdentifier: "myBestellCell", for: indexPath)
            cell.textLabel?.text = "\(bestellung[indexPath.section].items[indexPath.row])"
            cell.detailTextLabel?.text = "\(bestellung[indexPath.section].preise[indexPath.row])"
            return cell
        }
    }
    
    
    
    
    func toggleSection(tableView: UITableView, header: ExpandableHeaderView, section: Int) {
        if tableView == bestellungTableView {
            sections[section].expanded = !sections[section].expanded
            
            bestellungTableView.beginUpdates()
            for i in 0..<sections[section].items.count{
                bestellungTableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
            }
            bestellungTableView.endUpdates()
        }
        else {
            sections[section].expanded = !sections[section].expanded
            myBestellungTV.beginUpdates()
            for i in 0..<bestellung[section].items.count{
                myBestellungTV.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
            }
            myBestellungTV.endUpdates()
        }
    }
    // Pulley
    
    
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 102.0
    }
    
    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 340.0
    }
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        return PulleyPosition.all
    }
    
    
    // OTHERS
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        
        
        if touch?.view != myBestellungView && touch?.view != addItemView {
            dismissMyBestellungView()
            animateOut()
            
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getValue()
//        self.barname = parentPageViewController.name
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        visualEffectView.isHidden = true
        addItemView.isHidden = true
        myBestellungView.isHidden = true
        
        
        addItemView.layer.cornerRadius = 5
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

