//
//  SetInterstitial.swift
//  TimerS
//
//  Created by Dayeon Jung on 15/04/2020.
//  Copyright © 2020 Dayeon Jung. All rights reserved.
//

import Foundation
import WebKit
import GoogleMobileAds



extension ViewController {
    
    func setInterstitial() {
        
        var id = AdId.Inter.rawValue
        
        #if DEBUG
        id = AdId.TestInter.rawValue
        #endif
                
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: id,
                               request: request) { ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
        }
    }
    
}

extension ViewController: GADFullScreenContentDelegate {
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }
    
    /// Tells the delegate that the ad presented full screen content.
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did present full screen content.")
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
    }
    
}
