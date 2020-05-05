//
//  tab.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/08/30.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit
import FirebaseAuth
import LTMorphingLabel
import XLPagerTabStrip

class InitialViewController: ButtonBarPagerTabStripViewController  {
  
    

    @IBOutlet weak var label: LTMorphingLabel!
    

    override func viewDidLoad() {
        customNavigationBar() //ナビゲーションバーデザイン
        PagerTabUI() //ページタブバーデザイン
        super.viewDidLoad()
        initializeUI()
        LoggedIn()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        configureObserver()
    }
    
    
    func initializeUI() {
        label.text = "c y c h a i n"
        self.navigationItem.hidesBackButton = true
    }
    
    
    func PagerTabUI() {
        var style = settings.style
        style.buttonBarBackgroundColor = .clear
        style.buttonBarItemBackgroundColor = .clear
        style.buttonBarItemFont = .systemFont(ofSize: 16)
        style.buttonBarItemTitleColor = .black
        style.selectedBarBackgroundColor = .black // 選択中の色
        style.selectedBarHeight = 2  // 選択中のインジケーターの太さ
        style.buttonBarLeftContentInset = 30  // ButtonBarの左端余白
        style.buttonBarRightContentInset = 30
        style.buttonBarMinimumLineSpacing = 30  // Button間スペース
        style.buttonBarItemLeftRightMargin = 10 // Button内余白
        
        changeCurrentIndexProgressive = { oldCell, newCell, progressPercentage, changeCurrentIndex, animated in
              // 変更されたか、選択前後のCellをアンラップ
              guard changeCurrentIndex, let oldCell = oldCell, let newCell = newCell else { return }
              oldCell.label.textColor = .white  // 選択前のセル
              newCell.label.textColor = .black  // 選択後のセル
          }
    }
    
    
    func LoggedIn() {
        //ユーザーがログイン中なら画面スキップ
        //モーダルで本体に画面遷移
        if Auth.auth().currentUser != nil {
            log.debug("logging in")
            self.presentVC(view: "tabVC", animation: true)
        }
    }
    
    // NotificationCenterに監視対象として登録
     func configureObserver() {
         NotificationCenter.default.addObserver(
             self,
             selector: #selector(loginCompleted),
             name: LoginCompletedNotification,
             object: nil
         )
       }

     @objc func loginCompleted(notification: NSNotification){
        self.presentVC(view: "tabVC", animation: true)
     }
    
    
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        //タブバーの登録
        let sighUp = storyBoard.instantiateViewController(withIdentifier: "bSighUp")
        let logIn = storyBoard.instantiateViewController(withIdentifier: "bLogin")
        return [sighUp, logIn]
    }
        

}
    



