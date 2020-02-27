//
//  ScrollKeyBoard.swift
//  cychain
//
//  Created by takadahideaki007 on 2020/02/25.
//  Copyright © 2020 高田英明. All rights reserved.
//

import UIKit

protocol ScrollKeyBoard {
    func configureObserver()
    func removeObserver()
}

extension ScrollKeyBoard where Self: UIViewController {
    
    
    func configureObserver() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (notification) in
            self.keyboardWillShow(notification)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { notification in
            self.keyboardWillHide(notification)
        }
    }
    
    // キーボードが現れたときにviewをずらす
    func keyboardWillShow(_ notification: Notification) {
        let rect = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let duration: TimeInterval? = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: duration!) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -(rect?.size.height)!)
        }
    }
    
    // キーボードが消えたときにviewを戻す
    func keyboardWillHide(_ notification: Notification) {
        let duration: TimeInterval? = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!) {
            self.view.transform = CGAffineTransform.identity
        }
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
}


