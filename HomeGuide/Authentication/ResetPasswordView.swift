//
//  ResetPasswordView.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/08/24.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import SwiftUI
import Firebase
struct ResetPasswordView : View{
    @State var email : String = ""
    @State var error: Bool = false
    @State var message : String = ""
    @EnvironmentObject var session :SessionStore
    let titleFontColor = Color.black
    let titleFontStyle = CustomFontStyle.sectionTitle
    let spaceBetweenNavBarAndBody = CGFloat(10)
    let paddingFromInputFiledToBodyTop = CGFloat(10)
    let paddingTopFromButtonToInputField = CGFloat(20)
    let inputFieldTextColor = Color.grey
    let inputFieldTextStyle = CustomFontStyle.sectionDescription
    let inputFieldHeight = CGFloat(40)
    let inputFieldWidth = CGFloat(240)
    let paddingFromBodyToNavBar = CGFloat(5)
    let buttonRadius = CGFloat(5)
    let buttonFontStyle = CustomFontStyle.sectionSmallDescriptionA
    let errorMsgFontStyle = CustomFontStyle.sectionSmallDescriptionB
    let errorMsgFontColor = Color.coralRed
    func resetPassword(){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error != nil{
                self.error = true
                self.message = (AuthErrorCode(rawValue: error!._code)?.errorMessage ?? "") as String
            }else{
                self.message = "메일 주소로 재설정 메일을 발송하였습니다."
            }
        }
    }
    var body : some View{
        ZStack{
            Color.white.edgesIgnoringSafeArea(.all)
            VStack{
                CustomNavigationBar(hasTitleText: true, titleText: "비밀번호 찾기")
                ZStack{
                    Color.white
                    VStack{
                        Spacer().frame(height:20)
                        ZStack{
                            RoundedRectangle(cornerRadius: 5)
                            .stroke()
                                .foregroundColor(.coralRed)
                            ZStack(alignment: .center) {
                                if email.isEmpty { Text("메일 주소").foregroundColor(.lightGrey).adjustFont(fontStyle: self.inputFieldTextStyle).multilineTextAlignment(TextAlignment.center) }
                                    TextField("", text: $email)
                                }
                                .multilineTextAlignment(TextAlignment.center)
                            }
                            .frame(width:self.inputFieldWidth, height: self.inputFieldHeight)
                            .padding([.top], self.paddingFromInputFiledToBodyTop)
                            ZStack{
                                RoundedRectangle(cornerRadius: self.buttonRadius)
                                    .fill()
                                    .frame(width:185, height:43, alignment: .center)
                                    .foregroundColor(.coralRed)
                                Text("비밀번호 재설정하기")
                                    .adjustFont(fontStyle: self.buttonFontStyle)
                                    .foregroundColor(.white)
                            }
                                .onTapGesture {
                                    self.resetPassword()
                                }
                        .padding([.top], self.paddingTopFromButtonToInputField)
                        Text(self.message)
                            .adjustFont(fontStyle: self.errorMsgFontStyle)
                            .foregroundColor(self.errorMsgFontColor)
                        Spacer()
                    }
                }
                .padding(self.paddingFromBodyToNavBar)
                
            }
        }                    .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}
