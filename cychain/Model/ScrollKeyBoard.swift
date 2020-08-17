import UIKit

protocol ScrollKeyBoard {
    func configureObserver()
    func removeObserver()
}

extension ScrollKeyBoard where Self: UIViewController {
    
    func configureObserver() {
        log.debug("configureObserver")

        let center = NotificationCenter.default
        let mainQueue = OperationQueue.main
        var showToken: NSObjectProtocol?
        var hideToken: NSObjectProtocol?
        
        showToken = center.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                   object: nil,
                                   queue: mainQueue
        ) { (notification) in do {
            self.keyboardWillShow(notification)
            }
            center.removeObserver(showToken as Any)
        }
        
        
        hideToken = center.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                    object: nil,
                                    queue: mainQueue
        ) { (notification) in do {
            self.keyboardWillHide(notification)
            }
            center.removeObserver(hideToken as Any)
        }
    }
    
    // キーボードが現れたときにviewをずらす
    func keyboardWillShow(_ notification: Notification) {
        let duration: TimeInterval? = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: duration!) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -240)
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


