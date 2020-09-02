//
//  HomeKeyPopover.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/08/27.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import SwiftUI
struct HomeKeyPopoverView: View{
    @State var homeKey: Int
    @EnvironmentObject var session : SessionStore

    let roundedRectangleRadius = CGFloat(20)
    let backgroundColor = Color.white.opacity(0.8)
    let homeKeySize = CGFloat(28)
    let spaceBetweenIconAndNumber = CGFloat(20)
    let numberTextColor = Color.grey
    let popoverSize = CGFloat(150)
    var body: some View {
            VStack{
                ZStack{
                    RoundedRectangle(cornerRadius: self.roundedRectangleRadius)
                        .fill()
                        .foregroundColor(self.backgroundColor)
                        
                        VStack{
                            Image("HomeKey")
                                .resizable()
                                .frame(width:self.homeKeySize, height:self.homeKeySize)
                            Spacer()
                                .frame(height:self.spaceBetweenIconAndNumber)
                            MovingNumbersView(number: Double(self.session.session?.userInfo.homeKey ?? 1), numberOfDecimalPlaces: 0){str in
                                Text(str).foregroundColor(self.numberTextColor)
                            }
                        }
                    }
                    .frame(width:self.popoverSize, height:self.popoverSize)
                }
            
        }
}
