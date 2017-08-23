//
//  KellnerInfos.swift
//  shisha
//
//  Created by Ibrahim Akcam on 23.08.17.
//  Copyright © 2017 AM. All rights reserved.
//

import Foundation
class KellnerInfos: NSObject {
    var Bar: String?
    var Passwort: String?
    var ID: String?
    init(dictionary: [String: Any]) {
        self.Bar = dictionary["Bar"] as? String ?? ""
        self.Passwort = dictionary["Passwort"] as? String ?? ""
        self.ID = dictionary["ID"] as? String ?? ""
        
    }
}
