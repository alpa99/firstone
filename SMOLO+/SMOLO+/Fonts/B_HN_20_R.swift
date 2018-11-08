//
//  B_HN_20_R.swift
//  SMOLO+
//
//  Created by Ibrahim Akcam on 08.11.18.
//  Copyright © 2018 MAD. All rights reserved.
//

import UIKit

class B_HN_20_R: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)!
        self.tintColor = UIColor.white
        self.titleLabel?.textAlignment = NSTextAlignment.center
        self.backgroundColor = UIColor(red: 190/255, green: 0/255, blue: 2, alpha: 0.58)
    }
}
