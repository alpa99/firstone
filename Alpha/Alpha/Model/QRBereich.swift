//
//  QRBereich.swift
//  Alpha
//
//  Created by Alper Maraz on 19.10.17.
//  Copyright © 2017 AM. All rights reserved.
//

import Foundation
class QRBereich: NSObject {
    var Name: String?
    var Adresse: String?
    init(dictionary: [String: Any]) {
        self.Name = dictionary["Name"] as? String ?? ""
        self.Adresse = dictionary["Adresse"] as? String ?? ""
        
    }
}
