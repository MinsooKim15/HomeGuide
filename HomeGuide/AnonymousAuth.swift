//
//  AnonymousAuth.swift
//  
//
//  Created by minsoo kim on 2020/08/17.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth

class AnonymousAuth{
    init() {
        Auth.auth().signInAnonymously(){(authResult, error) in
            guard let user = authResult?.user else { return }
            let isAnonymous = user.isAnonymous  // true
            let uid = user.uid
            if error != nil{
                print(error)
            }
            print("로그인 성공")
        }
    }
}
