//
//  ContentView.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/06/25.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var modelView : HomeModelView
    var body: some View {
        NavigationView{
            VStack{
                HeadView()
                FilterView(modelView:modelView)
                if !modelView.model.isFilterOpen{
                    List{
                        ForEach(modelView.model.subscriptions, id:\.self.id){subscription in
                            NavigationLink(destination: SubscriptionDetailView(subscription: subscription)){
                                SubscriptionCardView(subscription: subscription)
                            }
                         }
                    }
                }
            }
        }
    }
}


struct HeadView: View{
    var body: some View{
        Text("여기가 머리")
        
    }
}
struct FilterView: View{
    @ObservedObject var modelView: HomeModelView
    var body: some View{
        Group{
            if !modelView.model.isFilterOpen{
                HStack{
                    Text("여기가 필터")
                    Button(action:modelView.openFilter){return Text("펼치기")}
                }
            }else{
                VStack{
                    VStack{
                        ForEach(modelView.model.filters, id:\.self.titleDisplay){ filter in
                            FilterRowView(modelView: self.modelView, filterCategory: filter)
                        }
                    }
                    if modelView.model.choosenFilterCategory != nil{
                        FilterDetailView(modelView: self.modelView)
                    }
                    Button(action:modelView.closeFilter){
                        return Text("닫기")
                    }
                }
            }
        }
    }

}
struct FilterRowView : View{
    var modelView: HomeModelView
    var filterCategory : HomeGuideModel.FilterCategory
    var body: some View{
        VStack{
            HStack{
                Button(action: chooseFilter){
                    return Text("\(filterCategory.titleDisplay)")
                }
            }
        }
    }
    func chooseFilter(){
        modelView.chooseFilterCategory(filterCategory: self.filterCategory)
    }
}

struct FilterDetailView: View{
    @ObservedObject var modelView:HomeModelView
    var body: some View{
        ScrollView{
            HStack{
                Text("\(modelView.model.choosenFilterCategory!.titleDisplay)")
                ForEach(modelView.model.choosenFilterCategory!.optionList!,id:\.self){ option in
                    Text("\(option.value)")
                }
            }
        }
    }
}

struct SubscriptionCardView: View{
    var subscription : HomeGuideModel.Subscription
    var body: some View{
        VStack{
            Text(subscription.title)
            Text(subscription.address.provinceKor + (subscription.address.detailFirst ?? ""))
            Text(subscription.buildingType + subscription.subscriptionType)
        }
    }
}
