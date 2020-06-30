//
//  Pickify.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/06/30.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import Foundation
// 요건 이름이 좀 이상하네..

import SwiftUI

struct Pickify: AnimatableModifier{
    var isChoosen : Bool
    var cornerRadius = CGFloat(60)
    var backgroundColor:Color{
        if isChoosen{
            return Color.coralRed

        }else{
            return Color.whiteGrey
        }
    }
    var blankSpace = CGFloat(0.15)
    var fontColor : Color {
        if isChoosen{
            return Color.white
        }else{
            return Color.grey
        }
    }
    func body(content: Content) -> some View{
        GeometryReader{ geometry in
            ZStack{
                RoundedRectangle(cornerRadius: self.cornerRadius)
                    .fill()
                    .foregroundColor(self.backgroundColor)
                    .frame(width: geometry.size.width*(1-self.blankSpace), height: geometry.size.height*(1-self.blankSpace))
                content
                    .adjustFont(fontStyle: .sectionSmallDescriptionA)
                    .foregroundColor(self.fontColor)
            }
        }
        
    }
}
extension View{
    func pickify(isChoosen:Bool) -> some View{
        self.modifier(Pickify(isChoosen:isChoosen))
    }
}

