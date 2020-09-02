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
import Firebase

class HomeModelView:ObservableObject{
    @EnvironmentObject var session : SessionStore

    @Published var model: HomeGuideModel = HomeModelView.createHomeGuideModel()
    init() {
        queryNewData()
    }
    private static func createHomeGuideModel()-> HomeGuideModel{
        let filters : Array<Dictionary<String,Any>> = [
            [
                "titleDisplay": "분양 형태",
                "titleQuery" : "subscriptionType",
                "type" : "discrete",
                "multiSelectAble": false,
                "optionList" : ["국민", "민영"]
            ],
            [
                "titleDisplay": "지역",
                "titleQuery" : "addressProvinceKor",
                "type" : "discrete",
                "multiSelectAble": true,
                "preChoose" : 2,
                "optionList" : ["서울특별시", "경기도", "인천광역시","부산광역시","대구광역시", "경상남도", "경상북도", "충청북도","충청남도","대전광역시","울산광역시", "광주광역시","전라남도","전라북도","강원도","세종특별자치시","제주특별자치도"]
            ],
            [
                "titleDisplay": "분양/임대",
                "titleQuery" : "supplyType",
                "type" : "discrete",
                "multiSelectAble": false,
                "optionList" : ["분양", "임대"]
            ],
            [
                "titleDisplay": "건물",
                "titleQuery" : "buildingType",
                "type" : "discrete",
                "multiSelectAble": false,
                "optionList" : ["아파트", "오피스텔","도시형생활주택"]
            ]
            // 무순위 개발 후 추가 : 무순위 쿼리시 하드코딩있음 주의
//            [
//                "titleDisplay": "무순위 여부",
//                "titleQuery" : "noRank",
//                "type" : "discrete",
//                "multiSelectAble": false,
//                "optionList" : ["무순위", "일반"]
//            ]
//            [
//                "titleDisplay" : "가격",
//                "titleQuery" : "totalPrice",
//                "type" : "range",
//                //억 단위 표시
//                "optionRange" : [0.0,5000000000],
//                "optionInterval": 10000000.0
//            ],
//            [
//                "titleDisplay" : "평형",
//                "titleQuery" : "size",
//                "type" : "range",
//                "optionRange" : [0.0, 50.0],
//                "optionInterval" : 3.0
//            ]
        ]
        let model = HomeGuideModel(filtersArray: filters)
        return model
    }

