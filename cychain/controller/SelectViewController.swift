import UIKit
import GoogleMobileAds

class SelectViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationBar下線削除
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
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
    
    
    @IBAction func search(_ sender: Any) {
        //tab切り替えで画面遷移
        let UINavigationController = tabBarController?.viewControllers?[1]
        tabBarController?.selectedViewController = UINavigationController
    }
}




