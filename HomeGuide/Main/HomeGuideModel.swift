//
//  HomeGuide.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/06/26.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

struct HomeGuideModel{
    
    var subscriptions : Array<Subscription>
    var guides : Array<Guide>
    var filters : Array<FilterCategory>
    var showHomeKeyPopUp: Bool = false
    // MARK: - For UI
    var isFilterOpen : Bool = false
    
    // MARK : - For Filtering
    var choosenFilterCategory: FilterCategory?

    // 한번이라도 filter가 변경되어야 새로 쿼리를 날린다.
    var isFilterChanged : Bool = false
    
    struct FilterCategory: Identifiable{
        var id : Int
        // It will be displayed
        var titleDisplay : String
        // it will be used for query
        var titleQuery: String
        var dataType : DataStyle
        var optionList : Array<FilterOption>?
        var filterRange : FilterRange?
        var choosenFilterRange: FilterRange?
        var isChecked : Bool?
        var multiSelectAble : Bool
        
        mutating func chooseAllOptions(){
            if self.optionList != nil{
                for (index,_) in self.optionList!.enumerated(){
                    self.optionList![index].choosen = true
                }
            }
        }
        func isLastOption(_ selectedOption: HomeGuideModel.FilterOption) -> Bool{
            if let optionList_ = optionList{
                var choosenCount = 0
                for option in optionList_{
                    if (option.choosen)&&(option != selectedOption){
                        choosenCount += 1
                    }
                }
                if choosenCount == 0{
                    return true
                }else{
                    return false
                }
            }else{
                return false
            }
        }
        var isChoosen: Bool {
            var choosen = false
            if let tempOptionList = optionList{
                for option in tempOptionList{
                    if option.choosen{
                        choosen = true
                    }
                }
            }
            return choosen
        }
        var choosenOptionString:String{
            var firstString = ""
            var choosenString = ""
            var choosenCounter = 0
            if isChoosen{
                if let tempOptionList = optionList{
                    for option in tempOptionList{
                        if option.choosen{
                            if choosenCounter == 0{
                                firstString = String(option.value)
                                choosenCounter = 1
                            }else{
                                choosenCounter += 1
                            }
                        }
                    }
                }
                if choosenCounter == 1{
                    choosenString = firstString
                }else{
                    choosenString = firstString + " 외 \(choosenCounter - 1)"
                }
                if isAllChosen{
                    choosenString = "모든 " + self.titleDisplay
                }
                return choosenString
            }else{
                return self.titleDisplay
            }

        }
        // Computed variables
        var chosenOptions:Array<String>?{
            if self.optionList != nil{
                var resultList = [String]()
                for option in self.optionList!{
                    if option.choosen{
                        resultList.append(option.value)
                    }
                }
                return resultList
            }else{
                return nil
            }
        }
        var isAllChosen: Bool{
            if (self.chosenOptions != nil){
                if self.optionList != nil{
                    if self.chosenOptions!.count == self.optionList!.count {
                        return true
                    }
                }
            }
                return false
        }
        var isBigQuery : Bool{
            if self.chosenOptions != nil{
                if self.chosenOptions!.count > 10{
                    return true
                }
            }
            return false
        }

        
        init(dictionary: Dictionary<String,Any>,id:Int) {
            self.id = id
            titleDisplay = dictionary["titleDisplay"] as! String
            titleQuery = dictionary["titleQuery"] as! String
            multiSelectAble = dictionary["multiSelectAble"] as! Bool
            var tempList = [FilterOption]()

            if (dictionary["type"] as! String ) == "discrete"{
                dataType = .discrete
                var filterId = 0
                for option in (dictionary["optionList"] as! Array<String>){
                    tempList.append(FilterOption(id: filterId, value : option))
                    filterId += 1
                }
                if multiSelectAble{
                    for (index,value) in tempList.enumerated(){
                        tempList[index].choosen = false
                    }
                    for index in 0 ..< (dictionary["preChoose"] as! Int){
                        tempList[index].choosen = true
                    }
                }
            }else if(dictionary["type"] as! String ) == "range"{
                dataType = .range
                filterRange = FilterRange(array : (dictionary["optionRange"] as! Array<Double>), interval : dictionary["optionInterval"] as! Double)
            }else{
                dataType = .bool
                isChecked = false
            }
            
            optionList = tempList
        }
    }
    struct FilterRange{
        var startData: Double
        var endData : Double
        var interval : Double
        
