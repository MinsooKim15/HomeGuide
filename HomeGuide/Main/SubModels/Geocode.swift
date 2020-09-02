//
//  Geocode.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/09/02.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import Foundation
struct Geocode{
    var latitude : Double
    var longitude : Double
    init(dictionary: Dictionary<String,Any>){
        latitude = dictionary["latitude"] as! Double
        longitude = dictionary["longitude"] as! Double
        
    }
}
