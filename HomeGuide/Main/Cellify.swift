//
//  Cellify.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/06/30.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

// 요건 이름이 좀 이상하네..

import SwiftUI

struct Cellify: AnimatableModifier{
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
    var color : Color?
    
    func body(content: Content) -> some View{
        ZStack{
            Group{
                if color != nil{
                    Rectangle().fill().foregroundColor(color!)
                }
            }
            Rectangle().stroke().foregroundColor(Color.grey)
            content
        }
        
    }
}
extension View{
    func cellify(color:Color) -> some View{
        self.modifier(Cellify(color:color))
    }
    func cellify() -> some View{
        self.modifier(Cellify())
    }
}

