//
//  NavigationBar.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/08/25.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import SwiftUI
struct CustomNavigationBar : View{
    let navBarPaddingToLead = CGFloat(20)
    let navBarPaddingToTop = CGFloat(20)
    let navBarMaxHeight = CGFloat(50)
    let navBarBackButtonSize = CGFloat(40)
    let titleFontColor = Color.black
    let titleFontStyle = CustomFontStyle.sectionTitle
    var hasTitleText : Bool
    var titleText : String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body : some View{
        ZStack{
          Color.white.edgesIgnoringSafeArea(.all)
          VStack(spacing:0){
              HStack(){
                Button(action:{self.presentationMode.wrappedValue.dismiss()} ){
                    return Image(systemName: "chevron.left").foregroundColor(.coralRed)
                }
                .frame(width:self.navBarBackButtonSize, height:self.navBarBackButtonSize)
                    .padding([.leading], self.navBarPaddingToLead)
                    .padding([.top], self.navBarPaddingToTop)
                  Spacer()
                Group{
                    if hasTitleText{
                        Text(self.titleText)
                        .adjustFont(fontStyle: self.titleFontStyle)
                        .foregroundColor(self.titleFontColor)
                        .multilineTextAlignment(TextAlignment.center)
                        .padding([.top], self.navBarPaddingToTop)
                    }
                }
              Spacer()
              Spacer().frame(width:self.navBarBackButtonSize, height:self.navBarBackButtonSize).padding([.trailing], self.navBarPaddingToLead)
              .padding([.top], self.navBarPaddingToTop)
            }
            Spacer()
            ExDivider()
        }
        }
        .frame(maxHeight: self.navBarMaxHeight)

    }
}

