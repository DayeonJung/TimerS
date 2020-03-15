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

class ViewController: UIViewController {

    enum Effect: String {
        case vibration
        case sound
        case all
    }
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    var webView:WKWebView!

    let urlString: String = "https://aws-amplify.d1qy0aio3e63ai.amplifyapp.com/"
    let TIMEOUTHANDLER: String = "timeoutHandler"
    
    var indicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.setWebView()
        self.setBannerView()
        self.setIndicator()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    override func viewDidAppear(_ animated: Bool) {
        self.loadBannerAd()
    }
    

    
    func setWebView() {
        let contentController = WKUserContentController()
        let config = WKWebViewConfiguration()
        contentController.add(self, name: self.TIMEOUTHANDLER)
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
        self.bannerView.adUnitID = "ca-app-pub-8670640792248384~7346897313"
        
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


extension ViewController: WKUIDelegate, WKScriptMessageHandler {
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler()
        }))

        present(alertController, animated: true, completion: nil)
    }
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if message.name == self.TIMEOUTHANDLER {
            
            let messageDatas = message.body as? [String:String]

            //https://iphonedevwiki.net/index.php/AudioServices
            if let messageData = messageDatas?.first, messageData.key == "effect" {
                switch Effect(rawValue: messageData.value) {
                case .sound:
                    AudioServicesPlaySystemSound(1109)
                    break
                case .vibration:
                    AudioServicesPlaySystemSound(4095)
                    break
                case .all:
                    AudioServicesPlaySystemSound(1109)
                    AudioServicesPlaySystemSound(4095)
                default:
                    break
                }
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
