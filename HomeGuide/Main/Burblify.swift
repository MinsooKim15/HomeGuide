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
    var makeBlank : Bool = false
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
    var lineWidth: CGFloat{
        if isChoosen{
            return CGFloat(1.6)
        }else{
            return CGFloat(0.4)
        }
    }
    var targetHeightRatio: CGFloat{
        if makeBlank{
            return CGFloat(0.7)
        }else{
            return CGFloat(1)
        }
    }
    var targetWidthRatio : CGFloat{
        if makeBlank{
            return CGFloat(0.7)
        }else{
            return CGFloat(1)
        }
    }
    func body(content: Content) -> some View{
        GeometryReader{geometry in
            ZStack{
                RoundedRectangle(cornerRadius:self.cornerRadius)
                    .stroke(self.strokeColor, lineWidth:self.lineWidth)
                content.lineLimit(1).foregroundColor(self.strokeColor)
            }
            .frame(width: geometry.size.width * self.targetWidthRatio, height: geometry.size.height * self.targetHeightRatio)
            .frame(alignment:.center)
        }
 
    }
}
extension View{
    func burblify(isChoosen:Bool, notChoosenStrokeColor: Color, choosenStrokeColor: Color, makeBlank:Bool = false) -> some View{
        self.modifier(Burblify(isChoosen:isChoosen, choosenStrokeColor : choosenStrokeColor, notChoosenStrokeColor:notChoosenStrokeColor,makeBlank:makeBlank))
    }
}
