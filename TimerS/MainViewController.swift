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

    let width = UIScreen.main.bounds.width * 0.7
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setup(){
        leftViewController = HamburgerViewController()
        leftViewWidth = self.width
        leftViewBackgroundColor = UIColor(red: 51/255, green: 84/255, blue: 138/255, alpha: 1.0)
        rootViewCoverColorForLeftView = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 0.7)
        leftViewPresentationStyle = .slideAbove
        
    }
    
    override func leftViewLayoutSubviews() {
        super.leftViewLayoutSubviews()
        
        if !isLeftViewStatusBarHidden {
            leftView?.frame = CGRect(x: 0,
                                     y: 20,
                                     width: self.width,
                                     height: UIScreen.main.bounds.height - 20)
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
