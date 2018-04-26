//
//  SpeisekarteInformation.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 20.03.18.
//  Copyright © 2018 AM. All rights reserved.
//

import Foundation
class SpeisekarteInformation: NSObject {
    var Name: String?
    var Preis: Double?
    var Liter: String?
    
    
    init(dictionary: [String: Any]) {
        self.Name = dictionary["Name"] as? String ?? "Fehler: Name"
        self.Preis = dictionary["Preis"] as? Double ?? 0.00
        self.Liter = dictionary["Liter"] as? String ?? "0.0l"

        
        
    }
}
