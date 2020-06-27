//
//  Array+Identifiable.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/06/22.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import Foundation

extension Array where Element: Identifiable{
    func firstIndex(matching: Element)-> Int?{
        for index in 0..<self.count {
            if self[index].id == matching.id{
                return index
            }
        }
        return nil
    }
}