        init(array: Array<Double>, interval : Double) {
            startData = array[0]
            endData = array[1]
            self.interval = interval
        }
    }
    enum DataStyle {
        case discrete
        case range
        case bool
    }
    
    struct FilterOption:Identifiable, Hashable{
        var id: Int
        // It will be displayed and query
        var value : String
        var choosen : Bool = true
    }
    
    
    init(filtersArray:Array<Dictionary<String, Any>>) {
        subscriptions = [Subscription]()
        guides = [Guide]()
        filters = [FilterCategory]()
        var id = 0
        for filterDictionary in filtersArray{
            let filterValue = FilterCategory(dictionary: filterDictionary, id : id)
            filters.append(filterValue)
            id += 1
        }
    }
    
    mutating func snapshotsTosubscriptions(snapshots:[QueryDocumentSnapshot]){
        
        for snapshot in snapshots{
            subscriptions.append(Subscription(snapshot: snapshot))
        }
        subscriptions = subscriptions.sorted(by: {$0.dateClose! < $1.dateClose!})
    }
    mutating func clearSubscriptions(){
        subscriptions = [Subscription]()
    }
    mutating func snapshotsToGuides(snapshots:[QueryDocumentSnapshot]){
        for snapshot in snapshots{
            subscriptions.append(Subscription(snapshot:snapshot))
        }
    }
    
    mutating func chooseHomeType(subscription:Subscription, homeType:HomeType){
        if let chosenIndex:Int = self.subscriptions.firstIndex(matching: subscription){
            if let choosenHomeTypeIndex = self.subscriptions[chosenIndex].typeList?.firstIndex(matching: homeType){
                self.subscriptions[chosenIndex].chosenHomeType = self.subscriptions[chosenIndex].typeList![choosenHomeTypeIndex]
            }
        }
    }
    
