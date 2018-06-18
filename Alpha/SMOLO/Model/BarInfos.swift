//
//  BarInfos.swift
//  SMOLO
//
//  Created by Ibrahim Akcam on 20.10.17.
//  Copyright © 2017 AM. All rights reserved.
//

import Foundation
class BarInfos: NSObject {
    var Name: String?
    var Adresse: String?
    var Bilder: String?
    var Text: String?
    var telnum: String?
    var Stadtteil: String?
    
    init(dictionary: [String: Any]) {
        self.Name = dictionary["Name"] as? String ?? ""
        self.Adresse = dictionary["Adresse"] as? String ?? ""
        self.Bilder = dictionary["Bilder"] as? String ?? ""
        self.Text = dictionary["maintxt"] as? String ?? ""
        self.telnum = dictionary["Telefonnummer"] as? String ?? ""
        self.Stadtteil = dictionary["Stadtteil"] as? String ?? ""


    }
}

