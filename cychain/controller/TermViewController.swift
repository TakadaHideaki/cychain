import UIKit

class TermViewController: UIViewController {
    
    private var textView: Term_PolicyView?
    private var height: CGFloat?
    var terms_Policy: Terms_Policy?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = terms_Policy?.title

        height = self.navigationController?.navigationBar.frame.size.height
        textView = Term_PolicyView(height: height ?? 44, sentence: terms_Policy?.sentence ?? "")
        self.view = textView
        self.navigationController?.isNavigationBarHidden = false
    }



}
