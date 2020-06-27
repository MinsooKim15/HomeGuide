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
    
    init() {
        subscriptions = [Subscription]()
        guides = [Guide]()
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
        var typeList : [HomeType]
        
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
                    typeList.append(homeType)
                }
            }
        }
    }

    
    struct Address {
        var provinceCode : String
        var provinceKor : String
        var detailFirst : String?
        var detailSecond : String?
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
    }
    struct Size{
        var inMeter : Float
        var inPy : Float
    }
}
