import UIKit
import Firebase
import RxSwift
import RxCocoa
import AudioToolbox
import NVActivityIndicatorView
import GoogleMobileAds
import Lottie


//class SearchViewController: UIViewController, UITextFieldDelegate {
class SearchViewController: UIViewController {

    
    
    @IBOutlet var myNameTextField: UITextField!
    @IBOutlet var searchNameTextField: UITextField!
    @IBOutlet weak var noPostLabel: UILabel!
    @IBOutlet weak var searchButton: Button!
    @IBOutlet weak var indicator: NVActivityIndicatorView!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var popButton: UIButton!
    
    private let viewModel = SearchViewModel()
    private var matchwModel: MatchModel?
    private let indicatorView = UIActivityIndicatorView()


    private let disposeBag = DisposeBag()
    
    //mutchiUserData == [UID: [message:メッセージ、image:写真]]
//    lazy var mutchiUserData = [String: [String: Any]]()
    var muchPopUpVC: MuchPopUpVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        muchPopUpVC = R.storyboard.main.muchPopUpVC()
        initialazeUI()
        bind()
    }
    
    func initialazeUI() {
//        myNameTextField.delegate = self
//        searchNameTextField.delegate = self
//        indicator()
        //tapSearchButton()
        customNavigationBar()
        setIndicator()
      
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        myNameTextField.text = ""
        searchNameTextField.text = ""
        //        labelHidden()
    }
    
    
    
     
     override func viewWillLayoutSubviews() {
     _ = self.initViewLayout
     }
     lazy var initViewLayout : Void = {
     admob()
     }()
     
     
     override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)
     
     
     
     //マッチング後のポップアップで
     //[結果を見る]押下は結果VCへ
     //[×]押下はdismiss
        guard let presented = self.presentedViewController else { return }
        if type(of: presented) == MuchPopUpVC.self {
            
            self.animationView.isHidden = true
            
            switch muchPopUpVC?.matchCount {
            case 1: pushVC(vc: R.storyboard.main.seachResultVC()!, animation: false)
            case 2,3: pushVC(vc: R.storyboard.main.seachResultListVC()!, animation: false)
            case 0: break
            default: break
            }
        }
    }
     
    private func bind() {
        let input = SearchViewModel.Input(
            userName: myNameTextField.rx.text.orEmpty.map{ $0.deleteSpace() },
            searchName: searchNameTextField.rx.text.orEmpty.map{ $0.deleteSpace() },
            searchButtonTapped: searchButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        //SearchButtonEnabled
        output.ButtonEnabled.drive(self.searchButton.rx.isEnabled).disposed(by: disposeBag)
        
        //マッチ無し
        output.noMatch.drive(noPostLabel.rx.isHidden).disposed(by: disposeBag)
        output.noMatch.drive(popButton.rx.isHidden).disposed(by: disposeBag)
        output.noMatch.drive(self.indicatorView.rx.isAnimating).disposed(by: disposeBag)

        output.noMatch.asObservable().subscribe(onNext: { _ in
            self.animationView.isHidden = true })
            .disposed(by: disposeBag)
        
        //マッチ
        output.hidden.drive(noPostLabel.rx.isHidden).disposed(by: disposeBag)
        output.hidden.drive(popButton.rx.isHidden).disposed(by: disposeBag)
        output.stopIndicator.drive(self.indicatorView.rx.isAnimating).disposed(by: disposeBag)
        
        output.match.take(1).subscribe(onNext: { [weak self] value in
           
            self?.muchPopUpVC?.matchCount = value.data.count
//            self?.muchPopUpVC?.matchCount = 1
            self?.mutchAction()
            self?.matchwModel = MatchModel(data: value)
        })
        .disposed(by: disposeBag)

        output.searchStart.drive(self.indicatorView.rx.isAnimating).disposed(by: disposeBag)

        
        
        
    }
 
    
    func mutchAction() {
        animationView.isHidden = false
        self.animationView.play()
        switchPopupVC()
        AudioServicesPlaySystemSound(1003)
        AudioServicesDisposeSystemSoundID(1003)
    }
    
    func switchPopupVC() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                   if let muchPopUpVC = self.muchPopUpVC {
                       self.present(muchPopUpVC, animated: false)
                   }
               }
    }
    
    func setIndicator() {
        indicatorView.center = view.center
        indicatorView.style = .whiteLarge
        indicatorView.color = .gray
        view.addSubview(indicatorView)
    }
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        myNameTextField.resignFirstResponder()
        searchNameTextField.resignFirstResponder()
        return  true
    }
}
 


        
    /*

 func tapSearchButton() {
     self.searchButton.addTarget(self, action: #selector(tapButton(_ :)), for: .touchDown)
 }
     @objc func tapButton(_ sender: UIButton) {
        searchButtonTapped()
}
}
　//func searchButtonTapped() {
    
        
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
*/
