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
    func cellMinusBtnTapped(sender: CustomTableViewCell)
    func cellPlusBtnTapped(sender: CustomTableViewCell)

}

class CustomTableViewCell: UITableViewCell {
    
    
    // VARS
    
    var delegate: CustomTableCellDelegate?
 
    var bestellung = [String]()
    
    // OUTLETS
    
    @IBOutlet weak var shishaNameLbl: UILabel!
    @IBOutlet weak var shishaPreisLbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    
    @IBOutlet weak var itemBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    
    
    // ACTIONS


    @IBAction func itemBtnTapped(_ sender: Any) {
        delegate?.cellItemBtnTapped(sender: self)
    }
    
    @IBAction func minusBtnTapped(_ sender: Any) {
        delegate?.cellMinusBtnTapped(sender: self)
    }
    
    @IBAction func plusBtnTapped(_ sender: Any) {
        delegate?.cellPlusBtnTapped(sender: self)
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
