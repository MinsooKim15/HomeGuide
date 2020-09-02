//
//  SessionStore.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/08/21.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import Foundation
import Firebase
import Combine
import SwiftUI

class SessionStore: ObservableObject {
    var didChange = PassthroughSubject<SessionStore, Never>()
    @Published var session: User? {
        willSet{
            print("변경할그야!!!!!!!!!!!!!!!!!")
        }
        didSet{
            self.didChange.send(self)
            print("변경")
        }
    }

    func addHomeKey(keyCount:Int){
        print("addHomeKey")
        print("keyCount \(keyCount)")
        self.session?.addHomeKey(keyCount:keyCount)
    }
    func useHomeKey(keyCount : Int){
        print("홈키 씀")
        print("소모 전 홈키 \(self.session?.userInfo.homeKey)")
        self.session?.useHomeKey(keyCount:keyCount)
        print("소모 후 홈키 \(self.session?.userInfo.homeKey)")
    }
    func checkToShowScore(homeType: HomeGuideModel.HomeType) -> Bool{
//        for item in self.session.userInfo.show
        if let showingList = self.session?.userInfo.showingSubscriptionList{
            for item in showingList{
                if item == homeType.id{
                    return true
                }
            }
        }
        return false
    }
    func addHomeType(homeType: HomeGuideModel.HomeType){
        print("홈타입 추가")
        self.session?.addHomeType(homeType:homeType)
    }
    var handle : AuthStateDidChangeListenerHandle?
    var userIsAnonymous = true
    var displayNameToShow: String{
        if session == nil{
            return "미가입자"
        }else{
            if session!.displayName == nil{
                return "가입자"
            }else{
                return self.session!.displayName!
            }
        }
    }
    var emailToShow:String{
        if session == nil{
            return "미가입자"
        }else{
            if session!.email == nil{
                return "가입메일"
            }else{
                return self.session!.email!
            }
        }
    }
    
    
    func signInAnonymous(){
        Auth.auth().signInAnonymously(){(authResult, error) in
            guard let user = authResult?.user else { return }
            self.userIsAnonymous = user.isAnonymous  // true
            let uid = user.uid
            if error != nil{
                print(error)
            }
            print("익명 로그인 성공")
        }
    }
    func listen(completion: @escaping ()-> Void){
        // monitor authentication changes using firebase
        print("상태변경")
        handle = Auth.auth().addStateDidChangeListener{(auth, user) in
            if let user = user{
                print("Got user: \(user)")
                
                if (self.session != nil) && (self.session?.uid == user.uid) && (self.session?.isAnonymous == false) && (user.isAnonymous == false){
                    print("기존과 같은 유저, 임시회원 상태 변경없음")
                    self.session?.updateData(
                        uid: user.uid,
                        displayName: user.displayName,
                        email: user.email
                    )
                }else{
                    print("신규, 전체 변경")
                    self.session = User(
                        uid: user.uid,
                        displayName : user.displayName,
                        email: user.email,
                        isAnonymous: user.isAnonymous
                    )
                    self.getUserInfo(uid:user.uid)
                }

            } else{
                // if we don't have a user, set our session to nil
                self.session = nil
                completion()
            }
        }
    }
//    // Additional methods (sign up, sign in) will go here
//    func signUpGooge(){
//        guard let auth = user.authentication else { return }
//        let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
//        Auth.auth().signIn(with: credentials) { (authResult, error) in
//        if let error = error {
//        print(error.localizedDescription)
//        } else {
//        print(“Login Successful.”)
//    }
    func getUserInfo(uid:String){
        let doc_ref = Firestore.firestore().collection("userInfos").document(uid)
        
        doc_ref.getDocument{(document,error) in
            if document?.exists ?? false{
                self.session?.userInfo = UserInfo(snapshot:document as! DocumentSnapshot)
            }
        }
    }
    
    func signUp(
        email: String,
        password: String,
        handler : @escaping AuthDataResultCallback){
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    func updateDisplayName(displayName:String){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = displayName
        changeRequest?.commitChanges { (error) in
            if error != nil{
                print(error)
            }else{
                self.session?.displayName = displayName
            }
        }
    }
    func signIn(
        email: String,
        password: String,
        handler : @escaping AuthDataResultCallback){
        Auth.auth().signIn(withEmail:email, password: password, completion:handler)
    }
    func signOut() -> Bool{
        do {
            try Auth.auth().signOut()
            self.session = nil
            return true
        } catch{
            return false
        }
    }
    func unbind () {
        if let handle = handle{
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
