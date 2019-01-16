//
//  KellnerExtrasCell.swift
//  SMOLO
//
//  Created by Ibrahim Akcam on 23.06.18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit

class KellnerExtrasCell: UITableViewCell {
    var extraRow = 0

    @IBOutlet weak var extrasNameLbl: UILabel!
    
    @IBOutlet weak var extrasPreisLbl: UILabel!
    
    override func awakeFromNib() {
        extrasNameLbl.textColor = UIColor.white
        extrasPreisLbl.textColor = UIColor.white
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
