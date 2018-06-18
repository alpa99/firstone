//
//  Oeffnungszeiten.swift
//  SMOLO
//
//  Created by Alper Maraz on 11.06.18.
//  Copyright © 2018 AM. All rights reserved.
//

import Foundation
class Oeffnungszeiten: NSObject {
    var Montag: String?
    var Dienstag: String?
    var Mittwoch: String?
    var Donnerstag: String?
    var Freitag: String?
    var Samstag: String?
    var Sonntag: String?
   
    
    init(dictionary: [String: Any]) {
        self.Montag = dictionary["Montag"] as? String ?? ""
        self.Dienstag = dictionary["Dienstag"] as? String ?? ""
        self.Mittwoch = dictionary["Mittwoch"] as? String ?? ""
        self.Donnerstag = dictionary["Donnerstag"] as? String ?? ""
        self.Freitag = dictionary["Freitag"] as? String ?? ""
        self.Samstag = dictionary["Samstag"] as? String ?? ""
        self.Sonntag = dictionary["Sonntag"] as? String ?? ""
 
        
    }
}
