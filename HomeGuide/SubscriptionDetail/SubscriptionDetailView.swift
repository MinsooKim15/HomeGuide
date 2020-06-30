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
                
                SubscriptionHeadView(subscription : subscription).cardify()
                
                SubscriptionSummaryView(subscription: subscription).cardify()
                SubscriptionScheduleView(subscription : subscription).cardify()
                SubscriptionPriceView(subscription : subscription).cardify()
                if subscription.naverLink != nil{
                    SubscriptionLinkView(title: "네이버에서 보기", link : subscription.naverLink!).cardify()
                }
                if subscription.officialLink != nil{
                    SubscriptionLinkView(title: "청약홈에서 보기", link : subscription.officialLink!).cardify()
                }
                if subscription.documentLink != nil{
                    SubscriptionLinkView(title: "공고 파일 보기", link : subscription.documentLink!).cardify()
                }
            }.listRowInsets(EdgeInsets())
            }
        .navigationBarTitle("")
        .navigationBarHidden(true)

    }
}
struct SubscriptionHeadView: View{
    // MARK: - Control Panel for UI
    let customFontRegular = "NanaumSquareOTFR"
    let customFontLight = "NanaumSquareOTFL"
    let customFontBold = "NanaumSquareOTFB"
    let customFontExtraBold = "NanaumSquareOTFEB"
    let titleFontSize = CGFloat(24)
    let descriptionAFontSize = CGFloat(16)
    let descriptionBFontSize = CGFloat(14)
    let priceFontSize = CGFloat(20)
    let titleFontStyle = CustomFontStyle.headTitle
    let descriptionAFontStyle = CustomFontStyle.headDescriptionA
    let descriptionBFontStyle = CustomFontStyle.headDescriptionB
    
    let titlePaddingTop = CGFloat(20)
    let descriptionAPaddingTop = CGFloat(14)
    let descriptionBPaddingTop = CGFloat(8)
    let descriptionBPaddingBottom = CGFloat(18)
    
    let fontColorHighlight = Color(hex: "FF4162")
    let fontColorDescriptionB = Color(hex:"A0A0A2")
    let datePaddingToTrail = CGFloat(32)
    
    var subscription: HomeGuideModel.Subscription
    var body: some View{
        HStack{
            VStack(alignment:.leading){
                Text(subscription.title)
                    .adjustFont(fontStyle:self.titleFontStyle)
                    .padding([.top], self.titlePaddingTop)
                Text(subscription.address.full)
                    .adjustFont(fontStyle:self.descriptionAFontStyle)
                    .padding([.top], self.descriptionAPaddingTop)
                HStack{
                    Text(subscription.buildingType)
                    Text("|")
                    Text(subscription.subscriptionType)
                }
                    .adjustFont(fontStyle:self.descriptionBFontStyle)
                    .padding([.top], self.descriptionBPaddingTop)
                    .padding([.bottom], self.descriptionBPaddingBottom)
                    .foregroundColor(self.fontColorDescriptionB)
            }
            Spacer()
        }
    }
}

struct SubscriptionSummaryView: View{
    // TODO : extension 이용해서, 전체 Color, Font, FontSize Control
    let sectionTitleFontStyle = CustomFontStyle.sectionTitle
    let descriptionFontStyle = CustomFontStyle.sectionSmallDescriptionA
    
    let descriptionPaddingTop = CGFloat(14)
    let paddingToTrail = CGFloat(20)
      
    var subscription : HomeGuideModel.Subscription
    var body: some View{
        VStack {
            HStack{
                Text("상세 정보")
                    .adjustFont(fontStyle: self.sectionTitleFontStyle)
                Spacer()
            }
            HStack{
                // 앞은 cardify 값만큼만
                VStack{
                    Group{
                        if (subscription.startDate != nil)&&(subscription.endDate != nil){
                            SmallRowView(header: "접수", value: subscription.startDate!.getString()+" ~ "+subscription.endDate!.getString())
                        }
                    }
                    Group{
                        if (subscription.lowestPrice != nil)&&(subscription.highestPrice != nil){
                            SmallRowView(header:"분양가", value:subscription.lowestPrice!.inText+" ~ "+subscription.highestPrice!.inText )
                        }
                    }
                    SmallRowView(header:"분양세대", value:"\(subscription.totalSupply)" )
                }
                Spacer().frame(width:self.paddingToTrail)
            }
            .adjustFont(fontStyle:self.descriptionFontStyle)
            .padding([.top], self.descriptionPaddingTop)
        }

    }
}

    
struct SmallRowView: View{
    let columnTitleFontColor = Color.lightGrey
    let columnValueFontColor = Color.grey
    var header:String
    var value: String
    var body:some View{
        return HStack{
            Text(header)
                .foregroundColor(self.columnTitleFontColor)
            Spacer()
            Text(value)
                .foregroundColor(self.columnValueFontColor)
        }

    }
}

struct SubscriptionScheduleView: View{
    var subscription: HomeGuideModel.Subscription
    var body : some View{
        Text("스케줄 표기")
    }
}
struct SubscriptionPriceView : View{
    var subscription: HomeGuideModel.Subscription
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

