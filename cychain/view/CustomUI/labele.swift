import UIKit

@IBDesignable
class labele: UILabel {
    
    override func drawText(in rect: CGRect) {

        let newRect = rect.inset(by: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10
        ))
        super.drawText(in: newRect)
    }
}


