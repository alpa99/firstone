//
//  File.swift
//  shisha
//
//  Created by Ibrahim Akcam on 06.09.17.
//  Copyright © 2017 AM. All rights reserved.
//

import Foundation

struct ExpandTVSection {

    var genre: String!
    var movies: [String]!
    var expanded: Bool!
    
    init(genre: String, movies: [String], expanded: Bool) {
        self.genre = genre
        self.movies = movies
        self.expanded = expanded
    }

}
