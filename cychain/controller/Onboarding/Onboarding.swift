import UIKit
import Lottie


class Onboarding: UIViewController {

    
    @IBOutlet weak var onboardingView: AnimationView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var middlLabel: UILabel!
    @IBOutlet weak var botomLabel: UILabel!
    @IBOutlet weak var middlLabelTopMargin: NSLayoutConstraint!
    @IBOutlet weak var StartButton: UIButton!
    
    let hight = Int(UIScreen.main.bounds.size.height)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        onboardingView.loopMode = .playOnce
        onboardingView.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelSet()
        ButtonSet()
    }
    
    func ButtonSet() {
        StartButton.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    func labelSet() {
        self.topLabel.isHidden = true
        self.middlLabel.isHidden = true
        self.botomLabel.isHidden = true
        
        self.onboardingView.bringSubviewToFront(topLabel)
        self.onboardingView.bringSubviewToFront(middlLabel)
        self.onboardingView.bringSubviewToFront(botomLabel)
        
        self.topLabel.text = "Hello!"
        self.middlLabel.text = "cychainはユーザーの\n安全の為アカウント登録を\nお願いしています"
        self.botomLabel.text = "アカウントはgooleの\n管理するサーバーです\n安心してご利用下さい"
        
        middlLabelTopMargin.constant = CGFloat(middlLabelMargin())
    }
    
    enum DeviseHight: Int {
             case iphone6_7_8_XS = 667
             case iphone6_7_8_Plus = 736
             case iphoneX = 812
             case iphoneXR_XsMax = 896
        }

        func middlLabelMargin() -> Int {
            switch hight {
            case DeviseHight.iphone6_7_8_XS.rawValue: return 20
            case DeviseHight.iphone6_7_8_Plus.rawValue: return 30
            case DeviseHight.iphoneX.rawValue: return 50
            case DeviseHight.iphoneXR_XsMax.rawValue: return 60
            default:  return 100
            }
        }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
            self.topLabel.isHidden = false
            self.middlLabel.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2)  {
                self.botomLabel.isHidden = false
            }
        }
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    
}
