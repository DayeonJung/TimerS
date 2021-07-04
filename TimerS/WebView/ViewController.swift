//
//  ViewController.swift
//  TimerS
//
//  Created by Dayeon Jung on 04/02/2020.
//  Copyright © 2020 Dayeon Jung. All rights reserved.
//
// 참고: https://www.theteams.kr/teams/866/post/64575
//      https://leejigun.github.io/CoreBlutooth

import UIKit
import WebKit
import PureLayout
import GoogleMobileAds
import AVFoundation
import AudioToolbox
import PWSwitch

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    enum Handler: String {
        case timeOut = "timeoutHandler"
        case hamburger = "hamburgerHandler"
        case interstitial = "interstitialHandler"
    }
    
    enum Effect: String {
        case vibration
        case sound
        case all
    }
    
    var bannerView: GADBannerView!
    var bannerContainer: UIView?
    
    var webView: WKWebView?

    var indicator: UIActivityIndicatorView?
    
    var interstitial: GADInterstitialAd!

    var alertSound: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setIndicator()
            
        self.setWebView()
        
        self.setBannerView()

        self.setInterstitial()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func setIndicator() {
        self.indicator = UIActivityIndicatorView(forAutoLayout: ())
        self.view.addSubview(self.indicator!)
        self.indicator?.autoCenterInSuperview()
    }
    
}

