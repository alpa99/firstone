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
    var movies: [String]!
    var preise: [Int]!
    var expanded: Bool!
    
    init(genre: String, movies: [String], preise: [Int], expanded: Bool) {
        self.genre = genre
        self.movies = movies
        self.preise = preise
        self.expanded = expanded
    }
    
}
