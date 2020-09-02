//
//  HomeKeyScoreView.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/08/27.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import SwiftUI
import GoogleMobileAds

struct HomeKeyScoreView:View{
    @EnvironmentObject var session: SessionStore
    var homeKeyText : Int{
        if (session.session == nil) || (self.session.session?.isAnonymous == true) || (self.session.session?.userInfo.homeKey == nil){
            return 0
        }else{
            return self.session.session?.userInfo.homeKey ?? 0
        }
    }
    let titleFontStyle = CustomFontStyle.sectionTitle
    let titleFontColor = Color.black
    let valueFontColor = Color.grey
    let valueFontStyle = CustomFontStyle.headTitle
    let paddingToLead = CGFloat(0)
    let heightOfItem = CGFloat(60)
    let homekeyImageViewSize = CGFloat(40)
    let paddingToTrail = CGFloat(20)
    let adButtonFont = CustomFontStyle.sectionDescription
    @State var showPopover : Bool = false
    var rewardAd:Rewarded
    init(){
        self.rewardAd = Rewarded()
    }
    
    func rewardFunction(){
        self.showPopover = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.session.addHomeKey(keyCount: 3)
            DispatchQueue.main.asyncAfter(deadline: .now()+1){
                self.showPopover = false
            }
            
        }
    }
    let spaceBetweenNavAndBody = CGFloat(80)
    let spaceBetweenBodyImageAndDivider = CGFloat(30)
    let spaceBetweenBodyDividerAndNumber = CGFloat(30)
    let spaceBetweenBodyAndDescription = CGFloat(60)
    let dividerWidth = CGFloat(40)
    let keyNumberColor = Color.grey
    let descriptionFont = CustomFontStyle.sectionDescription
    let descriptionSmallFont = CustomFontStyle.sectionSmallDescriptionB
    let paddingDescriptionToLeadAndTrail = CGFloat(40)
    let spaceBetweenDescription = CGFloat(20)
    var body: some View{
        VStack{
            // Custom Navigation이랑 Body만 쌓음
            CustomNavigationBar(hasTitleText: false, titleText: "")
            Spacer()
                .frame(height: self.spaceBetweenNavAndBody)
            Group{
                // Body를 본문, 설명문, Button으로 구분
                Group{
                    Image("HomeKey")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: self.homekeyImageViewSize, height: self.homekeyImageViewSize)
                    Spacer()
                        .frame(height: self.spaceBetweenBodyImageAndDivider)
                    Rectangle()
                        .fill()
                        .frame(width: self.dividerWidth, height: 1)
                        .foregroundColor(.coralRed)
                    Spacer()
                        .frame(height: self.spaceBetweenBodyDividerAndNumber)
                    MovingNumbersView(number: Double(self.session.session?.userInfo.homeKey ?? 1), numberOfDecimalPlaces: 0){txt in
                        Text(txt)
                            .foregroundColor(self.keyNumberColor)
                            .adjustFont(fontStyle: self.valueFontStyle)
                    }
                }
                Spacer()
                    .frame(height: self.spaceBetweenBodyAndDescription)
                Group{
                    //  Description
                    Group{
                        Text("청줍 가이드만의 정보를 확인하는 데 사용할 수 있어요.")
                        Text("광고를 시청하시고 3개의 키를 받으세요.")
                    }
                    .foregroundColor(.gray)
                    .adjustFont(fontStyle: self.descriptionFont)
                    Spacer()
                        .frame(height: self.spaceBetweenDescription)
                }
                .padding([.trailing, .leading], self.paddingDescriptionToLeadAndTrail)
                Spacer()
                // Button
                ZStack{
                    Rectangle()
                        .fill()
                        .foregroundColor(.coralRed)
                    Text("광고보고 HomeKey 얻기")
                        .foregroundColor(.white)
                        .adjustFont(fontStyle: self.adButtonFont)
                }
                .frame(height: 60)
                .onTapGesture {
                    self.rewardAd.showAd(rewardFunction: self.rewardFunction)
                }
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}


// ZStack{
//         VStack{
//             CustomNavigationBar(hasTitleText: false, titleText: "")
//             Spacer()
//              ZStack(alignment:.leading){
//                        Color.white
//                        VStack(alignment:.leading){
//                         GeometryReader{ geometry in
//                         HStack{
//                             Spacer()
//                             VStack{
//                                 Spacer().frame(height:geometry.size.height*0.3)
//                                 Group{
//                                     Image("HomeKey")
//                                         .resizable()
//                                         .aspectRatio(contentMode: .fill)
//                                         .frame(width: self.homekeyImageViewSize, height: self.homekeyImageViewSize)
//                                     Spacer()
//                                     Rectangle()
//                                         .fill()
//                                         .frame(width: 30, height: 1)
//                                         .foregroundColor(.coralRed)
//                                     Spacer()
//                                     MovingNumbersView(number: Double(self.session.session?.userInfo.homeKey ?? 1), numberOfDecimalPlaces: 0){txt in
//                                         Text(txt)
//                                             .foregroundColor(.coralRed)
//                                             .adjustFont(fontStyle: self.valueFontStyle)
//                                     }
//                                 }
//                                 Spacer()
//                                     .frame(height:geometry.size.height*0.6)
//                                 Spacer()
//                                 ZStack{
//                                     Rectangle()
//                                         .fill()
//                                         .foregroundColor(.coralRed)
//                                     Text("광고보고 HomeKey 얻기")
//                                         .foregroundColor(.white)
//                                         .adjustFont(fontStyle: self.adButtonFont)
//                                 }.frame(height: 60)
//                                 .onTapGesture {
//                                     self.rewardAd.showAd(rewardFunction: self.rewardFunction)
//                                 }
//                             }
//                             Spacer()
//
//                         }
//                            .padding()
//                            Spacer()
//
//                        }
//                        .padding([.leading], self.paddingToLead)
//
//                    }
//                .frame(height:self.heightOfItem)
//
//         }
//     }
// }
//
// .navigationBarTitle("")
//.navigationBarHidden(true)

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        let insertion = AnyTransition.move(edge: .trailing)
            .combined(with: .opacity)
        let removal = AnyTransition.scale
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}
//Group{
//    if self.showPopover{
//        Color.gray.opacity(0.5)
//        HomeKeyPopoverView(homeKey: session.session?.userInfo.homeKey ?? 1)
//            .transition(.moveAndFade)
//    }
//}
