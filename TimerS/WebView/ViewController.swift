//
//  ViewController.swift
//  TimerS
//
//  Created by Dayeon Jung on 04/02/2020.
//  Copyright © 2020 Dayeon Jung. All rights reserved.
//

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

//    let urlString: String = "http://127.0.0.1:3000/"
    let urlString: String = "https://aws-amplify.d1qy0aio3e63ai.amplifyapp.com/"

    
    let interAdUnitID: String = "ca-app-pub-8670640792248384/9329416028"
    let testInterID: String = "ca-app-pub-3940256099942544/4411468910"
    let bannerAdUnitID: String = "ca-app-pub-8670640792248384/2832937234"
    let testBannerID: String = "ca-app-pub-3940256099942544/2934735716"

    var indicator: UIActivityIndicatorView?
    
    var interstitial: GADInterstitial!

    var alertSound: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setIndicator()
            
        self.setWebView()
        
        self.setBannerView()

        self.interstitial = createAndLoadInterstitial()

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



