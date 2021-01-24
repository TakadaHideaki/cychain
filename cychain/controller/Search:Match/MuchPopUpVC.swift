import UIKit
import RxSwift
import RxCocoa
import Lottie

class MuchPopUpVC: UIViewController {
    
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var contentView: contentView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var nextViewButton: Button!
    
    private let viewModel = MatchPopupViewModel()
    private let disposeBag = DisposeBag()
    var matchCount: Int?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animationView.loopMode = .loop
        animationView.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        animationView.stop()
    }
    
    private func bind() {
        
        let input = MatchPopupViewModel
            .Input(nextViewButtonTapped: nextViewButton.rx.tap.asObservable(),
                   dismissButtonTapped: dismissButton.rx.tap.asObservable())

        let output = viewModel.transform(input: input)
        
        //バツボタンタップ
        output.nextVC
            .bind(onNext: { self.dismiss(animated: false) })
            .disposed(by: disposeBag)
          //マッチボタンタップ
        output.dismiss
            .bind(onNext: {
                self.matchCount = 0
                self.dismiss(animated: false)
            })
            .disposed(by: disposeBag)
    }
    
}
