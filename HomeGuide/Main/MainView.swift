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
    @State var navBarHidden: Bool = true
    var anonymousAuth = AnonymousAuth()
    // 여기서 배경색 컨트롤
    let backgroundColorView: some View = Color(hex:"F0F0F0")
    
    var body: some View {
            // 배경색
        NavigationView(){
            ZStack(){
                    backgroundColorView.edgesIgnoringSafeArea(.all)
                VStack(spacing : 0){
                    VStack(spacing : 0){
                        HeadView()
                        Spacer().frame(height:1)
                        FilterView(modelView:modelView)
                    }
                        Spacer().frame(height:3)
                            if !modelView.model.isFilterOpen{
                                if modelView.model.subscriptions.count != 0{
                                    List{
                                        // TODO : let index = array.firstIndex(of: item)를 이용해서 index를 받는다.
                                                ForEach(modelView.model.subscriptions, id:\.self.id){subscription in
                                                    VStack{
                                                        ZStack(alignment:.leading){
                                                            Color.white
                                                            SubscriptionCardView(subscription: subscription).frame(minWidth:0, maxWidth:.infinity)
                                                            NavigationLink(destination: SubscriptionDetailView(subscription: subscription, modelView:self.modelView)){
                                                                EmptyView()
                                                                }
                                                                
                                                            
                                                            .buttonStyle(PlainButtonStyle())
                                                            .frame(width: 0)
                                                            .opacity(0)
                                                        }
                                                        
                                                            // nil이 되면 항상 0이니까 광고 미노출
                                                        .addAdvertisement(index: self.modelView.model.subscriptions.firstIndex(matching: subscription) ?? 0)
                                                    }.listRowInsets(EdgeInsets())
                                                 }
                                            }
                                            .onAppear {
                                                UITableView.appearance().backgroundColor = Color(hex:"F0F0F0").uiColor()
                                                UITableView.appearance().separatorStyle = .none
                                                UITableViewCell.appearance().backgroundColor = .clear
                                            }
                                            .onDisappear {       UITableView.appearance().separatorStyle = .singleLine     }

                                }else{
                                    VStack{
                                        Spacer()
                                        Text("새로운 조건의 청약을 찾아보세요.")
                                        Spacer()
                                    }
                                    .foregroundColor(.grey)

                                }
                                        
                                    }
                            }
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    self.navBarHidden = true
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    self.navBarHidden = false
                }
                }
            }
    }
}


struct HeadView: View{
    // Control for all UI Numbers
    let headViewPaddingToTop = CGFloat(20)
    let titlePaddingToLeading = CGFloat(20)
    let customFontRegular = "NanumSquareOTFR"
    let customFontLight = "NanumSquareOTFL"
    let customFontBold = "NanumSquareOTFB"
    let customFontExtraBold = "NanumSquareOTFEB"
    let headFontSize = CGFloat(24)
    let headBackgroundColor:some View = Color.white
    let maxHeight = CGFloat(80)
    let fontColorHighlight = Color(hex:"FF4162")
    let barColor: Color = Color.coralRed
    
