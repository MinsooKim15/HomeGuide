//
//  SettingModel.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/06/28.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import Foundation

struct SettingModel{
    
    var settings = [SettingData]()
    
    struct SettingData: Identifiable{
        var id: Int
        var title : String
        var settingType : SettingModel.SettingType
        var description : String?
        var keyName : String
        var outlink : String?
        
        init(dictionary : Dictionary<String,Any>, id: Int){
            self.id = id
            self.title = dictionary["title"] as! String
            self.settingType = dictionary["settingType"] as! SettingModel.SettingType
            if let description = dictionary["description"] {
                self.description = description as! String
            }
            if let outlink = dictionary["outlink"]{
                self.outlink = outlink as! String
            }
            self.keyName = dictionary["keyName"] as! String
        }
    }
    init(with settingArray : Array<Dictionary<String, Any>>) {
        var id = 0
        var tempArray = [SettingData]()
        for settingDictionary in settingArray{
            let settingData = SettingData(dictionary:settingDictionary, id: id)
            tempArray.append(settingData)
            id += 1
        }
        self.settings = tempArray
    }
    
    enum SettingType{
        case navigatable
        case outlink
        case detail
    }
}
