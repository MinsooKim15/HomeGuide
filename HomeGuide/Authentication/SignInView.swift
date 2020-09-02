//
//  SignInView.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/08/21.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import SwiftUI
import GoogleSignIn
import Firebase

struct SignInView : View{
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var email : String = ""
    @State var password : String = ""
    @State var loading = false
    @State var error = false
    @State var errorMsg = ""
    
    @EnvironmentObject var session: SessionStore
    let navBarPaddingToLead = CGFloat(20)
    let navBarPaddingToTop = CGFloat(20)
    let navBarMaxHeight = CGFloat(50)
    
    func signIn(){
        loading = true
        error = false
        session.signIn(email: email, password: password){(result,error) in
            self.loading = false
            if error != nil{
                self.error = true
                self.errorMsg = (AuthErrorCode(rawValue: error!._code)?.errorMessage ?? "") as String
            }else{
                self.email = ""
                self.password = ""

                UIApplication.shared.endEditing()
                self.presentationMode.wrappedValue.dismiss()
            }
            
        }
    }
    
        func checkSession(){
            if (session.session != nil)&&(session.session?.isAnonymous == false){
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        let spaceBetweenNavBarAndBody = CGFloat(10)
        
        let spaceBetweenFormAndButtonGroup = CGFloat(40)
        let buttonFontStyle = CustomFontStyle.sectionSmallDescriptionA
        let inputFieldHeight = CGFloat(40)
        let inputFieldWidth = CGFloat(240)
        let inputFieldTextColor = Color.grey
        let inputFieldTextStyle = CustomFontStyle.sectionDescription
        let titleFontColor = Color.black
        let titleFontStyle = CustomFontStyle.sectionTitle
        let navBarBackButtonSize = CGFloat(30)
    //    let spaceBetweenFormTitleAndForms = CGFloat(10)
    //    let paddingFromHeadingToFormBody = CGFloat(10)
        let spacingBetweenInputFields = CGFloat(20)
        let paddingFormToTop = CGFloat(40)
        let buttonRadius = CGFloat(5)
        let spacingBetweenButtons = CGFloat(8)
        let errorMsgFontStyle = CustomFontStyle.sectionSmallDescriptionB
        let errorMsgFontColor = Color.coralRed
        let findPassWordFontStyle = CustomFontStyle.sectionSmallDescriptionB
        var body: some View{
            ZStack{
                Color.whiteGrey.edgesIgnoringSafeArea(.all)
                VStack(alignment: .center){
                      CustomNavigationBar(hasTitleText: true, titleText: "이메일로 로그인")
                      Spacer()
                          .frame(height: self.spaceBetweenNavBarAndBody)
                    ZStack{
                        Color.white
                        VStack(alignment: .center, spacing:0){
                            // MARK:- Form Group1
                            HStack{
                                Spacer()
                                VStack(spacing:self.spacingBetweenInputFields){
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 5)
                                        .stroke()
                                        .foregroundColor(.coralRed)
                                            ZStack(alignment: .center) {
                                                if email.isEmpty { Text("메일 주소").foregroundColor(.lightGrey).adjustFont(fontStyle: self.inputFieldTextStyle).multilineTextAlignment(TextAlignment.center) }
                                                TextField("", text: $email)
                                            }
                                            .multilineTextAlignment(TextAlignment.center)
    //                                    HorizontalLine(color: .coralRed)
                                    }
                                    .frame(width:self.inputFieldWidth, height: self.inputFieldHeight)
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke()
                                            .foregroundColor(.coralRed)
                                        ZStack(alignment: .center) {
                                            if password.isEmpty { Text("패스워드").foregroundColor(.lightGrey).adjustFont(fontStyle: self.inputFieldTextStyle).multilineTextAlignment(TextAlignment.center) }
                                            SecureField("", text: $password)
                                        }
                                        
                                        .multilineTextAlignment(TextAlignment.center)
    //                                    HorizontalLine(color: .coralRed)
                                    }
                                    .frame(width:self.inputFieldWidth, height: self.inputFieldHeight)
                                }

                                .foregroundColor(self.inputFieldTextColor)
                                .adjustFont(fontStyle:self.inputFieldTextStyle)
                                Spacer()
                            }
                            .padding([.top], self.paddingFormToTop)
                              Spacer()
                                  .frame(height: self.spaceBetweenFormAndButtonGroup)
                              // MARK:- Button Group
                            VStack(spacing:self.spacingBetweenButtons){
    //                              if (error){
                                      Text(self.errorMsg)
                                        .adjustFont(fontStyle: self.errorMsgFontStyle)
                                        .foregroundColor(self.errorMsgFontColor)
    //                        }
                                ZStack{
                                      RoundedRectangle(cornerRadius: self.buttonRadius)
                                          .fill()
                                          .frame(width:185, height:43, alignment: .center)
                                          .foregroundColor(.coralRed)
                                      Text("메일주소로 로그인")
                                          .adjustFont(fontStyle: self.buttonFontStyle)
                                          .foregroundColor(.white)
                                  }
                                      .onTapGesture {
                                          self.signIn()
                                      }
                                NavigationLink(destination: ResetPasswordView()){
                                    Text("비밀번호 찾기").adjustFont(fontStyle:self.findPassWordFontStyle )
                                }
                              }
                            Spacer()
                        }
                    }

                  }
                .onAppear{self.checkSession()}
                  .navigationBarTitle("")
                  .navigationBarHidden(true)
            }
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
        }
    
}
