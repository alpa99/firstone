//
//  ExpandTVSection2.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 18.03.18.
//  Copyright © 2018 AM. All rights reserved.
//

import Foundation

struct ExpandTVSection2 {
    
    var genre: String!
    var items: [String : [String : Int]]!
    var expanded: Bool!
    
    init(genre: String, items: [String : [String : Int]], expanded: Bool) {
        self.genre = genre
        self.items = items
        self.expanded = expanded
    }
    
}
