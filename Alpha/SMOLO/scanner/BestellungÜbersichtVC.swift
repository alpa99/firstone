//
//  MeineBestellungVC.swift
//  SMOLO
//
//  Created by Ibrahim Akcam on 23.01.19.
//  Copyright © 2019 AM. All rights reserved.
//

import UIKit
import Firebase

protocol BestellungÜbersichtDelegate {
    func passChanges(Kategorien: [String], Unterkategorien: [[String]], ItemsNamen: [[[String]]],ItemsPreise: [[[Double]]], ItemsLiter: [[[String]]], ItemsKommentar: [[[String]]], ItemsMenge: [[[Int]]], ItemsExpanded2: [[Bool]], ExtrasName: [[[[String]]]], ExtrasPreise: [[[[Double]]]])
}

class BestellungÜbersichtVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, MyBestellungCellDelegate, ExpandableHeaderViewDelegate, UITextFieldDelegate {
    
    var test = "geht?"
    var bestellteItemsDictionary = [bestellungTVSection]()
    var Kategorie = String()
    var Extras = [String: [String]]()
    var ExtrasPreise = [String: [Double]]()
    var barname = "NewBar"
    var baradresse = " "
    var tischnummer = 0
    var KellnerID = ""
    
    var BestellungKategorien = [String]()
    var BestellungUnterkategorien = [[String]]()
    var BestellungItemsNamen = [[[String]]]()
    var BestellungItemsPreise = [[[Double]]]()
    var BestellungItemsLiter = [[[String]]]()
    var BestellungItemsKommentar = [[[String]]]()
    var BestellungItemsMengen = [[[Int]]]()
    var BestellungItemsExpanded2 = [[Bool]]()
    var BestellungExtrasName = [[[[String]]]]()
    var BestellungExtrasPreise = [[[[Double]]]]()
    var ItemsPreis = [Double]()
    var ItemsMenge = [Double]()
    var ExtraPreis = [Double]()
    var gesamtpreislabel = 0.0

    
    var delegate: BestellungÜbersichtDelegate?
    
    @IBOutlet weak var uebersichtTV: UITableView!
    
    @IBOutlet weak var gesamtPreisLbl: UILabel!
    
    @IBAction func abschicken(_ sender: Any) {
        let alertKeineBestellung = UIAlertController(title: "Bestellung abschicken", message: "Bist du dir Sicher? Es gibt kein zurück.", preferredStyle: .alert)
        alertKeineBestellung.addAction(UIAlertAction(title: "Abschicken", style: .default, handler: { (UIAlertAction) in
            print("ok")
            self.handleBestellung()
        }))
        alertKeineBestellung.addAction(UIAlertAction(title: "Abbrechen", style: .default, handler: { (UIAlertAction) in
            print("abbrechen")
        }))
        // segue und handleBestellung fehlen
        self.present(alertKeineBestellung, animated: true, completion: nil)
    }
    
    func toggleSection(tableView: UITableView, header: ExpandableHeaderView, section: Int) {
        print(section, "hallo")
        
    }
    
