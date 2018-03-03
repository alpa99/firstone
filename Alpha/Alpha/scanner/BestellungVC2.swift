//
//  BestellungVC2.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 22.10.17.
//  Copyright © 2017 AM. All rights reserved.
//
import UIKit
import Firebase
import FBSDKLoginKit
import FirebaseAuth
import CoreLocation

class BestellungVC2: UIViewController, UITableViewDataSource, UITableViewDelegate, ExpandableHeaderViewDelegate, BestellenCellDelegate, MyBestellungCellDelegate, PageObservation2, CLLocationManagerDelegate {
 
    
    

    // VARS#

    
    var keys = [String: Int]()
    var bestellteItemsDictionary = [String: [String: Int]]()
    var yy = [String]()
    var genres = [String]()
    var itemss = [String]()
    var values = [Int]()
    
    var locationManager = CLLocationManager()
    
    var parentPageViewController2: PageViewController2!
    
    var barname = " "
    var baradresse = " "
    
    var items = [String]()
    var itemsPreise = [Int]()
    
    var sections = [ExpandTVSection]()
    
    var cellIndexPathSection = 0
    var cellIndexPathRow = 0
    var i = Int()

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
    
    
    func cellMyItemMengePlusAction(sender: MyBestellungCell) {
        let indexPath = self.myBestellungTV.indexPathForRow(at: sender.center)!
        var newArray = [String]()
        var newArray11 = [Int]()
        var newArray2 = [String]()
        for (section, genre) in bestellteItemsDictionary {
            newArray2.append(section)
            print(genre, "dssdfsdfsdfseww32")
        }
        var newDic = bestellteItemsDictionary[newArray2[indexPath.section]]!
        print(newDic, "newDic1 plus")
        for (a, b) in newDic {
            newArray.append(a)
            newArray11.append(b)
        }
        print(newArray11, "b")
        var valueItem = newArray11[indexPath.row]
        valueItem = valueItem+1
        newArray11[indexPath.row] = valueItem
        print(newArray11, "bb")
        newDic.updateValue(valueItem, forKey: newArray[indexPath.row])
        bestellteItemsDictionary.updateValue(newDic, forKey: newArray2[indexPath.section])
        
        bestellung[indexPath.section].preise = newArray11

        
        self.myBestellungTV.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
    func cellmyItemMengeMinusAction(sender: MyBestellungCell) {
        
        
        let indexPath = self.myBestellungTV.indexPathForRow(at: sender.center)!
        var newArray = [String]()
        var newArray11 = [Int]()
        var newArray2 = [String]()
        for (section, genre) in bestellteItemsDictionary {
            newArray2.append(section)
            print(genre, "dssdfsdfsdfseww32")
        }
        var newDic = bestellteItemsDictionary[newArray2[indexPath.section]]!
        print(newDic, "newDic1 plus")
        for (a, b) in newDic {
            newArray.append(a)
            newArray11.append(b)
        }
        print(newArray11, "b")
        var valueItem = newArray11[indexPath.row]
        if valueItem > 1 {
            valueItem = valueItem-1}

        newArray11[indexPath.row] = valueItem
        print(newArray11, "bb")
        newDic.updateValue(valueItem, forKey: newArray[indexPath.row])
        bestellteItemsDictionary.updateValue(newDic, forKey: newArray2[indexPath.section])
        
        bestellung[indexPath.section].preise = newArray11
        
        
        self.myBestellungTV.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
    func cellMyItemEntfernen(sender: MyBestellungCell) {

        let indexPath = self.myBestellungTV.indexPathForRow(at: sender.center)!
        print(indexPath, "indexPath")
        print(bestellteItemsDictionary, "1234512")
        print(sections, "sections")
        var newArray = [String]()
        var newArray11 = [Int]()
        var newArray2 = [String]()
        for (section, genre) in bestellteItemsDictionary {
            newArray2.append(section)
            print(genre, "dssdfsdfsdfseww32")
        }
        var newDic = bestellteItemsDictionary[newArray2[indexPath.section]]!
        print(newDic, "newDic1")

        for (a, b) in newDic {
            newArray.append(a)
            newArray11.append(b)
        }
        print(newArray, "newArray")
        newDic.removeValue(forKey: newArray[indexPath.row])
        newArray.remove(at: indexPath.row)
        newArray11.remove(at: indexPath.row)
        
        print(bestellteItemsDictionary[sections[indexPath.section].genre] as Any, "this is genre1")
        bestellteItemsDictionary.updateValue(newDic, forKey: newArray2[indexPath.section])
        print(bestellteItemsDictionary[sections[indexPath.section].genre] as Any, "this is genre2")
        
        bestellung[indexPath.section].items = newArray
        bestellung[indexPath.section].preise = newArray11
        self.myBestellungTV.deleteRows(at: [indexPath], with: .right)
        
        print(newArray, "2NEW ARRAY")
        
        if newArray.count == 0 {
            bestellung.remove(at: indexPath.section)
            print(genres,"12212")
            bestellteItemsDictionary.removeValue(forKey: genres[indexPath.section])
            genres.remove(at: indexPath.section)
            print(genres, "212121")
            self.myBestellungTV.reloadData()
        }
       

        print(bestellung, "bestellung")
        
//        DispatchQueue.main.async(execute: {
//            self.myBestellungTV.deleteRows(at: [indexPath], with: .right)
//        } )
//        myBestellungTV.deleteRows(at: [indexPath], with: .automatic)


    }
    
    
    
    @IBAction func myBestellungAbschicken(_ sender: Any) {
        
        print("omed stinkt")
      
        CLGeocoder().geocodeAddressString(baradresse, completionHandler: { (placemarks, error) -> Void in

            if let placemark = placemarks?[0] {

                let locat = placemark.location
            //                    let placemarks = placemarks,
            //                        let locationone = placemarks.first?.location


                let distancebar = self.locationManager.location?.distance(from: locat!)
                print (distancebar!, " entfernung")
                let distanceint = Int(distancebar!)
                if distanceint < 80 {
                self.handleBestellung()
                    print("distance ist ok")
                }else{
                    print ("distance ist nicht ok ")
                    let alert = UIAlertController(title: "Du befindest dich nicht mehr in der Nähe der Bar", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                
                print("jhsdjsd")
            }
            
        })
        
    }
    
    @IBAction func dismissPopUp(_ sender: Any) {
        animateOut()
        bestellungaktualisieren()
    }
    
    
    @IBAction func sendToFirebase(_ sender: Any) {
        myBestellungTV.reloadData()
        print(bestellteItemsDictionary, "sgsdgsd")
        
        for (genre, itemDictionary) in bestellteItemsDictionary {
            print(genres)
            if self.genres.contains(genre) == false {
                print("notelse")
                self.genres.append(genre)
                
                for (item, value) in itemDictionary {
                    
                    self.itemss.append(item)
                    self.values.append(value)
                    if itemss.count == itemDictionary.count{
                        
                        setSectionsBestellung(genre: genre, items: itemss, preise: values)
                        
                        self.itemss.removeAll()
                        self.values.removeAll()
                    }
                }
            } else {
                print("else")
                for (item, value) in itemDictionary {
                    
                    self.itemss.append(item)
                    self.values.append(value)
                    if itemss.count == itemDictionary.count{
                        if let g = genres.index(of: genre) {
                        
//                            setSectionsBestellung(genre: genre, items: self.itemss, preise: self.values)
                            print(g, "G")
                            self.bestellung[g].items = self.itemss
                            self.bestellung[g].preise = self.values
                            self.myBestellungTV.reloadData()
                            
                        }
                        self.itemss.removeAll()
                        self.values.removeAll()

                    }
                }
            }
        }
        self.bestellungVCView.addSubview(visualEffectView)
        visualEffectView.center = self.bestellungVCView.center
        self.bestellungVCView.addSubview(self.myBestellungView)
        self.myBestellungView.center = self.bestellungVCView.center
        self.myBestellungView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        self.myBestellungView.alpha = 0
        UIView.animate(withDuration: 1) {

            self.visualEffectView.effect = self.effect
            self.myBestellungView.alpha = 1
            self.myBestellungView.transform = CGAffineTransform.identity
        }
        
    }
    
    
    @IBAction func dismissMyBestellungView(_ sender: Any) {
        dismissMyBestellungView()
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
            
            childRef?.updateChildValues(values)
            let userBestellungenRef = Database.database().reference().child("userBestellungen").child(fromUserID)
            let bestellungID = childRef?.key
            userBestellungenRef.updateChildValues([bestellungID!: false])
            let kellnerBestellungenRef = Database.database().reference().child("userBestellungen").child("Kellner1")
            kellnerBestellungenRef.child(bestellungID!).updateChildValues(["angenommen": false])
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
        self.bestellungVCView.addSubview(visualEffectView)
        visualEffectView.center = self.bestellungVCView.center
        self.bestellungVCView.addSubview(addItemView)
        addItemView.center = self.bestellungVCView.center
        itemNameLbl.text = "\(sections[cellIndexPathSection].items[cellIndexPathRow])"
        //        self.inputView?.addSubview(addItemView)
        //        addItemView.center = (self.inputView?.center)!
        addItemView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        addItemView.alpha = 0
        UIView.animate(withDuration: 1) {
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
            self.addItemView.removeFromSuperview()
            self.visualEffectView.removeFromSuperview()
            
            
        }

    }
    
    func bestellungaktualisieren(){
        if i > 0 {
            print(bestellteItemsDictionary, "XX")
            print(cellIndexPathSection, "path")
            print(sections, "sections")
            print(bestellung, "bestellung")
            
            
            if bestellteItemsDictionary.index(forKey: sections[cellIndexPathSection].genre) != nil {
                var dic = bestellteItemsDictionary[sections[cellIndexPathSection].genre]
                dic?.updateValue(i, forKey: itemNameLbl.text!)
                
                bestellteItemsDictionary.updateValue(dic!, forKey: sections[cellIndexPathSection].genre)
                print(bestellteItemsDictionary, "YY")
                
            } else {
                bestellteItemsDictionary.updateValue([itemNameLbl.text! : i], forKey: sections[cellIndexPathSection].genre)
                print("blahla")
            }
        }
    }
    
    func dismissMyBestellungView() {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.myBestellungView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.myBestellungView.alpha = 0
            self.visualEffectView.effect = nil
            
            
        }){ (success:Bool) in
            self.myBestellungView.removeFromSuperview()
            self.visualEffectView.removeFromSuperview()
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
            if tableView == bestellungTableView {
            return 71
            } else {
                return 90
            }
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
            cell.backgroundColor = UIColor.clear
            
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
            let cell = Bundle.main.loadNibNamed("MyBestellungCell", owner: self, options: nil)?.first as! MyBestellungCell
    
            cell.delegate = self
            print(sections, "dfsdfsdfsd")
            if (sections[indexPath.section].expanded){
    
            cell.myItemName.text = "\(bestellung[indexPath.section].items[indexPath.row])"
                cell.myItemMenge.text = "\(bestellung[indexPath.section].preise[indexPath.row])"
            cell.myItemDescription.text = "3"

                self.myBestellungTV.register(UINib.init(nibName: "MyBestellungCell", bundle: nil), forCellReuseIdentifier: "MyBestellungCell")
            return cell
            }
            
            else {
                cell.myItemMengePlus.isHidden = true
                cell.myItemMengeMinus.isHidden = true
                cell.myItemMenge.isHidden = true
                cell.myItemName.isHidden = true
                cell.myItemDescription.isHidden = true
                cell.myEntfernenButton.isHidden = true
                return cell
            }
            
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
    
    // OTHERS
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
    
        if touch?.view != addItemView || touch?.view != myBestellungView  {
            dismissMyBestellungView()
            animateOut()
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.barname = parentPageViewController2.name
        self.baradresse = parentPageViewController2.adresse

        effect = visualEffectView.effect
        visualEffectView.effect = nil
        visualEffectView.bounds = self.bestellungVCView.bounds

        
        addItemView.layer.cornerRadius = 5
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
        getValue()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}