    var body: some View{
        VStack(spacing:0){
            ZStack{
                headBackgroundColor.edgesIgnoringSafeArea(.all)
                HStack{
                    Text("청줍 가이드")
                        .font(.custom(customFontBold, size: headFontSize))
//                        .foregroundColor(Color.white)
                        .padding([.leading], titlePaddingToLeading)
                    Spacer()
                }
                .foregroundColor(.black)
                .padding([.top],headViewPaddingToTop)
            }
            ExDivider()
        }
        .frame(maxHeight : maxHeight)
    }
}
struct ExDivider: View {
    let color: Color = .whiteGrey
    let width: CGFloat = 1.6
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: width)
            .edgesIgnoringSafeArea(.horizontal)
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
    let maxBubbleHeight = CGFloat(26)
    let customFontRegular = "NanaumSquareOTFR"
    let fontSize = CGFloat(14)
    let frameHeight = CGFloat(20)
    let unOpenedMaxHeight = CGFloat(40)
    let openFilterMinWidth = CGFloat(40)
    let openedFilterCloseButtonHeight = CGFloat(40)
    let filterGridPaddingToTrail = CGFloat(80)
    //필터 열었을 때, 필터 카테고리 고르는 영역이 차지하는 비율(세부 옵션이 1-상수가 됨)
    let filterOptionHeightRatio = 0.2
    let filterCategoryFontStyle = CustomFontStyle.sectionDescription
    let filterRowViewHeight = CGFloat(120)
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
                                    }.onTapGesture {
                                        self.modelView.openFilter()
                                    }
                                }

                            }
                        }
                        Spacer().foregroundColor(.whiteGrey)
                        HStack(spacing:0){
                            Divider()
                            Button(action:modelView.openFilter){return Image(systemName:"chevron.down").foregroundColor(.coralRed)}.frame(minWidth: self.openFilterMinWidth)
                        }
                    }
                }
                .frame(maxHeight : self.unOpenedMaxHeight)
            }else{
                VStack(spacing:0){
                    ScrollView{
                        ForEach(self.modelView.model.filters, id : \.self.id){filter in
                            FilterRowView(modelView: self.modelView, filterCategory: filter)
                                .cardify(.small)
                                .foregroundColor(.black)
                        }
                        Spacer()
                    }
//                    ZStack{
//                        Color.white
//                        GeometryReader{geometry in
//                           VStack(spacing:0){
//                            ZStack{
//                                    Grid(items: self.modelView.model.filters, columnCount: 2) {filter in
//                                        Text("\(filter.titleDisplay)")
//                                            .onTapGesture {
//                                                self.modelView.chooseFilterCategory(filterCategory: filter)
//                                            }
//                                        .adjustFont(fontStyle: self.filterCategoryFontStyle)
//                                        .burblify(isChoosen: true, notChoosenStrokeColor: .whiteGrey, choosenStrokeColor: .coralRed,makeBlank:true)
//
//                                    }
//                                .frame(height : geometry.size.height*0.2)
//                                .padding([.trailing], self.filterGridPaddingToTrail)
//                            }
//
//                               ExDivider()
//                               ZStack{
//                                   Color.white
//                                   if self.modelView.model.choosenFilterCategory != nil{
//                                       FilterDetailView(modelView: self.modelView)
//                                   }else{
//                                       EmptyView()
//                                   }
//                               }.frame(height : geometry.size.height*0.8)
//                           }
//                       }
//                    }
//                    List{
//                        ForEach(modelView.model.filters, id:\.self.titleDisplay){ filter in
//                            FilterRowView(modelView: self.modelView, filterCategory: filter)
//                        }
//                    }
                   
                    ZStack{
                        Color.coralRed
                        Text("검색하기").foregroundColor(Color.white)
                    }
                    .frame(height: self.openedFilterCloseButtonHeight)
                    .onTapGesture {
                        self.modelView.closeFilter()
                    }
                }
            }
        }.frame(minHeight: self.frameHeight)
    }
}
struct FilterRowView : View{
    var modelView: HomeModelView
    var filterCategory : HomeGuideModel.FilterCategory
    
    let paddingToLead = CGFloat(20)
    let titlePaddingToTop = CGFloat(20)
    let titlePaddingToBottomDivider = CGFloat(20)
    
    let detailPaddingToTopDivider = CGFloat(20)
    let detailPaddingToBottom = CGFloat(20)
    let detailMinHeight = CGFloat(100)
    let detailMaxHeight = CGFloat(300)
    let filterBurbleMaxHeight = CGFloat(60)
    
