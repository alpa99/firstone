//
//  BarInfo.swift
//  shisha
//
//  Created by Alper Maraz on 26.07.17.
//  Copyright © 2017 AM. All rights reserved.
//

import Foundation
class BarInfos: NSObject {
    var Name: String?
    var Stadt: String?
    var Adresse: String?
    var Passwort: String?
    init(dictionary: [String: Any]) {
        self.Name = dictionary["Name"] as? String ?? ""
        self.Stadt = dictionary["Stadt"] as? String ?? ""
        self.Adresse = dictionary["Adresse"] as? String ?? ""
        self.Passwort = dictionary["Passwort"] as? String ?? ""
        
}
}
