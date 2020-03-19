//
//  HamburgerView.swift
//  TimerS
//
//  Created by Dayeon Jung on 19/03/2020.
//  Copyright © 2020 Dayeon Jung. All rights reserved.
//

import UIKit

class HamburgerView: UIView {

       override init(frame: CGRect) {
        super.init(frame: frame)
        self.commoninit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commoninit()
    }
    
    
    func commoninit() {
        let superView = Bundle.main.loadNibNamed("HamburgerView", owner: self, options: nil)?.first as! UIView
        self.addSubview(superView)
        superView.frame = self.bounds
        superView.layoutIfNeeded()
        
    }
}
