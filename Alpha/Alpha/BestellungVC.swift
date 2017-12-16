//
//  BestellungVC.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 22.10.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class BestellungVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ExpandableHeaderViewDelegate, BestellenCellDelegate, PageObservation2 {

    // VARS
    var x = [String]()
    var y = [Int]()
    var a = [String]()
    var b = [Int]()
    var keys = [String: Int]()
    var z = [String: Int]()

    
    var timeToHold = 0
    var timer = Timer()
    var timeHolded = Int()
    
    var parentPageViewController2: PageViewController2!
    
    

    private var selectedItems = [String]()
    var barname = "Barracuda"
    
    
    var bars = [BarInfos]()
    var adresse = String ()
    
    var elements = [String]()
    
    var shishas = [String]()
    var shishasPreise = [Int]()
    var getränke = [String]()
    var getränkePreise = [Int]()
    var sections = [ExpandTVSection]()
    
    var count = 0
    var cellIndexPathSection = 0
    var cellIndexPathRow = 0
    var i = Int()
    
    var bestellteShishas  = [String: Int]()
    var bestellteGetränke  = [String: Int]()
    
    var bestellung = [ExpandTVSection]()

    var bestellungSections = ["Shishas","Getränke"]
    
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
//        handleBestellung()
    }
    
    @IBAction func dismissPopUp(_ sender: Any) {
        animateOut()
        print("touch")

    }


    
    
    @IBAction func sendToFirebase(_ sender: Any) {


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
        
        for (item, preis) in bestellteShishas {
            
            if x.contains(item) == false {
                x.append(item)
                y.append(preis)
                print(x, "X")

            }
        }
        
        for (item, preis) in bestellteGetränke {
            
            if a.contains(item) == false {
                a.append(item)
                b.append(preis)
            }
        }
        
        bestellung.removeAll()
        
        if x.count == 0 {
            setSectionsBestellung(genre: "Shishas", items: ["noch nix"], preise: y)

        } else {
        setSectionsBestellung(genre: "Shishas", items: x, preise: y)
    }
        if a.count == 0 {
            setSectionsBestellung(genre: "Getränke", items: ["noch nix"], preise: y)
            
        } else {
            setSectionsBestellung(genre: "Getränke", items: a, preise: b)
        }
    }
    
    
    @IBAction func dismissMyBestellungView(_ sender: Any) {
        dismissMyBestellungView()
        bestellung = [ExpandTVSection]()
        print("touch")
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

        print(value, "Value")
        var datref: DatabaseReference!
        datref = Database.database().reference()
        
        
        datref.child("Speisekarten").child("\(self.barname)").observe(.childAdded, with: { (snapshotKey) in
            self.keys.updateValue(Int(snapshotKey.childrenCount), forKey: snapshotKey.key)

            if self.keys.count == value {
                for (key, value) in self.keys {
                print(key, "vorher")

                    self.fetchSpeisekarte(ii: key, z: value)
                print(key, "nachher")
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
                    
                
                    self.shishas.append(shisha.Name!)
                    self.shishasPreise.append(shisha.Preis!)
                    
                    print(self.shishas, "shishas")
                    print(self.shishas.count, "shishacount")
                    print(ii, z, "zettt")
                    if self.shishas.count == z{

                        self.setSectionsSpeisekarte(genre: ii, items: self.shishas, preise: self.shishasPreise)
                        self.shishas.removeAll()
                        self.shishasPreise.removeAll()
                    }
                    

                }
                    


 //            datref.child("Speisekarten").child("\(self.barname)").child("Shishas").observe(.childAdded, with: { (snapshot) in
//                self.label.text = self.barname
//
//                if let dictionary = snapshot.value as? [String: AnyObject]{
//                    let shisha = SpeisekarteInfos(dictionary: dictionary)
//                    self.shishas.append(shisha.Name!)
//                    self.shishasPreise.append(shisha.Preis!)
//
//
//                }
//                if self.shishas.count == z["Shishas"]{
//                    self.setSectionsSpeisekarte(genre: "Shishas", items: self.shishas, preise: self.shishasPreise)
//                }
//
//            }, withCancel: nil)
//
//            datref.child("Speisekarten").child("\(self.barname)").child("Getränke").observe(.childAdded, with: { (snapshot) in
//
//                if let dictionary = snapshot.value as? [String: AnyObject]{
//                    let getränk = SpeisekarteInfos(dictionary: dictionary)
//                    self.getränke.append(getränk.Name!)
//                    self.getränkePreise.append(getränk.Preis!)
//                }
//                if self.getränke.count == z["Getränke"]{
//                    self.setSectionsSpeisekarte(genre: "Getränke", items: self.getränke, preise: self.getränkePreise)
//                }
//
//            }, withCancel: nil)
                }, withCancel: nil)
    }
    
        func handleBestellung(){
    
            var ref: DatabaseReference!
    
            if bestellteShishas.count > 0 || bestellteGetränke.count > 0{
                let timestamp = Double(NSDate().timeIntervalSince1970)
                let values = ["shishas": bestellteShishas, "getränke": bestellteGetränke, "toKellnerID": "Kellner1", "tischnummer": "3", "fromUserID": FBSDKAccessToken.current().userID, "timeStamp": timestamp, "angenommen": false] as [String : Any]
    
                ref = Database.database().reference().child("Bestellungen").child(barname)
                let childRef = ref?.childByAutoId()
                if bestellteGetränke.count != 0 || bestellteShishas.count != 0{
                childRef?.updateChildValues(values)
                    print(Date(timeIntervalSince1970: timestamp)) }
                else {
                    let alert = UIAlertController(title: "Deine Bestellung ist leer", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
//
//    func cellItemBtnTapped(sender: BestellenCell) {
//        let indexPath = self.bestellungTableView.indexPathForRow(at: sender.center)!
//        let selectedItems = "\(sections[indexPath.section].items[indexPath.row])"
//        let cell = bestellungTableView.cellForRow(at: indexPath) as! BestellenCell
//        if count > 0 && cell.countLbl.text != "Count"{
//            if indexPath.section == 0{
//        bestellteShishas.updateValue(Int(cell.countLbl.text!)!, forKey: selectedItems)
//            } else {
//
//                bestellteGetränke.updateValue(Int(cell.countLbl.text!)!, forKey: selectedItems)
//
//            }
//        } else {
//
//            print("Bitte Stückzahl auswählen")
//        }

//    }
    
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
        
        if i > 0 && cellIndexPathSection == 0 {
            bestellteShishas.updateValue(i, forKey: itemNameLbl.text!)
        } else if i > 0 && cellIndexPathSection == 1 {
            bestellteGetränke.updateValue(i, forKey: itemNameLbl.text!)
        } else if i == 0{
            bestellteGetränke.removeValue(forKey: itemNameLbl.text!)
            bestellteShishas.removeValue(forKey: itemNameLbl.text!)
            
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
    func getParentPageViewController2(parentRef2: PageViewController2) {
        parentPageViewController2 = parentRef2
    }

    

    // TABLEVIEW FUNCTIONS
    
    func setSectionsSpeisekarte(genre: String, items: [String], preise: [Int]){
        self.sections.append(ExpandTVSection(genre: genre, items: items, preise: preise, expanded: false))
        self.bestellungTableView.reloadData()
    }
    
    func setSectionsBestellung(genre: String, items: [String], preise: [Int]){
        bestellung.append(ExpandTVSection(genre: genre, items: items, preise: preise, expanded: true))
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
        if (sections[indexPath.section].expanded){
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
        header.customInit(tableView: tableView, title: sections[section].genre, section: section, delegate: self as ExpandableHeaderViewDelegate)
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
            myBestellungTV.endUpdates()
        }
    }

    // OTHERS

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first


        if touch?.view != myBestellungView && touch?.view != addItemView {
            dismissMyBestellungView()
            animateOut()
            print("touch")

        }
    }
    
//    @objc func normalTap(_ sender: UIGestureRecognizer){
//        print("Normal tap")
//
//    }

    @objc func longTap(_ sender: UIGestureRecognizer){
        if sender.state == .ended && (timeHolded>timeToHold || timeHolded == timeToHold) {
            timer.invalidate()
            print("sds")
            handleBestellung()
        } else if sender.state == .ended && timeHolded<timeToHold {
            timer.invalidate()
            print("sorry, du musst min \(timeToHold) Sekunden halten")
            
        }
            
        else if sender.state == .began {
            timeHolded = 0
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        }
    }
    @objc func updateTime(){
        timeHolded = timeHolded+1
        print(timeHolded)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.barname = parentPageViewController2.name
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        visualEffectView.isHidden = true
        addItemView.isHidden = true
        myBestellungView.isHidden = true

        
        addItemView.layer.cornerRadius = 5
        //fetchSpeisekarte()
        getValue()

//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(normalTap(_:)))
//        tapGesture.numberOfTapsRequired = 1
//        myBestellungAbschickenBtn.addGestureRecognizer(tapGesture)

        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap(_:)))
        myBestellungAbschickenBtn.addGestureRecognizer(longGesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
