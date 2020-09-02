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
    @ObservedObject var modelView : HomeModelView
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var session: SessionStore
    let navBarPaddingToLead = CGFloat(20)
    let navBarPaddingToTop = CGFloat(20)
    let navBarMaxHeight = CGFloat(50)
    var body: some View{
        ZStack{
            VStack(spacing:0){
                        ZStack{
                            Color.white.edgesIgnoringSafeArea(.all)
                        VStack(spacing:0){
                                HStack{
                                    Button(action:{self.presentationMode.wrappedValue.dismiss()} ){
                                        return Image(systemName: "chevron.left").foregroundColor(.coralRed)
                                    }
            //                        .frame(width:30, height:30)
                                    .padding([.leading], self.navBarPaddingToLead)
                                    .padding([.top], self.navBarPaddingToTop)
                                    Spacer()
                                }
                                Spacer()
                                ExDivider()
                            }
                        }
                        .frame(maxHeight: self.navBarMaxHeight)
                        .onAppear {
                            self.modelView.showDescriptionScreen(self.subscription)
                        }
                        List{
                            SubscriptionHeadView(subscription : subscription)
                                .cardify(.head)
                            if subscription.imgName != nil{
                                VStack{
                                    Spacer().frame(height: 10)
                                    FirebaseImage(id: subscription.imgName ?? "")
                                        .scaleEffect(x: 1.1, y: 1.1, anchor: .center)
                                }
                            }
                            
                            SubscriptionSummaryView(subscription: subscription).cardify()
                            if subscription.dateNotice != nil{
                                SubscriptionScheduleView(subscription : subscription).cardify()
                            }
                            SubscriptionPriceView(subscription : subscription, modelView: self.modelView)
                                .cardify(.noTrail)
                            if (subscription.chosenHomeType != nil) && (subscription.subscriptionType == "민영") && (subscription.chosenHomeType?.estimatedScore != nil) && (subscription.firstOtherDidNotPassed){
                                SubscriptionScoreView(homeType: subscription.chosenHomeType!, homeGuideModelView: self.modelView).cardify()
                            }
                            if subscription.naverLink != nil{
                                SubscriptionLinkView(title: "네이버에서 보기", link : subscription.naverLink!).cardify(.small)
                            }
                            if subscription.officialLink != nil{
                                SubscriptionLinkView(title: "청약홈에서 보기", link : subscription.officialLink!).cardify(.small)
                            }
                            Banner()
                            if subscription.documentLink != nil{
                                SubscriptionLinkView(title: "공고 파일 보기", link : subscription.documentLink!).cardify(.small)
                            }
                            
                        }
                        .listRowInsets(EdgeInsets())
                        

                        }
                    .foregroundColor(.black)
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
            Group{
//                여기는 점수 팝업 공간
                if self.modelView.model.showHomeKeyPopUp{
                    Color.grey.opacity(0.5).edgesIgnoringSafeArea(.all)
                    HomeKeyPopoverView(homeKey: self.session.session?.userInfo.homeKey ?? 0)
                }
            }
        }
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
                    if subscription.subscriptionType.count > 1{
                        Text("|")
                        Text(subscription.subscriptionType)
                    }
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
    
    let descriptionPaddingTop = CGFloat(16)
    let paddingToTrail = CGFloat(20)
    let paddingBetweenRow = CGFloat(8)
      
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
                                .padding([.bottom], self.paddingBetweenRow)
                        }
                    }
                    Group{
                        if (subscription.lowestPrice != nil)&&(subscription.highestPrice != nil){
                            SmallRowView(header:"분양가", value:subscription.lowestPrice!.inText+" ~ "+subscription.highestPrice!.inText )
                            .padding([.bottom], self.paddingBetweenRow)
                        }
                    }
                    SmallRowView(header:"분양세대", value:"\(subscription.totalSupply)" + " 세대" )
                }
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
    let sectionTitleFontStyle = CustomFontStyle.sectionTitle
    let descriptionFontStyle = CustomFontStyle.sectionDescription
    let descriptionPaddingTop = CGFloat(16)
    let descriptionNotApartFontStyle = CustomFontStyle.sectionSmallDescriptionA
    
    var subscription: HomeGuideModel.Subscription
    var body : some View{
        VStack{
            HStack{
              Text("분양 일정")
                .adjustFont(fontStyle: self.sectionTitleFontStyle)
                Spacer()
            }
            Group{
                if (subscription.buildingType == "아파트")&&(subscription.noRank == false){
                VStack{
                    ScheduleRowView(isTitle:true, rowTitle:"", rowValue1:"해당지역", rowValue2:"기타지역")
                    Divider()
                    Group{
                        if subscription.dateNotice != nil{
                            ScheduleRowView(isBig: true, rowTitle: "공고일", rowValue1: subscription.dateNotice!.getString())
                            Divider()
                        }

                    }
                    Group{
                        if subscription.hasSpecialSupply{
                            ScheduleRowView(rowTitle:"특별공급",
                                            rowValue1:subscription.dateSpecialSupplyNear!.getString(),
                                            rowValue2:subscription.dateSpecialSupplyOther!.getString()
                            )
                            Divider()
                        }
                    }
                    ScheduleRowView(rowTitle:"1순위",
                                    rowValue1:subscription.dateFirstNear!.getString(),
                                    rowValue2:subscription.dateFirstOther!.getString()
                    )
                    Divider()
                    ScheduleRowView(rowTitle:"2순위",
                                    rowValue1:subscription.dateSecondNear!.getString(),
                                    rowValue2:subscription.dateSecondOther!.getString()
                    )
                    Divider()
                    if subscription.dateAnnounce != nil{
                        ScheduleRowView(isBig:true, rowTitle:"당첨자 발표일",
                                        rowValue1:subscription.dateAnnounce!.getString()
                        )

                    }
                }
            }else{
                VStack{
                    if subscription.dateNotice != nil{
                        SmallRowView(header: "모집공고일", value: subscription.dateNotice!.getString())
                    }
                    if subscription.dateSecondOther != nil{
                        SmallRowView(header: "청약접수", value : subscription.dateSecondOther!.getString())
                    }
                    if subscription.dateAnnounce != nil{
                        SmallRowView(header: "당첨자 발표일", value: subscription.dateAnnounce!.getString())
                    }
                    if subscription.dateContract != nil{
                        SmallRowView(header:"계약일", value : subscription.dateContract!.getString())
                    }
                }.adjustFont(fontStyle:self.descriptionNotApartFontStyle)
            }
            }
            .padding([.top],self.descriptionPaddingTop)
            Group{
                if subscription.noRankNotSpecified == true{
                    HStack{
                        Spacer()
                        Text("상세 정보는 업데이트 예정이에요.")
                        Spacer()
                    }.adjustFont(fontStyle:self.descriptionFontStyle)

                }
            }
        }
    }
}
struct ScheduleRowView: View{
    var isTitle : Bool = false
    var isBig :Bool = false
    var rowTitle: String
    var rowValue1 : String
    var rowValue2 : String = ""
    var cellHeight = CGFloat(14)
    var cellWidth = CGFloat(10)
    var paddingBottom = CGFloat(8)
    var paddingTop = CGFloat(8)
    
