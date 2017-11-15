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

class BestellenCell: UITableViewCell {

    // VARS
    
    var delegate: BestellenCellDelegate?
    
    var bestellung = [String]()
    
    // OUTLETS
    
    @IBOutlet weak var itemNameLbl: UILabel!
    
    @IBOutlet weak var itemPreisLbl: UILabel!
    
    @IBOutlet weak var itemAddBtn: UIButton!
    
    // ACTIONS
    

    @IBAction func itemAddTapped(_ sender: Any) {
        delegate?.cellItemAddTapped(sender: self)
    }
    

    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
