import UIKit
import Firebase
import FirebaseUI
import AudioToolbox
import NVActivityIndicatorView
import GoogleMobileAds
import Lottie


class SearchViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var myNameTextField: UITextField!
    @IBOutlet var searchNameTextField: UITextField!
    @IBOutlet weak var noPostLabel: UILabel!
    @IBOutlet weak var searchButton: Button!
    @IBOutlet weak var indicator: NVActivityIndicatorView!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var popButton: UIButton!
    
    
    //mutchiUserData == [UID: [message:メッセージ、image:写真]]
    lazy var mutchiUserData = [String: [String: Any]]()
    var muchPopUpVC: MuchPopUpVC?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        initialazeUI()
    }
    
    func initialazeUI() {
        myNameTextField.delegate = self
        searchNameTextField.delegate = self
        indicator()
        labelHidden()
        customNavigationBar()
        muchPopUpVC = R.storyboard.main.muchPopUpVC()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        myNameTextField.text = ""
        searchNameTextField.text = ""
        labelHidden()
    }
    
    
    override func viewWillLayoutSubviews() {
        _ = self.initViewLayout
    }
    lazy var initViewLayout : Void = {
        admob()
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //マッチポップで[結果を見る]を押したら結果へ
        //[×]を押したらポップアップのdismissのみ
        guard let presented = self.presentedViewController else { return }
        if type(of: presented) == MuchPopUpVC.self {
            
            switch muchPopUpVC?.numberOfMatching {
            case .oneMatch: pushVC(vc: R.storyboard.main.seachResultVC()!, animation: false)
            case .multipleMatch: pushVC(vc: R.storyboard.main.seachResultListVC()!, animation: false)
            case .dissmiss: break
            case .none: break
            }
        }
    }

    
    @IBAction func searchAction(_ sender: Any) {
        
        let myName = myNameTextField.text?.deleteSpace() ?? ""
        let searchName = searchNameTextField.text?.deleteSpace() ?? ""

        self.view.endEditing(true)

        if myName.isEmpty || searchName.isEmpty {
            noNameAlert()
            return

        } else {

            indicator.startAnimating()

            let ref = Database.database().reference().child("\(myName)/\(searchName)/")
            ref.observeSingleEvent(of: .value, with: { (DataSnapshot) in
                //マッチ無し
                if DataSnapshot.value is NSNull {
                    self.nomutch()//マッチ無しラベルを表示

                } else {
                    //マッチ有り
                    //mutchiUserData == [UID: ["message": メッセージ, "image": 投稿写真]]
                    self.mutchiUserData = DataSnapshot.value as! [String: [String : Any]]

                    //ブロックユーザー登録があった場合
                    if let blockUserID = UD.array(forKey: Name.KeyName.block.rawValue) as? [String]  {
                        blockUserID.forEach {
                            //マッチしたユーザーとブロックユーザーが一致したら
                            //ブロックユーザーを表示させない処理
                            if self.mutchiUserData.keys.contains($0) {
                                self.mutchiUserData[$0] = nil // [UID　(←コレがblockなら削除): [message: メッセージ, profile: 投稿写真]]
                            }
                        }
                    }
                    if self.mutchiUserData.isEmpty {
                        self.nomutch() //ブロックアカウント削除後マッチ無し
                    } else {
                        self.mutch() //ブロックアカウント削除後マッチ有り
                    }
                }
            })
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        myNameTextField.resignFirstResponder()
        searchNameTextField.resignFirstResponder()
        return  true
    }
    
    
    private func mutch() {
        self.indicator.stopAnimating()
        animationView.isHidden = false
        animationView.play()
        AudioServicesPlaySystemSound(1003)
        AudioServicesDisposeSystemSoundID(1003)
        noPostLabel.isHidden = true
        popButton.isHidden = true
        
        guard let myName = myNameTextField.text?.deleteSpace(),
            let searchName = searchNameTextField.text?.deleteSpace()
            else { return }
        
        let matchData = MatchData.shared
        matchData.matchDataSet(matchData: self.mutchiUserData, names: [myName, searchName])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if let muchPopUpVC = self.muchPopUpVC {
                self.present(muchPopUpVC, animated: false)
            }
        }
    }
    
    private func nomutch() {
        self.indicator.stopAnimating()
        noPostLabel.isHidden = false
        popButton.isHidden = false
        animationView.isHidden = true
    }
    
    private func labelHidden() {
        noPostLabel.isHidden = true
        popButton.isHidden = true
        animationView.isHidden = true
    }
    

    

}