    let titleFontStyle = CustomFontStyle.sectionTitle
    let notChoosenCellColor = Color.lightGrey
    let choosenCellColor = Color.coralRed
    let filterTextStyle = CustomFontStyle.sectionSmallDescriptionA
    let stepperWidth = CGFloat(50)
    let stepperHeight = CGFloat(50)
    let optionDetailpaddingToLead = CGFloat(20)
    let optionDetailpaddingToTrail = CGFloat(20)
    let columnCount = 3
    let cellHeight = CGFloat(30)
    var frameHeight: CGFloat{
        let rowCount =  Int(ceil(Double(filterCategory.optionList!.count)/Double(self.columnCount)))
        return CGFloat(rowCount) * self.cellHeight
    }
    @State private var celsius: Int = 1
    var body: some View{
        VStack{
            HStack{
                Text(filterCategory.titleDisplay)
                    .adjustFont(fontStyle: self.titleFontStyle)
                Spacer()
                Text("전체 선택")
                .foregroundColor(.grey)
                    .adjustFont(fontStyle: self.filterTextStyle)
                    .onTapGesture {
                        self.modelView.chooseAllFilterOption(filterCategory: self.filterCategory)
                }
            }
            Group{
                if filterCategory.dataType == .discrete{
                    Group{
                        // MARK:- allChosen일 때 전체를 회색으로 보이고 픈 코드, 중복이 엄청나게 많다.
                        if (!filterCategory.isAllChosen) || (filterCategory.multiSelectAble){
                            Grid(items:filterCategory.optionList!, columnCount: self.columnCount){option in
                                //TODO : Cellify 대체할만한 modifier 만들기 isChoosen을 받을 수 있어야 함.
                                Text(option.value)
                                    .adjustFont(fontStyle: self.filterTextStyle)
                                    .filterCellify(choosen: option.choosen,choosenStrokeColor: self.choosenCellColor ,notChoosenStrokeColor:self.notChoosenCellColor)
                                    .onTapGesture {
                                        self.modelView.chooseFilterOption(filterCategory: self.filterCategory, filterOption: option)
                                }
                            }
                        }else{
                            Grid(items:filterCategory.optionList!, columnCount: self.columnCount){option in
                                //TODO : Cellify 대체할만한 modifier 만들기 isChoosen을 받을 수 있어야 함.
                                Text(option.value)
                                    .adjustFont(fontStyle: self.filterTextStyle)
                                    .filterCellify(choosen: false,choosenStrokeColor: self.choosenCellColor ,notChoosenStrokeColor:self.notChoosenCellColor)
                                    .onTapGesture {
                                        self.modelView.chooseFilterOption(filterCategory: self.filterCategory, filterOption: option)
                                }
                            }
                        }
                    }

                }
            }.frame(height : self.frameHeight)

        }

    }
    func chooseFilter(){
        
    }
}

struct SubscriptionCardView: View{
    var subscription : HomeGuideModel.Subscription
    
    // MARK: - Control Panel for UI
    let priceFontSize = CGFloat(20)
    let paddingToLead = CGFloat(20)
    
    let titlePaddingTop = CGFloat(20)
    let descriptionAPaddingTop = CGFloat(12)
    let descriptionBPaddingTop = CGFloat(8)
    let descriptionBPaddingBottom = CGFloat(18)
    let fontColorHighlight = Color(hex: "FF4162")
    let fontColorDescriptionB = Color(hex:"A0A0A2")
    let datePaddingToTrail = CGFloat(30)