    func passItemEntfernen(sender: MyBestellungCell) {
        print(sender.Cell1Section, "Cell1Section")
        print(bestellteItemsDictionary, sender.sections, sender.sections2, sender.rows2, BestellungItemsNamen)
//        var kategorieInSection = bestellteItemsDictionary[sender.sections].Kategorie
        var unterkategorieInSection = bestellteItemsDictionary[sender.Cell1Section].Unterkategorie
//        var expandedInSection = bestellteItemsDictionary[sender.sections].expanded
//        var expanded2InSection = bestellteItemsDictionary[sender.sections].expanded2
        var itemsInSection = bestellteItemsDictionary[sender.Cell1Section].items
        var preisInSection = bestellteItemsDictionary[sender.Cell1Section].preis
        var literInSection = bestellteItemsDictionary[sender.Cell1Section].liter
        var mengeInSection = bestellteItemsDictionary[sender.Cell1Section].menge
        var kommentarInSection = bestellteItemsDictionary[sender.Cell1Section].kommentar
        var extrasInSection = bestellteItemsDictionary[sender.Cell1Section].extras
        var extrasPreiseInSection = bestellteItemsDictionary[sender.Cell1Section].extrasPreise
        print(sender.sections, sender.sections2, sender.rows, sender.rows2, "was ist richtig?")
        print(itemsInSection, 32456543)
        
        var newunterkategorieInSection = unterkategorieInSection[sender.sections2]
        var newitemsInSection = itemsInSection[sender.sections2]
        var newpreisInSection = preisInSection[sender.sections2]
        var newliterInSection = literInSection[sender.sections2]
        var newmengeInSection = mengeInSection[sender.sections2]
        var newKommentarInSection = kommentarInSection[sender.sections2]
        var newextrasInSection = extrasInSection[sender.sections2]
        var newextrasPreiseInSection = extrasPreiseInSection[sender.sections2]

        
//        var newkategorieInSection = kategorieInSection
//        var newexpandedInSection = expandedInSection
//        var newexpanded2InSection = expanded2InSection[sender.sections2]

        print(newitemsInSection, "test 101")
        print(newunterkategorieInSection, "test 102")
        
        newitemsInSection.remove(at: sender.rows2)
        newliterInSection.remove(at: sender.rows2)
        newpreisInSection.remove(at: sender.rows2)
        newmengeInSection.remove(at: sender.rows2)
        newKommentarInSection.remove(at: sender.rows2)
        newextrasInSection.remove(at: sender.rows2)
        newextrasPreiseInSection.remove(at: sender.rows2)
        
        print(newitemsInSection, "test 201")
        print(newunterkategorieInSection, "test 202")

        
        if newitemsInSection.count != 0{
            print("if")
            itemsInSection[sender.sections2] = newitemsInSection
            preisInSection[sender.sections2] = newpreisInSection
            literInSection[sender.sections2] = newliterInSection
            mengeInSection[sender.sections2] = newmengeInSection
            kommentarInSection[sender.sections2] = newKommentarInSection
            extrasInSection[sender.sections2] = newextrasInSection
            extrasPreiseInSection[sender.sections2] = newextrasPreiseInSection
            
            BestellungItemsNamen[sender.Cell1Section] = itemsInSection
            BestellungItemsPreise[sender.Cell1Section] = preisInSection
            BestellungItemsLiter[sender.Cell1Section] = literInSection
            BestellungItemsMengen[sender.Cell1Section] = mengeInSection
            BestellungItemsKommentar[sender.Cell1Section] = kommentarInSection
            BestellungExtrasName[sender.Cell1Section] = extrasInSection
            BestellungExtrasPreise[sender.Cell1Section] = extrasPreiseInSection
            
            bestellteItemsDictionary[sender.Cell1Section].items = itemsInSection
            bestellteItemsDictionary[sender.Cell1Section].preis = preisInSection
            bestellteItemsDictionary[sender.Cell1Section].liter = literInSection
            bestellteItemsDictionary[sender.Cell1Section].menge = mengeInSection
            bestellteItemsDictionary[sender.Cell1Section].kommentar = kommentarInSection
            bestellteItemsDictionary[sender.Cell1Section].extras = extrasInSection
            bestellteItemsDictionary[sender.Cell1Section].extrasPreise = extrasPreiseInSection
            
        }  else {
            unterkategorieInSection.remove(at: sender.sections2)
            print(BestellungItemsNamen, sender.sections, sender.sections2, sender.rows, sender.rows2, sender.Cell1Section, "ELSE 1")
            
            var newBestellungNamen = BestellungItemsNamen[sender.Cell1Section]
            var newBestellungPreise = BestellungItemsPreise[sender.Cell1Section]
            var newBestellungLiter = BestellungItemsLiter[sender.Cell1Section]
            var newBestellungMengen = BestellungItemsMengen[sender.Cell1Section]
            var newBestellungKommentar = BestellungItemsKommentar[sender.Cell1Section]
            var newBestellungExtrasName = BestellungExtrasName[sender.Cell1Section]
            var newBestellungExtrasPreise = BestellungExtrasPreise[sender.Cell1Section]
            var newBestellungExpanded2 = BestellungItemsExpanded2[sender.Cell1Section]
            
            newBestellungNamen.remove(at: sender.sections2)
            newBestellungPreise.remove(at: sender.sections2)
            newBestellungLiter.remove(at: sender.sections2)
            newBestellungMengen.remove(at: sender.sections2)
            newBestellungKommentar.remove(at: sender.sections2)
            newBestellungExtrasName.remove(at: sender.sections2)
            newBestellungExtrasPreise.remove(at: sender.sections2)
            newBestellungExpanded2.remove(at: sender.sections2)
            
            BestellungItemsNamen[sender.Cell1Section] = newBestellungNamen
            BestellungItemsPreise[sender.Cell1Section] = newBestellungPreise
            BestellungItemsLiter[sender.Cell1Section] = newBestellungLiter
            BestellungItemsMengen[sender.Cell1Section] = newBestellungMengen
            BestellungItemsKommentar[sender.Cell1Section] = newBestellungKommentar
            BestellungExtrasName[sender.Cell1Section] = newBestellungExtrasName
            BestellungExtrasPreise[sender.Cell1Section] = newBestellungExtrasPreise
            BestellungItemsExpanded2[sender.Cell1Section] = newBestellungExpanded2
            BestellungUnterkategorien[sender.Cell1Section].remove(at: sender.sections2)
        
            
            print(BestellungItemsNamen, "ELSE 1")

            print(bestellteItemsDictionary[sender.Cell1Section].items, "ELSE 2")

            bestellteItemsDictionary[sender.Cell1Section].items.remove(at: sender.sections2)
            bestellteItemsDictionary[sender.Cell1Section].preis.remove(at: sender.sections2)
            bestellteItemsDictionary[sender.Cell1Section].liter.remove(at: sender.sections2)
            bestellteItemsDictionary[sender.Cell1Section].menge.remove(at: sender.sections2)
            bestellteItemsDictionary[sender.Cell1Section].expanded2.remove(at: sender.sections2)
            bestellteItemsDictionary[sender.Cell1Section].Unterkategorie = unterkategorieInSection
            bestellteItemsDictionary[sender.Cell1Section].kommentar.remove(at: sender.sections2)
            bestellteItemsDictionary[sender.Cell1Section].extras.remove(at: sender.sections2)
            bestellteItemsDictionary[sender.Cell1Section].extrasPreise.remove(at: sender.sections2)
        
            print(bestellteItemsDictionary[sender.Cell1Section].items, "ELSE 2")

            
            if bestellteItemsDictionary[sender.Cell1Section].Unterkategorie.count == 0{
                print(bestellteItemsDictionary, BestellungKategorien, sender.sections, "ELSE 3")
                print(BestellungItemsNamen, sender.sections, sender.sections2, sender.rows, sender.rows2, "namen")
                bestellteItemsDictionary.remove(at: sender.Cell1Section)
                BestellungKategorien.remove(at: sender.Cell1Section)
                BestellungItemsNamen.remove(at: sender.Cell1Section)
                BestellungItemsPreise.remove(at: sender.Cell1Section)
                BestellungItemsLiter.remove(at: sender.Cell1Section)
                BestellungItemsMengen.remove(at: sender.Cell1Section)
                BestellungItemsKommentar.remove(at: sender.Cell1Section)
                BestellungExtrasName.remove(at: sender.Cell1Section)
                BestellungExtrasPreise.remove(at: sender.Cell1Section)
                BestellungItemsExpanded2.remove(at: sender.Cell1Section)
                BestellungUnterkategorien.remove(at: sender.Cell1Section)
                
                
                print(bestellteItemsDictionary, BestellungKategorien, BestellungUnterkategorien, sender.sections, "ELSE 3")

                sender.bestellteItemsDictionary = bestellteItemsDictionary
            
                if bestellteItemsDictionary.count == 0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }
                
            } }
   print(BestellungItemsNamen, BestellungKategorien, "entefrnne tst")
        