    var fontStyle = CustomFontStyle.sectionSmallDescriptionA
    var titleColor:Color{
        if isTitle{
            return Color.black
        }else{
            return Color.grey
        }
    }
    var body: some View{
        GeometryReader{geometry in
            Group{
                if self.isBig{
                    HStack{
                        Text(self.rowTitle)
                            .frame(width : geometry.size.width/3, height : self.cellHeight)
                            .foregroundColor(Color.black)
                        Text(self.rowValue1)
                            .frame(width :geometry.size.width/3 * 2, height : self.cellHeight)
                    }
                }else{
                    HStack{
                        Text(self.rowTitle)
                            .frame(width : geometry.size.width/3, height : self.cellHeight)
                            .foregroundColor(Color.black)
                        Text(self.rowValue1)
                            .frame(width : geometry.size.width/3, height : self.cellHeight)
                        Text(self.rowValue2)
                            .frame(width : geometry.size.width/3, height : self.cellHeight)
                    }.foregroundColor(self.titleColor)
                }
            }
            }
        .adjustFont(fontStyle: fontStyle)
        .foregroundColor(Color.grey)
        .padding([.bottom], self.paddingBottom)
        .padding([.top], self.paddingTop)
    }
}


struct SubscriptionPriceView : View{
    var subscription: HomeGuideModel.Subscription
    let descriptionPaddingTop = CGFloat(16)
//    func chooseHomeType(homeType:HomeGuideModel.HomeType){
//        if let chosenIndex = subscription.typeList?.firstIndex(matching: homeType){
//            for index in 0..<subscription.typeList!.count{
//                subscription.typeList![index].isChoosen = false
//            }
//            subscription.typeList![chosenIndex].isChoosen = true
//        }
//    }
    let priceSentencePaddingTop = CGFloat(20)
    let sectionPaddingTop = CGFloat(20)
    let sectionTitleBottomPadding = CGFloat(20)
    let smallDescriptionFontStyle = CustomFontStyle.sectionSmallDescriptionA
    let smallDescriptionFontStyleBold = CustomFontStyle.sectionSmallDescriptionBold
    let sectionTitleFontStyle = CustomFontStyle.sectionTitle
    let sentenceFontStyle = CustomFontStyle.sectionDescription
    let sentenceSmallPaddingToTop = CGFloat(10)
    let sentenceBigPaddingToTop = CGFloat(20)
    let subtitlePaddingTop = CGFloat(20)
    let columnCount = 4
    let cellHeight = CGFloat(50)
    var gridHeight: CGFloat{
        let rowCount =  Int(ceil(Double(subscription.typeList!.count)/Double(self.columnCount)))
        return CGFloat(rowCount) * self.cellHeight
    }
    // 사진 때문에 Cardify가 안먹어서 noTrail설정하고, 여기서 직접 Trail 적용함.
    var paddingToTrail = CGFloat(20)
    
