//
//  BestellenCell.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 12.11.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit

protocol BestellenCellDelegate {
    func cellItemBtnTapped(sender: BestellenCell)
    func cellMinusBtnTapped(sender: BestellenCell)
    func cellPlusBtnTapped(sender: BestellenCell)
    
}

class BestellenCell: UITableViewCell {

    // VARS
    
    var delegate: BestellenCellDelegate?
    
    var bestellung = [String]()
    
    // OUTLETS
    
    @IBOutlet weak var shishaNameLbl: UILabel!
    @IBOutlet weak var shishaPreisLbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var itemBtn: UIButton!
    
    

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
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
