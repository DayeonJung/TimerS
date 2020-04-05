//
//  HamburgerViewController.swift
//  TimerS
//
//  Created by Dayeon Jung on 21/03/2020.
//  Copyright © 2020 Dayeon Jung. All rights reserved.
//

import UIKit
import PWSwitch

class HamburgerViewController: UIViewController {
    
    let ImgViewLogo = UIImageView(forAutoLayout: ())
    let lbTitle = UILabel(forAutoLayout: ())
    let lbAppInfo = UILabel(forAutoLayout: ())
    let lbSound = UILabel(forAutoLayout: ())
    let soundSwitch = PWSwitch(forAutoLayout: ())
    let vibSwitch = PWSwitch(forAutoLayout: ())

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        self.setUI()
        self.setSwitchUI()
        self.setSwitchEvent()
            
    }
    
    override func viewDidLayoutSubviews() {
        self.soundSwitch.setOn(UserDefaults.standard.bool(forKey: UserDefaultKey.sound.rawValue), animated: true)
        self.vibSwitch.setOn(UserDefaults.standard.bool(forKey: UserDefaultKey.vibration.rawValue), animated: true)
    }
    
    func setUI() {
        
        ImgViewLogo.image = UIImage(named: "logo")
        self.view.addSubview(ImgViewLogo)
        
        ImgViewLogo.autoSetDimensions(to: CGSize(width: 36, height: 40))
        ImgViewLogo.autoAlignAxis(toSuperviewAxis: .vertical)
        ImgViewLogo.autoPinEdge(.top, to: .top, of: self.view, withOffset: 36)
        
        
        lbTitle.text = "TimerS"
        lbTitle.textColor = .white
        lbTitle.font = UIFont(name: "Helvetica", size: 24)
        self.view.addSubview(lbTitle)
        
        self.lbTitle.autoPinEdge(.top, to: .bottom, of: ImgViewLogo, withOffset: 10)
        self.lbTitle.autoAlignAxis(.vertical, toSameAxisOf: ImgViewLogo)
        
        let ver = Bundle.main.infoDictionary!["CFBundleShortVersionString"]! as? String
        self.lbAppInfo.text = "TimerS for nolbal family\nVer " + (ver ?? "") + "\ndesigned by SSO\ndeveloped by Sandy Kim\nreleased by Dayeon"
        self.lbAppInfo.numberOfLines = 0
        self.lbAppInfo.textColor = .white
        self.lbAppInfo.font = UIFont(name: "Helvetica", size: 12)
        self.view.addSubview(self.lbAppInfo)
        
        self.lbAppInfo.autoPinEdge(.leading, to: .leading, of: self.view, withOffset: 14)
        self.lbAppInfo.autoPinEdge(.bottom, to: .bottom, of: self.view, withOffset: -26)
        
    }
    
    
    func setSwitchUI() {
        
        let lbSound = UILabel(forAutoLayout: ())
        lbSound.text = "Sound"
        lbSound.textColor = .white
        lbSound.font = UIFont(name: "Helvetica", size: 16)
        self.view.addSubview(lbSound)

        lbSound.autoPinEdge(.top, to: .bottom, of: self.lbTitle, withOffset: 50)
        lbSound.autoPinEdge(.leading, to: .leading, of: self.view, withOffset: 24)
        
        
        let lbVibration = UILabel(forAutoLayout: ())
        lbVibration.text = "Vibration"
        lbVibration.textColor = .white
        lbVibration.font = UIFont(name: "Helvetica", size: 16)
        self.view.addSubview(lbVibration)

        lbVibration.autoPinEdge(.top, to: .bottom, of: lbSound, withOffset: 20)
        lbVibration.autoPinEdge(.leading, to: .leading, of: self.view, withOffset: 24)

        
        self.view.addSubview(self.soundSwitch)
        
        self.soundSwitch.autoSetDimensions(to: CGSize(width: 44, height: 26))
        self.soundSwitch.autoAlignAxis(.horizontal, toSameAxisOf: lbSound)
        self.soundSwitch.autoPinEdge(.trailing, to: .trailing, of: self.view, withOffset: -24)
        
        
        self.view.addSubview(self.vibSwitch)
        
        self.vibSwitch.autoSetDimensions(to: CGSize(width: 44, height: 26))
        self.vibSwitch.autoAlignAxis(.horizontal, toSameAxisOf: lbVibration)
        self.vibSwitch.autoPinEdge(.trailing, to: .trailing, of: self.view, withOffset: -24)

    }
    
    
    func setSwitchEvent() {
        
        self.soundSwitch.tag = 0
        self.vibSwitch.tag = 1
        self.soundSwitch.addTarget(self, action: #selector(self.switchValueDidChange), for: .valueChanged)
        self.vibSwitch.addTarget(self, action: #selector(self.switchValueDidChange), for: .valueChanged)

    }
    
    
    @objc func switchValueDidChange(sender: PWSwitch!) {
        
        if sender.tag == 0 {
            UserDefaults.standard.set(sender.on, forKey: UserDefaultKey.sound.rawValue)
        } else if sender.tag == 1 {
            UserDefaults.standard.set(sender.on, forKey: UserDefaultKey.vibration.rawValue)
        }
        

    }
}
