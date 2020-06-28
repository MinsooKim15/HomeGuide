//
//  SubscriptionDetailView.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/06/27.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import SwiftUI

struct SubscriptionDetailView : View{
    var subscription: HomeGuideModel.Subscription
    var body: some View{
        VStack{
            List{
                SubscriptionHeadView()
                SubscriptionScheduleView()
                SubscriptionPriceView()
                if subscription.naverLink != nil{
                    SubscriptionLinkView(title: "네이버에서 보기", link : subscription.naverLink!)
                }
                if subscription.officialLink != nil{
                    SubscriptionLinkView(title: "청약홈에서 보기", link : subscription.officialLink!)
                }
                if subscription.documentLink != nil{
                    SubscriptionLinkView(title: "공고 파일 보기", link : subscription.documentLink!)
                }
            }
        }

    }
}
struct SubscriptionHeadView: View{
    var body: some View{
        Text("메인 정보 표기")
    }
}
struct SubscriptionScheduleView: View{
    var body : some View{
        Text("스케줄 표기")
    }
}
struct SubscriptionPriceView : View{
    var body: some View{
        Text("가격 표기")
    }
}
struct SubscriptionLinkView: View{
    var title : String
    var link : String
    var body: some View{
        Text("\(title)")
    }
}

