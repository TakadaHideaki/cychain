//
//  labele.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/05/10.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit

@IBDesignable


class labele: UILabel {
    
    override func drawText(in rect: CGRect) {

        let newRect = rect.inset(by: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10
        ))
        super.drawText(in: newRect)
    }
}


