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

enum UserDefaultKey: String {
    case sound = "soundSwitchState"
    case vibration = "vibrationSwitchState"
}

class ViewController: UIViewController {

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
    
    var webView: WKWebView?

    let urlString: String = "https://aws-amplify.d1qy0aio3e63ai.amplifyapp.com/"
    
    let interAdUnitID: String = "ca-app-pub-8670640792248384/9329416028"
    let bannerAdUnitID: String = "ca-app-pub-8670640792248384/2832937234"
    let testInterID: String = "ca-app-pub-3940256099942544/4411468910"
    let testBannerID: String = "ca-app-pub-3940256099942544/2934735716"
    
    var indicator: UIActivityIndicatorView?
    
    var interstitial: GADInterstitial!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setIndicator()
        
        self.setBannerView()
        
        self.interstitial = createAndLoadInterstitial()

        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView, attribute: .bottom, relatedBy: .equal, toItem: bottomLayoutGuide, attribute: .top, multiplier: 1, constant: 0),
             NSLayoutConstraint(item: bannerView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        ])
    }
    
    
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


    func setWebView() {
        let contentController = WKUserContentController()
        let config = WKWebViewConfiguration()
        
        contentController.add(self, name: Handler.timeOut.rawValue)
        contentController.add(self, name: Handler.hamburger.rawValue)
        contentController.add(self, name: Handler.interstitial.rawValue)

        config.userContentController = contentController
        
        self.webView = WKWebView(frame: self.view.frame, configuration: config)
        if let webView = self.webView {
            self.view.addSubview(webView)
            webView.autoPinEdge(toSuperviewSafeArea: .top)
            webView.autoPinEdge(toSuperviewSafeArea: .left)
            webView.autoPinEdge(toSuperviewSafeArea: .right)
            webView.autoPinEdge(.bottom, to: .top, of: self.bannerView)

            webView.navigationDelegate = self
            webView.uiDelegate = self
            
            webView.allowsLinkPreview = false
            webView.configuration.preferences.javaScriptEnabled = true
            
            webView.load(URLRequest(url: URL(string: self.urlString)!))
        }
    }
    
    
    func setIndicator() {
        self.indicator = UIActivityIndicatorView(forAutoLayout: ())
        self.view.addSubview(self.indicator!)
        self.indicator?.autoCenterInSuperview()
    }
    
    
    func setBannerView() {
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)

        self.bannerView.adUnitID = self.bannerAdUnitID
        
        #if DEBUG
        self.bannerView.adUnitID = self.testBannerID
        #endif
        
        bannerView.delegate = self

        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
    }
    
}


extension WKWebView {
    override open var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension ViewController: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        // Add banner to view and add constraints as above.
        self.addBannerViewToView(bannerView)
        
        if self.webView == nil {
            self.setWebView()
        }
        
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
          bannerView.alpha = 1
        })
    }

}


extension ViewController: GADInterstitialDelegate {
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
      self.interstitial = createAndLoadInterstitial()
    }
    
}

extension ViewController: WKUIDelegate, WKScriptMessageHandler {

    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler()
        }))

        present(alertController, animated: true, completion: nil)
    }
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        let soundState = UserDefaults.standard.bool(forKey: UserDefaultKey.sound.rawValue)
        let vibState = UserDefaults.standard.bool(forKey: UserDefaultKey.vibration.rawValue)

        if message.name == Handler.timeOut.rawValue {
            
            //https://iphonedevwiki.net/index.php/AudioServices
            if soundState && vibState {
                AudioServicesPlaySystemSound(1109)
                AudioServicesPlaySystemSound(4095)
            } else if soundState && !vibState {
                AudioServicesPlaySystemSound(1109)
            } else if !soundState && vibState {
                AudioServicesPlaySystemSound(4095)
            }
                        
        } else if message.name == Handler.hamburger.rawValue {
            
            sideMenuController?.showLeftView(animated: true, completionHandler: nil)
            
        } else if message.name == Handler.interstitial.rawValue {
            
            if self.interstitial.isReady {
                self.interstitial.present(fromRootViewController: self)
            } else {
              print("Ad wasn't ready")
            }
        }
        
        
    }

    
}


extension ViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.indicator?.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.indicator?.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        let alert = UIAlertController(title: "네트워크 오류", message: error.localizedDescription, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "확인", style: .default, handler : nil)

        alert.addAction(defaultAction)
        self.present(alert, animated: false, completion: nil)

    }
    
}
