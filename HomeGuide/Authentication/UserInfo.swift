////
////  UserInfo.swift
////  HomeGuide
////
////  Created by minsoo kim on 2020/08/26.
////  Copyright © 2020 minsoo kim. All rights reserved.
////
//
//import Foundation
//import Firebase
//import FirebaseFirestoreSwift
//import FirebaseFirestore
//
//struct UserInfo : Codable{
//    var id : String
//    var homeKey : Int
//    var showingSubscriptionList : [String]
//
//    mutating func getAndSetUserInfo(snapshot: DocumentSnapshot){
//        self.id = snapshot.documentID
//        if let snapshotValue = snapshot.data(){
//            self.homeKey = snapshotValue["homeKey"] as! Int
//            self.showingSubscriptionList = snapshotValue["showingSubscriptionList"] as! [String]
//        }else{
//            self.homeKey = 1
//            self.showingSubscriptionList = [String]()
//        }
//    }
//
//    init(uid:String){
//        self.id = uid
//        self.homeKey = 1
//        self.showingSubscriptionList = []
//    }
//
//    enum CodingKeys: String, CodingKey{
//        case homeKey
//        case showingSubscriptionList
//    }
////    NotUser For Now
//    init(from decoder:Decoder) throws {
//        _ = try decoder.container(keyedBy: CodingKeys.self)
//        id = "0"
//        homeKey = 0
//        showingSubscriptionList = [String]()
//    }
//    mutating func addSubscription(subscription:HomeGuideModel.Subscription){
//        self.showingSubscriptionList.append(subscription.id)
//        self.updateUserInfo()
//    }
//    mutating func checkShowingList(subscription:HomeGuideModel.Subscription)->Bool{
//        for showingSubscriptionId in self.showingSubscriptionList{
//            if showingSubscriptionId == subscription.id{
//                return true
//            }
//        }
//        return false
//    }
//    mutating func addHomeKey(keyCount:Int){
//        self.homeKey = self.homeKey + keyCount
//        self.updateUserInfo()
//    }
//    func updateUserInfo(){
//        do {
//            try Firestore.firestore().collection("userInfos").document(self.id).setData(from:self)
//        } catch let error{
//            print("Error writing userInfo to Firestore: \(error)")
//        }
//    }
//}
////class UserInfoStore:ObservableObject{
////    func addHomeKey(keyCount: Int){
////        print("addHomeKey! in UserInfoStore")
////        self.userInfo.addHomeKey(keyCount:keyCount)
////    }
////    @Published var userInfo : UserInfo
////    func getUserInfo(uid:String){
////        let doc_ref = Firestore.firestore().collection("userInfos").document(uid)
////        doc_ref.getDocument{(document,error) in
////            if document?.exists ?? false{
////                self.userInfo = UserInfo(snapshot:document as! QueryDocumentSnapshot)
////            }else{
////                self.updateUserInfo()
////            }
////        }
////    }
////}
