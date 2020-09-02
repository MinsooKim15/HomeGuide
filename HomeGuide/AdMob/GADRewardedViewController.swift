import SwiftUI
import GoogleMobileAds
import UIKit
import Combine
    
final class Rewarded: NSObject, GADRewardedAdDelegate{
    
    var rewardedAd:GADRewardedAd
    
    var rewardFunction: (() -> Void)? = nil
    var rewardWorth : Bool
    
    override init() {
        
        let rewardAdId = Bundle.main.infoDictionary?["GADRewardAdId"] as! String
        self.rewardedAd = GADRewardedAd(adUnitID: rewardAdId)
        self.rewardWorth = false
        super.init()
        LoadRewarded()
        
    }
    
    func LoadRewarded(){
        let req = GADRequest()
        self.rewardedAd.load(req)
    }
    
    func showAd(rewardFunction: @escaping () -> Void){
        if self.rewardedAd.isReady{
            self.rewardFunction = rewardFunction
            let root = UIApplication.shared.windows.first?.rootViewController
            self.rewardedAd.present(fromRootViewController: root!, delegate: self)
        }
       else{
            print("Not Ready")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                self.showAdAgain(rewardFunction: rewardFunction)
            }
       }
    }
    func showAdAgain(rewardFunction: @escaping () -> Void){
        if self.rewardedAd.isReady{
             self.rewardFunction = rewardFunction
             let root = UIApplication.shared.windows.first?.rootViewController
             self.rewardedAd.present(fromRootViewController: root!, delegate: self)
         }
        else{
            print("Not Ready YETTT!")
        }
    }
    
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        self.rewardWorth = true
    }
    
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        if self.rewardWorth == true{
            let rewardAdId = Bundle.main.infoDictionary?["GADRewardAdId"] as! String
            self.rewardedAd = GADRewardedAd(adUnitID: rewardAdId)
            LoadRewarded()
            if let rf = rewardFunction {
                rf()
            }
        }
    }
}

struct RewardADView:View{
    var rewardAd:Rewarded
    
    init(rewardFunction:@escaping ()->Void){
        self.rewardAd = Rewarded()
        self.rewardFunction = rewardFunction
    }
    var rewardFunction : () -> Void
    
    var body : some View{
      Button("text", action: {
        self.rewardAd.showAd(rewardFunction:self.rewardFunction)
      })
    }
}
