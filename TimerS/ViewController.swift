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



class ViewController: UIViewController {

    var webView:WKWebView!

    let urlString: String = "https://aws-amplify.d1qy0aio3e63ai.amplifyapp.com/"
    
    var indicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        URLCache.shared.removeAllCachedResponses()
        self.webView = WKWebView()
        self.view.addSubview(self.webView)
        self.webView.autoPinEdgesToSuperviewSafeArea()

        self.webView.navigationDelegate = self
        
        self.webView.allowsLinkPreview = false
        
        self.webView.load(URLRequest(url: URL(string: self.urlString)!))

        self.indicator = UIActivityIndicatorView(forAutoLayout: ())
        self.view.addSubview(self.indicator!)
        self.indicator?.autoCenterInSuperview()
        
    }

}

extension WKWebView {
    override open var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
