//
//  MyBestellungCelle.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 29.03.18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit

protocol MyBestellungCellDelegate {
    func passItemEntfernen(sender: MyBestellungCell)
    func passItemPlus(sender: MyBestellungCell)
    func passItemMinus(sender: MyBestellungCell)
    
}

class MyBestellungCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource, ExpandableHeaderViewDelegate2, MyBestellungCell2Delegate {
    
    // VARS
    //
    var bestellteItemsDictionary = [bestellungTVSection]()
    var items = [[String]]()
    var preise = [[Double]]()
    var liters = [[String]]()
    var sections = Int()
    var rows = Int()
    
    var sections2 = Int()
    var rows2 = Int()
    
    var delegate: MyBestellungCellDelegate?

    // OUTLETS
    
    
    @IBOutlet weak var myBestellungTV: UITableView!

    func cellMyItemEntfernen(sender: MyBestellungCell2) {
        sections2 = sender.sections2
        rows2 = sender.rows2
        delegate?.passItemEntfernen(sender: self)
        
 
    }
    
    func cellmyItemMengeMinusAction(sender: MyBestellungCell2) {
        sections2 = sender.sections2
        rows2 = sender.rows2
        delegate?.passItemMinus(sender: self)
    }
    
    func cellMyItemMengePlusAction(sender: MyBestellungCell2) {
        sections2 = sender.sections2
        rows2 = sender.rows2
        delegate?.passItemPlus(sender: self)
    }
    
    // Tabelle
    func numberOfSections(in tableView: UITableView) -> Int {
        print(bestellteItemsDictionary, sections, "4439iewjdskx")
        

        return bestellteItemsDictionary[sections].Unterkategorie.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(bestellteItemsDictionary, "4439iewjdskx")
        return bestellteItemsDictionary[sections].items[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if bestellteItemsDictionary[sections].expanded2[indexPath.section] != false {
            return CGFloat(bestellteItemsDictionary[sections].items[indexPath.section].count*46 + 200)
            
        }
        else {
            return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 15
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView2()
        
        header.customInit(tableView: tableView, title:  bestellteItemsDictionary[sections].Unterkategorie[section], section: section, delegate: self as ExpandableHeaderViewDelegate2)
        return header
        
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("MyBestellungCell2", owner: self, options: nil)?.first as! MyBestellungCell2
        cell.delegate = self
        cell.backgroundColor = UIColor.clear
                if bestellteItemsDictionary[sections].expanded2[indexPath.section] != false {
        
                    var item = bestellteItemsDictionary[sections].items[indexPath.section]
                    var preis = bestellteItemsDictionary[sections].preis[indexPath.section]
                    var liter = bestellteItemsDictionary[sections].liter[indexPath.section]
                    var menge = bestellteItemsDictionary[sections].menge[indexPath.section]

//                    section2 = indexPath.section
//                    row2 = indexPath.row
                    cell.sections2 = indexPath.section
                    cell.rows2 = indexPath.row
                    cell.myItemName.text = item[indexPath.row]
                    let preisFormat = String(format: "%.2f", arguments: [preis[indexPath.row]])

                    cell.myItemPreis.text = "\(preisFormat) €"
                    cell.myItemMenge.text = String(menge[indexPath.row])
                    
                    cell.myItemLiter.text = liter[indexPath.row]
                    if liter[indexPath.row] != "0.0l"{
                        cell.myItemLiter.text = liter[indexPath.row]

                    }

                    else {
                        cell.myItemLiter.isHidden = true
                    }
        
        
                    return cell
        
                } else {
                    cell.myItemName.isHidden = true
                    cell.myItemPreis.isHidden = true
                    cell.myItemMenge.isHidden = true
                    cell.myItemLiter.isHidden = true
                    cell.myItemEntfernen.isHidden = true
                    cell.myItemMengePlus.isHidden = true
                    cell.myItemMengeMinus.isHidden = true

                    return cell
        }

    }
    
    
    func toggleSection(tableView: UITableView, header: ExpandableHeaderView2, section: Int) {
        print("jw98weiujked")
        for i in 0..<bestellteItemsDictionary[sections].Unterkategorie.count{
            if i == section {
                bestellteItemsDictionary[sections].expanded2[i] = !bestellteItemsDictionary[sections].expanded2[i]
            } else {
                bestellteItemsDictionary[sections].expanded2[i] = false
                
            }
        }
        
        myBestellungTV.beginUpdates()
        let indexSet = NSMutableIndexSet()
        for i in 0..<bestellteItemsDictionary[sections].items[section].count {
            myBestellungTV.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        for i in 0..<bestellteItemsDictionary[sections].Unterkategorie.count{
            if i != section{
                indexSet.add(i)}
        }
        myBestellungTV.reloadSections(indexSet as IndexSet, with: .automatic)
        
        myBestellungTV.endUpdates()
        
    }
    
    // OTHERS
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        myBestellungTV.delegate = self
        myBestellungTV.dataSource = self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
