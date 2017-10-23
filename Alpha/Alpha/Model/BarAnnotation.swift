//
//  BarAnnotation.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 20.10.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import MapKit

class BarAnnotation: NSObject, MKAnnotation {
    var coordinate = CLLocationCoordinate2D()
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}

