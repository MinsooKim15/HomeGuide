////
////  GADBannerViewController.swift
////  HomeGuide
////
////  Created by minsoo kim on 2020/06/30.
////  Copyright © 2020 minsoo kim. All rights reserved.
////
//
// 추후 적용
//
//import SwiftUI
//import GoogleMobileAds
//import UIKit
//
//final private class SmartBannerVC: UIViewControllerRepresentable  {
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
//
//
//    func makeUIViewController(context: Context) -> UIViewController {
//        let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
////        let bannerID = "ca-app-pub-3940256099942544/2934735716"
//        let bannerID = Bundle.main.infoDictionary?["BannerId"] as! String
//        print("MySmartBannerId------")
//        print(bannerID)
//        let viewController = UIViewController()
//        bannerView.adUnitID = bannerID
//        bannerView.rootViewController = viewController
//        viewController.view.addSubview(bannerView)
//        viewController.view.frame = CGRect(origin: .zero, size: kGADAdSizeBanner.size)
//        bannerView.load(GADRequest())
//        if #available(iOS 11.0, *) {
//          // In iOS 11, we need to constrain the view to the safe area.
//          // Position the banner. Stick it to the bottom of the Safe Area.
//          // Make it constrained to the edges of the safe area.
//          let guide = viewController.view.safeAreaLayoutGuide
//          NSLayoutConstraint.activate([
//            guide.leftAnchor.constraint(equalTo: bannerView.leftAnchor),
//            guide.rightAnchor.constraint(equalTo: bannerView.rightAnchor),
//            guide.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor)
//          ])
//        }
//        else {
//          // In lower iOS versions, safe area is not available so we use
//          // bottom layout guide and view edges.
//        viewController.view.addConstraint(NSLayoutConstraint(item: bannerView,
//                                                attribute: .leading,
//                                                relatedBy: .equal,
//                                                toItem: viewController.view,
//                                                attribute: .leading,
//                                                multiplier: 1,
//                                                constant: 0))
//          viewController.view.addConstraint(NSLayoutConstraint(item: bannerView,
//                                                attribute: .trailing,
//                                                relatedBy: .equal,
//                                                toItem: viewController.view,
//                                                attribute: .trailing,
//                                                multiplier: 1,
//                                                constant: 0))
//          viewController.view.addConstraint(NSLayoutConstraint(item: bannerView,
//                                                attribute: .bottom,
//                                                relatedBy: .equal,
//                                                toItem: viewController.view,
//                                                attribute: .top,
//                                                multiplier: 1,
//                                                constant: 0))
//        }
//        return viewController
//    }
//}
//
//struct SmartBanner:View{
//    var body: some View{
//        HStack{
//            SmartBannerVC().frame(width: 320, height: 50, alignment: .center)
//            Spacer()
//        }
//    }
//}
