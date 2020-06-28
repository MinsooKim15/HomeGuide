//
//  HomeModelView.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/06/25.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

// Home의 ModelView
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift


class HomeModelView:ObservableObject{

    @Published var model: HomeGuideModel = HomeModelView.createHomeGuideModel()
    init() {
        getData()
        print("done")
    }
    private static func createHomeGuideModel()-> HomeGuideModel{
        let filters : Array<Dictionary<String,Any>> = [
            [
                "titleDisplay": "분양 형태",
                "titleQuery" : "subscriptionType",
                "type" : "discrete",
                "optionList" : ["국민임대", "장기전세", "민간분양", "일반 민간임대", "10년 공공임대", "영구임대", "5년 공공임대", "공공분양", "5년 민간임대", "뉴스테이", "행복주택", "분납임대"]
        ],
            [
                "titleDisplay" : "건물",
                "titleQuery" : "buildingType",
                "type": "discrete",
                "optionList": ["아파트", "오피스텔", "기타"]
            ],
            [
                "titleDisplay" : "가격",
                "titleQuery" : "totalPrice",
                "type" : "range",
                //억 단위 표시
                "optionRange" : [0.0,50.0]
            ],
            [
                "titleDisplay" : "평형",
                "titleQuery" : "size",
                "type" : "range",
                "optionRange" : [0.0, 50.0]
            ]
        ]
        let model = HomeGuideModel(filtersArray: filters)
        return model
    }

    func getData(){
        let db = Firestore.firestore()
        db.collection("subscriptions").getDocuments{(querySnapshot, err) in
            if let err = err{
                print("에러!: \(err)")
            }else{
                self.model.snapshotsTosubscriptions(snapshots: querySnapshot!.documents)
            }
        }
    }
    //TODO : Filter Query - After Insert Enough Data
    
    
    // MARK: - Intents
    func openFilter(){
        model.isFilterOpen = true
    }
    func closeFilter(){
        if let currentChoosenFilter = model.choosenFilterCategory {
            if let choosenCurrentIndex = model.filters.firstIndex(matching: currentChoosenFilter){
                // save current choosenFilter data to filters
                model.filters[choosenCurrentIndex] = model.choosenFilterCategory!
            }
        }
        model.choosenFilterCategory = nil
        //TODO : Add GetData Query Method Here
        model.isFilterOpen = false
    }
    func chooseFilterCategory(filterCategory:HomeGuideModel.FilterCategory){
        print("----------------------------")
        print(filterCategory)
        if let choosenIndex = model.filters.firstIndex(matching:filterCategory){
            if let currentChoosenFilter = model.choosenFilterCategory {
                if let choosenCurrentIndex = model.filters.firstIndex(matching: currentChoosenFilter){
                    // save current choosenFilter data to filters
                    model.filters[choosenCurrentIndex] = model.choosenFilterCategory!
                }
            }
            model.choosenFilterCategory = model.filters[choosenIndex]
        }
    }
    func chooseFilterOption(filterOption: HomeGuideModel.FilterOption){
        if let choosenIndex = model.choosenFilterCategory!.optionList!.firstIndex(matching:filterOption){
            //Toggle 합니다.
            model.choosenFilterCategory!.optionList![choosenIndex].choosen = !model.choosenFilterCategory!.optionList![choosenIndex].choosen
        }
    }
}
