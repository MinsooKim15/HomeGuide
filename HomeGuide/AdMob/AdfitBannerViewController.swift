//
//  AdfitBannerViewController.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/07/24.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import Foundation
import UIKit
import AdFitSDK
import SwiftUI

final private class AdfitBannerViewController: UIViewControllerRepresentable, AdFitBannerAdViewDelegate {
    func isEqual(_ object: Any?) -> Bool {
        return true
    }
    
    var hash: Int = 0
    
    var superclass: AnyClass?
    
    func `self`() -> Self {
        return self
    }
    
    func perform(_ aSelector: Selector!) -> Unmanaged<AnyObject>! {
        let a = Unmanaged.passRetained(true as AnyObject)
        return a
    }
    
    func perform(_ aSelector: Selector!, with object: Any!) -> Unmanaged<AnyObject>! {
        let a = Unmanaged.passRetained(true as AnyObject)
        return a
    }
    
    func perform(_ aSelector: Selector!, with object1: Any!, with object2: Any!) -> Unmanaged<AnyObject>! {
        let a = Unmanaged.passRetained(true as AnyObject)
        return a
    }
    
    func isProxy() -> Bool {
        true
    }
    
    func isKind(of aClass: AnyClass) -> Bool {
        true
    }
    
    func isMember(of aClass: AnyClass) -> Bool {
        true
    }
    
    func conforms(to aProtocol: Protocol) -> Bool {
        true
    }
    
    func responds(to aSelector: Selector!) -> Bool {
        true
    }
    
    var description: String = ""
    

    func makeUIViewController(context: Context) -> UIViewController{
        let bannerId = Bundle.main.infoDictionary?["AdfitBannerId"] as! String
        let bannerAdView = AdFitBannerAdView(clientId: bannerId, adUnitSize: "320x100")
        print(bannerAdView.adUnitSize)
        print(bannerAdView.clientId)
        let viewController = UIViewController()
        bannerAdView.rootViewController = viewController
        viewController.view.addSubview(bannerAdView)
        viewController.view.frame = CGRect(x:0, y:0, width: 320, height:100)
        print("adfit!!!!!!")
        bannerAdView.loadAd()
        return viewController
    }
    func adViewDidReceiveAd(_ bannerAdView: AdFitBannerAdView) {
        print("gotAD!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    }
        
    func adViewDidFailToReceiveAd(_ bannerAdView: AdFitBannerAdView, error: Error) {
        print("didFailToReceiveAd - error :\(error.localizedDescription)")
    }
        
    func adViewDidClickAd(_ bannerAdView: AdFitBannerAdView) {
        print("didClickAd")
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
// 지역별 순서 매기기 기능 추가하자
struct AdfitBanner:View{
    var body: some View{
        HStack{
            Spacer()
            AdfitBannerViewController().frame(width:320, height:100, alignment: .center)
            Text("안녕!")
            Spacer()
        }
    }
}
