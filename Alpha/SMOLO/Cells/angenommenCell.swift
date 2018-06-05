//
//  angenommenCell.swift
//  SMOLO
//
//  Created by Ibrahim Akcam on 11.03.18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit



class angenommenCell: UITableViewCell {

    @IBOutlet weak var bestellungsText: UITextView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var tischnummer: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
