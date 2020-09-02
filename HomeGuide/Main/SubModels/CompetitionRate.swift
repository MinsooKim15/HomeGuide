//
//  CompetitionRate.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/08/28.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import Foundation
struct CompetitionRate{
    var isFallShort:Bool
    var rate : Double
    var applicant : Int
    var supply : Int

    init(dictionary:Dictionary<String,Any>) {
        isFallShort = (dictionary["isFallShort"] as? Bool) ?? false
        rate = (dictionary["rate"] as? Double) ?? 0.0
        applicant = (dictionary["applicant"] as? Int) ?? 0
        supply = (dictionary["supply"] as? Int) ?? 0
    }
}
