//
//  UserDetailView.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/08/24.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import SwiftUI
struct UserDetailView : View{
    @EnvironmentObject var session : SessionStore
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    func signOut(){
        self.session.signOut()
        self.presentationMode.wrappedValue.dismiss()
    }
    var body: some View{
        ZStack{
            Color.whiteGrey
            VStack{
                CustomNavigationBar(hasTitleText: false, titleText: "")
                VStack{
                    UserDetailItemView(textValue:"로그아웃하기")
                        .onTapGesture {
                            self.signOut()

                    }
                    Spacer()
                }
            }
        }
        
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}
struct UserDetailItemView: View{
    var textValue : String
    let paddingToLead = CGFloat(20)
    var body: some View{
        ZStack{
            Color.white
            HStack{
                Text(textValue).foregroundColor(Color.black)
                Spacer()
            }
            .padding([.leading], self.paddingToLead)
        }
        .frame(height:60)
    }
}
