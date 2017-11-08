//
//  File.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 22.10.17.
//  Copyright © 2017 AM. All rights reserved.
//

import Foundation

struct ExpandTVSection {
    
    var genre: String!
    var items: [String]!
    var preise: [Int]!
    var expanded: Bool!
    
    init(genre: String, items: [String], preise: [Int], expanded: Bool) {
        self.genre = genre
        self.items = items
        self.preise = preise
        self.expanded = expanded
    }
    
}
