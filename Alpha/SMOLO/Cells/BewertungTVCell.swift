//
//  BewertungTVCell.swift
//  SMOLO
//
//  Created by Alper Maraz on 04.12.18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit

class BewertungTVCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource, bestellenCell2Delegate, ExpandableHeaderViewDelegate2 {
    func addBtnTapped(sender: BestellenCell2) {
        print("hii")
    }
    
  
    
    var section = Int()
    var row = Int()
    
    var section2 = Int()
    var row2 = Int()
    
    var cellIndexPathSection: Int!

    var unterkategorien = [BewertungSection]()

    var items = [[String]]()

    
    @IBOutlet weak var BewertenCellTV: UITableView!
    
    //TABLEVIEW
    
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
      return 200
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
        let cell = Bundle.main.loadNibNamed("BewertungTVCell2", owner: self, options: nil)?.first as! BewertungTVCell2
      //  cell.delegate = self
        cell.backgroundColor = UIColor.clear
            
        let item = unterkategorien[cellIndexPathSection].items[indexPath.section]
           
            section2 = indexPath.section
            row2 = indexPath.row
            cell.section2 = indexPath.section
            cell.row2 = indexPath.row
            cell.ItemLbl.text = item[indexPath.row]
        
        
            return cell
    }
    
    
    func toggleSection(tableView: UITableView, header: ExpandableHeaderView2, section: Int) {
        
        print("hi")
        
    }
    override func layoutSubviews()
    {
        super.layoutSubviews()
        BewertenCellTV.delegate = self
        BewertenCellTV.dataSource = self
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
