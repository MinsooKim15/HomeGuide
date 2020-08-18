//
//  Burblify.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/06/29.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import Foundation
import SwiftUI

struct Cardify: AnimatableModifier{

    
    // MARK: - 여기서 조정하는 값
    let backgroundView : some View = Color.white
    let backgroundGreyView : some View = Color(hex:"F0F0F0")
    let paddingToLead = CGFloat(20)
    let paddingBetweenCard = CGFloat(6)
    var paddingTop:CGFloat{
        switch style{
        case .head:
            return CGFloat(0)
        case .body:
            return CGFloat(40)
        case .noTrail:
            return CGFloat(40)
        case .small:
            return CGFloat(12)
        }
    }
    var paddingBottom:CGFloat{
        switch style{
        case .head:
            return CGFloat(0)
        case .body:
            return CGFloat(40)
        case .noTrail:
            return CGFloat(40)
        case .small:
            return CGFloat(12)
        }
    }
    var paddingTrail:CGFloat{
        switch style{
        case .noTrail:
            return CGFloat(0)
        default:
            return CGFloat(20)
        }
    }
    var style : CardifyStyle
    func body(content: Content) -> some View{
        VStack{
            
            ZStack{
                backgroundView
                content
                    .padding([.leading], self.paddingToLead)
                    .padding([.top], self.paddingTop)
                    .padding([.bottom], self.paddingBottom)
                    .padding([.trailing], self.paddingTrail)
            }
            Spacer().frame(height: paddingBetweenCard)
        }.listRowInsets(EdgeInsets())
    }
}
extension View{
    func cardify(_ style: CardifyStyle = CardifyStyle.body) -> some View{
        self.modifier(Cardify(style:style))
    }
}
enum CardifyStyle{
    case head
    case body
    case small
    case noTrail
}
