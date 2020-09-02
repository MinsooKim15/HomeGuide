//
//  NoticeView.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/08/23.
//  Copyright © 2020 minsoo kim. All rights reserved.


import SwiftUI
struct NoticeView: View{

    @ObservedObject var modelView : NoticeModelView
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let navBarPaddingToLead = CGFloat(20)
    let navBarPaddingToTop = CGFloat(20)
    let navBarMaxHeight = CGFloat(50)
    var body: some View{
        ZStack{
            Color.whiteGrey
            VStack{
                ZStack{
                  Color.white.edgesIgnoringSafeArea(.all)
                  VStack(spacing:0){
                    HStack{
                        Button(action:{self.presentationMode.wrappedValue.dismiss()} ){
                            return Image(systemName: "chevron.left").foregroundColor(.coralRed)
                        }
                            .frame(width:30, height:30)
                            .padding([.leading], self.navBarPaddingToLead)
                            .padding([.top], self.navBarPaddingToTop)
                            Spacer()
                    }
                    Spacer()
                    ExDivider().foregroundColor(.whiteGrey)
                }
                }
                .frame(maxHeight: self.navBarMaxHeight)
                Spacer()
                List{
                    ForEach(modelView.model.notices, id:\.self.id){ notice in
                        NoticeItemView(notice:notice, modelView: self.modelView)
                    }.listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                Spacer()
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            
        }

    }
}

struct NoticeItemView: View{
    var notice : NoticeModel.Notice
    var modelView : NoticeModelView
    let titleFontColor = Color.black
    let titleFontStyle = CustomFontStyle.sectionDescription
    let subtitleFontColor = Color.lightGrey
    let subtitleFontStyle = CustomFontStyle.sectionSmallDescriptionB
    let iconColor = Color.grey
    let paddingToLead = CGFloat(20)
    let paddingToTrail = CGFloat(20)
    let heightOfItem = CGFloat(80)
    var arrowIcon : String{
        if notice.opened{
            return "chevron.up"
        }else{
            return "chevron.down"
        }
    }
    var body: some View{
        ZStack(alignment: .leading){
            Color.white
            VStack{
                HStack{
                    VStack(alignment: .leading){
                        Text(notice.writtenDateString)
                            .foregroundColor(self.subtitleFontColor)
                            .adjustFont(fontStyle: self.subtitleFontStyle)
                        Text(notice.title)
                            .foregroundColor(self.titleFontColor)
                            .adjustFont(fontStyle: self.titleFontStyle)
                    }
                    Spacer()
                    Image(systemName: self.arrowIcon)
                        .foregroundColor(self.iconColor)
                }
                .padding([.leading],self.paddingToLead)
                .padding([.trailing], self.paddingToTrail)
                .frame(height : self.heightOfItem)
                .onTapGesture {
                    self.modelView.toggleNotice(notice: self.notice)
                }
                Group{
                    if(notice.opened){
                        NoticeDetailView(notice:notice)
                    }
                }
            }
        }
    }
}

struct NoticeDetailView : View{
    var notice : NoticeModel.Notice
    let spaceBetweenTitleAndBody = CGFloat(40)
    var body: some View{
        ZStack{
            Color.whiteGrey
            VStack(alignment: .leading){
                Spacer().frame(height:self.spaceBetweenTitleAndBody)
                ForEach(notice.body, id: \.self.id){ bodyItem in
                    NoticeDetailItemView(noticeBodyItem: bodyItem)
                }
            }.onAppear {
                UITableView.appearance().backgroundColor = Color(hex:"F0F0F0").uiColor()
                UITableView.appearance().separatorStyle = .none
                UITableViewCell.appearance().backgroundColor = .clear
            }
        }
    }
}
struct NoticeDetailItemView: View{
    var noticeBodyItem : NoticeModel.NoticeBody
    var paddingToLead = CGFloat(20)
    var paddingToTrail = CGFloat(20)
     var spaceBetweenItemAndUnder = CGFloat(20)
    var body: some View{
        Group{
            if noticeBodyItem.type == .text{
                VStack{
                    NoticeDetailTextView(textValue : noticeBodyItem.textValue ?? "", style: noticeBodyItem.textStyle)
                        .padding([.leading], self.paddingToLead)
                        .padding([.trailing], self.paddingToTrail)
                    Spacer()
                    .frame(height: self.spaceBetweenItemAndUnder)
                }
            }else if noticeBodyItem.type == .linkedText{
                VStack{
                    NoticeDetailLinkedTextView(textValue : noticeBodyItem.textValue ?? "",style:noticeBodyItem.textStyle, linkUrl:noticeBodyItem.linkUrl!)
                        .padding([.leading], self.paddingToLead)
                        .padding([.trailing], self.paddingToTrail)
                    Spacer()
                    .frame(height: self.spaceBetweenItemAndUnder)
                }
            }else{
                VStack{
                    FirebaseImage(id: noticeBodyItem.imageUrl!)
                        Spacer()
                            .frame(height: self.spaceBetweenItemAndUnder)
                }
            }
        }
    }
}

struct NoticeDetailTextView: View{
    var textValue : String
    var style : NoticeModel.NoticeBodyTextStyle
    var textStyle : CustomFontStyle{
        switch style{
        case .plain:
            return CustomFontStyle.sectionSmallDescriptionA
        case .bold:
            return CustomFontStyle.sectionSmallDescriptionBold
        }
    }
    var textFontColor : Color{
        switch style{
        case .plain:
            return Color.grey
        case .bold:
            return Color.black
        }
    }
   
    var body: some View{
        HStack{
            Text(textValue)
                .foregroundColor(textFontColor)
                .adjustFont(fontStyle: textStyle)
            Spacer()
        }
    }
}
struct NoticeDetailLinkedTextView: View{
    var textValue : String
    var style : NoticeModel.NoticeBodyTextStyle
    var linkUrl : String
    var textStyle = CustomFontStyle.sectionSmallDescriptionA
    var textFont = Color.blue
    var body: some View{
        Text(self.textValue)
            .adjustFont(fontStyle:textStyle)
        .foregroundColor(textFont)
            .onTapGesture {
                if let encoded  = self.linkUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let myURL = URL(string: encoded){
                          UIApplication.shared.open(myURL)
                }
        }
    }
}
