//
//  Button.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 19.03.18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit

class Button: UIButton {

    let goldColor = UIColor.init(red: 185.0/255.0, green: 170.0/255.0, blue: 140.0/255.0, alpha: 1.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tintColor = UIColor.white
        self.layer.cornerRadius = 4
    
        self.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        
        if self.titleLabel?.text == "zurück"  {
            self.layer.backgroundColor = UIColor.clear.cgColor

        } else {
        self.layer.backgroundColor = goldColor.cgColor
//        self.titleLabel?.textColor = UIColor.white
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
