//
//  Cellify.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/06/30.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

// 요건 이름이 좀 이상하네..

import SwiftUI

struct FilterCellify: AnimatableModifier{
//    var cornerRadius = CGFloat(60)
//    var backgroundColor:Color{
//        if isChoosen{
//            return Color.coralRed
//
//        }else{
//            return Color.whiteGrey
//        }
//    }
    var blankSpace = CGFloat(0.1)
    var color : Color {
        if choosen{
            return Color.red
        }else{
            return Color.black
        }
    }
    var choosen : Bool
    var makeBlank = true
    var choosenStrokeColor : Color
    var notChoosenStrokeColor : Color
    var strokeColor : Color{
        if choosen{
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
            if choosen{
                return CGFloat(1.6)
            }else{
                return CGFloat(0.4)
            }
        }
        var targetHeightRatio: CGFloat{
            if makeBlank{
                return CGFloat(0.4)
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
    func filterCellify(choosen:Bool, choosenStrokeColor: Color, notChoosenStrokeColor: Color) -> some View{
        self.modifier(FilterCellify(choosen: choosen,choosenStrokeColor:choosenStrokeColor,notChoosenStrokeColor: notChoosenStrokeColor))
    }
}

