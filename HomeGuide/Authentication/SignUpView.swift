//
//  SignInView.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/08/21.
//  Copyright © 2020 minsoo kim. All rights reserved.
//
import GoogleSignIn
import SwiftUI
import Firebase
struct SignUpView : View{
    
    var headingMsg1 = "한 번의 가입으로"
    var headingMsg2 = "더 편리해지는 청약 찾기"
    @State var email : String = ""
    @State var password : String = ""
    @State var loading = false
    @State var error = false
    @State var errorMsg = ""
    @State var displayName = ""
    @EnvironmentObject var session: SessionStore
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    //   Google SignIn Var and Method
    let gIDSignIn = GIDSignIn.sharedInstance()
    @ObservedObject var myGoogle = GoogleSigninController()
    func googleSignIn(){
        self.gIDSignIn?.presentingViewController =
        UIApplication.shared.windows.first?.rootViewController
        // TODO:- Client ID To InfoList(For STG,PRD)
        self.gIDSignIn?.clientID = Bundle.main.infoDictionary?["GoogleFirebaseClientID"] as! String
        self.gIDSignIn?.delegate = self.myGoogle
        self.gIDSignIn?.signIn()
    }
    
    
    func signUp(){
        loading = true
        error = false
        session.signUp(email: email, password: password){(result,error) in
            self.loading = false
            if error != nil{
                self.error = true
                self.errorMsg = (AuthErrorCode(rawValue: error!._code)?.errorMessage ?? "") as String
            }else{
                self.email = ""
                self.password = ""
                self.session.updateDisplayName(displayName: self.displayName)
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
//    let spaceBetweenFormTitleAndForms = CGFloat(10)
//    let paddingFromHeadingToFormBody = CGFloat(10)
    let spacingBetweenInputFields = CGFloat(20)
    let paddingFormToTop = CGFloat(40)
    let buttonRadius = CGFloat(5)
    let spacingBetweenButtons = CGFloat(8)
    let errorMsgFontStyle = CustomFontStyle.sectionSmallDescriptionB
    let errorMsgFontColor = Color.coralRed
    var body: some View{
        ZStack{
            Color.whiteGrey.edgesIgnoringSafeArea(.all)
            VStack(alignment: .center){
                CustomNavigationBar(hasTitleText: true, titleText: "회원가입")
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
                                            if displayName.isEmpty { Text("이름").foregroundColor(.lightGrey).adjustFont(fontStyle: self.inputFieldTextStyle).multilineTextAlignment(TextAlignment.center) }
                                            TextField("", text: $displayName)
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
                                  Text("회원 가입")
                                      .adjustFont(fontStyle: self.buttonFontStyle)
                                      .foregroundColor(.white)
                              }
                                  .onTapGesture {
                                      self.signUp()
                                  }
                              // 구글 로그인 이미지
                              Image("GoogleSignin")
                                  .resizable()
                                  .frame(width: 193, height: 48, alignment: .center)
                                  .onTapGesture {
                                      self.googleSignIn()
                              }
                              NavigationLink(destination: SignInView()){
                                  ZStack{
                                    RoundedRectangle(cornerRadius: self.buttonRadius)
                                          .fill()
                                          .frame(width:185, height:45, alignment: .center)
                                          .foregroundColor(.lightGrey)
                                      Text("메일주소로 로그인")
                                          .adjustFont(fontStyle: self.buttonFontStyle)
                                          .foregroundColor(.white)
                                  }
                              }
                          }
                        Spacer()
                    }
                }
                Spacer()
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


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView().environmentObject(SessionStore())
    }
}
