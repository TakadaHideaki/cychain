import UIKit

class ProfileView: NSObject {
    
    @IBOutlet var profileBaseView: UIView!
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var myNameTextField: UITextField!
    @IBOutlet weak var targetNameTextField: UITextField!
    @IBOutlet weak var msgTextView: UITextView!
    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var postButton: Button!
    
    override init() {
        super.init()
        let nib = UINib(nibName: "ProfileView", bundle: Bundle.main)
        profileBaseView = nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
}
