//
//  KellnerCell.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 11.11.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit


protocol KellnerCellDelegate {
    func annehmenBtnPressed(sender: KellnerCell)

    
}


class KellnerCell: UITableViewCell {

    var delegate: KellnerCellDelegate?


    @IBOutlet weak var tischnummer: UILabel!
    
    @IBOutlet weak var bestellungsText: UITextView!
    
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var annehmenBtn: UIButton!
    
    @IBAction func annehmenPressed(_ sender: Any) {
        delegate?.annehmenBtnPressed(sender: self)

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
