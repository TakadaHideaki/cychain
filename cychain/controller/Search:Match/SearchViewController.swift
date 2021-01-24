import UIKit
import RxSwift
import RxCocoa
import AudioToolbox
import NVActivityIndicatorView
import GoogleMobileAds
import Lottie

class SearchViewController: UIViewController {
    
    @IBOutlet var myNameTextField: UITextField!
    @IBOutlet var searchNameTextField: UITextField!
    @IBOutlet weak var noPostLabel: UILabel!
    @IBOutlet weak var searchButton: Button!
    @IBOutlet weak var indicator: NVActivityIndicatorView!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var popButton: UIButton!
    
    private let viewModel = SearchViewModel()
    private let matchModel = MatchModel.shared
    private let disposeBag = DisposeBag()
    private let muchPopUpVC = R.storyboard.main.muchPopUpVC()
    
    lazy var indicatorView = { () -> UIActivityIndicatorView in
        var view = UIActivityIndicatorView()
        view.style = .large
        view.color = .gray
        view.center = self.view.center
        self.view.addSubview(view)
        self.view.bringSubviewToFront(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialazeUI()
        customNavigationBar()
        bind()
    }
    
    func initialazeUI() {
        //textFieldを２つ設置した時に発生するLayoutConstraintエラー（バグ？）に対応
        myNameTextField.autocorrectionType = .no
        searchNameTextField.autocorrectionType = .no
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        myNameTextField.text = ""
        searchNameTextField.text = ""
    }
    
    //AdNob
     override func viewWillLayoutSubviews() {
     _ = self.initViewLayout
     }
     lazy var initViewLayout : Void = {
     admob()
     }()
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //マッチング後のポップアップから復帰した時の処理
        //ポップアップの[結果を見る]押下は結果VCへ遷移、[×]押下はdismiss
        guard let presented = self.presentedViewController else { return }
        if type(of: presented) == MuchPopUpVC.self {
            log.debug(muchPopUpVC?.matchCount)
            switch muchPopUpVC?.matchCount {
            case 0: break
            case 1: pushVC(vc: R.storyboard.main.seachResultVC()!, animation: false)
            default: pushVC(vc: R.storyboard.main.MatchListVC()! , animation: false)
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
        
        //indicator
        output.contolIndicator
            .map{ _ in false }
            .scan(true) { state, _ in !state}
            .drive(self.indicatorView.rx.isAnimating).disposed(by: disposeBag)
        
        //SearchButtonEnabled
        output.btnEnabled.drive(self.searchButton.rx.isEnabled).disposed(by: disposeBag)
        
        //NoMatchAction
        output.noMatch.debug().drive(noPostLabel.rx.isHidden).disposed(by: disposeBag)
        output.noMatch.drive(popButton.rx.isHidden).disposed(by: disposeBag)
        output.noMatch
            .asObservable()
            .scan(false) { state, _ in !state}
            .startWith(true)
            .bind(to: self.animationView.rx.isHidden)
            .disposed(by: disposeBag)
        
        //MatchAction
        output.matchUI.drive(noPostLabel.rx.isHidden).disposed(by: disposeBag)
        output.matchUI.drive(popButton.rx.isHidden).disposed(by: disposeBag)
//        output.stopIndicator.drive(self.indicatorView.rx.isAnimating).disposed(by: disposeBag)
        
        output.match.take(1).subscribe(onNext: { [weak self] value in
            let count = value.data.count
            //マッチ数によって表示画面が違うのでポップ画面にマッチ数を送る
            self?.muchPopUpVC?.matchCount = count
            self?.mutchAction()
            switch count {
            case 0 : break
            case 1: self?.matchModel.setData(data: value)
            default: self?.matchModel.matchdata = value
            }
        })
        .disposed(by: disposeBag)
    }
 
    func mutchAction() {
        AudioServicesPlaySystemSound(1003)
        AudioServicesDisposeSystemSoundID(1003)
        self.animationView.isHidden = false
        self.animationView.play() { finished in
            guard let vc = self.muchPopUpVC else { return }
            self.present(vc, animated: false)
        }
    }
    
}
extension Reactive where Base: AnimationView {
    var isHiddn: Binder<Bool> {
        return Binder(self.base) { animationview, bool in
            animationview.isHidden = bool
         
        }
    }
}
