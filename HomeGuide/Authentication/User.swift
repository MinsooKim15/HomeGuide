//
//  User.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/08/21.
//  Copyright © 2020 minsoo kim. All rights reserved.
//
import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

struct User{
    var uid : String
    var email : String?
    var displayName : String?
    var isAnonymous : Bool
    var userInfo : UserInfo
    init(uid:String, displayName: String? , email:String?, isAnonymous: Bool){
        self.uid = uid
        self.email = email
        self.displayName = displayName
        self.isAnonymous = isAnonymous
        self.userInfo = UserInfo()
    }
    mutating func updateData(uid:String, displayName: String? , email:String?){
        self.uid = uid
        self.email = email
        self.displayName = displayName
    }

    mutating func addHomeKey(keyCount: Int){
        print("addHomekey")
        print("변경전 Key 개수 \(self.userInfo.homeKey)")
        self.userInfo.homeKey = keyCount + self.userInfo.homeKey
        print("변경후 Key 개수 \(self.userInfo.homeKey)")
        self.updateUserInfo()
    }
    mutating func useHomeKey(keyCount: Int){
        print("addHomekey")
        print("변경전 Key 개수 \(self.userInfo.homeKey)")
        self.userInfo.homeKey = self.userInfo.homeKey - keyCount
        print("변경후 Key 개수 \(self.userInfo.homeKey)")
        
    }
    
    mutating func updateUserInfo(){
        let doc_ref = Firestore.firestore().collection("userInfos").document(uid)
        
        do {
            try doc_ref.setData(from: self.userInfo)
        } catch let error{
            print(error)
        }
    }
    mutating func addHomeType(homeType : HomeGuideModel.HomeType){
        print("적용 전 Subscription List")
        print(self.userInfo.showingSubscriptionList)
        self.userInfo.showingSubscriptionList.append(homeType.homeTypeCode)
        print("적용 후 Subscription List")
        print(self.userInfo.showingSubscriptionList)
        self.updateUserInfo()
    }

}
struct UserInfo: Codable{
    var homeKey: Int
    var showingSubscriptionList:[String]
    init(){
        self.homeKey = 1
        self.showingSubscriptionList = [String]()
        print("homeKey Init됨")
    }
    init(snapshot: DocumentSnapshot){
        if let snapshotValue = snapshot.data(){
            self.homeKey = snapshotValue["homeKey"] as! Int
            self.showingSubscriptionList = snapshotValue["showingSubscriptionList"] as! [String]
        }else{
            self.homeKey = 1
            self.showingSubscriptionList = [String]()
        }
    }
    enum CodingKeys: String, CodingKey{
        case homeKey
        case showingSubscriptionList
    }
}
