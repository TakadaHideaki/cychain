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
