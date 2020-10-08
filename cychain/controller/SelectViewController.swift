import UIKit
import RxSwift
import GoogleMobileAds

class SelectViewController: UIViewController {
    
    @IBOutlet weak var postButton: Button!
    @IBOutlet weak var searchButton: Button!
    private let disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swichVC()
        //BuildTARGET確認
        #if cychain
        log.debug("cychain")
        #elseif cychaincopy
        log.debug("cychaincopy")
        #endif
    }

    override func viewWillLayoutSubviews() {
        _ = self.initViewLayout
    }
    lazy var initViewLayout : Void = {
        admob()
    }()
    
    func swichVC() {
        self.postButton.rx.tap
            .bind(onNext: { self.presentVC(vc: R.storyboard.main.PostNC()!, animation: true) })
            .disposed(by: disposeBag)
        
        self.searchButton.rx.tap
             .bind(onNext: {
                let UINavigationController = self.tabBarController?.viewControllers?[1]
                self.tabBarController?.selectedViewController = UINavigationController
             })
         .disposed(by: disposeBag)  
    }

}
