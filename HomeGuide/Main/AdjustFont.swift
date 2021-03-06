//
//  AdjustFont.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/06/30.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import Foundation
import Foundation
import SwiftUI
struct FontModifier: AnimatableModifier{
    @Environment(\.sizeCategory) var sizeCategory
    var fontStyle: CustomFontStyle
    let customFontRegular = "NanumSquareOTFR"
    let customFontLight = "NanumSquareOTFL"
    let customFontBold = "NanumSquareOTFB"
    let customFontExtraBold = "NanumSquareOTFEB"
    
    
    init(fontStyle:CustomFontStyle){
        // 다짜고짜 fontSize만 주었을 때
        self.fontStyle = fontStyle
    }
//    init(fontStyle: CustomFontStyle , fontColor : Color , weight: FontWeight){
//        self.fontStyle = fontStyle
//        self.font = getDefaultFontStyle()
//    }

    func body(content: Content) -> some View {
        content.font(getDefaultFontStyle())
    }
    func getDefaultFontStyle() -> Font{
        switch(self.fontStyle){
        case .sectionSmallDescriptionA:
            return Font.custom(self.customFontRegular, size:CGFloat(12))
        case .sectionSmallDescriptionB:
            return Font.custom(self.customFontBold, size:CGFloat(12))
        case .sectionDescription:
            return Font.custom(self.customFontRegular, size:CGFloat(14))
        case .sectionTitle:
            return Font.custom(self.customFontBold, size:CGFloat(18))
        case .headTitle:
            return Font.custom(self.customFontBold, size:CGFloat(24))
        case .headDescriptionA:
            return Font.custom(self.customFontRegular, size:CGFloat(18))
        case .headDescriptionB:
            return Font.custom(self.customFontRegular, size:CGFloat(14))
        case .mainHeadTitle:
            return Font.custom(self.customFontBold, size:CGFloat(28))
        case .sectionSmallDescriptionBold:
            return Font.custom(self.customFontBold, size:CGFloat(12))
        }
        
    }

}

extension View{
//    func adjustFont(fontStyle: CustomFontStyle , fontColor : Color , weight: FontWeight) -> some View{
//        self.modifier(FontModifier(fontStyle: fontStyle, fontColor: fontColor, weight: weight))
//    }
    func adjustFont(fontStyle: CustomFontStyle) -> some View{
        self.modifier(FontModifier(fontStyle:fontStyle))
    }
}
enum FontWeight {
    case light
    case regular
    case bold
    case extraBold
}
enum CustomFontStyle{
    case sectionSmallDescriptionA
    case sectionSmallDescriptionB
    case sectionDescription
    case sectionTitle
    case headTitle
    case headDescriptionA
    case headDescriptionB
    case mainHeadTitle
    case sectionSmallDescriptionBold
}