        uebersichtTV.reloadData()
    }
    
    override func willMove(toParent parent: UIViewController?) {
                let BestellungVC2 = self.storyboard?.instantiateViewController(withIdentifier: "BestellungVC2") as! BestellungVC2
        print(BestellungKategorien, "haja324r1111sjsaj")
        print(BestellungUnterkategorien, "hajas123jsaj")
        print(BestellungItemsNamen, "hajasj2453saj")
        
        self.delegate?.passChanges(Kategorien: BestellungKategorien, Unterkategorien: BestellungUnterkategorien, ItemsNamen: BestellungItemsNamen, ItemsPreise: BestellungItemsPreise, ItemsLiter: BestellungItemsLiter, ItemsKommentar: BestellungItemsKommentar, ItemsMenge: BestellungItemsMengen, ItemsExpanded2: BestellungItemsExpanded2, ExtrasName: BestellungExtrasName, ExtrasPreise: BestellungExtrasPreise)

        print(BestellungItemsKommentar, "kommentar12")
                BestellungVC2.bestellteItemsDictionary = bestellteItemsDictionary
                BestellungVC2.BestellungKategorien = BestellungKategorien
                BestellungVC2.BestellungUnterkategorien = BestellungUnterkategorien
                BestellungVC2.BestellungItemsNamen = BestellungItemsNamen
                BestellungVC2.BestellungItemsPreise = BestellungItemsPreise
                BestellungVC2.BestellungItemsLiter = BestellungItemsLiter
                BestellungVC2.BestellungExtrasName = BestellungExtrasName
                BestellungVC2.BestellungExtrasPreise = BestellungExtrasPreise
                BestellungVC2.BestellungItemsMengen = BestellungItemsMengen
                BestellungVC2.BestellungItemsExpanded2 = BestellungItemsExpanded2
                BestellungVC2.BestellungItemsKommentar = BestellungItemsKommentar
        


        BestellungVC2.bestellungaktualisieren2()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

//        let BestellungVC2 = self.storyboard?.instantiateViewController(withIdentifier: "BestellungVC2") as! BestellungVC2
//        print(BestellungVC2.BestellungItemsMengen, BestellungItemsMengen, "HIER 1")
//
//        BestellungVC2.BestellungKategorien = BestellungKategorien
//        BestellungVC2.BestellungUnterkategorien = BestellungUnterkategorien
//        BestellungVC2.BestellungItemsNamen = BestellungItemsNamen
//        BestellungVC2.BestellungItemsPreise = BestellungItemsPreise
//        BestellungVC2.BestellungItemsLiter = BestellungItemsLiter
//        BestellungVC2.BestellungExtrasName = BestellungExtrasName
//        BestellungVC2.BestellungExtrasPreise = BestellungExtrasPreise
//        BestellungVC2.BestellungItemsMengen = BestellungItemsMengen
//        BestellungVC2.BestellungItemsExpanded2 = BestellungItemsExpanded2
//        print(BestellungVC2.BestellungItemsMengen, BestellungItemsMengen, "HIER 2")
    }
    
    func handleBestellung(){
           var ref: DatabaseReference!

           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy/MM/dd HH:mm"
           let DayOne = formatter.date(from: "2018/05/15 12:00")
           let timestamp = Double(NSDate().timeIntervalSince(DayOne!))

           let fromUserID = Auth.auth().currentUser?.uid
           let values = ["Barname": barname ,"toKellner ID": KellnerID, "tischnummer": "\(tischnummer)", "fromUserID": fromUserID! , "timeStamp": timestamp, "Status": "versendet"] as [String : Any]
           let userRef = Database.database().reference().child("Users").child(fromUserID!)
           userRef.updateChildValues(["akutelleBar" : barname, "letzteBestellungZeit": timestamp])

               ref = Database.database().reference().child("Bestellungen").child(barname)
           
               let childRef = ref?.childByAutoId()

           for Bestellung in self.bestellteItemsDictionary {
               
               let Unterkategorien = Bestellung.Unterkategorie
               for Unterkategorie in Bestellung.Unterkategorie {
                   let UnterkategorieSection = Unterkategorien.firstIndex(of: Unterkategorie)
                   let items = Bestellung.items[UnterkategorieSection!]
               
                   let mengen = Bestellung.menge[UnterkategorieSection!]
                   let preise = Bestellung.preis[UnterkategorieSection!]
                   let kommentar = Bestellung.kommentar[UnterkategorieSection!]
                   let extrasNamen = Bestellung.extras[UnterkategorieSection!]
                   let extrasPreise = Bestellung.extrasPreise[UnterkategorieSection!]

                   for i in 0 ..< items.count {
                    
                       let bestellungName = ["Name": items[i]]
                       let bestellungMenge = ["Menge": mengen[i]]
                       let bestellungPreis = ["Preis": preise[i]]
                       let bestellungKommentar = ["Kommentar": kommentar[i]]
                       let childchildref = childRef?.child(Bestellung.Kategorie).child(Unterkategorie).childByAutoId()
                           childchildref?.updateChildValues(bestellungName)
                           childchildref?.updateChildValues(bestellungMenge)
                           childchildref?.updateChildValues(bestellungPreis)
                           childchildref?.updateChildValues(bestellungKommentar)
                       let bestellungItemId = childchildref?.key
                       childchildref?.updateChildValues(["bestellungItemId" : bestellungItemId!])
                       let extraPreis = extrasPreise[i]
                       for x in extrasNamen[i]{
                           let preis = extraPreis[extrasNamen[i].firstIndex(of: x)!]
                           childchildref?.child("Extras").child("Extra \(extrasNamen[i].firstIndex(of: x)!)").updateChildValues(["Name" : x])
                           childchildref?.child("Extras").child("Extra \(extrasNamen[i].firstIndex(of: x)!)").updateChildValues(["Preis" : preis])

                       } } } }
           
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
       
    
    func passItemPlus(sender: MyBestellungCell) {
        let i = 1
        var mengeInSection = bestellteItemsDictionary[sender.Cell1Section].menge
        var newmengeInSection = mengeInSection[sender.sections2]
        newmengeInSection[sender.rows2] = newmengeInSection[sender.rows2] + i
        mengeInSection[sender.sections2] = newmengeInSection
        BestellungItemsMengen[sender.Cell1Section] = mengeInSection
        bestellteItemsDictionary[sender.Cell1Section].menge = mengeInSection
        uebersichtTV.reloadData()
    }
    

    func passItemMinus(sender: MyBestellungCell) {
        var mengeInSection = bestellteItemsDictionary[sender.Cell1Section].menge
        
        var newmengeInSection = mengeInSection[sender.sections2]
        let i = 1
        if newmengeInSection[sender.rows2] > 1{
            newmengeInSection[sender.rows2] = newmengeInSection[sender.rows2] - i
            mengeInSection[sender.sections2] = newmengeInSection
            BestellungItemsMengen[sender.Cell1Section] = mengeInSection
            bestellteItemsDictionary[sender.Cell1Section].menge = mengeInSection
            uebersichtTV.reloadData()
        }
    }
    
    func passKommentarAendern(sender: MyBestellungCell) {
        print(sender.kommentar, "3 k text")
        var KommentareItems = BestellungItemsKommentar[sender.Cell1Section]
        var NewKommentareItems = KommentareItems[sender.sections2]
//        print(NewKommentareItems[sender.rows2], "wefwef")
//        print(BestellungItemsKommentar, "kommis")
        NewKommentareItems[sender.rows2] = sender.kommentar
        KommentareItems[sender.sections2] = NewKommentareItems
        BestellungItemsKommentar[sender.Cell1Section] = KommentareItems
        print(BestellungItemsKommentar, "kommentar lo")
 
    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return bestellteItemsDictionary.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var heightForHeaderInSection: Int?
        
        heightForHeaderInSection = 36
        return CGFloat(heightForHeaderInSection!)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var countUKat =  0
        var countItems = 0
        var countExtras = 0
        
        countUKat = bestellteItemsDictionary[indexPath.section].items.count
        for items in bestellteItemsDictionary[indexPath.section].items  {
        
        countItems = countItems+items.count
        
        }
        
        for extras in bestellteItemsDictionary[indexPath.section].extras{
            for extra in extras{
                countExtras = extra.count
            }
        }
        
        return CGFloat(36+countUKat*36+countItems*171+countExtras*44)
//
//        if (Bestellungen[indexPath.section].expanded) {
//            let kategorieCount = Bestellungen[indexPath.section].Kategorie.count
//            var UnterkategorieCount = 0
//            var itemsCount = 0
//            for items in  Bestellungen[indexPath.section].items {
//                for item in items {
//                    itemsCount = itemsCount + item.count
//                }
//            }
//            for unterkategorie in Bestellungen[indexPath.section].Unterkategorie {
//                UnterkategorieCount = UnterkategorieCount + unterkategorie.count
//
//            }
//            print(itemsCount, "itemscount")
//            print(kategorieCount, "kategorieCount")
//            print(UnterkategorieCount, "UnterkategorieCount")
//            return CGFloat(kategorieCount*100 + UnterkategorieCount*100 + itemsCount*86+50)
//
//
//        }
//        else {
//            return 1000
//        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        header.contentView.layer.cornerRadius = 5
        header.contentView.layer.backgroundColor = UIColor.clear.cgColor
        
        header.layer.cornerRadius = 5
        header.layer.backgroundColor = UIColor.clear.cgColor
        header.customInit(tableView: tableView, title:  bestellteItemsDictionary[section].Kategorie , section: section, delegate: self as ExpandableHeaderViewDelegate)
        return header
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
//        let cell = Bundle.main.loadNibNamed("MyBestellungCell", owner: self, options: nil)?.first as! MyBestellungCell
//        cell.backgroundColor = UIColor.clear
//        cell.delegate = self
//        cell.bestellteItemsDictionary = bestellteItemsDictionary
//        cell.sections = indexPath.section
//        cell.Extras = self.Extras
//        cell.ExtrasPreise = self.ExtrasPreise
        
        let cell = Bundle.main.loadNibNamed("MyBestellungCell", owner: self, options: nil)?.first as! MyBestellungCell
        cell.delegate = self
        cell.bestellteItemsDictionary = bestellteItemsDictionary
        print(bestellteItemsDictionary, "33333333")
        cell.Cell1Section = indexPath.section
        print(BestellungItemsNamen, "halllooooo")
//        cell.delegate = self as! MyBestellungCellDelegate

        
//
//        var Items = bestellteItemsDictionary[indexPath.section].items
//
//        var Preise = bestellteItemsDictionary[indexPath.section].preis
//        var Mengen = bestellteItemsDictionary[indexPath.section].menge
//        var Kommentare = bestellteItemsDictionary[indexPath.section].kommentar
//
//        print(Items, indexPath.row)
//        var newItems = Items[indexPath.row]
//        var newPreise = Preise[indexPath.row]
//        var newMengen = Mengen[indexPath.row]
//        var newKommentare = Kommentare[indexPath.row]
//        var Extras =  bestellteItemsDictionary[indexPath.section].extras
//        var newExtras = Extras[indexPath.row]
////        print(Bestellungen, "bestellung")
////        print(Extras, "Extras")
////        print(Cell2Row, "Cell2Row")
////        print(indexPath.row, "indexPath.row")
//        var newnewExtras = newExtras[indexPath.row]
//        var ExtrasPreise =  bestellteItemsDictionary[indexPath.section].extrasPreise
//        var newExtrasPreise = ExtrasPreise[indexPath.row]
//
////        print(newExtras, newExtrasPreise, indexPath.row)
//        var newnewExtrasPreise = newExtrasPreise[indexPath.row]
//
//        cell.myItemName.text = newItems[indexPath.row]
//        cell.extrasNamen = newnewExtras
//        cell.extrasPreise = newnewExtrasPreise
//        cell.Kategorie = bestellteItemsDictionary[indexPath.section].Kategorie
//
//        let preisFormat = String(format: "%.2f", arguments: [newPreise[indexPath.row]])
//        cell.myItemPreis.text = "\(preisFormat) €"
//        cell.myItemMenge.text = String(newMengen[indexPath.row])
//        cell.kommentarLbl.text = newKommentare[indexPath.row]
            gesamtpreislabel = 0.0
         
            gesamtpreisBerechnen(section: indexPath.section, row: indexPath.row)
            
            return cell
            }
            
            func gesamtpreisBerechnen(section: Int, row: Int) {
                
                for extrasPreise in bestellteItemsDictionary[section].extrasPreise {
                    for extrasPreis in extrasPreise {
                        for extraPreis in extrasPreis {
                            ExtraPreis.append(extraPreis)
                            }}}
                
                for itemsPreise in  bestellteItemsDictionary[section].preis {
                    for itemPreise in itemsPreise {
                            ItemsPreis.append(itemPreise)
                        }}
                
                for itemsMengen in  bestellteItemsDictionary[section].menge {
                    for itemsMenge in itemsMengen {
                            ItemsMenge.append(Double(itemsMenge))
                        }}
                
//                if bestellteItemsDictionary[section].menge.count == ItemsMenge.count {
                    teilPreis(itemPreis: ItemsPreis, extrasPreis: ExtraPreis, menge: ItemsMenge)
                    
                
            }
        
            func teilPreis(itemPreis: [Double], extrasPreis: [Double], menge: [Double]) {
                gesamtpreislabel = 0.0
                for i in 0..<itemPreis.count{
                    gesamtpreislabel += (itemPreis[i]+extrasPreis[i])*menge[i]
                    print(menge[i], itemPreis[i], extrasPreis[i], "variablen")
                    print(gesamtpreislabel, "preiiiis")
                    gesamtPreisLbl.text = "\(String(format: "%.2f", gesamtpreislabel)) €"
                        
                   
                }
            }

    override func viewDidLoad() {
        ExtraPreis.removeAll()
        ItemsPreis.removeAll()
        ItemsMenge.removeAll()
        self.navigationItem.title = "Deine Bestellung"

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "hintergrund")!)

        super.viewDidLoad()
        navigationController?.delegate = self
print(test, "geht? / test1")

    }
}
