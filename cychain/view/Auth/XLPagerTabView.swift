import UIKit

class XLPagerTabView: UIView {

    @IBOutlet weak var mailButton: Button!
    @IBOutlet weak var googleButton: Button!
    
    class func instance() -> XLPagerTabView {
        return UINib(nibName: "XLPagerTabView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! XLPagerTabView
    }
    
    func setButtonImg() {
        mailButton.setImage(R.image.mail(), for: .normal)
        mailButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        googleButton.setImage(R.image.google(), for: .normal)
        googleButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
    
    func buttonTitle(mailtitle: String, googleTitle: String) {
        mailButton.setTitle(mailtitle, for: .normal)
        googleButton.setTitle(googleTitle, for: .normal)
    }


}
