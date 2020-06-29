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
    func body(content: Content) -> some View{
        VStack{
            ZStack{
                backgroundView
                content
                    .padding([.leading], self.paddingToLead)
            }
            Spacer().frame(height: paddingBetweenCard)
        }.listRowInsets(EdgeInsets())
    }
}
extension View{
    func cardify() -> some View{
        self.modifier(Cardify())
    }
}
