//
//  AddAdevertisement.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/07/04.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import SwiftUI

struct AddAdevertisement: AnimatableModifier {
    var index: Int //현재 아이템의 리스트 중 Index를 받는다.
    // MARK: - 잘동작하는지 확인이 필요함.
    // 광고 로직은 여기의 상수와 메소드만 수정한다.
    let frequencyOfAdd = 5
    func addAd() -> Bool{
        var rightToAdd = false
        if (((self.index+1) % frequencyOfAdd) == 0){
            rightToAdd = true
        }
        return rightToAdd
    }
    
    func body(content: Content) -> some View {
        VStack{
            // TODO 여기 배너와 콘텐트 간의 관계는 미세 조정 필요
            content
            Group{
                if addAd(){
                   Banner()
                }
            }

        }
    }
}


extension View{
    func addAdvertisement(index: Int) -> some View{
        self.modifier(AddAdevertisement(index: index))
    }
}

