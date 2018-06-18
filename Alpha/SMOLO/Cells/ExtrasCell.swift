//
//  ExtrasCell.swift
//  SMOLO
//
//  Created by Ibrahim Akcam on 10.06.18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit
protocol ExtraCellDelegate {
    func selectExtra(sender: ExtrasCell)
}

class ExtrasCell: UITableViewCell {

    var extraRow = 0
    @IBOutlet weak var extraLbl: UILabel!
    @IBOutlet weak var extraPreis: UILabel!
    @IBOutlet weak var extraSelect: UIButton!
    var delegate: ExtraCellDelegate?
    
    @IBAction func extraSelected(_ sender: Any) {
        delegate?.selectExtra(sender: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        extraSelect.setImage(UIImage(named: "essen"), for: .normal)
        extraSelect.setImage(UIImage(named: "essen-i"), for: .selected)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