    struct Subscription : Identifiable{
        var id : String
        var title : String
        var address : Address
        var buildingType : String
        var supplyType : String
        var subscriptionType : String
        var noRank : Bool
        var noRankDate : Date?
        var hasSpecialSupply : Bool
        var dateSpecialSupplyNear : Date?
        var dateSpecialSupplyOther : Date?
        var dateFirstNear : Date?
        var dateFirstOther: Date?
        var dateSecondNear : Date?
        var dateSecondOther: Date?
        var dateNotice : Date?
        var dateAnnounce : Date?
        var dateContract : Date?
        var priceDidSet : Bool
        var zoneType: Int
        var officialLink : String?
        var naverLink : String?
        var documentLink : String?
        var typeList : [HomeType]?
        var lowestPrice : Price?
        var highestPrice : Price?
        var startDate: Date?
        var endDate: Date?
        var dateLeftInString : String?
        var dateClose : Date?
        var showLabel : Bool
        var showHighlightLabel : Bool
        var chosenHomeType: HomeType?
        var noRankNotSpecified : Bool
        var geocode : Geocode?
        var imgName : String?
        var iconName: String {
            if (self.buildingType == "아파트") || (self.buildingType == "apt"){
                let number = Int.random(in: 1..<3)
                let imgName = "apartIcon" + String(number)
                return imgName
            }else{
                let imgName = "building"
                return imgName
            }
        }
        var totalSupply: Int{
            var tempTotalSupply = 0
            if let tempTypeList = self.typeList{
                for homeType in tempTypeList{
                    tempTotalSupply += homeType.totalSupply
                }
            }
            return tempTotalSupply
        }
        var firstOtherDidNotPassed: Bool{
            self.notPassed(self.dateFirstOther!) ?? false
        }
        var isNew:Bool{
            let currentDate = Date()
            if let dateNoticeSet = self.dateNotice {
                let interval = currentDate - dateNoticeSet
                
                let cal = Calendar.current
                
                let currentMonth = cal.component(.month, from: currentDate)
                let currentWeek = cal.component(.weekOfYear, from: currentDate)
                let currentDay = cal.component(.day, from: currentDate)
                
                
                let targetMonth = cal.component(.month, from: dateNoticeSet)
                let targetWeek = cal.component(.weekOfYear, from : dateNoticeSet)
                let targetDay = cal.component(.day, from:dateNoticeSet)
                let dayDiff = currentDay -  targetDay
                let monthDiff = currentMonth - targetMonth
                print(dayDiff)
                print("!!!!!!!!!!!!!!!isNew!!!!!")
                // TODO: 날짜 비교의 좋은 예 - 전체 코드를 아래 처럼 수정하자
                let components = Calendar.current.dateComponents([.year, .month, .day], from: dateNoticeSet, to: Date())
                if (components.day! < 3) {
                    return true
                }
                
            }
            return false
        }

        
        init(snapshot: QueryDocumentSnapshot) {
            id = snapshot.documentID
            let snapshotValue = snapshot.data()
            title = (snapshotValue["title"] as! String)
            address = Address(
                provinceCode : (snapshotValue["addressProvinceCode"] as? String) ?? "seoul",
                provinceKor: (snapshotValue["addressProvinceKor"] as? String) ?? "서울시",
                detailFirst: (snapshotValue["addressDetailFirstKor"] as? String),
                detailSecond: (snapshotValue["addressDetailSecondKor"] as? String)
            )
            supplyType = (snapshotValue["supplyType"] as? String) ?? "분양"
            buildingType = (snapshotValue["buildingType"] as? String) ?? "아파트"
            subscriptionType = (snapshotValue["subscriptionType"] as? String) ?? ""
            noRank = (snapshotValue["noRank"] as? Bool) ?? false
            noRankDate = (snapshotValue["noRankDate"] as? Timestamp)?.dateValue()
            hasSpecialSupply = (snapshotValue["hasSpecialSupply"] as? Bool) ?? false
            dateSpecialSupplyNear = (snapshotValue["dateSpecialSupplyNear"] as? Timestamp)?.dateValue()
            dateSpecialSupplyOther = (snapshotValue["dateSpecialSupplyOther"] as? Timestamp)?.dateValue()
            dateFirstNear = (snapshotValue["dateFirstNear"] as? Timestamp)?.dateValue()
            dateFirstOther = (snapshotValue["dateFirstOther"] as? Timestamp)?.dateValue()
            dateSecondNear = (snapshotValue["dateSecondNear"] as? Timestamp)?.dateValue()
            dateSecondOther = (snapshotValue["dateSecondOther"] as? Timestamp)?.dateValue()
            dateNotice = (snapshotValue["dateNotice"] as? Timestamp)?.dateValue()
            dateAnnounce = (snapshotValue["dateAnnounce"] as? Timestamp)?.dateValue()
            dateContract = (snapshotValue["dateContract"] as? Timestamp)?.dateValue()
            zoneType = (snapshotValue["zoneType"] as? Int) ?? 1
            officialLink = (snapshotValue["officialLink"] as? String)
            naverLink = (snapshotValue["naverLink"] as? String)
            documentLink = (snapshotValue["documentLink"] as? String)
            priceDidSet = (snapshotValue["priceDidSet"] as! Bool)
            typeList = [HomeType]()
            noRankNotSpecified = (snapshotValue["noRankNotSpecified"] as? Bool) ?? true
            showLabel = false
            showHighlightLabel = false
            imgName = snapshotValue["imgName"] as? String
            if let tempTypeList = snapshotValue["typeList"]{
                for (index, element) in (tempTypeList as? Array<Any>)!.enumerated(){
                    // TODO : - Array의 Index를 넣어주세요
                    let homeType = HomeType(
                        idNum: index, dictionary: element as! Dictionary<String,Any>)
                    typeList?.append(homeType)
                }
            }
            // 첫번째 것을 선택해둔다.
            if typeList != nil{
                if typeList!.count > 0{
                    chosenHomeType = typeList?[0]
                }
            }
            lowestPrice = getLowestPrice()
            highestPrice = getHighestPrice()

            (dateLeftInString, dateClose, showLabel,showHighlightLabel) = getDateLeftString()
            if let geocodeDictionary = snapshotValue["geocode"] as? Dictionary<String,Any>{
                geocode = Geocode(dictionary:geocodeDictionary)
            }
        }
        
