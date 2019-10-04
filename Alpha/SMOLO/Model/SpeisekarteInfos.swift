//
//  SpeisekarteInfos.swift
//  SMOLO
//
//  Created by Ibrahim Akcam on 22.10.17.
//  Copyright © 2017 AM. All rights reserved.
//

import Foundation
class SpeisekarteInfos: NSObject {
    var Genre: String?
    var Name: String?
    var Preis: Int?
    
    init(dictionary: [String: Any]) {
        self.Genre = dictionary["Genre"] as? String ?? ""
        self.Name = dictionary["Name"] as? String ?? ""
        self.Preis = dictionary["Preis"] as? Int ?? 0
    }
}