    func getData(){
        let db = Firestore.firestore()

        let calendar = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
        db.collection("subscriptions").whereField("dateSecondOther", isGreaterThanOrEqualTo: calendar!).getDocuments{(querySnapshot, err) in
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
        self.queryNewData()
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
    func setShowHomeKeyPopUp(_ bool : Bool){
        self.model.showHomeKeyPopUp = bool
    }
    func chooseFilterOption(filterCategory: HomeGuideModel.FilterCategory, filterOption: HomeGuideModel.FilterOption){
        model.isFilterChanged = true
        if let choosenCategoryIndex = model.filters.firstIndex(matching: filterCategory){
            if let choosenIndex = model.filters[choosenCategoryIndex].optionList!.firstIndex(matching:filterOption){
                //Toggle 합니다.
                    if model.filters[choosenCategoryIndex].multiSelectAble{
                        // 다중 선택 가능한 경우
                        
                        if model.filters[choosenCategoryIndex].isAllChosen{
                            //모두 선택되어 있으면, 지금 선택빼고 모두 취소
                            for (index, value) in model.filters[choosenCategoryIndex].optionList!.enumerated(){
                                model.filters[choosenCategoryIndex].optionList![index].choosen = false
                            }
                            model.filters[choosenCategoryIndex].optionList![choosenIndex].choosen = true
                        }
                        if !model.filters[choosenCategoryIndex].isLastOption(filterOption){
                            // 마지막 선택 옵션이 아닌 경우에만 토글함
                            model.filters[choosenCategoryIndex].optionList![choosenIndex].choosen = !model.filters[choosenCategoryIndex].optionList![choosenIndex].choosen
                        }
                    }else{
                        //다중 선택 불가한 경우
                        for (index, value) in model.filters[choosenCategoryIndex].optionList!.enumerated(){
                            model.filters[choosenCategoryIndex].optionList![index].choosen = false
                        }
                        model.filters[choosenCategoryIndex].optionList![choosenIndex].choosen = true
                    }
            }
        }
            
        }
    func chooseAllFilterOption(filterCategory:HomeGuideModel.FilterCategory){
        if let choosenCategoryIndex = model.filters.firstIndex(matching: filterCategory){
            model.filters[choosenCategoryIndex].chooseAllOptions()
        }
    }
    func chooseFilterOption(filterOption: HomeGuideModel.FilterOption){
        // TODO : 만약 모든 Filter가 False가 되게 생기면 변화를 주지 않는 로직 추가하기
        if let choosenIndex = model.choosenFilterCategory!.optionList!.firstIndex(matching:filterOption){
            //Toggle 합니다.
            model.choosenFilterCategory!.optionList![choosenIndex].choosen = !model.choosenFilterCategory!.optionList![choosenIndex].choosen
        }
    }
    func chooseHomeType(subscription:HomeGuideModel.Subscription , homeType: HomeGuideModel.HomeType){
        model.chooseHomeType(subscription:subscription, homeType:homeType)
    }
    func queryNewData(){
        print("쿼리 실행")
        print(self.model.filters[0].titleQuery)
        print(self.model.filters[0].chosenOptions!)
        let db = Firestore.firestore()
        var hasBigQuery = false
        var bigQueryIndex = [Int]()
        let calendar = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
        var query = db.collection("subscriptions").whereField("dateSecondOther", isGreaterThanOrEqualTo: calendar!)
        var queryCounter = 0
        for (index,filter) in self.model.filters.enumerated(){
            queryCounter += 1
            print("쿼리 \(queryCounter)")
            print("\(filter.titleQuery)에서")
            print("\(filter.chosenOptions!) 맞는 것을 찾아")
            print("\(filter.isAllChosen), 모두 선택인가")
            if filter.dataType == HomeGuideModel.DataStyle.discrete{
                if !filter.isAllChosen{
                    if !filter.isBigQuery{
                        if filter.multiSelectAble{
                            query = query.whereField(filter.titleQuery, in: filter.chosenOptions!)
                        }else{
                            // 하드코딩임. 반드시 변경 ㅜ
                            if filter.titleQuery == "noRank"{
                                if filter.chosenOptions![0] == "무순위"{
                                    query = query.whereField(filter.titleQuery, isEqualTo: true)
                                }else{
                                    query = query.whereField(filter.titleQuery, isEqualTo: false)
                                }
                            }else{
                                query = query.whereField(filter.titleQuery, isEqualTo: filter.chosenOptions![0])
                            }

                        }
                    }else{
                        hasBigQuery = true
                        bigQueryIndex.append(index)
                    }
                }
            }
        }
        // BigQuery의 Index가 2이상일때는 해결하지 못함 ㅜ
        if hasBigQuery{
            self.model.clearSubscriptions()
            for option in self.model.filters[bigQueryIndex[0]].optionList!{
                if option.choosen{
                    query.whereField(self.model.filters[bigQueryIndex[0]].titleQuery, isEqualTo: option.value).getDocuments{(querySnapshot, err) in
                    if let err = err{
                        print("에러!: \(err)")
                    }else{
                        self.model.snapshotsTosubscriptions(snapshots: querySnapshot!.documents)
                    }
                }

            }
            }
        }else{
            query.getDocuments{(querySnapshot, err) in
            if let err = err{
                print("에러!: \(err)")
            }else{
                self.model.clearSubscriptions()
                self.model.snapshotsTosubscriptions(snapshots: querySnapshot!.documents)
            }
        }
        }
        model.isFilterChanged = false
    }
//    func queryNewData_(){
//        // 새 데이터를 받고,
//        if self.model.isFilterChanged{
//            let db = Firestore.firestore()
//            db.collection("subscriptions").whereField("dateSecondOther", isGreaterThan: Date()).getDocuments{(querySnapshot, err) in
//                if let err = err{
//                    print("에러!:\(err)")
//                }else{
//                    self.model.clearSubscriptions()
//                    self.model.snapshotsTosubscriptions(snapshots: querySnapshot!.documents)
//                }
//            }
//        }
//
//        // 필터링 한다.
//    }
    // OnlyForLogging
    func showDescriptionScreen(_ subscription : HomeGuideModel.Subscription){
        // 클릭 됨.
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "\(subscription.id)",
            AnalyticsParameterItemName: subscription.title,
            AnalyticsParameterContentType: "cont"
        ])
//        // 새로운 스크린 뜸
//        Analytics.logEvent(
//            AnalyticsEventScreenView,
//        parameters: [AnalyticsParameterScreenName: screenName,
//                     AnalyticsParameterScreenClass: screenClass])
    }
}
