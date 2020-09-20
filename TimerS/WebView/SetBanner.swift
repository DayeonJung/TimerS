//
//  SetBanner.swift
//  TimerS
//
//  Created by Dayeon Jung on 15/04/2020.
//  Copyright © 2020 Dayeon Jung. All rights reserved.
//

import UIKit
import WebKit
import GoogleMobileAds

extension ViewController {

    func setBannerView() {
        
        self.bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        self.bannerView.translatesAutoresizingMaskIntoConstraints = false
        self.bannerView.tag = 100
        self.bannerView.adUnitID = AdId.Banner.rawValue
        #if DEBUG
        self.bannerView.adUnitID = AdId.TestBanner.rawValue
        #endif
        
        self.bannerView.delegate = self
        self.bannerView.rootViewController = self
        self.bannerView.load(GADRequest())
        
    }
    
}


extension ViewController: GADBannerViewDelegate {
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        
        if self.view.viewWithTag(100) == nil {
            view.addSubview(self.bannerView)
            self.bannerView.autoSetDimensions(to: CGSize(width: 320, height: 50))
            self.bannerView.autoPinEdge(toSuperviewEdge: .bottom)
            self.bannerView.autoAlignAxis(toSuperviewAxis: .vertical)
        }

        self.bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
          self.bannerView.alpha = 1
        })
    }

}
