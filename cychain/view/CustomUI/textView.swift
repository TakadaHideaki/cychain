//
//  textView.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/06/01.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit

 @IBDesignable class textView: UITextView {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let next = next {
            next.touchesBegan(touches , with: event)
        } else {
            super.touchesBegan(touches , with: event)
        }
    }

}