    @State var chosenHomeType : HomeGuideModel.HomeType?
    @ObservedObject var modelView: HomeModelView
    var body: some View{
        VStack{
            HStack{
                Text("평형별 상세")
                    .adjustFont(fontStyle: self.sectionTitleFontStyle)
                Spacer()
            }
            Grid(items: subscription.typeList!,columnCount:4){ homeType in
                Group{
                    if homeType == self.subscription.chosenHomeType{
                        Text("\(homeType.title)")
                        .pickify(isChoosen:true)
                    }else{
                        Text("\(homeType.title)")
                        .pickify(isChoosen:false)
                    }
                }
                .onTapGesture{
                    self.modelView.chooseHomeType(subscription: self.subscription, homeType: homeType)
                }
            }
            .frame(height: self.gridHeight)
            .padding([.top],self.descriptionPaddingTop)
            .padding([.trailing], self.paddingToTrail)
            .padding([.bottom], 20)
            Divider()
            Group{
                if self.subscription.chosenHomeType != nil{
                    Group{
                        if self.subscription.chosenHomeType!.typeImgName != nil{
                            VStack{
                                Spacer().frame(height: 20)
                                FirebaseImage(id: self.subscription.chosenHomeType!.typeImgName ?? "")
                                    .scaleEffect(x: 1.1, y: 1.1, anchor: .center)
                            }
                        }
                    }
                }
            }
            Group{
                if self.subscription.chosenHomeType != nil{
                    VStack{
                        HStack{
                            Text(self.subscription.chosenHomeType!.title+"형")
                                .padding([.top], self.subtitlePaddingTop)
                            Spacer()
                        }
                        //상세 정보
                        Group{
                            if subscription.noRank == false{
                                VStack{
                                    HStack{
                                        Text("면적")
                                        Spacer()
                                    }
                                    .adjustFont(fontStyle:self.sectionTitleFontStyle)
                                    .padding([.bottom], self.sectionTitleBottomPadding)
                                    VStack{
                                        SmallRowView(header:"넓이(미터)" , value:String(self.subscription.chosenHomeType!.size.inMeter) + " m²")
                                        SmallRowView(header:"넓이(평형", value: String(self.subscription.chosenHomeType!.size.inPy) + " 평")
                                    }
                                    
                                    .adjustFont(fontStyle:self.smallDescriptionFontStyle)
                                }
                            }
                        }
                        .padding([.top], self.sectionPaddingTop)
                        .padding([.trailing], self.paddingToTrail)
                        VStack{
                            HStack{
                                Text("공급세대")
                                Spacer()
                            }.adjustFont(fontStyle:self.sectionTitleFontStyle)
                            .padding([.bottom], self.sectionTitleBottomPadding)
                            VStack{
                                Group{
                                    if subscription.hasSpecialSupply{
                                        SmallRowView(header:"특별공급" , value:String(self.subscription.chosenHomeType!.specialSupply!) + " 세대")
                                        SmallRowView(header:"일반공급", value: String(self.subscription.chosenHomeType!.generalSupply!) + " 세대")
                                    }
                                }
                                SmallRowView(header:"총 세대수", value:String(self.subscription.chosenHomeType!.totalSupply) + " 세대")
                            }
                            .adjustFont(fontStyle:self.smallDescriptionFontStyle)
                        }
                        .padding([.top], self.sectionPaddingTop)
                        .padding([.trailing], self.paddingToTrail)
                        if (subscription.priceDidSet)&&(!subscription.noRankNotSpecified){
                            VStack{
                                HStack{
                                    Text("가격")
                                    Spacer()
                                }.adjustFont(fontStyle:self.sectionTitleFontStyle)
                                .padding([.bottom], self.sectionTitleBottomPadding)
                                VStack(spacing:0){
                                    HStack(spacing:0){
                                        DetailColumnView(
                                            isTailMerged: true,
                                            row1: "계약금",
                                            row2: "중도금",
                                            row3: "잔금"
                                        )
                                            .adjustFont(fontStyle: self.smallDescriptionFontStyleBold)
                                        DetailColumnView(
                                            isTailMerged: true,
                                            row1: self.subscription.chosenHomeType!.firstPrice.inText,
                                            row2: self.subscription.chosenHomeType!.middlePrice.inText,
                                            row3: self.subscription.chosenHomeType!.finalPrice.inText
                                        )
    //                                    Spacer()
                                        DetailColumnView(
                                            isHeadMerged: true,
                                            row1: "초기 필요 자금",
                                            row1_1 : "(A)",
                                            row1_2 : "\(self.subscription.chosenHomeType!.needMoneyFirst)",
                                            row2: "입주시 필요 자금",
                                            row2_1 : "(B)",
                                            row2_2 : "\(self.subscription.chosenHomeType!.needMoneyFinal)",
                                            row3: "대출 가능 금액",
                                            row3_2 : "\(self.subscription.chosenHomeType!.loanLimit.inText)"
                                        )
                                    }
                                    .frame(minHeight: 240)
                                    .padding([.trailing], self.paddingToTrail)
                                    HStack{
                                        VStack{
                                            HStack{
                                                Text("총 가격")
                                                Text("\(self.subscription.chosenHomeType!.totalPrice.inText) ").foregroundColor(Color.coralRed)
                                                Text("중에")
                                                Spacer()
                                            }.adjustFont(fontStyle: self.sentenceFontStyle)
                                            HStack{
                                                Text("청약시에 필요한 돈은")
                                                Text("\(self.subscription.chosenHomeType!.needMoneyFirst)").foregroundColor(Color.coralRed)
                                                Text("이고")
                                                Spacer()
                                            }
                                            .adjustFont(fontStyle: self.sentenceFontStyle)
                                            .padding([.top], self.sentenceBigPaddingToTop)
                                            HStack{
                                                VStack{
                                                    HStack{
                                                    Text("(A) 계약금 + 중도금")
                                                        Spacer()
                                                    }

                                                    Group{
                                                        if self.subscription.chosenHomeType!.middlePriceLoanable{
                                                            HStack{
                                                            Text("중도금 대출이 가능하니 필요자금은 더 줄어들 수 있어요.")
                                                                Spacer()
                                                            }

                                                        }
                                                    }.padding([.top], self.sentenceSmallPaddingToTop)
                                                }
                                                .padding([.top], self.sentenceSmallPaddingToTop)
                                                Spacer()
                                            }
                                            .foregroundColor(Color.lightGrey)
                                            Group{
                                                if ((self.subscription.chosenHomeType!.needMoneyFinal == "0.0억 원")||(self.subscription.chosenHomeType!.needMoneyFinal == "0 억원")){
                                                    HStack{
                                                        Text("입주 시점에는 더 필요하지 않아요.")
                                                        Spacer()
                                                    }
                                                }else{
                                                    HStack{
                                                        Text("입주 시점에는")
                                                        Text("\(self.subscription.chosenHomeType!.needMoneyFinal)").foregroundColor(Color.coralRed)
                                                        Text("이 더 필요해요.")
                                                        Spacer()
                                                    }
                                                }
                                            }
                                            .adjustFont(fontStyle: self.sentenceFontStyle)
                                            .padding([.top], self.sentenceBigPaddingToTop)
                                            HStack{
                                                VStack(alignment: .leading){
                                                   Text("(B) 잔금 - 대출 가능 금액")
                                                   Text("대출 가능 금액은 무주택자 기준이며, 개인에 따라 달라질 수 있어요.")
                                               }
                                               .foregroundColor(Color.lightGrey)
                                                .padding([.top], self.sentenceSmallPaddingToTop)
                                                Spacer()
                                            }
                                       }
                                        Spacer()
                                    }.padding([.top], self.priceSentencePaddingTop)
                                }.adjustFont(fontStyle:self.smallDescriptionFontStyle)
                            }
                            .padding([.top], self.sectionPaddingTop)
                            
                        }

                    }
                }
            }
        }
    }
}

