//
//  BestellenCell.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 12.11.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit

protocol BestellenCellDelegate {
    func cellItemAddTapped(sender: BestellenCell)
//    func cellItemBtnTapped(sender: BestellenCell)
//    func cellMinusBtnTapped(sender: BestellenCell)
//    func cellPlusBtnTapped(sender: BestellenCell)
    
}

class BestellenCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource, ExpandableHeaderViewDelegate2 {

    // VARS
    
    var delegate: BestellenCellDelegate?
    
    var unterkategorien = [ExpandTVSection2]()
    var items = [[String]]()
    var preise = [[Int]]()
    var liters = [[String]]()
    var section = Int()
    var section2 = 0
    var row = 0
    var i = 0
    
    // OUTLETS

    @IBOutlet weak var BestellenTV: UITableView!
    
    
    // ACTIONS
    

    @IBAction func itemAddTapped(_ sender: Any) {
        delegate?.cellItemAddTapped(sender: self)
    }
    

    // Tabelle
    func numberOfSections(in tableView: UITableView) -> Int {
        print(unterkategorien, "dfdsgsdf")
        return unterkategorien[0].Unterkategorie.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return unterkategorien[0].items[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if unterkategorien[0].expanded2[indexPath.section] != false {
            return CGFloat(unterkategorien[0].items[section].count*44 + 50)}
        else {
            return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView2()
        
        header.customInit(tableView: tableView, title:  unterkategorien[section2].Unterkategorie[section], section: section, delegate: self as ExpandableHeaderViewDelegate2)
        return header
        
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("BestellenCell2", owner: self, options: nil)?.first as! BestellenCell2
        
        //        cell.itemLbl.text = "cell.itemLbl.text"
        if unterkategorien[0].expanded2[indexPath.section] != false {
            
            var item = unterkategorien[0].items[indexPath.section]
            var preis = unterkategorien[0].preis[indexPath.section]
            var liter = unterkategorien[0].liter[indexPath.section]
            cell.ItemLbl.text = item[indexPath.row]
            cell.PreisLbl.text = "\(preis[self.row])€"
            if liter[indexPath.row] != "0,0l"{
                cell.LiterLbl.text = (liter[self.row])
                
            }
                
            else {
                cell.LiterLbl.isHidden = true
            }
            
            
            return cell
            
        } else {
            cell.ItemLbl.isHidden = true
            cell.PreisLbl.isHidden = true
            cell.LiterLbl.isHidden = true
            return cell
        }
    }
    
    
    func toggleSection(tableView: UITableView, header: ExpandableHeaderView2, section: Int) {
        unterkategorien[0].expanded2[section] = !unterkategorien[0].expanded2[section]
        BestellenTV.beginUpdates()
        print(unterkategorien[0].expanded2)
        for i in 0..<unterkategorien[0].items[section].count {
            BestellenTV.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
            //            SpeisekarteTV2.reloadSections(IndexSet(i), with: .automatic)
            print([IndexPath(row: section, section: i)], "345443")
        }
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
