//
//  WinnigScore.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/08/28.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import Foundation
struct WinningScore{
    var minScore : Int?
    var maxScore : Int?
    var averageScore : Int?
    init(dictionary: Dictionary<String,Any>){
        minScore = dictionary["minScore"] as? Int
        maxScore = dictionary["maxScore"] as? Int
        averageScore = dictionary["averageScore"] as? Int
    }
}
