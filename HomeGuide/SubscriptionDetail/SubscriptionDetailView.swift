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
    var body: some View{
        VStack{
            List{
                
                SubscriptionHeadView(subscription : subscription).cardify(.head)
                SubscriptionSummaryView(subscription: subscription).cardify()
                SubscriptionScheduleView(subscription : subscription).cardify()
                SubscriptionPriceView(subscription : subscription, modelView: self.modelView).cardify()
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
                    SmallRowView(header:"분양세대", value:"\(subscription.totalSupply)" )
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
    
    var subscription: HomeGuideModel.Subscription
    var body : some View{
        VStack{
            HStack{
              Text("분양 일정")
                Spacer()
            }
            VStack{
                ScheduleRowView(isTitle:true, rowTitle:"", rowValue1:"해당지역", rowValue2:"기타지역")
                Divider()
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
                ScheduleRowView(isBig:true, rowTitle:"당첨자 발표일",
                                rowValue1:subscription.dateNotice!.getString()
                )
            }
            .padding([.top],self.descriptionPaddingTop)
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
    @State var chosenHomeType : HomeGuideModel.HomeType?
    @ObservedObject var modelView: HomeModelView
    var body: some View{
        VStack{
            HStack{
                Text("평형별 상세")
                Spacer()
            }
            Grid(items: subscription.typeList!){ homeType in
                Group{
                    if homeType == self.chosenHomeType{
                        Text("\(homeType.title)")
                        .pickify(isChoosen:true)
                    }else{
                        Text("\(homeType.title)")
                        .pickify(isChoosen:false)
                    }
                }
                .onTapGesture{
                    self.chosenHomeType = homeType
                }
            }
            .frame(minHeight: 100)
            .padding([.top],self.descriptionPaddingTop)
            Divider()
            Group{
                if self.chosenHomeType != nil{
                    VStack{
                        HStack{
                            Text(self.chosenHomeType!.title+"형")
                            Spacer()
                        }
                        //상세 정보
                        VStack{
                            Text("면적")
                            SmallRowView(header:"넓이(미터)" , value:String(chosenHomeType!.size.inMeter))
                            SmallRowView(header:"넓이(평형", value: String(chosenHomeType!.size.inPy))
                        }
                        VStack{
                            Text("공급세대")
                            Group{
                                if subscription.hasSpecialSupply{
                                    SmallRowView(header:"특별공급" , value:String(chosenHomeType!.specialSupply!))
                                    SmallRowView(header:"일반공급", value: String(chosenHomeType!.generalSupply!))
                                }
                            }
                            SmallRowView(header:"총 세대수", value:String(chosenHomeType!.totalSupply))
                        }
                        VStack{
                            Text("가격")
                            HStack{
                                DetailColumnView(
                                    isTailMerged: true,
                                    row1: "계약금",
                                    row2: "중도금",
                                    row3: "잔금"
                                )
                                Spacer()
                                DetailColumnView(
                                    isTailMerged: true,
                                    row1: chosenHomeType!.firstPrice.inText,
                                    row2: chosenHomeType!.middlePrice.inText,
                                    row3: chosenHomeType!.finalPrice.inText
                                )
                                Spacer()
                                DetailColumnView(
                                    isHeadMerged: true,
                                    row1: "초기 필요 자금 \(chosenHomeType!.needMoneyFirst)",
                                    row2: "입주시 필요 자금 \(chosenHomeType!.needMoneyFinal)",
                                    row3: "대출 가능 금액 \(chosenHomeType!.loanLimit)"
                                )
                            }.frame(height: 200)
                            VStack{
                                Text("청약시에 필요한 돈은 \(chosenHomeType!.needMoneyFirst)원이고,")
                                HStack{
                                    Text("(A) 계약금 + 중도금")
                                    Group{
                                        if chosenHomeType!.middlePriceLoanable{
                                            Text(", 중도금 대출 가능 여부에 따라 달라질 수 있어요.")
                                        }
                                    }
                                }
                                Text("총 필요한 금액은 \(chosenHomeType!.needMoneyFinal)원 입니다.")
                                VStack{
                                    Text("(B) 잔금 - 대출 가능 금액")
                                    Text("대출 가능 금액은 무주택자 기준으로 개인에 따라 차이가 있습니다.")
                                }
                            }

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
    var row2 : String
    var row3 : String
    var row4 : String = ""
    
    
    var body: some View{
        GeometryReader{geometry in
            VStack{
                if (!self.isTailMerged)&&(!self.isHeadMerged){
                    Spacer()
                    Text(self.row1)
                        .frame(height:geometry.size.height/4)
                        .cellify()
                    Spacer()
                    Text(self.row2).frame(height:geometry.size.height/4)
                    .cellify()
                    Spacer()
                    Text(self.row3).frame(height:geometry.size.height/4)
                    .cellify()
                    Spacer()
                    Text(self.row4).frame(height:geometry.size.height/4)
                    .cellify()
                }else if(self.isTailMerged){
                    Spacer()
                    Text(self.row1).frame(height:geometry.size.height/4)
                    .cellify()
                    Spacer()
                    Text(self.row2).frame(height:geometry.size.height/4)
                    .cellify()
                    Spacer()
                    Text(self.row3).frame(height:geometry.size.height/4 * 2)
                    .cellify()
                    Spacer()
                }else if(self.isHeadMerged){
                    Spacer()
                    Text(self.row1).frame(height:geometry.size.height/4 * 2)
                    .cellify()
                    Spacer()
                    Text(self.row2).frame(height:geometry.size.height/4)
                    .cellify()
                    Spacer()
                    Text(self.row3).frame(height:geometry.size.height/4)
                    .cellify()
                    Spacer()
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
        }
    }
}
struct Grid<Item, ItemView>: View where Item:Identifiable, ItemView : View{
    private var items: [Item]
    private var viewForItem: (Item)-> ItemView
    // @escaping은 지금 들어온 함수가 지금 init에서 안 쓰이고, 나중에 쓰일 거에요. 라는 말임.
    init(items: [Item], viewForItem: @escaping (Item)-> ItemView){
        self.items = items
        self.viewForItem = viewForItem
    }
    var body: some View {
        GeometryReader {geometry in
            self.body(for: GridLayout(itemCount: self.items.count, in: geometry.size))
        }
    }
    private func body(for layout: GridLayout) -> some View{
        ForEach(items){item in
            self.body(for:item, in:layout)
        }
    }
    private func body(for item: Item, in layout: GridLayout) -> some View{
        let index = items.firstIndex(matching: item)
                return viewForItem(item)
                    .frame(width: layout.itemSize.width, height:layout.itemSize.height)
                    .position(layout.location(ofItemAt:index!))
    }
}
struct GridLayout {
    private(set) var size: CGSize
    private(set) var rowCount: Int = 0
    private(set) var columnCount: Int = 0
    
    init(itemCount: Int, nearAspectRatio desiredAspectRatio: Double = 1, in size: CGSize) {
        self.size = size
        // if our size is zero width or height or the itemCount is not > 0
        // then we have no work to do (because our rowCount & columnCount will be zero)
        guard size.width != 0, size.height != 0, itemCount > 0 else { return }
        // find the bestLayout
        // i.e., one which results in cells whose aspectRatio
        // has the smallestVariance from desiredAspectRatio
        // not necessarily most optimal code to do this, but easy to follow (hopefully)
//        var bestLayout: (rowCount: Int, columnCount: Int) = (1, itemCount)
//        var smallestVariance: Double?
//        let sizeAspectRatio = abs(Double(size.width/size.height))
//        for rows in 1...itemCount {
//            let columns = (itemCount / rows) + (itemCount % rows > 0 ? 1 : 0)
//            if (rows - 1) * columns < itemCount {
//                let itemAspectRatio = sizeAspectRatio * (Double(rows)/Double(columns))
//                let variance = abs(itemAspectRatio - desiredAspectRatio)
//                if smallestVariance == nil || variance < smallestVariance! {
//                    smallestVariance = variance
//                    bestLayout = (rowCount: rows, columnCount: columns)
//                }
//            }
//        }
        var columnPoint = 4
        var bestLayout:(rowCount: Int, columnCount: Int) = (itemCount/columnPoint, columnPoint)
        rowCount = bestLayout.rowCount
        columnCount = bestLayout.columnCount
    }
    var itemSize: CGSize {
        if rowCount == 0 || columnCount == 0 {
            return CGSize.zero
        } else {
            return CGSize(
                width: size.width / CGFloat(columnCount),
                height: size.height / CGFloat(rowCount)
            )
        }
    }
    
    func location(ofItemAt index: Int) -> CGPoint {
        if rowCount == 0 || columnCount == 0 {
            return CGPoint.zero
        } else {
            return CGPoint(
                x: (CGFloat(index % columnCount) + 0.5) * itemSize.width,
                y: (CGFloat(index / columnCount) + 0.5) * itemSize.height
            )
        }
    }
}

