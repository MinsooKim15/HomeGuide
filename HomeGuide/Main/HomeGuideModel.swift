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
    
    // MARK: - For UI
    var isFilterOpen : Bool = false
    
    // MARK : - For Filtering
    var choosenFilterCategory: FilterCategory?

    
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
            var choosenString = ""
            var choosenCounter = 0
            if isChoosen{
                if let tempOptionList = optionList{
                    for option in tempOptionList{
                        if option.choosen{
                            if choosenString == ""{
                                choosenString = String(option.value)
                                choosenCounter = 1
                            }else{
                                choosenString = choosenString + " 외 \(choosenCounter)"
                                choosenCounter += 1
                            }
                        }
                    }
                }
                return choosenString
            }else{
                return self.titleDisplay
            }

        }

        
        init(dictionary: Dictionary<String,Any>,id:Int) {
            self.id = id
            titleDisplay = dictionary["titleDisplay"] as! String
            titleQuery = dictionary["titleQuery"] as! String
            var tempList = [FilterOption]()

            if (dictionary["type"] as! String ) == "discrete"{
                dataType = .discrete
                var filterId = 0
                for option in (dictionary["optionList"] as! Array<String>){
                    tempList.append(FilterOption(id: filterId, value : option))
                    filterId += 1
                }
            }else{
                dataType = .range
                filterRange = FilterRange(array : (dictionary["optionRange"] as! Array<Double>))
            
            }
            optionList = tempList
        }
    }
    struct FilterRange{
        var startData: Double
        var endData : Double
        init(array: Array<Double>) {
            startData = array[0]
            endData = array[1]
        }
    }
    enum DataStyle {
        case discrete
        case range
    }
    
    struct FilterOption:Identifiable, Hashable{
        var id: Int
        // It will be displayed and query
        var value : String
        var choosen : Bool = false
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
    }
    mutating func snapshotsToGuides(snapshots:[QueryDocumentSnapshot]){
        for snapshot in snapshots{
            subscriptions.append(Subscription(snapshot:snapshot))
        }
    }
    
    struct Subscription{
        var id : String
        var title : String
        var address : Address
        var buildingType : String
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
        var iconName: String {
            if (self.buildingType == "아파트") || (self.buildingType == "apt"){
                let number = Int.random(in: 1..<4)
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

        
        init(snapshot: QueryDocumentSnapshot) {
            id = snapshot.documentID
            let snapshotValue = snapshot.data()
            print(snapshotValue)
            title = (snapshotValue["title"] as! String)
            address = Address(
                provinceCode : (snapshotValue["addressProvinceCode"] as? String) ?? "seoul",
                provinceKor: (snapshotValue["addressProvinceKor"] as? String) ?? "서울시",
                detailFirst: (snapshotValue["addressDetailFirstKor"] as? String),
                detailSecond: (snapshotValue["addressDetailSecondKor"] as? String)
            )
            buildingType = (snapshotValue["buildingType"] as? String) ?? "apart"
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
            zoneType = (snapshotValue["zoneType"] as? Int) ?? 1
            officialLink = (snapshotValue["officialLink"] as? String)
            naverLink = (snapshotValue["naverLink"] as? String)
            documentLink = (snapshotValue["documentLink"] as? String)
            typeList = [HomeType]()
            if let tempTypeList = snapshotValue["typeList"]{
                for (index, element) in (tempTypeList as? Array<Any>)!.enumerated(){
                    // TODO : - Array의 Index를 넣어주세요
                    let homeType = HomeType(
                        idNum: index, dictionary: element as! Dictionary<String,Any>)
                    typeList?.append(homeType)
                }
            }
            lowestPrice = getLowestPrice()
            highestPrice = getHighestPrice()
            dateLeftInString = getDateLeftString()
            startDate = getStartDate()
            endDate = getEndDate()
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
        func getHighestPrice()-> Price?{
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
        
        
        func getLowestPrice()-> Price?{
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
        func getDateLeftString() -> String?{
            // MARK : Nil error 주의
            var dateLeftString : String?
            
            if self.notPassed(dateSpecialSupplyNear!){
               dateLeftString = getDateLeftString(from: dateSpecialSupplyNear!)
            }
            if self.notPassed(dateSpecialSupplyOther!){
                dateLeftString = getDateLeftString(from: dateSpecialSupplyNear!)
            }
            if self.notPassed(dateFirstNear!){
                dateLeftString = getDateLeftString(from: dateSpecialSupplyNear!)
            }
            if self.notPassed(dateFirstOther!){
                dateLeftString = getDateLeftString(from: dateSpecialSupplyNear!)
            }
            if self.notPassed(dateSecondNear!){
                dateLeftString = getDateLeftString(from: dateSpecialSupplyNear!)
            }
            if self.notPassed(dateSecondOther!){
                dateLeftString = getDateLeftString(from: dateSpecialSupplyNear!)
            }
            return dateLeftString
        }
        func getDateLeftString(from targetDate:Date) -> String{
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
            let weekDiff = (targetWeek - currentWeek)
            let monthDiff = (targetMonth - currentMonth)
            
            var resultString = ""
            // 같은 달 안 인가?
            
            if (interval.day == 0)&&(dayDiff == 0){
                resultString = "오늘"
            }else if (targetMonth == currentMonth)&&(dayDiff < 7){
                resultString = "D-\(dayDiff)"
            }else{
                resultString = "\(targetMonth)/\(targetDay)"
            }
//
//
//
//
//            var string = ""
//            if targetWeek > currentWeek{
//                if ((weekDiff <= 4) || (monthDiff == 0)){
//                    string = "\(weekDiff)주 후"
//                }else{
//                    string = "\(monthDiff)개월 뒤"
//                }
//            }else{
//
//                if dayDiff == 0 {
//                    string = "오늘"
//                }else{
//                    string = "D - \(dayDiff)"
//                }
//            }
            return resultString
        }
        func notPassed(_ targetDate:Date)-> Bool{
            if targetDate >= Date(){
                return true
            }else{
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
    
    struct HomeType{
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
        var needMoneyFirst : Int
        var needMoneyFinal : Int
        var loanLimit : Int
        var size : Size
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
            needMoneyFirst = (dictionary["needMoneyFirst"] as? Int) ?? 0
            needMoneyFinal = (dictionary["needMoneyFinal"] as? Int) ?? 0
            loanLimit = (dictionary["loanLimit"] as? Int) ?? 0
            
            size = Size(inMeter: (dictionary["sizeInMeter"] as? NSNumber)?.floatValue ?? 0, inPy: (dictionary["sizeInPy"] as? NSNumber)?.floatValue ?? 0)
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
