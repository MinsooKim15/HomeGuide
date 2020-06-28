//
//  SettingModel.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/06/28.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import Foundation

struct SettingModel{
    
    var settings : Array<SettingData>
    
    struct SettingData{
        var title : String
        var isNavigatable: Bool
        var description : String
    }
    
}
