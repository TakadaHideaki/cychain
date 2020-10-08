import UIKit

class textField: UITextField {
    
    private var maxLengths = [UITextField: Int]()
    
        @IBInspectable var maxLength: Int {
            get {
                guard let length = maxLengths[self] else {
                    return Int.max
                }
                return length
            }
            set {
                maxLengths[self] = newValue
                addTarget(self, action: #selector(limitLength), for: .editingChanged)
            }
        }
    
    // 枠線の色
    @IBInspectable var borderColor: UIColor? {
        get {
            return layer.borderColor.map { UIColor(cgColor: $0) }
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    
    // 枠線のWidth
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    
    
    // 角丸設定
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
        
        @objc func limitLength(textField: UITextField) {
            guard let prospectiveText = textField.text, prospectiveText.count > maxLength else {
                return
            }
            
            let selection = selectedTextRange
            let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
            
            #if swift(>=4.0)
            text = String(prospectiveText[..<maxCharIndex])
            #else
            text = prospectiveText.substring(to: maxCharIndex)
            #endif
            
            selectedTextRange = selection
        }
        
    }

