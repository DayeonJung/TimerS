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
    
    @IBOutlet weak var hamburgerView: UIView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var soundSwitch: PWSwitch!
    
    @IBOutlet weak var vibrationSwitch: PWSwitch!
    
    var webView:WKWebView!

    let urlString: String = "https://aws-amplify.d1qy0aio3e63ai.amplifyapp.com/"
    
    let adUnitID: String = "ca-app-pub-8670640792248384~7346897313"
    let testUnitID: String = "ca-app-pub-3940256099942544/4411468910"
    
    var indicator: UIActivityIndicatorView?
    
    var hamburgerVisible: Bool = true
    
    var interstitial: GADInterstitial!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.leadingConstraint.constant = -300

        self.setWebView()
        self.setBannerView()
        self.setIndicator()
        
        self.soundSwitch.tag = 0
        self.vibrationSwitch.tag = 1
        self.soundSwitch.addTarget(self, action: #selector(self.switchValueDidChange), for: .valueChanged)
        self.vibrationSwitch.addTarget(self, action: #selector(self.switchValueDidChange), for: .valueChanged)

        self.interstitial = createAndLoadInterstitial()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    override func viewDidAppear(_ animated: Bool) {
        self.loadBannerAd()
    }
    
    
    func createAndLoadInterstitial() -> GADInterstitial {
    
        var id = self.adUnitID
        
        #if DEBUG
        id = self.testUnitID
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
        self.view.addSubview(self.webView)
        self.webView.autoPinEdge(toSuperviewSafeArea: .top)
        self.webView.autoPinEdge(toSuperviewSafeArea: .left)
        self.webView.autoPinEdge(toSuperviewSafeArea: .right)
        self.webView.autoPinEdge(.bottom, to: .top, of: self.bannerView)

        
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        
        self.webView.allowsLinkPreview = false
        self.webView.configuration.preferences.javaScriptEnabled = true
        
        self.webView.load(URLRequest(url: URL(string: self.urlString)!))

    }
    
    
    func setIndicator() {
        self.indicator = UIActivityIndicatorView(forAutoLayout: ())
        self.view.addSubview(self.indicator!)
        self.indicator?.autoCenterInSuperview()
    }
    
    
    func setBannerView() {
        self.bannerView.adUnitID = self.adUnitID
        
        #if DEBUG
        self.bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        #endif
        
        self.bannerView.rootViewController = self
    }
    
    
    func loadBannerAd() {
        let frame = { () -> CGRect in
            if #available(iOS 11.0, *) {
                return view.frame.inset(by: view.safeAreaInsets)
            } else {
                return view.frame
            }
        }()
        let viewWidth = frame.size.width
        self.bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        self.bannerView.load(GADRequest())
    }

    
}


extension WKWebView {
    override open var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
        
        let soundState = UserDefaults.standard.bool(forKey: "soundSwitchState")
        let vibState = UserDefaults.standard.bool(forKey: "vibrationSwitchState")

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
            self.view.bringSubviewToFront(self.hamburgerView)

            if !self.hamburgerVisible {
                self.leadingConstraint.constant = -300
                self.hamburgerVisible = true
            } else {
                self.leadingConstraint.constant = 0
                self.hamburgerVisible = false
                
                
                self.soundSwitch.setOn(soundState, animated: true)
                self.vibrationSwitch.setOn(vibState, animated: true)
                                
                let button = NBButton(forAutoLayout: ())
                button.cornerRadius = 0
                button.backgroundColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 0.7)
                
                button.onClick = {
                    self.leadingConstraint.constant = -300
                    self.hamburgerVisible = true
                    
                    button.removeFromSuperview()
                    
                    UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                        self.view.layoutIfNeeded()
                    }) { (completed) in
                        print("completed")
                    }
                }
                
                self.view.addSubview(button)
                button.autoSetDimensions(to: CGSize(width: UIScreen.main.bounds.width-300, height: self.view.frame.height))
                button.autoPinEdge(.left, to: .right, of: self.hamburgerView)
                button.autoPinEdge(.top, to: .top, of: self.hamburgerView)
                button.autoPinEdge(.bottom, to: .bottom, of: self.hamburgerView)

            }
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                print("completed")
            }
            
        } else if message.name == Handler.interstitial.rawValue {
            
            if self.interstitial.isReady {
                self.interstitial.present(fromRootViewController: self)
            } else {
              print("Ad wasn't ready")
            }
        }
        
        
    }
    
    
    @objc func switchValueDidChange(sender: PWSwitch!) {
        
        if sender.tag == 0 {
            UserDefaults.standard.set(sender.on, forKey: "soundSwitchState")
        } else if sender.tag == 1 {
            UserDefaults.standard.set(sender.on, forKey: "vibrationSwitchState")
            
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
