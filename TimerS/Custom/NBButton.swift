//
//  NBButton.swift
//  NewNolBal
//
//  Created by LKH on 30/07/2019.
//  Copyright © 2019 LKH. All rights reserved.
//

import UIKit
@IBDesignable
class NBButton: UIButton {

    @IBInspectable var shadowColor: UIColor? = .clear {
        didSet {
            updateUI()
        }
    }
    
    /* The opacity of the shadow. Defaults to 0. Specifying a value outside the
     * [0,1] range will give undefined results. Animatable. */
    @IBInspectable var shadowOpacity: Float = 0 {
        didSet {
            updateUI()
        }
    }
    
    @IBInspectable var shadowSpread: CGFloat = 0 {
        didSet {
            updateUI()
        }
    }
    
    /* The shadow offset. Defaults to (0, -3). Animatable. */
    @IBInspectable var shadowOffset: CGPoint {
        set {
            layer.shadowOffset = CGSize(width: newValue.x, height: newValue.y)
        }
        get {
            return CGPoint(x: layer.shadowOffset.width, y:layer.shadowOffset.height)
        }
    }
    
    /* The blur radius used to create the shadow. Defaults to 3. Animatable. */
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            updateUI()
        }
    }
    
    @IBInspectable public var startColor:   UIColor = .clear { didSet { updateColors() }}
    @IBInspectable public var endColor:     UIColor = .clear { didSet { updateColors() }}
    @IBInspectable public var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable public var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable public var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable public var diagonalMode:    Bool =  false { didSet { updatePoints() }}
    override public class var layerClass: AnyClass { return CAGradientLayer.self }
    var gradientLayer: CAGradientLayer { return layer as! CAGradientLayer }
    
    /// Border color of the view
    @IBInspectable public var borderColor: UIColor? = nil {
        didSet {
            updateUI()
        }
    }
    
    /// Border width of the view
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            updateUI()
        }
    }
    
    /// Corner radius of the view
    @IBInspectable public var cornerRadius: CGFloat = 8 {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Variables
    /// Closure is called on click event of the button
    public var onClick = { () }
    

    
    // MARK: - init methods
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    

    
    // MARK: - UI Setup
    private func setupUI() {
        addTarget(self, action: #selector(clickAction(button:)), for: .touchUpInside)
        updateUI()
    }
    


    
    // MARK: - Update UI
    private func updateUI() {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor ?? tintColor.cgColor
        layer.shadowRadius = self.shadowRadius / 2.0
        layer.shadowOpacity = self.shadowOpacity
        layer.shadowColor = self.shadowColor?.cgColor
        
        if self.shadowSpread == 0 {
            layer.shadowPath = nil
        } else {
            let dx = -self.shadowSpread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            layer.shadowPath = UIBezierPath(rect: rect).cgPath
        }
 
    }
    
    private func updateColors() {
        gradientLayer.colors    = [startColor.cgColor, endColor.cgColor]
    }
    
    private func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    
    private func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 0, y: 0) : CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 1, y: 1) : CGPoint(x: 0.5, y: 1)
        }
    }
    
    override func prepareForInterfaceBuilder() {
        updateUI()
        updatePoints()
        updateLocations()
        updateColors()
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
        updatePoints()
        updateLocations()
        updateColors()
    }
    
    // MARK: - On Click
    @objc private func clickAction(button: UIButton) {
        onClick()
    }

}
