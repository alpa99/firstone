//
//  BestellungVC2.swift
//  SMOLO
//
//  Created by Ibrahim Akcam on 22.10.17.
//  Copyright © 2017 AM. All rights reserved.
//
import UIKit
import Firebase
import FBSDKLoginKit
import FirebaseAuth
import CoreLocation

protocol BestellungVC2Delegate {
    func reloaddas(sender: Any)
  
}
class BestellungVC2: UIViewController, UITableViewDataSource, UITableViewDelegate, ExpandableHeaderViewDelegate, BestellenCellDelegate, MyBestellungCellDelegate, PageObservation2, CLLocationManagerDelegate, UITextViewDelegate {

    

   
    // VARS
   
    var barname = "NewBar"
    var baradresse = " "
    var tischnummer = 0
    var KellnerID = ""
    var placeholder = "Hier haben Sie Platz für besondere Wünsche. Bitte äußern Sie nur Wünsche bezüglich der Zutaten."
    
    var BestellungKategorien = [String]()
    var BestellungUnterkategorien = [[String]]()
    var BestellungItemsNamen = [[[String]]]()
    var BestellungItemsPreise = [[[Double]]]()
    var BestellungItemsLiter = [[[String]]]()
    var BestellungItemsKommentar = [[[String]]]()
    var BestellungItemsMengen = [[[Int]]]()
    var BestellungItemsExpanded2 = [[Bool]]()
    
    var delegate: bestellenCell2Delegate?
    
    var itemNamen = [String]()
    var itemPreise = [Double]()
    var itemLiter = [String]()
    var verfuegbarkeit = [Bool]()
    
 
    var sections = [ExpandTVSection2]()
    var Kategorien = [String]()
    var Unterkategorien = [String: [String]]()
    var Items = [String: [[String]]]()
    var Preis = [String: [[Double]]]()
    var Liter = [String: [[String]]]()
    var Beschreibung = [String: [[String]]]()
    var Verfuegbarkeit = [String: [[Bool]]]()
    var Expanded = [String: [Bool]]()

    var bestellteItemsDictionary = [bestellungTVSection]()
    var locationManager = CLLocationManager()
    var parentPageViewController2: PageViewController2!
    
    //bestellungTV
    var cellIndexPathSection = 0
    var cellIndexPathRow = 0
    
    //bestellcellTV
    var cellIndexPathSection2 = 0
    var cellIndexPathRow2 = 0
    var i = 1
    
    var effect: UIVisualEffect!
    
    // OUTLETS
    
    @IBOutlet var bestellungVCView: UIView!
    @IBOutlet var addItemView: UIView!
    @IBOutlet weak var KategorieLbl: UILabel!
    @IBOutlet weak var UnterkategorieLbl: UILabel!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var itemPreisLbl: UILabel!
    @IBOutlet weak var itemLiterLbl: UILabel!
    @IBOutlet weak var itemCountLbl: UILabel!
    
    @IBOutlet weak var myBestellungTV: UITableView!
    @IBOutlet weak var bestellungTableView: UITableView!
    @IBOutlet var myBestellungView: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var dismissPopUp: UIButton!
    @IBOutlet weak var aktualisierungAbbrechen: UIButton!
    @IBOutlet weak var myBestellungAbschickenBtn: UIButton!
    
    @IBOutlet weak var kommentarTextView: UITextView!
    
    
    
    // ACTIONS
    
    @IBAction func myBestellungAbschicken(_ sender: Any) {
//        CLGeocoder().geocodeAddressString(baradresse, completionHandler: { (placemarks, error) -> Void in
//            if let placemark = placemarks?[0] {
//
//                let locat = placemark.location
//            //                    let placemarks = placemarks,
//            //                        let locationone = placemarks.first?.location
//
//
//                let distancebar = self.locationManager.location?.distance(from: locat!)
//                print (distancebar!, " entfernung")
//                let distanceint = Int(distancebar!)
//                if distanceint < 150{
//                print("distance ist ok")

                    self.seugueAbschicken()
                    self.handleBestellung()
//                }else{
//                    print ("distance ist nicht ok ")
//                    let alert = UIAlertController(title: "Du befindest dich nicht mehr in der Nähe der Bar", message: nil, preferredStyle: UIAlertControllerStyle.alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//
//                    self.present(alert, animated: true, completion: nil)
//                }
//            }
//
//        })

    }


    @IBAction func dismissPopUp(_ sender: Any) {
        animateOut()
        bestellungaktualisieren()

    }
    
    @IBAction func aktualisierungAbbrechen(_ sender: Any) {
        animateOut()

    }

