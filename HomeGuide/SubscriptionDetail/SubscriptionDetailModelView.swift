//
//  SubscriptionDetailModelView.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/06/28.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import SwiftUI

class SubscriptionDetailModelView{
    
    var model : SubscriptionDetail = SubscriptionDetail()
    // MARK: - Intents
    func setSubscription(subscription: HomeGuideModel.Subscription){
        model.subscription = subscription
    }
}
