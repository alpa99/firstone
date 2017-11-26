//
//  BarInfos.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 20.10.17.
//  Copyright © 2017 AM. All rights reserved.
//

import Foundation
class BarInfos: NSObject {
    var Name: String?
    var Adresse: String?
    var Bild: String?
    init(dictionary: [String: Any]) {
        self.Name = dictionary["Name"] as? String ?? ""
        self.Adresse = dictionary["Adresse"] as? String ?? ""
        self.Bild = dictionary["Bild"] as? String ?? ""

    }
}

