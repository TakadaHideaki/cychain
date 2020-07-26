import UIKit
import FirebaseAuth
import LTMorphingLabel
import XLPagerTabStrip

class InitialViewController: ButtonBarPagerTabStripViewController  {
  
    

    @IBOutlet weak var label: LTMorphingLabel!
    
    var labelText = "c y c h a i n"
    var attributedText: NSMutableAttributedString?

    override func viewDidLoad() {
        customNavigationBar() //navigationBarデザイン(※記述場所viewDidLoadの前)
        PagerTabUI()        //ページタブバーデザイン(※記述場所viewDidLoadの前)
        
        super.viewDidLoad()
        initializeUI()
        LoggedIn()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
//        confirmInitialLaunch()
        configureObserver()
    }
    
    
    func initializeUI() {
        label.text = labelText
        self.navigationItem.hidesBackButton = true
    }
    
    
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
    
    // 初めてのログインならonboardingを表示
    func confirmInitialLaunch() {
        if UD.bool(forKey: Name.KeyName.flag.rawValue) {
            UD.set(false, forKey: Name.KeyName.flag.rawValue)
            self.pushVC(vc: R.storyboard.main.onboardingVC()!, animation: false)
        }
    }
    
    // ログイン中の場合はログイン画面をスキップ
    func LoggedIn() {
        if Auth.auth().currentUser != nil {
            self.presentVC(vc: R.storyboard.main.tabVC()!, animation: true)
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
        self.presentVC(vc: R.storyboard.main.tabVC()!, animation: true)
     }
    
    
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        //タブバーの登録
        let sighUp: UIViewController =  R.storyboard.main.bSighUp()!
        let logIn: UIViewController = R.storyboard.main.bLogin()!
        return [sighUp, logIn]
    }
        

}
    



