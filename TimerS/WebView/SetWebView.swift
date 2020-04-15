//
//  SetWebView.swift
//  TimerS
//
//  Created by Dayeon Jung on 15/04/2020.
//  Copyright © 2020 Dayeon Jung. All rights reserved.
//

import Foundation
import WebKit


extension ViewController {
    
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

            webView.autoPinEdgesToSuperviewEdges()

            webView.navigationDelegate = self
            webView.uiDelegate = self
            
            webView.allowsLinkPreview = false
            webView.configuration.preferences.javaScriptEnabled = true
            
            webView.load(URLRequest(url: URL(string: self.urlString)!))
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
