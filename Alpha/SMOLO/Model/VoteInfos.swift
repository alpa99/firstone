//
//  File.swift
//  SMOLO
//
//  Created by Alper Maraz on 17.11.17.
//  Copyright © 2017 AM. All rights reserved.
//

import Foundation
class VoteInfos: NSObject {
    var Name: String?
    var quality: Double?
    var quantity: Double?
    var finalgrade: Double?


    init(dictionary: [String: Any]) {
        self.Name = dictionary["Name"] as? String ?? ""
        self.quality = dictionary["quality"] as? Double ?? 0.0
        self.quantity = dictionary["quantity"] as? Double ?? 0.0
        self.finalgrade = dictionary["finalgrad"] as? Double ?? 0.0

        
    }
    
}
