import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth
import LTMorphingLabel
import XLPagerTabStrip

class InitialViewController: ButtonBarPagerTabStripViewController  {
  
    @IBOutlet weak var label: LTMorphingLabel!
    
    var labelText = "c y c h a i n"
    var attributedText: NSMutableAttributedString?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
//        customNavigationBar(color: .clear)
//        self.navigationController?.navigationBar.barTintColor = .orange

        //        confirmInitialLaunch()
        configureObserver()
    }

    override func viewDidLoad() {
        PagerTabUI()
// ------ ↑super.viewDidLoadの前に記述 -----------
        super.viewDidLoad()
        initializeUI()
        LoggedIn()
    }
    
    func initializeUI() {
        label.text = labelText
        setNavigationBar()
    }
    
    func setNavigationBar() {
        //app全体のnagigationBarの下線を無しにする
        UINavigationBar.appearance().shadowImage = UIImage()
        //initialVC配下のnavigationBarの設定
        //backgraundを透明
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //戻るボタンの文字を消す（＜だけにする）
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let bar = self.navigationController?.navigationBar
        bar?.tintColor = .darkGray
        bar?.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(rawValue: 0.1)),
                                    .kern: Float(2.0)]
        
    }
    
    // 初回起動は、Onboarding表示
    func confirmInitialLaunch() {
        if UD.bool(forKey: Name.KeyName.flag.rawValue) {
            UD.set(false, forKey: Name.KeyName.flag.rawValue)
            self.pushVC(vc: R.storyboard.main.onboardingVC()!, animation: false)
        }
    }
    
    // ログイン中はログイン画面をスキップ
    func LoggedIn() {
        if Auth.auth().currentUser != nil {
            self.presentVC(vc: R.storyboard.main.tabVC()!, animation: false)
        }
    }
    
    // NotificationCenterに監視対象として登録
    // ログインが成功したらhome画面へ遷移
     func configureObserver() {
         NotificationCenter.default.addObserver(
             self,
             selector: #selector(loginCompleted),
             name: LoginCompletedNotification,
             object: nil
         )
       }
     @objc func loginCompleted(notification: NSNotification){
        self.presentVC(vc: R.storyboard.main.tabVC()!, animation: false)
     }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        //XLPagerのTabBarに名前を登録
        let sighUp: UIViewController =  R.storyboard.main.bSighUp()!
        let logIn: UIViewController = R.storyboard.main.bLogin()!
        return [sighUp, logIn]
    }
    //LPagerTabBarのdesign
    func PagerTabUI() {
        settings.style.buttonBarBackgroundColor = .clear
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.buttonBarItemFont = .systemFont(ofSize: 16)
        settings.style.buttonBarItemTitleColor = .black
        settings.style.selectedBarBackgroundColor = .black // 選択中の色
        settings.style.selectedBarHeight = 2  // 選択中のインジケーターの太さ
        settings.style.buttonBarLeftContentInset = 30  // ButtonBarの左端余白
        settings.style.buttonBarRightContentInset = 30
        settings.style.buttonBarMinimumLineSpacing = 30  // Button間スペース
        settings.style.buttonBarItemLeftRightMargin = 10 // Button内余白
        
        changeCurrentIndexProgressive = { oldCell, newCell, progressPercentage, changeCurrentIndex, animated in
              // 選択前後のCellをアンラップ
              guard changeCurrentIndex, let oldCell = oldCell, let newCell = newCell else { return }
              oldCell.label.textColor = .white  // 選択前のセルの色
              newCell.label.textColor = .black  // 選択後のセルの色
          }
    }
        

}
    