    let sectionTitleFontStyle = CustomFontStyle.sectionTitle
    let sectionDescriptionAFontStyle = CustomFontStyle.sectionDescription
    let sectionDescriptionBFontStyle = CustomFontStyle.sectionSmallDescriptionA
    let circleWidth = CGFloat(54)
    let circleHeight = CGFloat(54)
    let circleFontStyle = CustomFontStyle.sectionSmallDescriptionB
    let circleLineWidth = CGFloat(0.6)
    let badgeWidth = CGFloat(50)
    let badgeHeight = CGFloat(20)
    let cornerRadius = CGFloat(5)
    let badgeBackgroundColor = Color.coralRed
    let badgeTextColor = Color.white
    let newBadgeBackgroundColor = Color.grey
    var body: some View{
//        GeometryReader{geometry in
                                HStack{
                                    VStack(alignment:.leading){
                                        Text(self.subscription.title)
                                            .adjustFont(fontStyle: self.sectionTitleFontStyle)
                                            .padding([.top], self.titlePaddingTop)
                                        Text(self.subscription.address.full)
                                            .adjustFont(fontStyle:self.sectionDescriptionAFontStyle)
                                            .padding([.top], self.descriptionAPaddingTop)
                                        HStack(){
                                            Group{
                                                if self.subscription.isNew == true{
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius:self.cornerRadius)
                                                        .fill()
                                                        .foregroundColor(self.newBadgeBackgroundColor)
                                                        .frame(width: self.badgeWidth, height: self.badgeHeight)
                                                        Text("NEW")
                                                            .foregroundColor(self.badgeTextColor)
                                                    }
                                                }
                                                if self.subscription.noRank == true{
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius:self.cornerRadius)
                                                        .fill()
                                                        .foregroundColor(self.badgeBackgroundColor)
                                                        .frame(width: self.badgeWidth, height: self.badgeHeight)
                                                        Text("무가점")
                                                            .foregroundColor(self.badgeTextColor)
                                                    }
                                                }
                                            }
                                            Text(self.subscription.buildingType)
                                            Group{
                                                if self.subscription.subscriptionType.count > 1{
                                                    Text("|")
                                                    Text(self.subscription.subscriptionType)

                                                }
                                            }
                                            Group{
                                                if (self.subscription.lowestPrice != nil)&&(self.subscription.noRank == false){
                                                    Text("|")
                                                    Text(self.subscription.lowestPrice!.inText + "부터")
                                                }
                                            }

                                            Spacer()
                                        }.adjustFont(fontStyle:self.sectionDescriptionBFontStyle)

                                            .padding([.top], self.descriptionBPaddingTop)
                                            .padding([.bottom], self.descriptionBPaddingBottom)
                                            .foregroundColor(self.fontColorDescriptionB)
                                    }
                                    .padding([.leading], self.paddingToLead)
//                                    .frame(width:geometry.size.width * 0.7)
                                    Spacer()
                                    VStack{
                                        HStack{
                                            ZStack{
            //                                    if subscription.dateLeftInString != nil{
            //                                        ZStack{
            //                                            Circle()
            //                                                .stroke(lineWidth: CGFloat(self.circleLineWidth))
            //                                            .foregroundColor(.coralRed)
            //                                            .frame(width:self.circleWidth, height: self.circleHeight)
            //                                            Text(subscription.dateLeftInString!)
            //                                                .adjustFont(fontStyle:self.circleFontStyle)
            //                                                .foregroundColor(self.fontColorHighlight)
            //                                        }
            //                                    }
                                                Image(subscription.iconName)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width:50, height:50)
                                                Group{
                                                    if subscription.showHighlightLabel{
                                                        ZStack{
                                                            Rectangle()
                                                                .fill()
                                                                .foregroundColor(.coralRed)
                                                            Text(subscription.dateLeftInString!)
                                                                .foregroundColor(.white)
                                                                .adjustFont(fontStyle: .sectionSmallDescriptionA)
                                                       }
                                                        .frame(width:80, height:20)
                                                        .rotationEffect(.degrees(30))
                                                    }else if subscription.showLabel{
                                                        ZStack{
                                                            Rectangle()
                                                                .fill()
                                                                .foregroundColor(.lightGrey)
                                                            Text(subscription.dateLeftInString!)
                                                                .foregroundColor(.white)
                                                                .adjustFont(fontStyle: .sectionSmallDescriptionA)
                                                        }
                                                        .frame(width:70, height:20)
                                                        .rotationEffect(.degrees(30))
                                                    }
                                                }
                                            }
                                            Spacer().frame(width: self.datePaddingToTrail)
                                        }

                                    }.frame(width:100)
//                                    .frame(width:geometry.size.width * 0.3)
                                    .adjustFont(fontStyle:self.sectionDescriptionBFontStyle)
                                    // TODO : Image 넣기 없으면 기본 이미지 로직까지 - 이미지는 먼 미래
                                }
                                .foregroundColor(.black)
            
//        }
    }
}
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let modelView = HomeModelView()
        return MainView(modelView : modelView)
    }
}
