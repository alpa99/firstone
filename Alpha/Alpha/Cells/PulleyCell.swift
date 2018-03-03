//
//  PulleyCell.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 03.03.18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit

protocol PulleyCellDelegate {

}

class PulleyCell: UITableViewCell {
    
    var delegate: PulleyCellDelegate?

    
    @IBOutlet weak var barName: UILabel!
    
    @IBOutlet weak var stadtName: UILabel!
    
    @IBOutlet weak var distanzName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        barName.textColor = UIColor.white
        stadtName.textColor = UIColor.white
        distanzName.textColor = UIColor.white
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
