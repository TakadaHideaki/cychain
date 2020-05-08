//
//  ShadowButton.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/10/12.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit

// class ShadowButton: UIButton {
//
//    @IBInspectable var cornerRadius: CGFloat = 0.0 {
//        didSet {
//            setNeedsLayout()
//        }
//    }
//    
//    
//    @IBInspectable var shadowColor: UIColor = UIColor.darkGray {
//        didSet {
//            setNeedsLayout()
//        }
//    }
//    @IBInspectable var shadowOffsetWidth: CGFloat = 0.0 {
//        didSet {
//            setNeedsLayout()
//        }
//    }
//    @IBInspectable var shadowOffsetHeight: CGFloat = 1.8 {
//        didSet {
//            setNeedsLayout()
//        }
//    }
//    @IBInspectable var shadowOpacity: Float = 0.30 {
//        didSet {
//            setNeedsLayout()
//        }
//    }
//    @IBInspectable var shadowRadius: CGFloat = 3.0 {
//        didSet {
//            setNeedsLayout()
//        }
//    }
//    private var shadowLayer: CAShapeLayer = CAShapeLayer() {
//        didSet {
//            setNeedsLayout()
//        }
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        layer.cornerRadius = cornerRadius
//        shadowLayer.path = UIBezierPath(roundedRect: bounds,
//                                        cornerRadius: cornerRadius).cgPath
//        shadowLayer.fillColor = backgroundColor?.cgColor
//        shadowLayer.shadowColor = shadowColor.cgColor
//        shadowLayer.shadowPath = shadowLayer.path
//        shadowLayer.shadowOffset = CGSize(width: shadowOffsetWidth,
//                                          height: shadowOffsetHeight)
//        shadowLayer.shadowOpacity = shadowOpacity
//        shadowLayer.shadowRadius = shadowRadius
//        layer.insertSublayer(shadowLayer, at: 0)
//    }
//
//
//}
