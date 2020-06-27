//
//  ContentView.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/06/25.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var modelView : HomeModelView
    var body: some View {
        Button(action: modelView.getData, label: {Text("클릭")})
    }
}

