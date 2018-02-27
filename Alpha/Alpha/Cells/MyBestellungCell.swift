//
//  MyBestellungCell.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 19.02.18.
//  Copyright © 2018 AM. All rights reserved.
//
import UIKit

protocol MyBestellungCellDelegate {
    
    func cellMyItemEntfernen(sender: MyBestellungCell)
    func cellMyItemMengePlusAction(sender: MyBestellungCell)
    func cellmyItemMengeMinusAction(sender: MyBestellungCell)

}

class MyBestellungCell: UITableViewCell {

    var delegate: MyBestellungCellDelegate?
    
    @IBOutlet weak var myItemMenge: UILabel!
    @IBOutlet weak var myItemMengeMinus: UIButton!
    @IBOutlet weak var myItemMengePlus: UIButton!
    
    @IBOutlet weak var myItemName: UILabel!
    @IBOutlet weak var myItemDescription: UILabel!
    
    @IBOutlet weak var myEntfernenButton: UIButton!
    
    @IBAction func myItemMengePlusAction(_ sender: Any) {
        delegate?.cellMyItemMengePlusAction(sender: self)
    }
    
    @IBAction func myItemMengeMinusAction(_ sender: Any) {
        delegate?.cellmyItemMengeMinusAction(sender: self)
    }
    
    @IBAction func myItemEntfernen(_ sender: Any) {
        delegate?.cellMyItemEntfernen(sender: self)
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
