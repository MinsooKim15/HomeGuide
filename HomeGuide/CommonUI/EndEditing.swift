//
//  EndEditing.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/08/25.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import Foundation
import SwiftUI
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