struct DetailColumnView : View{
    var isTailMerged : Bool = false
    var isHeadMerged : Bool = false
    var row1 : String
    var row1_1 : String = ""
    var row1_2 : String = ""
    var row2 : String
    var row2_1 : String = ""
    var row2_2 : String = ""
    var row3 : String
    var row3_1 : String = ""
    var row3_2 : String = ""
    var row4 : String = ""
    var highlightColor = Color.coralRed.opacity(0.6)
    var subHighlightColor = Color.coralRed
    var nonHighLightColor = Color.whiteGrey
    
    var body: some View{
        GeometryReader{geometry in
            VStack(alignment: .center,spacing:0){
                if (!self.isTailMerged)&&(!self.isHeadMerged){
//                    Spacer()
                    Text(self.row1)
                        .frame(height:geometry.size.height/4)
                        .cellify()
                    Text(self.row2).frame(height:geometry.size.height/4)
                    .cellify()
//                    Spacer()
                    Text(self.row3).frame(height:geometry.size.height/4)
                    .cellify()
//                    Spacer()
                    Text(self.row4).frame(height:geometry.size.height/4)
                    .cellify()
                }else if(self.isTailMerged){
//                    Spacer()
                    Text(self.row1).frame(height:geometry.size.height/4)
                    .cellify()
//                    Spacer()
                    Text(self.row2).frame(height:geometry.size.height/4)
                    .cellify()
//                    Spacer()
                    Text(self.row3).frame(height:geometry.size.height/4 * 2)
                    .cellify()
//                    Spacer()
                }else if(self.isHeadMerged){
//                    Spacer()
                    VStack{
                        Text(self.row1_1)
                        Text(self.row1)
                        Text(self.row1_2)
                    }
                    .frame(height:geometry.size.height/4 * 2, alignment: .center)
                    .cellify(color:self.highlightColor )
//                    Spacer()
                    VStack{
                        Text(self.row2_1)
                        Text(self.row2)
                        Text(self.row2_2)
                    }
                    .frame(height:geometry.size.height/4, alignment: .center)
                    .cellify(color:self.subHighlightColor)
//                    Spacer()
                    VStack{
                        Text(self.row3_1)
                        Text(self.row3)
                        Text(self.row3_2)
                    }
                    .frame(height:geometry.size.height/4, alignment: .center)
                    .cellify(color:self.nonHighLightColor)
//                    Spacer()
                }

            }
        }
    }
}

