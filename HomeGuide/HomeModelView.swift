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

    var model: HomeGuideModel = HomeGuideModel()
    
    func getData(){
        let db = Firestore.firestore()
        db.collection("subscriptions").getDocuments{(querySnapshot, err) in
            if let err = err{
                print("에러!: \(err)")
            }else{
                self.model.snapshotsTosubscriptions(snapshots: querySnapshot!.documents)
                
                for subscription in self.model.subscriptions{
                    print(subscription)
                }
            }
        }
    }
}
