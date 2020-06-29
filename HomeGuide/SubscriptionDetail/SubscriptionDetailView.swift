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
    
    let paddingToLead = CGFloat(20)
    
    let titlePaddingTop = CGFloat(20)
    let descriptionAPaddingTop = CGFloat(14)
    let descriptionBPaddingTop = CGFloat(8)
    let descriptionBPaddingBottom = CGFloat(18)
    
    let fontColorHighlight = Color(hex: "FF4162")
    let fontColorDescriptionB = Color(hex:"A0A0A2")
    let datePaddingToTrail = CGFloat(32)
    
    var subscription: HomeGuideModel.Subscription
    var body: some View{
        VStack(alignment:.leading){
            Text(subscription.title)
                .font(.custom(self.customFontExtraBold, size: self.titleFontSize))
                .padding([.top], self.titlePaddingTop)
            Text(subscription.address.full)
                .font(.custom(self.customFontRegular,size:self.descriptionAFontSize))
                .padding([.top], self.descriptionAPaddingTop)
            HStack{
                Text(subscription.buildingType)
                Text("|")
                Text(subscription.subscriptionType)
            }
                .font(.custom(self.customFontRegular,size:self.descriptionBFontSize))
                .padding([.top], self.descriptionBPaddingTop)
                .padding([.bottom], self.descriptionBPaddingBottom)
                .foregroundColor(self.fontColorDescriptionB)
        }
        
    }
}

struct SubscriptionSummaryView: View{
    let customFontRegular = "NanaumSquareOTFR"
    let customFontLight = "NanaumSquareOTFL"
    let customFontBold = "NanaumSquareOTFB"
    let customFontExtraBold = "NanaumSquareOTFEB"
    let titleFontSize = CGFloat(24)
    let paddingToLead = CGFloat(20)
    
    var subscription : HomeGuideModel.Subscription
    var body: some View{
        VStack {
            Text("상세 정보")
                .font(.custom(self.customFontRegular, size: self.titleFontSize))
            VStack{
                Group{
                    if (subscription.startDate != nil)&&(subscription.endDate != nil){
                        HStack{
                            Text("접수")
                            Spacer()
                            Text(subscription.startDate!.getString()+" ~ "+subscription.endDate!.getString())
                        }
                    }
                }
                Group{
                    if (subscription.lowestPrice != nil)&&(subscription.highestPrice != nil){
                        HStack{
                            Text("접수")
                            Spacer()
                            Text(subscription.lowestPrice!.inText+" ~ "+subscription.highestPrice!.inText)
                        }
                    }
                }
                Group{
                    HStack{
                        Text("분양세대")
                        Spacer()
                        Text("\(subscription.totalSupply)")
//                        Text(String(subscription.totalSupply))
                    }
                }
            }
        }

    }
}

//Group{
//    if (subscription.startDate != nil)&&(subscription.endDate != nil){
//        return SmallRowView(header:"접수", value:subscription.startDate.getString()+" ~ "+subscription.endDate.getString())
//    }
//}
//    //Group{
//        Text("상세 정보")
//
//            Group{
//                if (subscription.lowestPrice != nil)&&(subscription.highestPrice != nil){
//                    return SmallRowView(header:"분양가격", value:(subscription.lowestPrice?.inText + " ~ " + subscription.highestPrice?.inText) )
//                }
//            }
//            SmallRowView(header:"분양세대", value:String(subscription.totalSupply))
//        Text("안녕")
//    }
//    }
    
    
    
struct SmallRowView: View{
    var header:String
    var value: String
    var body:some View{
        return HStack{
            Text(header)
            Spacer()
            Text(value)
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

