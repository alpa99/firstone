//
//  SpeisekarteInfos.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 22.10.17.
//  Copyright © 2017 AM. All rights reserved.
//

import Foundation
class SpeisekarteInfos: NSObject {
    var Name: String?
    var Preis: String?
    
    
    init(dictionary: [String: Any]) {
        self.Name = dictionary["Name"] as? String ?? ""
        self.Preis = dictionary["Preis"] as? String ?? ""
        
        
        
    }
}