//비상용
//VStack{
//    Group{
//        if subscription.typeList != nil{
//            Picker(selection: $selection, label: Text("평형선택")){
//                ForEach(0..<subscription.typeList!.count){
//                    Text(self.subscription.typeList![$0].title)
//                }
//            }
//            Text("선택된 것은 바로바로 \(self.subscription.typeList![selection].title)")
//        }
//    }
//    .pickerStyle(SegmentedPickerStyle())
//}

struct SubscriptionLinkView: View{
    var title : String
    var link : String
    
    var body: some View{
        Text("\(title)").onTapGesture{
            print("탭 됨")
            print(self.link)
            if let encoded  = self.link.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let myURL = URL(string: encoded){
                  UIApplication.shared.open(myURL)
            }
        }.foregroundColor(Color.coralRed)
    }
}

struct SubscriptionScoreView: View{
    @EnvironmentObject var session : SessionStore
    var homeType  : HomeGuideModel.HomeType
    var homeGuideModelView : HomeModelView
    // 애초에 가점 정보가 있고, 민영인지의 체크는 밖에서 하고 여기서는 계정만 체크
    @State var showingAlert : Bool = false
    var rewardAd = Rewarded()
    let sectionTitleFontStyle = CustomFontStyle.sectionTitle
    let paddingToTrail = CGFloat(40)
    let paddingFromBodyToTitle = CGFloat(20)
    var estimatedScoreToShow : String{
        print("estimatedScoreToShow 호출")
        if session.session?.userInfo.showingSubscriptionList.contains(homeType.homeTypeCode) ?? false{
            return "\(homeType.estimatedScore!) 점"
        }else{
            return "??? 점"
        }
    }
    let sectionSmallTitleFontStyle = CustomFontStyle.sectionSmallDescriptionB
    func touchScore(){
        if !(session.session?.userInfo.showingSubscriptionList.contains(homeType.homeTypeCode) ?? false){
            if session.session?.userInfo.homeKey ?? 0 > 0 {
                homeGuideModelView.setShowHomeKeyPopUp(true)
                DispatchQueue.main.asyncAfter(deadline: .now()+1){
                    self.session.useHomeKey(keyCount:1)
                    self.session.addHomeType(homeType : self.homeType)
                    DispatchQueue.main.asyncAfter(deadline: .now()+1){
                        self.homeGuideModelView.setShowHomeKeyPopUp(false)
                    }
                }
            }else{
                showingAlert = true
            }
        }
    }
    func showAd(){
        self.rewardAd.showAd(rewardFunction: adRewardFunction)
    }
    func adRewardFunction(){
        self.homeGuideModelView.setShowHomeKeyPopUp(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.session.addHomeKey(keyCount: 3)
            DispatchQueue.main.asyncAfter(deadline: .now()+1){
                self.session.useHomeKey(keyCount:1)
                self.session.addHomeType(homeType : self.homeType)
                DispatchQueue.main.asyncAfter(deadline: .now()+1){
                    self.homeGuideModelView.setShowHomeKeyPopUp(false)
                }
            }
        }
    }
    
