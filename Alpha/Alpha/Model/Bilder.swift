//
//  Bilder.swift
//  Alpha
//
//  Created by Alper Maraz on 06.03.18.
//  Copyright © 2018 AM. All rights reserved.
//

import Foundation
class Bilder: NSObject {
    var link: String?
   
    init(dictionary: [String: Any]) {
        self.link = dictionary["Link"] as? String ?? ""
     
        
    }
}
