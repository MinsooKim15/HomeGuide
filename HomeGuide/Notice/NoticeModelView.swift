//
//  NoticeModelView.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/08/23.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

class NoticeModelView:ObservableObject{
    @Published var model = NoticeModel()
    init() {
        queryNoticeData()
    }
    func queryNoticeData(){
        let db = Firestore.firestore()
        db.collection("notices").getDocuments(){(querySnapshot, err) in
            if let _ = err{
                print("에러!")
            }else{
                self.model.snapshotsToNotices(snapshots : querySnapshot!.documents)
            }
        }
    }
    func toggleNotice(notice:NoticeModel.Notice){
        model.toggleNotice(notice:notice)
    }
}
