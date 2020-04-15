//
//  SetBanner.swift
//  TimerS
//
//  Created by Dayeon Jung on 15/04/2020.
//  Copyright © 2020 Dayeon Jung. All rights reserved.
//

import Foundation
import WebKit
import GoogleMobileAds

extension ViewController {

    func setBannerView() {
        
        self.bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        self.bannerView.adUnitID = self.bannerAdUnitID
        #if DEBUG
        self.bannerView.adUnitID = self.testBannerID
        #endif
        
        self.bannerView.delegate = self
        self.bannerView.rootViewController = self
        self.bannerView.load(GADRequest())
        
    }
    
}


extension ViewController: GADBannerViewDelegate {
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {

        view.addSubview(bannerView)
        bannerView.autoSetDimensions(to: CGSize(width: 320, height: 50))
        bannerView.autoPinEdge(toSuperviewEdge: .bottom)
        bannerView.autoAlignAxis(toSuperviewAxis: .vertical)

        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
          bannerView.alpha = 1
        })
    }

}
