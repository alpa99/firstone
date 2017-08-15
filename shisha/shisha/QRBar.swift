//
//  QRBar.swift
//  shisha
//
//  Created by Alper Maraz on 15.08.17.
//  Copyright © 2017 AM. All rights reserved.
//

import Foundation
class QRBar: NSObject {
    var Name: String?
    
    init(dictionary: [String: Any]) {
        self.Name = dictionary["Name"] as? String ?? ""
        
        
    }
}
