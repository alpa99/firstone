//
//  TableViewCell.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 01.11.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {


    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!

    
    @IBAction func add(_ sender: Any) {
        print(label1.text ?? "asfasd")
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
