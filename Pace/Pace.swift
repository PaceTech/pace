//
//  Pace.swift
//  Pace
//
//  Created by Tara Wilson on 7/23/15.
//  Copyright (c) 2015 twil. All rights reserved.
//

import UIKit
import GoogleMaps

class Pace: NSObject {
    var id : String?
    var distance: String?
    var pace: String?
    var location: CLLocationCoordinate2D?
    var owner: String?
    var time: String?
    var participants: [AnyObject]?
}