        func getEndDate()-> Date{
            if self.dateSecondOther != nil{
                return self.dateSecondOther!
            }else if self.dateSecondNear != nil{
                return self.dateSecondNear!
            }else if self.dateFirstOther != nil{
                return self.dateFirstOther!
            }else if self.dateFirstNear != nil{
                return self.dateFirstNear!
            }else if self.dateSpecialSupplyOther != nil{
                return self.dateSpecialSupplyOther!
            }else{
                return self.dateSpecialSupplyNear!
            }
        }
        func getStartDate()-> Date{
            if self.dateSpecialSupplyNear != nil{
                return self.dateSpecialSupplyNear!
            }else if self.dateSpecialSupplyOther != nil{
                return self.dateSecondOther!
            }else if self.dateFirstNear != nil{
                return self.dateFirstNear!
            }else if self.dateFirstOther != nil{
                return self.dateFirstOther!
            }else if self.dateSecondNear != nil{
                return self.dateSecondNear!
            }else{
                return self.dateSecondOther!
            }
        }
        func getLowestPrice()-> Price?{
            if let tempTypeList = self.typeList {
                var candidateHighPrice: Price? = nil
                for homeType in tempTypeList{
                    if candidateHighPrice == nil{
                        candidateHighPrice = homeType.totalPrice
                    }else{
                        if homeType.totalPrice.inNumeric < candidateHighPrice!.inNumeric{
                            candidateHighPrice = homeType.totalPrice
                        }
                    }
                }
                return candidateHighPrice
            }else{
                return nil
            }
        }
        
        
        func getHighestPrice()-> Price?{
            if let tempTypeList = self.typeList {
                var candidateLowPrice: Price? = nil
                
                for homeType in tempTypeList{
                    if candidateLowPrice == nil{
                        candidateLowPrice = homeType.totalPrice
                    }else{
                        if homeType.totalPrice.inNumeric > candidateLowPrice!.inNumeric{
                            candidateLowPrice = homeType.totalPrice
                        }
                    }
                }
                return candidateLowPrice
            }else{
                return nil
            }
            
        }
        
