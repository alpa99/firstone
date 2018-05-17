//
//  BarItems.swift
//  Alpha
//
//  Created by Alper Maraz on 15.05.18.
//  Copyright © 2018 AM. All rights reserved.
//

import Foundation
class BarItems: NSObject {
    var item1: String?
    var item2: String?
    var item3: String?
    var item4: String?
    var item5: String?
    var item6: String?
    var item7: String?
    var item8: String?
    var item9: String?
    var item10: String?

    init(dictionary: [String: Any]) {
        self.item1 = dictionary["Item1"] as? String ?? ""
        self.item2 = dictionary["Item2"] as? String ?? ""
        self.item3 = dictionary["Item3"] as? String ?? ""
        self.item4 = dictionary["Item4"] as? String ?? ""
        self.item5 = dictionary["Item5"] as? String ?? ""
        self.item6 = dictionary["Item6"] as? String ?? ""
        self.item7 = dictionary["Item7"] as? String ?? ""
        self.item8 = dictionary["Item8"] as? String ?? ""
        self.item9 = dictionary["Item9"] as? String ?? ""
        self.item10 = dictionary["Item10"] as? String ?? ""

    }
}
