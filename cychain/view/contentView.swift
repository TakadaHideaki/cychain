//
//  contentView.swift
//  cychain
//
//  Created by takadahideaki007 on 2020/03/25.
//  Copyright © 2020 高田英明. All rights reserved.
//

import UIKit

class contentView: UIView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let view = super.hitTest(point, with: event)
    return view == self ? nil : view
    }
}
