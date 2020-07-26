import UIKit
import Lottie

class MuchPopUpVC: UIViewController {
    

    
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var contentView: contentView!
    
    var numberOfMatching: match?

    enum match {
        case oneMatch
        case multipleMatch
        case dissmiss
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        animationView.loopMode = .loop
        animationView.play()
    }
    
     override func viewDidDisappear(_ animated: Bool) {
           super.viewDidDisappear(animated)
        animationView.stop()
    }

    
    @IBAction func dismissButton(_ sender: Any) {
        numberOfMatching = .dissmiss
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func nextView(_ sender: Any) {
        
        let matchData = MatchData.shared
        
        if matchData.muchData?.count == 1{
            numberOfMatching = .oneMatch
        } else {
            numberOfMatching = .multipleMatch
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
