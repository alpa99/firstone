//
//  TableViewCell.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 01.11.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit

protocol CustomTableCellDelegate {
    func cellItemBtnTapped(sender: CustomTableViewCell)
}

class CustomTableViewCell: UITableViewCell {
    
    
    // VARS
    
    var delegate: CustomTableCellDelegate?
 
    var bestellung = [String]()
    
    // OUTLETS
    
    @IBOutlet weak var shishaNameLbl: UILabel!
    
    @IBOutlet weak var shishaPreisLbl: UILabel!
    

    @IBOutlet weak var itemBtn: UIButton!
    
    // ACTIONS

    
    @IBAction func itemBtnTapped(_ sender: Any) {
    
    delegate?.cellItemBtnTapped(sender: self)
    }
    
    // OTHERS
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
