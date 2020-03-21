//
//  MainViewController.swift
//  TimerS
//
//  Created by Dayeon Jung on 21/03/2020.
//  Copyright © 2020 Dayeon Jung. All rights reserved.
//

import UIKit
import LGSideMenuController

class MainViewController: LGSideMenuController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setup(){
        leftViewController = HamburgerViewController()
        leftViewWidth = UIScreen.main.bounds.width * 0.7
        leftViewBackgroundColor = UIColor(red: 51/255, green: 84/255, blue: 138/255, alpha: 1.0)
        rootViewCoverColorForLeftView = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 0.7)
        leftViewPresentationStyle = .slideAbove
        
    }

    override func leftViewWillLayoutSubviews(with size: CGSize) {
        super.leftViewWillLayoutSubviews(with: size)

        if !isLeftViewStatusBarHidden {
            leftView?.frame = CGRect(x: 0.0, y: 20.0, width: size.width, height: size.height - 20.0)
        }
    }


    override var isLeftViewStatusBarHidden: Bool {
        get {
            return super.isLeftViewStatusBarHidden
        }

        set {
            super.isLeftViewStatusBarHidden = newValue
        }
    }
    
    
    
}
