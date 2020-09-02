//
//  SettingModelView.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/06/28.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import SwiftUI
class SettingModelView{
    @Published var model: SettingModel = SettingModelView.createSettingModel()
    
    private static func createSettingModel()-> SettingModel{
        let currentVersion = getCurrentVersion()
        
        let latestVersion = getLatestVersion()
        let settingData: Array<Dictionary<String,Any>> = [
            [
                "title" : "공지사항",
                "settingType" : SettingModel.SettingType.navigatable,
                "keyName" : "notice"
            ],
            [
                "title" : "앱 버전",
                "settingType" : SettingModel.SettingType.detail,
                "keyName" : "appVersion",
                "description" : (currentVersion ?? "") + "/" + (latestVersion ?? "")
            ],
            [
                "title" : "인스타그램",
                "settingType" : SettingModel.SettingType.outlink,
                "keyName" : "review",
                "outlink" : "https://instagram.com/chung_joop_guide?igshid=aloegxpfqjko"
            ]
        ]
        return SettingModel(with:settingData)
    }
    private static func getCurrentVersion() -> String?{
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        return version
    }
    private static func getLatestVersion() -> String?{
        guard
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=kr.ac.yonsei.minsookim.HomeGuide"),
            let data = try? Data(contentsOf: url),
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
            let results = json["results"] as? [[String: Any]],
            results.count > 0,
            let appStoreVersion = results[0]["version"] as? String
            else { return "" }
        return appStoreVersion
    }
    
    //    func getVersionData(){
//        guard let dictionary = Bundle.main.infoDictionary,
//        let version = dictionary["CFBundleVersionString"] as? String,
//            let build = dictionary["CFBundleVersion"] as? String else {return nil}
//        let versionAndBuild: String = "version:\(version), build:\(build)"
//    }


}