        func getDateLeftString() -> (String,Date,Bool,Bool){
            // MARK : Nil error 주의
            var dateLeftString : String?
            var dateCloseCandidate : Date?
            print(self.title)
            if self.hasSpecialSupply{
                if self.notPassed(dateSpecialSupplyNear!){
                    print("특공")
                    var showLabel = false
                    var showHighlightLabel = false
                    (dateLeftString, showLabel, showHighlightLabel) = getDateLeftString(from: dateSpecialSupplyNear!, with:"특공")
                    dateCloseCandidate = dateSpecialSupplyNear!
                    return (dateLeftString ?? "", dateCloseCandidate!, showLabel, showHighlightLabel)
                }
                if self.notPassed(dateSpecialSupplyOther!){
                    print("특공기타")
                    var showLabel = false
                    var showHighlightLabel = false
                    (dateLeftString, showLabel, showHighlightLabel) = getDateLeftString(from: dateSpecialSupplyOther!, with:"특공")
                    dateCloseCandidate = dateSpecialSupplyOther!
                    return (dateLeftString ?? "", dateCloseCandidate!, showLabel, showHighlightLabel)
                }
            }
            if let _ = dateFirstNear, self.notPassed(dateFirstNear!){
                print("1순위해당")
                var showLabel = false
                var showHighlightLabel = false
                (dateLeftString, showLabel, showHighlightLabel) = getDateLeftString(from: dateFirstNear!, with:"1순위")
                dateCloseCandidate = dateFirstNear!
                return (dateLeftString ?? "", dateCloseCandidate!, showLabel, showHighlightLabel)
            }
            if let _ = dateFirstOther,  self.notPassed(dateFirstOther!){
                print("1순위 기타")
                var showLabel = false
                var showHighlightLabel = false
                (dateLeftString, showLabel, showHighlightLabel) = getDateLeftString(from: dateFirstOther!, with:"1순위")
                dateCloseCandidate = dateFirstOther!
                return (dateLeftString ?? "", dateCloseCandidate!, showLabel, showHighlightLabel)
            }
            if let _ = dateSecondNear, self.notPassed(dateSecondNear!){
                print("2순위해당")
                var showLabel = false
                var showHighlightLabel = false
                (dateLeftString, showLabel, showHighlightLabel) = getDateLeftString(from: dateSecondNear!, with:"2순위")
                dateCloseCandidate = dateSecondNear!
                return (dateLeftString ?? "", dateCloseCandidate!, showLabel, showHighlightLabel)
            }
            if let _ = dateSecondOther, self.notPassed(dateSecondOther!){
                print("2순위기타")
                var showLabel = false
                var showHighlightLabel = false
                if (self.noRank == true)||(self.buildingType != "아파트"){
                    (dateLeftString, showLabel, showHighlightLabel) = getDateLeftString(from: dateSecondOther!, with:"접수")
                }else{
                    (dateLeftString, showLabel, showHighlightLabel) = getDateLeftString(from: dateSecondOther!, with:"2순위")
                }

                dateCloseCandidate = dateSecondOther!
                return (dateLeftString ?? "", dateCloseCandidate!, showLabel, showHighlightLabel)
            }
            return ("", dateSecondOther!, false,false)
        }
        func getDateLeftString(from targetDate:Date, with dateString: String) -> (String,Bool,Bool){
            let currentDate = Date()
            let interval = targetDate - currentDate
            
            let cal = Calendar.current
            
            let currentMonth = cal.component(.month, from: currentDate)
            let currentWeek = cal.component(.weekOfYear, from: currentDate)
            let currentDay = cal.component(.day, from: currentDate)
            
            
            let targetMonth = cal.component(.month, from: targetDate)
            let targetWeek = cal.component(.weekOfYear, from : targetDate)
            let targetDay = cal.component(.day, from: targetDate)
            let dayDiff = targetDay - currentDay
            _ = (targetWeek - currentWeek)
            _ = (targetMonth - currentMonth)
            
            var resultString = ""
            // 같은 달 안 인가?
            var showLabel = false
            var showHighlightLabel = false
            if let intervalDay = interval.day,(intervalDay < 1)&&(dayDiff == 0){
                resultString = "\(dateString) TODAY"
                showLabel = true
                showHighlightLabel = true
            }else if (targetMonth == currentMonth)&&(dayDiff < 3){
                resultString = "\(dateString) D-\(dayDiff)"
                showLabel = true
                showHighlightLabel = true
            }else if (targetMonth == currentMonth)&&(dayDiff < 5){
                resultString = "\(dateString) D-\(dayDiff)"
                showLabel = true
                showHighlightLabel = false
            }else{
                resultString = "\(targetMonth)/\(targetDay)"
                showLabel = false
                showHighlightLabel = false
            }
            return (resultString, showLabel, showHighlightLabel)
        }
        func isSameDay(date1: Date, date2: Date) -> Bool {
            let diff = Calendar.current.dateComponents([.day], from: date1, to: date2)
            if diff.day == 0 {
                return true
            } else {
                return false
            }
        }
        func notPassed(_ targetDate:Date)-> Bool{
            let currentDate = Date()
            if targetDate >= currentDate{
                print("같은 날임")
                return true
            }else{
//                 당일일 수도 있음
                if isSameDay(date1: targetDate, date2: currentDate){
                    print("같은 날임")
                    return true
                }
                return false
            }
        }
        
    }

    
    struct Address {
        var provinceCode : String
        var provinceKor : String
        var detailFirst : String?
        var detailSecond : String?
        var full:String
        init(provinceCode: String, provinceKor: String, detailFirst : String?, detailSecond: String?){
            self.provinceCode = provinceCode
            self.provinceKor = provinceKor
            self.detailFirst = detailFirst
            self.detailSecond = detailSecond
            var fullString = provinceKor
            if self.detailFirst != nil{
                fullString = fullString + " " + self.detailFirst!
            }
            if self.detailSecond != nil{
                fullString = fullString + " " + self.detailSecond!
            }
            self.full = fullString
        }
    }
    struct Guide{
        var id : String
        var imgUrl:String?
        var title : String?
        var subtitle : String?
        var webUrl : String?
        init(snapshot: QueryDocumentSnapshot){
            id = snapshot.documentID
            let snapshotValue = snapshot.data()
            imgUrl = snapshotValue["imgUrl"] as? String
            title = snapshotValue["title"] as? String
            subtitle = snapshotValue["subtitle"] as? String
            webUrl = snapshotValue["webUrl"] as? String
        }
    }
    
