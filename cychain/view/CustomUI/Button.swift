//
//  Button.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/11/30.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit

class Button: UIButton {
    
     override class var layerClass: AnyClass {
          get {
              return CAGradientLayer.self
          }
      }

    @IBInspectable
    open var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = useCornerRadius ? cornerRadius : bounds.midY
        }
    }
    
    @IBInspectable
    open var useCornerRadius: Bool = true {
        didSet {
            layer.cornerRadius = useCornerRadius ? cornerRadius : bounds.midY
        }
    }
    
    
    
    @IBInspectable
    open var shadowColor: UIColor? {
        didSet {
            layer.shadowColor = shadowColor?.cgColor ?? backgroundColor?.cgColor
        }
    }
    
    @IBInspectable
    open var shadowOpacity: Float = 0.8 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable
    open var shadowOffset: CGSize = CGSize(width: 0, height: 3) {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable
    open var shadowRadius: CGFloat = 8 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable
    open var gradientStartColor: UIColor = .clear {
        didSet {
            guard let gradientLayer = self.layer as? CAGradientLayer else { return }
            gradientLayer.colors = colors
        }
    }
    
    @IBInspectable
    open var gradientEndColor: UIColor = .clear {
        didSet {
            guard let gradientLayer = self.layer as? CAGradientLayer else { return }
            gradientLayer.colors = colors
        }
    }
    
    @IBInspectable
    open var gradientStartPoint: CGPoint = CGPoint(x: 0, y: 0) {
        didSet {
            guard let gradientLayer = self.layer as? CAGradientLayer else { return }
            gradientLayer.startPoint = gradientStartPoint
        }
    }
    
    @IBInspectable
    open var gradientEndPoint: CGPoint = CGPoint(x: 1, y: 1) {
        didSet {
            guard let gradientLayer = self.layer as? CAGradientLayer else { return }
            gradientLayer.endPoint = gradientEndPoint
        }
    }
    

    private var colors: [CGColor] {
        return [gradientStartColor.cgColor, gradientEndColor.cgColor]
    }
    

    
    open override func didMoveToWindow() {
        super.didMoveToWindow()
        layer.cornerRadius = useCornerRadius ? cornerRadius : bounds.midY
        layer.shadowColor = shadowColor?.cgColor ?? backgroundColor?.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        
        guard let gradientLayer = self.layer as? CAGradientLayer else { return }
        gradientLayer.cornerRadius = useCornerRadius ? cornerRadius : bounds.midY
        gradientLayer.colors = colors
        gradientLayer.startPoint = gradientStartPoint
        gradientLayer.endPoint = gradientEndPoint
    }
    

}
