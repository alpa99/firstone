
//
//  BestellenCell2.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 21.03.18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit

protocol bestellenCell2Delegate {
    func addBtnTapped(sender: BestellenCell2)
}

class BestellenCell2: UITableViewCell {

    @IBOutlet weak var ItemLbl: UILabel!
    @IBOutlet weak var LiterLbl: UILabel!
    @IBOutlet weak var PreisLbl: UILabel!
    @IBOutlet weak var beschreibungLbl: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var viewAdd: UIView!
    @IBOutlet weak var strich: UIView!
    
    var section2 = Int()
    var row2 = Int()
    var delegate: bestellenCell2Delegate?
    
    
    @IBAction func addBtnTapped(_ sender: Any) {
        delegate?.addBtnTapped(sender: self)
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        beschreibungLbl.textColor = UIColor.white

        ItemLbl.font = UIFont(name: "Verdana", size: 15.0)
        viewAdd.layer.cornerRadius = 4
        strich.layer.cornerRadius = 4
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


