//
//  BarDetail.swift
//  shisha
//
//  Created by Alper Maraz on 18.09.17.
//  Copyright © 2017 AM. All rights reserved.
//

import Foundation
class BarDetail: NSObject {
    var Name: String?
    var Adresse: String?
        
    init(dictionary: [String: Any]) {
        self.Adresse = dictionary["Adresse"] as? String ?? ""
        self.Name = dictionary["Name"] as? String ?? ""

        
}
}
