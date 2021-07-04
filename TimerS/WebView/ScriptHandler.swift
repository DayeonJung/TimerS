//
//  ScriptHandler.swift
//  TimerS
//
//  Created by Dayeon Jung on 15/04/2020.
//  Copyright © 2020 Dayeon Jung. All rights reserved.
//

import Foundation
import WebKit
import AVFoundation

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
                
                self.setSound()
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)

            } else if soundState && !vibState {

                self.setSound()
                
            } else if !soundState && vibState {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)

            }
                        
        } else if message.name == Handler.hamburger.rawValue {
            
            sideMenuController?.showLeftView(animated: true, completion: { })
            
        } else if message.name == Handler.interstitial.rawValue {
            
            if self.interstitial != nil {
                self.interstitial.present(fromRootViewController: self)
            } else {
              print("Ad wasn't ready")
            }
        }
        
        
    }

    func setSound() {
        let path = Bundle.main.path(forResource: "alert", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)

        do {
            self.alertSound = try AVAudioPlayer(contentsOf: url)
            self.alertSound?.play()
        } catch {
            print("couldn't load file :(")
        }
    }
}
