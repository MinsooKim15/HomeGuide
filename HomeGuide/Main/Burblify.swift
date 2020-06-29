//
//  Burblify.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/06/29.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import Foundation
import SwiftUI

struct Burblify: AnimatableModifier{
    var isChoosen: Bool
    var choosenStrokeColor : Color
    var notChoosenStrokeColor : Color
    var strokeColor : Color{
        if isChoosen{
            return choosenStrokeColor
        }else{
            return notChoosenStrokeColor
        }
    }
    
    // MARK: - 여기서 조정하는 값
    let cornerRadius = CGFloat(30)
    let maxWidth = CGFloat(100)
    let minWidth = CGFloat(100)
    let choosenLineWidth = CGFloat(1.6)
    let notChoosenLineWidth = CGFloat(0.8)
    func body(content: Content) -> some View{
        ZStack(){
            Group{
                if isChoosen{
                    RoundedRectangle(cornerRadius:cornerRadius).stroke(strokeColor, lineWidth:self.choosenLineWidth)
                }else{
                    RoundedRectangle(cornerRadius:cornerRadius).stroke(strokeColor, lineWidth: self.notChoosenLineWidth)
                }
            }

            content.lineLimit(1).foregroundColor(strokeColor)
        }.frame(alignment:.center)
 
    }
}
extension View{
    func burblify(isChoosen:Bool, notChoosenStrokeColor: Color, choosenStrokeColor: Color) -> some View{
        self.modifier(Burblify(isChoosen:isChoosen, choosenStrokeColor : choosenStrokeColor, notChoosenStrokeColor:notChoosenStrokeColor))
    }
}