    @IBAction func dismissMyBestellungView(_ sender: Any) {
        dismissMyBestellungView()
        
    }
    

    // FUNCTIONS
    
    @IBAction func bestellungPrüfen(_ sender: Any) {
        if BestellungKategorien.count != 0{

        for Kategorie in BestellungKategorien {
            let section = BestellungKategorien.index(of: Kategorie)
            setSectionsBestellung(Kategorie: Kategorie, Unterkategorie: BestellungUnterkategorien[section!], items: BestellungItemsNamen[section!], preis: BestellungItemsPreise[section!], liter: BestellungItemsLiter[section!], kommentar: BestellungItemsKommentar[section!], menge: BestellungItemsMengen[section!], expanded2: BestellungItemsExpanded2[section!])
    
        }
        myBestellungTV.reloadData()
            
                self.bestellungVCView.addSubview(visualEffectView)
                visualEffectView.center = self.bestellungVCView.center
                self.bestellungVCView.addSubview(self.myBestellungView)
                self.myBestellungView.center = self.bestellungVCView.center
                self.myBestellungView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
                self.myBestellungView.alpha = 0
                UIView.animate(withDuration: 0.2) {
        
                    self.visualEffectView.effect = self.effect
                    self.myBestellungView.alpha = 1.0
                    self.myBestellungView.transform = CGAffineTransform.identity

            }
        } else {
            let alertKeineBestellung = UIAlertController(title: "Bestellung überprüfen", message: "Deine Bestellung ist leer", preferredStyle: .alert)
            alertKeineBestellung.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertKeineBestellung, animated: true, completion: nil)
        }
    }
    
    
    
    func getKategorien (){
        var datref: DatabaseReference!
        datref = Database.database().reference()
        
        datref.child("Speisekarten").child("\(self.barname)").observeSingleEvent(of: .value, with: { (snapshotKategorie) in
            for key in (snapshotKategorie.children.allObjects as? [DataSnapshot])! {
                
                if !self.Kategorien.contains(key.key) {
                    self.Kategorien.append(key.key)
                    self.getUnterKategorienItems(Kategorie: key.key)
                }
            }
        }, withCancel: nil)
    }
    
    
    func getUnterKategorienItems(Kategorie: String){
        var datref: DatabaseReference!
        datref = Database.database().reference()
        datref.child("Speisekarten").child(self.barname).child(Kategorie).observeSingleEvent(of: .value, with: { (snapshotUnterkategorieItem) in
            
            for key in (snapshotUnterkategorieItem.children.allObjects as? [DataSnapshot])! {
                let snapshotItem = snapshotUnterkategorieItem.childSnapshot(forPath: key.key)
                
                if self.Unterkategorien[Kategorie] != nil {
                    self.Unterkategorien[Kategorie]?.append(key.key)
                    self.Expanded[Kategorie]?.append(false)
                    for items in (snapshotItem.children.allObjects as? [DataSnapshot])!{
                        if let dictionary = items.value as? [String: AnyObject]{
                            let item = SpeisekarteInformation(dictionary: dictionary)
                            var newitems = self.Items[Kategorie]
                            var newpreis = self.Preis[Kategorie]
                            var newliter = self.Liter[Kategorie]
                            var newbeschreibung = self.Beschreibung[Kategorie]
                            var newverfuegbarkeit = self.Verfuegbarkeit[Kategorie]

                            
                            if (self.Items[Kategorie]?.count)! < (self.Unterkategorien[Kategorie]?.count)! {
                                newitems?.append([item.Name!])
                                newpreis?.append([item.Preis!])
                                newliter?.append([item.Liter!])
                                newbeschreibung?.append([item.Beschreibung!])
                                newverfuegbarkeit?.append([item.Verfuegbarkeit!])


                                
                                self.Items[Kategorie] = newitems
                                self.Preis[Kategorie] = newpreis
                                self.Liter[Kategorie] = newliter
                                self.Beschreibung[Kategorie] = newbeschreibung
                                self.Verfuegbarkeit[Kategorie] = newverfuegbarkeit

                                
                                
                            }
                            else {
                                newitems![(self.Unterkategorien[Kategorie]?.index(of: key.key))!].append(item.Name!)
                                self.Items[Kategorie] = newitems
                                newpreis![(self.Unterkategorien[Kategorie]?.index(of: key.key))!].append(item.Preis!)
                                self.Preis[Kategorie] = newpreis
                                newliter![(self.Unterkategorien[Kategorie]?.index(of: key.key))!].append(item.Liter!)
                                self.Liter[Kategorie] = newliter
                                newbeschreibung![(self.Unterkategorien[Kategorie]?.index(of: key.key))!].append(item.Beschreibung!)
                                self.Beschreibung[Kategorie] = newbeschreibung
                                newverfuegbarkeit![(self.Unterkategorien[Kategorie]?.index(of: key.key))!].append(item.Verfuegbarkeit!)
                                self.Verfuegbarkeit[Kategorie] = newverfuegbarkeit
                                
                            }
                            
                            
                        }
                        
                    }
                    
                } else {
                    
                    self.Unterkategorien.updateValue([key.key], forKey: Kategorie)
                    self.Expanded.updateValue([false], forKey: Kategorie)
                    
                    for items in (snapshotItem.children.allObjects as? [DataSnapshot])!{
                        if let dictionary = items.value as? [String: AnyObject]{
                            let item = SpeisekarteInformation(dictionary: dictionary)
                            
                            if self.Items[Kategorie] != nil{
                                var newItems = self.Items[Kategorie]
                                newItems![(self.Unterkategorien[Kategorie]?.index(of: key.key))!].append(item.Name!)
                                self.Items[Kategorie] = newItems
                                
                                var newPreis = self.Preis[Kategorie]
                                newPreis![(self.Unterkategorien[Kategorie]?.index(of: key.key))!].append(item.Preis!)
                                self.Preis[Kategorie] = newPreis
                                
                                var newLiter = self.Liter[Kategorie]
                                newLiter![(self.Unterkategorien[Kategorie]?.index(of: key.key))!].append(item.Liter!)
                                self.Liter[Kategorie] = newLiter
                                var newBeschreibung = self.Beschreibung[Kategorie]
                                newBeschreibung![(self.Unterkategorien[Kategorie]?.index(of: key.key))!].append(item.Beschreibung!)
                                self.Beschreibung[Kategorie] = newBeschreibung
                                var newVerfuegbarkeit = self.Verfuegbarkeit[Kategorie]
                                newVerfuegbarkeit![(self.Unterkategorien[Kategorie]?.index(of: key.key))!].append(item.Verfuegbarkeit!)
                                self.Verfuegbarkeit[Kategorie] = newVerfuegbarkeit
                                
                            } else {
                                self.Items.updateValue([[item.Name!]], forKey: Kategorie)
                                self.Preis.updateValue([[item.Preis!]], forKey: Kategorie)
                                self.Liter.updateValue([[item.Liter!]], forKey: Kategorie)
                                self.Beschreibung.updateValue([[item.Beschreibung!]], forKey: Kategorie)
                                self.Verfuegbarkeit.updateValue([[item.Verfuegbarkeit!]], forKey: Kategorie)

                                
                                
                            }
                            
                        }
                        
                    }
                }
            }
            
            if self.Unterkategorien.count == self.Kategorien.count {

                for kategorie in self.Kategorien {
                    self.setSectionsSpeisekarte(Kategorie: kategorie, Unterkategorie: self.Unterkategorien[kategorie]!, items: self.Items[kategorie]!, preis: self.Preis[kategorie]!, liter: self.Liter[kategorie]!, beschreibung: self.Beschreibung[kategorie]!, verfuegbarkeit:  self.Verfuegbarkeit[kategorie]!, expanded2: self.Expanded[kategorie]!)
                }
                print(self.sections, "sections")
            }
            
            
        }, withCancel: nil)
        
        
    }
    
    


    func seugueAbschicken(){

        performSegue(withIdentifier: "wirdabgeschickt", sender: self)
    }
    
    

    func handleBestellung(){
        var ref: DatabaseReference!

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let DayOne = formatter.date(from: "2018/05/15 12:00")
        let timestamp = Double(NSDate().timeIntervalSince(DayOne!))

        let fromUserID = Auth.auth().currentUser?.uid
        let values = ["Barname": barname ,"toKellnerID": KellnerID, "tischnummer": "\(tischnummer)", "fromUserID": fromUserID! , "timeStamp": timestamp, "Status": "versendet"] as [String : Any]
        let userRef = Database.database().reference().child("Users").child(fromUserID!)
        userRef.updateChildValues(["akutelleBar" : barname, "letzteBestellungZeit": timestamp])

            ref = Database.database().reference().child("Bestellungen").child(barname)
        
            let childRef = ref?.childByAutoId()

        for Bestellung in self.bestellteItemsDictionary {
            let Unterkategorien = Bestellung.Unterkategorie

            for Unterkategorie in Bestellung.Unterkategorie {
                let UnterkategorieSection = Unterkategorien.index(of: Unterkategorie)
                var items = Bestellung.items[UnterkategorieSection!]
                var mengen = Bestellung.menge[UnterkategorieSection!]
                var preise = Bestellung.preis[UnterkategorieSection!]
                var kommentar = Bestellung.kommentar[UnterkategorieSection!]
                
                for i in 0 ..< items.count {
                 
                    let bestellungName = ["Name": items[i]]
                    let bestellungMenge = ["Menge": mengen[i]]
                    let bestellungPreis = ["Preis": preise[i]]
                    let bestellungKommentar = ["Kommentar": kommentar[i]]
                    if i > 0 && items[i] == items[i-1]{
                        childRef?.child(Bestellung.Kategorie).child(Unterkategorie).child(items[i]+"\(i)").updateChildValues(bestellungName)
                        childRef?.child(Bestellung.Kategorie).child(Unterkategorie).child(items[i]+"\(i)").updateChildValues(bestellungMenge)
                        childRef?.child(Bestellung.Kategorie).child(Unterkategorie).child(items[i]+"\(i)").updateChildValues(bestellungPreis)
                        childRef?.child(Bestellung.Kategorie).child(Unterkategorie).child(items[i]+"\(i)").updateChildValues(bestellungKommentar)

                    } else {
                        childRef?.child(Bestellung.Kategorie).child(Unterkategorie).child(items[i]).updateChildValues(bestellungName)
                        childRef?.child(Bestellung.Kategorie).child(Unterkategorie).child(items[i]).updateChildValues(bestellungMenge)
                        childRef?.child(Bestellung.Kategorie).child(Unterkategorie).child(items[i]).updateChildValues(bestellungPreis)
                        childRef?.child(Bestellung.Kategorie).child(Unterkategorie).child(items[i]).updateChildValues(bestellungKommentar)
                    }

                }

            }

        }
        
            childRef?.child("Information").updateChildValues(values)
        let userBestellungenRef = Database.database().reference().child("userBestellungen").child(fromUserID!)
        let userProfil = Database.database().reference().child("Users").child(fromUserID!)
        let bestellungID = childRef?.key
        
            userBestellungenRef.child(bestellungID!).updateChildValues(["BestellungsID": bestellungID!, "abgeschlossen": false])
            userBestellungenRef.child(bestellungID!).updateChildValues(values)
        userProfil.updateChildValues(["aktuelleBar" : barname, "aktuellerTisch": tischnummer, "letzteBestellungZeit": timestamp])
    

            let kellnerBestellungenRef = Database.database().reference().child("userBestellungen").child(KellnerID)
        kellnerBestellungenRef.child(bestellungID!).updateChildValues(["Status": "versendet", "fromUserID": fromUserID!, "tischnummer": "\(tischnummer)"] )

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
        itemCountLbl.text = "1"
        

        addItemView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        addItemView.alpha = 0
        UIView.animate(withDuration: 0.2) {
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
            self.kommentarTextView.text = self.placeholder
            self.kommentarTextView.textColor = UIColor.white
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
        bestellteItemsDictionary.removeAll()

        
    }
    func getParentPageViewController2(parentRef2: PageViewController2) {
        parentPageViewController2 = parentRef2
    }
    
    
    
    // TABLEVIEW FUNCTIONS
    
    func setSectionsSpeisekarte(Kategorie: String, Unterkategorie: [String], items: [[String]], preis: [[Double]], liter: [[String]], beschreibung: [[String]], verfuegbarkeit: [[Bool]],  expanded2: [Bool]){
        self.sections.append(ExpandTVSection2(Kategorie: Kategorie, Unterkategorie: Unterkategorie, items: items, preis: preis, liter: liter, beschreibung: beschreibung, verfuegbarkeit:  verfuegbarkeit, expanded2: expanded2, expanded: false))
        self.bestellungTableView.reloadData()
    }
    
    func setSectionsBestellung(Kategorie: String, Unterkategorie: [String], items: [[String]], preis: [[Double]], liter: [[String]], kommentar: [[String]], menge: [[Int]], expanded2: [Bool]){
        self.bestellteItemsDictionary
            .append(bestellungTVSection(Kategorie: Kategorie, Unterkategorie: Unterkategorie, items: items, preis: preis, liter: liter, kommentar: kommentar, menge: menge, expanded2: expanded2, expanded: true))
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        var numberOfSections: Int?
        if tableView == bestellungTableView{
            numberOfSections = sections.count
        }
        if tableView == myBestellungTV{
            numberOfSections = bestellteItemsDictionary.count
        }
        
        
        return numberOfSections!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var heightForHeaderInSection: Int?
        if tableView == bestellungTableView{
            heightForHeaderInSection = 36        }
        if tableView == myBestellungTV{
            heightForHeaderInSection = 36        }
        return CGFloat(heightForHeaderInSection!)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        var heightForRowAt: Int?
        if tableView == bestellungTableView{
            if (sections[indexPath.section].expanded) {

                heightForRowAt = (sections[indexPath.section].Unterkategorie.count*60)
                for expandend in sections[indexPath.section].expanded2 {
                    if expandend == true {
                        heightForRowAt = heightForRowAt! + sections[indexPath.section].items[indexPath.row].count*36
                    }
                }

            }
            else {
                heightForRowAt = 0
            }

        }

        if tableView == myBestellungTV{
            if (bestellteItemsDictionary[indexPath.section].expanded) {
                heightForRowAt = (bestellteItemsDictionary[indexPath.section].Unterkategorie.count*60)
                for expandend in bestellteItemsDictionary[indexPath.section].expanded2 {
                    if expandend == true {
                        heightForRowAt = heightForRowAt! + bestellteItemsDictionary[indexPath.section].items[indexPath.row].count*149
                    }
                }
                
            }
            else {
                heightForRowAt = 0
            }

        }


        return CGFloat(heightForRowAt!)

    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        var heightForFooterInSection: Int?
        if tableView == bestellungTableView{
        
            heightForFooterInSection = 15
        }
        
        if tableView == myBestellungTV{
            heightForFooterInSection = 15
        }
        
        return CGFloat(heightForFooterInSection!)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let header = ExpandableHeaderView()
        header.contentView.layer.cornerRadius = 5
        header.contentView.layer.backgroundColor = UIColor.clear.cgColor

        header.layer.cornerRadius = 5
        header.layer.backgroundColor = UIColor.clear.cgColor
        
        
        
        if tableView == bestellungTableView{
            header.customInit(tableView: tableView, title: sections[section].Kategorie, section: section, delegate: self as ExpandableHeaderViewDelegate)
        }
        if tableView == myBestellungTV{
            header.customInit(tableView: tableView, title: bestellteItemsDictionary[section].Kategorie, section: section, delegate: self as ExpandableHeaderViewDelegate)
        }
        
        
        
        return header
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        if tableView == bestellungTableView {
            let cell = Bundle.main.loadNibNamed("BestellenCell", owner: self, options: nil)?.first as! BestellenCell
            
            cell.backgroundColor = UIColor.clear
            
            cell.unterkategorien = sections
            cell.items = sections[indexPath.section].items
            cell.preise = sections[indexPath.section].preis
            cell.liters = sections[indexPath.section].liter
            
            cell.cellIndexPathSection = indexPath.section

            cell.delegate = self
            cellIndexPathRow = indexPath.row
            cellIndexPathSection = indexPath.section
            return cell

        }
        
        else {
             let cell = Bundle.main.loadNibNamed("MyBestellungCell", owner: self, options: nil)?.first as! MyBestellungCell
            cell.delegate = self
            cell.bestellteItemsDictionary = bestellteItemsDictionary
            cell.sections = indexPath.section
            
            return cell

        }
    
    }
    

    func toggleSection(tableView: UITableView, header: ExpandableHeaderView, section: Int) {
        if tableView == bestellungTableView {
        
        for i in 0..<sections.count{
            if i == section {
                sections[section].expanded = !sections[section].expanded
            } else {
                sections[i].expanded = false

            }
        }
        
        
            bestellungTableView.beginUpdates()
        bestellungTableView.reloadRows(at: [IndexPath(row: 0, section: section)], with: .automatic)
        
            bestellungTableView.endUpdates()
        }
        
//        if tableView == myBestellungTV {
//
//            for i in 0..<bestellteItemsDictionary.count{
//                if i == section {
//                    bestellteItemsDictionary[section].expanded = !bestellteItemsDictionary[section].expanded
//                } else {
//                    bestellteItemsDictionary[i].expanded = false
//
//                }
//            }
//
//            myBestellungTV.beginUpdates()
//            myBestellungTV.reloadRows(at: [IndexPath(row: 0, section: section)], with: .automatic)
//
//            myBestellungTV.endUpdates()
//        }

    }
    
    // OTHERS
    
    func reloadUnterkategorie(sender: BestellenCell) {
        sections = sender.unterkategorien
        bestellungTableView.beginUpdates()
        bestellungTableView.reloadRows(at: [IndexPath(row: 0, section: sender.cellIndexPathSection)], with: .automatic)
        
        bestellungTableView.endUpdates()
        
    }
    
    func pass(sender: BestellenCell) {
        itemNamen = sections[cellIndexPathSection].items[sender.section2]
        itemPreise = sections[cellIndexPathSection].preis[sender.section2]
        itemLiter = sections[cellIndexPathSection].liter[sender.section2]
        verfuegbarkeit = sections[cellIndexPathSection].verfuegbarkeit[sender.section2]
        KategorieLbl.text = sections[cellIndexPathSection].Kategorie
        UnterkategorieLbl.text = sections[cellIndexPathSection].Unterkategorie[sender.section2]
        
        if verfuegbarkeit[sender.row2] {
        if itemNamen[sender.row2] == "Tabakmix" {
            print(itemNamen[sender.row2], "MISCHEN")
        } else {
        let preisFormat = String(format: "%.2f", arguments: [itemPreise[sender.row2]])
        itemPreisLbl.text = preisFormat
        itemNameLbl.text = itemNamen[sender.row2]
        if itemLiter[sender.row2] != "0.0l" {
            itemLiterLbl.isHidden = false
            itemLiterLbl.text = itemLiter[sender.row2]
        } else {
            itemLiterLbl.text = "0.0l"
            itemLiterLbl.isHidden = true
        }
        animateIn()
            }
        } else {
            let alertKeineBestellung = UIAlertController(title: "nicht Verfügbar", message: "Es tut uns Leid. Dieses Produkt ist derzeit nicht Verfügbar.", preferredStyle: .alert)
            alertKeineBestellung.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertKeineBestellung, animated: true, completion: nil)

        }
    }
    
    
    func bestellungaktualisieren(){
        if i > 0{
            
            // kategorie gibt es nicht
            if !BestellungKategorien.contains(KategorieLbl.text!){
                BestellungKategorien.append(KategorieLbl.text!)
                BestellungUnterkategorien.append([UnterkategorieLbl.text!])
                BestellungItemsNamen.append([[itemNameLbl.text!]])
                BestellungItemsPreise.append([[Double(itemPreisLbl.text!)!]])
                BestellungItemsLiter.append([[itemLiterLbl.text!]])
                BestellungItemsMengen.append([[Int(itemCountLbl.text!)!]])
                if kommentarTextView.text == placeholder || kommentarTextView.text == "" {
                    BestellungItemsKommentar.append([["kein Kommentar"]])
                } else {
                    BestellungItemsKommentar.append([[kommentarTextView.text!]]) }
                BestellungItemsExpanded2.append([true])
                
                //"kat, ukat, i gibt es nicht"
                // kategorie gibt es
            } else {
                // unterkategorie gibt es nicht
                if !BestellungUnterkategorien[BestellungKategorien.index(of: KategorieLbl.text!)!].contains(UnterkategorieLbl.text!) {
                    BestellungUnterkategorien[BestellungKategorien.index(of: KategorieLbl.text!)!].append(UnterkategorieLbl.text!)
                    BestellungItemsNamen[BestellungKategorien.index(of: KategorieLbl.text!)!].append([itemNameLbl.text!])
                    BestellungItemsPreise[BestellungKategorien.index(of: KategorieLbl.text!)!].append([Double(itemPreisLbl.text!)!])
                    BestellungItemsLiter[BestellungKategorien.index(of: KategorieLbl.text!)!].append([itemLiterLbl.text!])
                    if kommentarTextView.text == placeholder || kommentarTextView.text == "" {
                        BestellungItemsKommentar[BestellungKategorien.index(of: KategorieLbl.text!)!].append(["kein Kommentar"])
                    } else {
                        BestellungItemsKommentar[BestellungKategorien.index(of: KategorieLbl.text!)!].append([kommentarTextView.text!])

                    }
                    BestellungItemsMengen[BestellungKategorien.index(of: KategorieLbl.text!)!].append([Int(itemCountLbl.text!)!])
                    BestellungItemsExpanded2[BestellungKategorien.index(of: KategorieLbl.text!)!].append(true)
                    
                    // ukat, i gibt es nicht"
                    
                } else {
                    // item gibt es nicht
                    var itemsNamenInSection = BestellungItemsNamen[BestellungKategorien.index(of: KategorieLbl.text!)!]
                    var itemsPreiseInSection = BestellungItemsPreise[BestellungKategorien.index(of: KategorieLbl.text!)!]
                    var itemsLiterInSection = BestellungItemsLiter[BestellungKategorien.index(of: KategorieLbl.text!)!]
                    var itemsKommentarInSection = BestellungItemsKommentar[BestellungKategorien.index(of: KategorieLbl.text!)!]
                    var itemsMengenInSection = BestellungItemsMengen[BestellungKategorien.index(of: KategorieLbl.text!)!]
                    let unterkategorie = BestellungUnterkategorien[BestellungKategorien.index(of: KategorieLbl.text!)!]
                    
//                    if !itemsNamenInSection[unterkategorie.index(of: UnterkategorieLbl.text!)!].contains(itemNameLbl.text!) {
                    
                        itemsNamenInSection[unterkategorie.index(of: UnterkategorieLbl.text!)!].append(itemNameLbl.text!)
                        BestellungItemsNamen[BestellungKategorien.index(of: KategorieLbl.text!)!] = itemsNamenInSection
                        
                        itemsPreiseInSection[unterkategorie.index(of: UnterkategorieLbl.text!)!].append(Double(itemPreisLbl.text!)!)
                        BestellungItemsPreise[BestellungKategorien.index(of: KategorieLbl.text!)!] = itemsPreiseInSection
                        
                        itemsLiterInSection[unterkategorie.index(of: UnterkategorieLbl.text!)!].append(itemLiterLbl.text!)
                        BestellungItemsLiter[BestellungKategorien.index(of: KategorieLbl.text!)!] = itemsLiterInSection
                    
                    if kommentarTextView.text == placeholder || kommentarTextView.text == "" {
                        itemsKommentarInSection[unterkategorie.index(of: UnterkategorieLbl.text!)!].append("kein Kommentar")
                    } else {
                        itemsKommentarInSection[unterkategorie.index(of: UnterkategorieLbl.text!)!].append(kommentarTextView.text!)

                    }
                        BestellungItemsKommentar[BestellungKategorien.index(of: KategorieLbl.text!)!] = itemsKommentarInSection
                        
                        itemsMengenInSection[unterkategorie.index(of: UnterkategorieLbl.text!)!].append(Int(itemCountLbl.text!)!)
                        BestellungItemsMengen[BestellungKategorien.index(of: KategorieLbl.text!)!] = itemsMengenInSection
                        
                        
//                    } else {
//                        let ItemNameInRow = itemsNamenInSection[unterkategorie.index(of: UnterkategorieLbl.text!)!].index(of: itemNameLbl.text!)
//                        var ItemMengeInRow = itemsMengenInSection[unterkategorie.index(of: UnterkategorieLbl.text!)!]
//                        ItemMengeInRow[ItemNameInRow!] = Int(itemCountLbl.text!)!
//                        itemsMengenInSection[unterkategorie.index(of: UnterkategorieLbl.text!)!] = ItemMengeInRow
//                        BestellungItemsMengen[BestellungKategorien.index(of: KategorieLbl.text!)!] = itemsMengenInSection
//                        // hier weiter machen
//                        // item gibt es
//
//                    }
                }
            }

            itemNamen.removeAll()
            itemPreise.removeAll()
            itemLiter.removeAll()
            
        }
        print(BestellungItemsNamen, "item")
        print(BestellungItemsKommentar, "kommi")
        i = 1
    }
    
    
    func passItemPlus(sender: MyBestellungCell) {
        
        let i = 1
        var mengeInSection = bestellteItemsDictionary[sender.sections].menge
        var newmengeInSection = mengeInSection[sender.sections2]
        newmengeInSection[sender.rows2] = newmengeInSection[sender.rows2] + i
        mengeInSection[sender.sections2] = newmengeInSection
        BestellungItemsMengen[sender.sections] = mengeInSection
        bestellteItemsDictionary[sender.sections].menge = mengeInSection
        myBestellungTV.reloadData()
        
    }
    
    func passItemMinus(sender: MyBestellungCell) {
        var mengeInSection = bestellteItemsDictionary[sender.sections].menge
        
        var newmengeInSection = mengeInSection[sender.sections2]
        let i = 1
        if newmengeInSection[sender.rows2] > 1{
            newmengeInSection[sender.rows2] = newmengeInSection[sender.rows2] - i
            mengeInSection[sender.sections2] = newmengeInSection
            BestellungItemsMengen[sender.sections] = mengeInSection
            bestellteItemsDictionary[sender.sections].menge = mengeInSection
            myBestellungTV.reloadData()
        }
        
        
    }
    
    
    
    
    
    func passItemEntfernen(sender: MyBestellungCell) {
        var itemsInSection = bestellteItemsDictionary[sender.sections].items
        var preisInSection = bestellteItemsDictionary[sender.sections].preis
        var literInSection = bestellteItemsDictionary[sender.sections].liter
        var mengeInSection = bestellteItemsDictionary[sender.sections].menge
        var newitemsInSection = itemsInSection[sender.sections2]
        var newpreisInSection = preisInSection[sender.sections2]
        var newliterInSection = literInSection[sender.sections2]
        var newmengeInSection = mengeInSection[sender.sections2]
        
        newitemsInSection.remove(at: sender.rows2)
        newliterInSection.remove(at: sender.rows2)
        newpreisInSection.remove(at: sender.rows2)
        newmengeInSection.remove(at: sender.rows2)
        
        if newitemsInSection.count != 0{
            
            itemsInSection[sender.sections2] = newitemsInSection
            preisInSection[sender.sections2] = newpreisInSection
            literInSection[sender.sections2] = newliterInSection
            mengeInSection[sender.sections2] = newmengeInSection
            BestellungItemsNamen[sender.sections] = itemsInSection
            BestellungItemsPreise[sender.sections] = preisInSection
            BestellungItemsLiter[sender.sections] = literInSection
            BestellungItemsMengen[sender.sections] = mengeInSection
            bestellteItemsDictionary[sender.sections].items = itemsInSection
            bestellteItemsDictionary[sender.sections].preis = preisInSection
            bestellteItemsDictionary[sender.sections].liter = literInSection
            bestellteItemsDictionary[sender.sections].menge = mengeInSection
            
        }  else {
            
            BestellungItemsNamen[sender.sections].remove(at: sender.sections2)
            BestellungItemsPreise[sender.sections].remove(at: sender.sections2)
            BestellungItemsLiter[sender.sections].remove(at: sender.sections2)
            BestellungItemsMengen[sender.sections].remove(at: sender.sections2)
            BestellungUnterkategorien[sender.sections].remove(at: sender.sections2)
            BestellungItemsExpanded2[sender.sections].remove(at: sender.sections2)
            
            
            bestellteItemsDictionary[sender.sections].items.remove(at: sender.sections2)
            bestellteItemsDictionary[sender.sections].preis.remove(at: sender.sections2)
            bestellteItemsDictionary[sender.sections].liter.remove(at: sender.sections2)
            bestellteItemsDictionary[sender.sections].menge.remove(at: sender.sections2)
            bestellteItemsDictionary[sender.sections].Unterkategorie.remove(at: sender.sections2)
            bestellteItemsDictionary[sender.sections].expanded2.remove(at: sender.sections2)
            
            
            if bestellteItemsDictionary[sender.sections].Unterkategorie.count == 0{
                bestellteItemsDictionary.remove(at: sender.sections)
                BestellungKategorien.remove(at: sender.sections)
                BestellungItemsNamen.remove(at: sender.sections)
                BestellungItemsMengen.remove(at: sender.sections)
                BestellungItemsLiter.remove(at: sender.sections)
                BestellungItemsPreise.remove(at: sender.sections)
                BestellungUnterkategorien.remove(at: sender.sections)
                BestellungItemsExpanded2.remove(at: sender.sections)
                
                
                if bestellteItemsDictionary.count == 0 {
                    dismissMyBestellungView()
                    
                }
            }
        }
        sender.bestellteItemsDictionary = bestellteItemsDictionary
        myBestellungTV.reloadData()
    
    }

    func passKommentarAendern(sender: MyBestellungCell) {
        var kommentarInSection = bestellteItemsDictionary[sender.sections].kommentar
        
        var newKommentarInSection = kommentarInSection[sender.sections2]
            newKommentarInSection[sender.rows2] = sender.kommenar
            kommentarInSection[sender.sections2] = newKommentarInSection
            BestellungItemsKommentar[sender.sections] = kommentarInSection
            bestellteItemsDictionary[sender.sections].kommentar = kommentarInSection
            myBestellungTV.reloadData()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if self.view.subviews.contains(addItemView) {
            self.view.endEditing(true)
        }
        if touch?.view != addItemView && touch?.view != myBestellungView {
            dismissMyBestellungView()
            animateOut()
        }
        
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.kommentarTextView.textColor = .black
        self.kommentarTextView.text = ""
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" { textView.resignFirstResponder()
            return false
        }
        
        return true
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        kommentarTextView.delegate = self
        kommentarTextView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
        kommentarTextView.textColor = .white
        kommentarTextView.text = placeholder
        bestellungTableView.reloadData()
        addItemView.backgroundColor = UIColor(patternImage: UIImage(named: "hintergrund")!)
        myBestellungView.backgroundColor = UIColor(patternImage: UIImage(named: "hintergrund")!)
        self.barname = parentPageViewController2.name
        self.baradresse = parentPageViewController2.adresse
        self.tischnummer = parentPageViewController2.tischnummer
        self.KellnerID = parentPageViewController2.KellnerID

        effect = visualEffectView.effect
        visualEffectView.effect = nil
        visualEffectView.bounds = self.bestellungVCView.bounds


        addItemView.layer.cornerRadius = 5
//
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.delegate = self
        
        getKategorien()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


