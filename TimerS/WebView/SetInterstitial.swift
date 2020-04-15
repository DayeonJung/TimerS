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
    
    func createAndLoadInterstitial() -> GADInterstitial {
    
        var id = self.interAdUnitID
        
        #if DEBUG
        id = self.testInterID
        #endif
        
        let interstitial = GADInterstitial(adUnitID: id)
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
}

extension ViewController: GADInterstitialDelegate {
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
      self.interstitial = createAndLoadInterstitial()
    }
    
}
