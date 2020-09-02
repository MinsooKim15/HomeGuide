//
//  GoogleLogInController.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/08/24.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn

class GoogleSigninController: UIViewController, GIDSignInDelegate, ObservableObject {
    
    var googleSignIn = GIDSignIn.sharedInstance()
    var googleId = ""
    var googleIdToken = ""
    var googleFirstName = ""
    var googleLastName = ""
    var googleEmail = ""
    var googleProfileURL = ""
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        guard user != nil else {
            print("Uh oh. The user cancelled the Google login.")
            return
        }
        
        print("TOKEN => \(user.authentication.idToken!)")
        guard let authentication = user.authentication else {
            print("가드에 걸렸다?")
            return
        }
        print("토큰 받은 후 로그인 시도 중")
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential){(authResult, error) in
            if let error = error{
                print(error)
            }else{
                print("성공?")
                print(authResult.debugDescription)
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
        guard user != nil else {
            print("Uh oh. The user cancelled the Google login.")
            return
        }
        
        print("TOKEN => \(user.authentication.idToken!)")
    }
}