    struct HomeType : Identifiable ,Equatable{
        static func == (lhs: HomeGuideModel.HomeType, rhs: HomeGuideModel.HomeType) -> Bool {
            return lhs.title == rhs.title
        }
        var id : String
        var title : String
        var generalSupply : Int?
        var specialSupply :  Int?
        var totalSupply : Int
        var totalPrice : Price
        var firstPrice : Price
        var middlePrice : Price
        var finalPrice : Price
        var middlePriceLoanable : Bool
        var needMoneyFirst : String
        var needMoneyFinal : String
        var loanLimit : Price
        var size : Size
        var isChoosen:Bool = false
        var homeTypeCode : String
        var typeImgName: String?
        var firstCompetitionRate : CompetitionRate?
        var secondCompetitionRate : CompetitionRate?
        var winningScore : WinningScore?
        var estimatedScore : Int?
        init(idNum : Int, dictionary: Dictionary<String, Any>){
            id = "homeType_" + String(idNum)
            title = (dictionary["title"] as? String)!
            generalSupply = dictionary["generalSupply"] as? Int
            specialSupply = dictionary["specialSupply"] as? Int
            totalSupply = (dictionary["totalSupply"] as? Int)!
            totalPrice = Price(inText: (dictionary["totalPriceText"] as? String) ?? "0원", inNumeric: (dictionary["totalPriceNumeric"] as? Int) ?? 0)
            firstPrice = Price(inText: (dictionary["firstPriceText"] as? String) ?? "0원", inNumeric: (dictionary["firstPriceNumeric"] as? Int) ?? 0)
            middlePrice = Price(inText: (dictionary["middlePriceText"] as? String) ?? "0원", inNumeric: (dictionary["middlePriceNumeric"] as? Int) ?? 0)
            finalPrice = Price(inText: (dictionary["finalPriceText"] as? String) ?? "0원", inNumeric: (dictionary["finalPriceNumeric"] as? Int) ?? 0)
            middlePriceLoanable = (dictionary["middlePriceLoanable"] as? Bool) ?? false
            needMoneyFirst = (dictionary["needMoneyFirst"] as? String) ?? "0원"
            needMoneyFinal = (dictionary["needMoneyFinal"] as? String) ?? "0원"
            loanLimit = Price(inText: (dictionary["loanLimitText"] as? String) ?? "0원", inNumeric: (dictionary["loanLimitNumeric"] as? Int) ?? 0)
            size = Size(inMeter: (dictionary["sizeInMeter"] as? NSNumber)?.floatValue ?? 0, inPy: (dictionary["sizeInPy"] as? NSNumber)?.floatValue ?? 0)
            typeImgName = dictionary["typeImgName"] as? String
            homeTypeCode = dictionary["homeTypeCode"] as! String
            if let firstCompetitionRateDictionary = dictionary["firstCompetitionRate"] as? Dictionary<String,Any>{
                firstCompetitionRate = CompetitionRate(dictionary:firstCompetitionRateDictionary)
            }
            if let secondCompetitionRateDictionary = dictionary["secondCompetitionRate"] as? Dictionary<String,Any>{
                secondCompetitionRate = CompetitionRate(dictionary:secondCompetitionRateDictionary)
            }
            if let winningScoreDictionary = dictionary["winningScore"] as? Dictionary<String,Any>{
                winningScore = WinningScore(dictionary:winningScoreDictionary)
            }
            estimatedScore = dictionary["estimatedScore"] as? Int
        }
        
        
    }
    struct Price{
        var inText : String
        var inNumeric : Int
        init(_ priceInNumeric: Int){
            self.inNumeric = priceInNumeric
            var numericDivided = (Double(self.inNumeric)/100000000.0)
            numericDivided = (numericDivided * 100.0).rounded() / 100
            self.inText = String(numericDivided) + "억 원"
        }
        init(inText: String, inNumeric:Int){
            self.inText = inText
            self.inNumeric = inNumeric
        }
    }
    struct Size{
        var inMeter : Float
        var inPy : Float
    }
}
