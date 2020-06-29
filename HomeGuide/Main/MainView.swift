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
    // 여기서 배경색 컨트롤
    let backgroundColorView: some View = Color(hex:"F0F0F0")
    
    var body: some View {
            // 배경색
        NavigationView(){
            ZStack(){
                    backgroundColorView.edgesIgnoringSafeArea(.all)
                VStack(spacing : 0){
                        HeadView()
                        Spacer().frame(height:1)
                        FilterView(modelView:modelView)
                        Spacer().frame(height:3)
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
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                }
            }
    }
}


struct HeadView: View{
    // Control for all UI Numbers
    let headViewPaddingToTop = CGFloat(20)
    let titlePaddingToLeading = CGFloat(20)
    let customFontRegular = "NanaumSquareOTFR"
    let customFontLight = "NanaumSquareOTFL"
    let customFontBold = "NanaumSquareOTFR"
    let customFontExtraBold = "NanaumSquareOTFR"
    let headFontSize = CGFloat(28)
    let headBackgroundColor:some View = Color.white
    let maxHeight = CGFloat(100)
    let fontColorHighlight = Color(hex:"FF4162")
    
    var body: some View{
        ZStack{
            headBackgroundColor.edgesIgnoringSafeArea(.all)
            HStack{
                Text("청줍 가이드")
                    .font(.custom(customFontRegular, size: headFontSize))
                    .padding([.leading], titlePaddingToLeading)
                Spacer()
            }
            .padding([.top],headViewPaddingToTop)
        }
        .frame(maxHeight : maxHeight)
    }
}


struct FilterView: View{
    @ObservedObject var modelView: HomeModelView
    let paddingToLead = CGFloat(20)
    let burbleNotChoosenStrokeColor = Color(hex:"9C9B9E")
    let burbleChoosenStrokeColor = Color(hex:"FF4162")
    let spaceBetweenFilterBubble = CGFloat(10)
    let minBubbleWidth = CGFloat(90)
    let maxBubbleWidth = CGFloat(120)
    let maxBubbleHeight = CGFloat(30)
    let customFontRegular = "NanaumSquareOTFR"
    let fontSize = CGFloat(16)
    let frameHeight = CGFloat(80)
    let unOpenedMaxHeight = CGFloat(70)
    var body: some View{
        Group{
            if !modelView.model.isFilterOpen{
                ZStack{
                    Color.white
                    HStack{
                        ScrollView(.horizontal, showsIndicators : false){
                            HStack{
                                Spacer().frame(width: paddingToLead)
                                ForEach(modelView.model.filters, id: \.self.titleDisplay){ filter in
                                    Group{
                                        Text(filter.choosenOptionString)
                                            .burblify(isChoosen:filter.isChoosen, notChoosenStrokeColor: self.burbleNotChoosenStrokeColor ,choosenStrokeColor : self.burbleChoosenStrokeColor)
                                            .frame(minWidth: self.minBubbleWidth, maxWidth: self.maxBubbleWidth, maxHeight : self.maxBubbleHeight, alignment : .center)
                                            .font(.custom(self.customFontRegular, size:self.fontSize))
                                            .padding([.top,.bottom], 5)
                                        Spacer().frame(width:self.spaceBetweenFilterBubble)
                                    }
                                }

                            }
                        }
                        Spacer()
                        Button(action:modelView.openFilter){return Text("펼치기")}
                    }
                }
                .frame(maxHeight : self.unOpenedMaxHeight)
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
        }.frame(minHeight: self.frameHeight)
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
        Group{
            if modelView.model.choosenFilterCategory != nil{
                ScrollView{
                    HStack{
                        Text("\(modelView.model.choosenFilterCategory!.titleDisplay)")
                        ForEach(modelView.model.choosenFilterCategory!.optionList!,id:\.self){ option in
                            Group{
                                if !option.choosen {
                                    Text("\(option.value)").onTapGesture {
                                        self.modelView.chooseFilterOption(filterOption: option)
                                    }
                                }else{
                                    Text("\(option.value)").onTapGesture {
                                        self.modelView.chooseFilterOption(filterOption: option)
                                    }.foregroundColor(Color.red)
                                }
                            }
                        }
                    }
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


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let modelView = HomeModelView()
        return MainView(modelView : modelView)
    }
}
