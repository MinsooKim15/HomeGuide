//
//  Cellify.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/06/30.
//  Copyright © 2020 minsoo kim. All rights reserved.
//


import SwiftUI

struct Badgify: AnimatableModifier{
    let backgroundColor = Color.coralRed
    let textColor = Color.white
    let badgeWidth = CGFloat(50)
    let badgeHeight = CGFloat(20)
    // MARK: - 여기서 조정하는 값
    let cornerRadius = CGFloat(5)
    func body(content: Content) -> some View{
        GeometryReader{geometry in
            ZStack{
                    RoundedRectangle(cornerRadius:self.cornerRadius)
                        .fill()
                        .foregroundColor(self.backgroundColor)
                        .frame(width: self.badgeWidth, height: self.badgeHeight)
                    content
                        .lineLimit(1)
                        .foregroundColor(self.textColor)
                }
            
            .padding([.all],0)
            }
    }
}



extension View{
    func badgify() -> some View{
        self.modifier(Badgify())
    }
}