    var body : some View{
        VStack{
            VStack{
                HStack{
                    Text("청약 예상 가점")
                        .adjustFont(fontStyle: self.sectionTitleFontStyle)
                    Spacer()
                        .frame(width:20)
                    Text("AI 예측 Beta")
                        .adjustFont(fontStyle: self.sectionSmallTitleFontStyle)
                        .foregroundColor(.lightGrey)
                    Spacer()
                }
                ExDivider()
            }
            HStack{
                Spacer()
                Group{
                    if session.session?.isAnonymous ?? true {
                        ZStack{
                            HStack{
                                Spacer()
                            Text("평균 ???점")
                                Spacer().frame(width: 20)
                            }

                            NavigationLink(destination: SignUpView()){
                                Rectangle().opacity(0.0)
                            }.buttonStyle(PlainButtonStyle())
                        }
                    }else{
                        Text("평균 " + estimatedScoreToShow)
                            .onTapGesture {
                                self.touchScore()
                        }
                    }
                }
            }
            .padding([.top], self.paddingFromBodyToTitle)
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("홈키가 모자라요."),
                    message: Text("광고를 보고 충전하시겠어요? 나중에 설정에서도 충전할 수 있어요."),
                    primaryButton: .destructive(
                        Text("광고보기"),
                        action: {
                            self.showAd()
                }), secondaryButton: .cancel())
            }
        }
    }
}
