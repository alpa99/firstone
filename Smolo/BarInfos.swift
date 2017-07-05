//
//  BarInfos.swift
//  Smolo
//
//  Created by Alper Maraz on 05.07.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit

class BarInfos: NSObject {
    var Name: String?
    var Stadt: String?
    var Adresse: String?
    init(dictionary: [String: Any]) {
        self.Name = dictionary["Name"] as? String ?? ""
        self.Stadt = dictionary["Stadt"] as? String ?? ""
        self.Adresse = dictionary["Adresse"] as? String ?? ""

    }

    
}
