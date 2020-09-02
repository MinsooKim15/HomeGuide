//
//  Notice.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/08/23.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import Foundation
import Firebase
import Combine
import SwiftUI

struct NoticeModel{
    var notices : Array<Notice>
    mutating func snapshotsToNotices(snapshots:[QueryDocumentSnapshot]){
        
        for snapshot in snapshots{
            notices.append(Notice(snapshot: snapshot))
        }
        notices = notices.sorted(by: {$0.writtenDate > $1.writtenDate})
    }
    init() {
        notices = [Notice]()
    }
    mutating func toggleNotice(notice: NoticeModel.Notice){
        if let choosenNoticeIndex = notices.firstIndex(matching: notice){
            // save current choosenFilter data to filters
            notices[choosenNoticeIndex].opened = !notices[choosenNoticeIndex].opened
        }
    }
    struct Notice:Identifiable{
        var id : String
        var title : String
        var writtenDate : Date
        var updateDate : Date?
        var body: Array<NoticeBody>
        var opened : Bool
        var writtenDateString : String{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yy/MM/dd"
            let dateString = dateFormatter.string(from: self.writtenDate)
            return dateString
        }
        
        init(snapshot: QueryDocumentSnapshot) {
            id = snapshot.documentID
            let snapshotValue = snapshot.data()
            title = snapshotValue["title"] as! String
            writtenDate = (snapshotValue["writtenDate"] as? Timestamp)?.dateValue() as! Date
            updateDate = (snapshotValue["updateDate"] as? Timestamp)?.dateValue()
            body = [NoticeBody]()
            if let tempBodyList = snapshotValue["body"]{
                for (index, element) in (tempBodyList as? Array<Any>)!.enumerated(){
                    let noticeBody = NoticeBody(
                        idNum: index, dictionary: element as! Dictionary<String,Any>)
                    body.append(noticeBody)
                }
            }
            opened = false
            
        }
    }
    struct NoticeBody{
        var id : Int
        var type : NoticeModel.NoticeBodyType
        var textStyle : NoticeModel.NoticeBodyTextStyle
        var textValue : String?
        var imageUrl : String?
        var linkUrl : String?
        
        init(idNum : Int, dictionary: Dictionary<String, Any>) {
            id = idNum
            type = NoticeBodyType(rawValue:(dictionary["type"] as! String))!
            textStyle = NoticeBodyTextStyle(rawValue:(dictionary["textStyle"] as? String) ?? "plain")!
            textValue = dictionary["textValue"] as? String
            imageUrl = dictionary["imageUrl"] as? String
            linkUrl = dictionary["linkUrl"] as? String
        }
    }
    enum NoticeBodyTextStyle:String{
        case plain = "plain"
        case bold = "bold"
    }
    enum NoticeBodyType:String{
        case text = "text"
        case image = "image"
        case linkedText = "linkedText"
    }
}
