//
//  BestellenCell.swift
//  SMOLO
//
//  Created by Ibrahim Akcam on 12.11.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit

protocol BestellenCellDelegate {
    func pass(sender: BestellenCell)
    func reloadUnterkategorie(sender: BestellenCell)
}



class BestellenCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource, bestellenCell2Delegate, ExpandableHeaderViewDelegate2 {

    // VARS
    var delegate: BestellenCellDelegate?
    var unterkategorien = [ExpandTVSection2]()
    var items = [[String]]()
    var preise = [[Double]]()
    var liters = [[String]]()
    var beschreibungen = [[String]]()
    var section = Int()
    var row = Int()
    
    var section2 = Int()
    var row2 = Int()

    var cellIndexPathSection: Int!

    func addBtnTapped(sender: BestellenCell2) {
        section2 = sender.section2
        row2 = sender.row2
        delegate?.pass(sender: self)
    }
   

    
    // OUTLETS

    @IBOutlet weak var BestellenTV: UITableView!
    

    // Tabelle
    func numberOfSections(in tableView: UITableView) -> Int {
        return unterkategorien[cellIndexPathSection].Unterkategorie.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return unterkategorien[cellIndexPathSection].items[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if unterkategorien[cellIndexPathSection].expanded2[indexPath.section] != false {
            return CGFloat(46)

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
        
        header.customInit(tableView: tableView, title:  unterkategorien[cellIndexPathSection].Unterkategorie[section], color: UIColor.white, section: section, delegate: self as ExpandableHeaderViewDelegate2)
        return header
        
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("BestellenCell2", owner: self, options: nil)?.first as! BestellenCell2
        cell.delegate = self
        cell.backgroundColor = UIColor.clear
        //        cell.itemLbl.text = "cell.itemLbl.text"
        if unterkategorien[cellIndexPathSection].expanded2[indexPath.section] != false {
            
            let item = unterkategorien[cellIndexPathSection].items[indexPath.section]
            let preis = unterkategorien[cellIndexPathSection].preis[indexPath.section]
            let liter = unterkategorien[cellIndexPathSection].liter[indexPath.section]
            let beschreibung = unterkategorien[cellIndexPathSection].beschreibung[indexPath.section]
            section2 = indexPath.section
            row2 = indexPath.row
            cell.section2 = indexPath.section
            cell.row2 = indexPath.row
            cell.ItemLbl.text = item[indexPath.row]
            cell.beschreibungLbl.text = beschreibung[indexPath.row]
            
            if liter[indexPath.row] != "0.0"{
                let preisFormat = String(format: "%.2f", arguments: [preis[indexPath.row]])
                cell.PreisLbl.text = "\(preisFormat)€"
            } else {
                cell.PreisLbl.isHidden = true
            }
            
            
            if liter[indexPath.row] != "0.0l"{
                cell.LiterLbl.text = (liter[indexPath.row])

            } else {
                cell.LiterLbl.isHidden = true
            }
           
            
            return cell
            
        } else {
            cell.ItemLbl.isHidden = true
            cell.PreisLbl.isHidden = true
            cell.LiterLbl.isHidden = true
            cell.addBtn.isHidden = true
            cell.strich.isHidden = true
            cell.viewAdd.isHidden = true
            cell.beschreibungLbl.isHidden = true
            
            return cell
        }
    }
    
    
    func toggleSection(tableView: UITableView, header: ExpandableHeaderView2, section: Int) {

        for i in 0..<unterkategorien[cellIndexPathSection].Unterkategorie.count{
            if i == section {
                unterkategorien[cellIndexPathSection].expanded2[i] = !unterkategorien[cellIndexPathSection].expanded2[i]
            } else {
                unterkategorien[cellIndexPathSection].expanded2[i] = false
                
            }
        }
        
        BestellenTV.beginUpdates()
        let indexSet = NSMutableIndexSet()
        for i in 0..<unterkategorien[cellIndexPathSection].items[section].count {
            BestellenTV.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        for i in 0..<unterkategorien[cellIndexPathSection].Unterkategorie.count{
            if i != section{
                indexSet.add(i)}
        }
        BestellenTV.reloadSections(indexSet as IndexSet, with: .automatic)
        delegate?.reloadUnterkategorie(sender: self)
        
        BestellenTV.endUpdates()
        
    }
    
    // OTHERS
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        BestellenTV.delegate = self
        BestellenTV.dataSource = self
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
