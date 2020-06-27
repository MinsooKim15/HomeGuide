//
//  SubscriptionDetailView.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/06/27.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import SwiftUI

struct SubscriptionDetailView : View{
    var subscription : HomeGuideModel.Subscription
    var body: some View{
        Text("\(subscription.title)에 온걸 환영해!")
    }
}
