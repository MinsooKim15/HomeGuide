//
//  SettingView.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/06/28.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    var modelView : SettingModelView
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let navBarPaddingToLead = CGFloat(20)
    let navBarPaddingToTop = CGFloat(20)
    let navBarMaxHeight = CGFloat(50)
    let spaceBetweenUserViewAndSettingList = CGFloat(4)
    let spaceBetweenUserViewAndHomeKey = CGFloat(4)
    let spaceBetweenHomeKeyAndSettingList = CGFloat(4)
    let settingViewBackgroundColor = Color.whiteGrey
    let titleBarFontStyle = CustomFontStyle.headDescriptionA
    @EnvironmentObject var session : SessionStore
    var body: some View {
        ZStack{
            self.settingViewBackgroundColor
                    VStack{
                        ZStack{
                          Color.white.edgesIgnoringSafeArea(.all)
                          VStack(spacing:0){
                            HStack(alignment: .center){
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
                            UserView()
                                .cardify()
                            HomeKeyView()
                                .cardify(.small)
                            ForEach(self.modelView.model.settings){ settingItem in
                                SettingItemView(settingItem:settingItem)
//                                    .cardify(.small)
                            }.listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        }
                        .onAppear {
                            UITableView.appearance().backgroundColor = Color(hex:"F0F0F0").uiColor()
                            UITableView.appearance().separatorStyle = .none
                            UITableViewCell.appearance().backgroundColor = .clear
                        }
//                        .onDisappear {       UITableView.appearance().separatorStyle = .singleLine     }
                        }
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
        }
}
struct UserView: View{
    @EnvironmentObject var session : SessionStore
    let profileImageViewSize = CGFloat(40)
    let profileImageRadius = CGFloat(27)
    let userViewMaxHeight = CGFloat(140)
    let paddingToLead = CGFloat(10)
    let spaceBetweenImageAndName = CGFloat(20)
    let spaceBetweenNameAndEmail = CGFloat(8)
    let profileNameTextType = CustomFontStyle.sectionTitle
    let profileEmailTextType = CustomFontStyle.sectionDescription
    let paddingToTrail = CGFloat(20)
    var targetView : some View{
        return Group{
            if (session.session == nil)||(session.session?.isAnonymous == true){
                SignUpView()
            }else{
                UserDetailView()
            }
        }
    }
    var displayNameToShow: String{
        if (self.session.session == nil) || (self.session.session?.isAnonymous == true){
            return "로그인하기"
        }else{
            if self.session.session!.displayName == nil{
                return "회원"
            }else{
                return self.session.session!.displayName!
            }
        }
    }
    var emailToShow:String{
        if (self.session.session == nil) || (self.session.session?.isAnonymous == true){
            return ""
        }else{
            if self.session.session!.email == nil{
                return ""
            }else{
                return self.session.session!.email!
            }
        }
    }

    var body: some View{
        ZStack{
            HStack{
                Image("Person")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: self.profileImageViewSize, height: self.profileImageViewSize)
                    .clipShape(RoundedRectangle(cornerRadius: self.profileImageRadius))
                Spacer()
                    .frame(width: self.spaceBetweenImageAndName)
                Group{
                    if(self.session.session == nil) || (self.session.session?.isAnonymous == true){
                        Text("로그인하기")
                            
                    }else{
                        VStack(alignment: .leading, spacing:self.spaceBetweenNameAndEmail){
                            Text(self.displayNameToShow)
                                .adjustFont(fontStyle: self.profileNameTextType)
                            Text(self.emailToShow)
                                .adjustFont(fontStyle: self.profileEmailTextType)
                        }
                    }
                }
                .foregroundColor(.black)
                Spacer()
            }
            NavigationLink(destination: targetView){
                EmptyView()
            }.padding([.trailing], self.paddingToTrail)
        }
        .padding([.leading], self.paddingToLead)
    }
}

struct HomeKeyView: View{
    let titleFontStyle = CustomFontStyle.sectionTitle
    let titleFontColor = Color.black
    let valueFontColor = Color.grey
    let valueFontStyle = CustomFontStyle.sectionDescription
    let paddingToLead = CGFloat(0)
    let heightOfItem = CGFloat(60)
    let homekeyImageViewSize = CGFloat(20)
    let paddingToTrail = CGFloat(20)
    @EnvironmentObject var session : SessionStore
    
    var homeKeyText : String{
        if (session.session == nil) || (self.session.session?.isAnonymous == true) || (self.session.session?.userInfo.homeKey == nil){
            return "-"
        }else{
            return String(self.session.session?.userInfo.homeKey ?? 0)
        }
    }
    func addHomeKey(){
        print("addHomeKey: Reward!")
        self.session.addHomeKey(keyCount:3)
    }
    var targetView: some View{
        
        return Group {
            if session.session?.isAnonymous ?? true{
                SignUpView()
            }else{
                HomeKeyScoreView()
            }
        }
    }
    var body: some View{
        ZStack(alignment:.leading){
            Color.white
            VStack(alignment:.leading){
                Spacer()
                ZStack{
                    HStack{
                        Image("HomeKey")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: self.homekeyImageViewSize, height: self.homekeyImageViewSize)
                        Text("홈 키")
                            .foregroundColor(self.titleFontColor)
                            .adjustFont(fontStyle: self.titleFontStyle)
                        Spacer()

                        Text(self.homeKeyText)
                            .foregroundColor(self.valueFontColor)
                            .adjustFont(fontStyle: self.valueFontStyle)
                            .padding([.trailing], self.paddingToTrail)
                    }
                    NavigationLink(destination: targetView){
                        EmptyView()
                    }
                }
                Spacer()
            }
            .padding([.leading], self.paddingToLead)
        }
        .frame(height:self.heightOfItem)
    }
}


struct SettingItemView: View{
    var settingItem: SettingModel.SettingData
    let titleFontStyle = CustomFontStyle.sectionTitle
    let titleFontColor = Color.black
    let valueFontStyle = CustomFontStyle.sectionDescription
    let valueFontColor = Color.grey
    let paddingToLead = CGFloat(20)
    let heightOfItem = CGFloat(60)
    let paddingToTrail = CGFloat(40)
    var body : some View{
        ZStack(alignment: .leading){
            Color.white
            VStack(alignment: .leading){
                Spacer()
                HStack{
                    Text(settingItem.title)
                        .foregroundColor(titleFontColor)
                        .adjustFont(fontStyle: self.titleFontStyle)
                    Spacer()
                    Group{
                        if self.settingItem.settingType == SettingModel.SettingType.detail{
                            Text(self.settingItem.description!)
                                .foregroundColor(self.valueFontColor)
                                .adjustFont(fontStyle: self.valueFontStyle)
                                .padding([.trailing], self.paddingToTrail)
                        }
                    }
                }
                Spacer()
                ExDivider()
            }.padding([.leading], self.paddingToLead)
            if self.settingItem.settingType == SettingModel.SettingType.navigatable{
                NavigationLink(destination: NoticeView(modelView: NoticeModelView())){
                    EmptyView()
                }.padding([.trailing], self.paddingToTrail)
            }
            if self.settingItem.settingType == SettingModel.SettingType.outlink{
                Rectangle()
                    .foregroundColor(Color.white.opacity(0.000000000000001))
                    .onTapGesture {
                        if let encoded  = self.settingItem.outlink!.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let myURL = URL(string: encoded){
                              UIApplication.shared.open(myURL)
                    }
                }
            }
        }
        .frame(height:self.heightOfItem)
    }
}
