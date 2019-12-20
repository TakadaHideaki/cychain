//
//  tab.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/08/30.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit
import LTMorphingLabel
import XLPagerTabStrip

class InitialViewController: ButtonBarPagerTabStripViewController {

    @IBOutlet weak var label: LTMorphingLabel!
    

    override func viewDidLoad() {
        
        customNavigationBar()
        
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
        // スワイプやButtonBarItemタップ等でページを切り替えた時の動作
        changeCurrentIndexProgressive = { oldCell, newCell, progressPercentage, changeCurrentIndex, animated in
            // 変更されたか、選択前後のCellをアンラップ
            guard changeCurrentIndex, let oldCell = oldCell, let newCell = newCell else { return }
            oldCell.label.textColor = .white  // 選択前のセル
            newCell.label.textColor = .black  // 選択後のセル
        }
        super.viewDidLoad()
        
        label.text = "c y c h a i n"
        self.navigationItem.hidesBackButton = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        // NotificationCenterに監視対象として登録
        NotificationCenter.default.addObserver(self, selector: #selector(loginCompleted), name: LoginCompletedNotification, object: nil)
    }
    
    @objc func loginCompleted(notification: NSNotification){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabVC = storyboard.instantiateViewController(withIdentifier: "tabVC")
        tabVC.modalPresentationStyle = .fullScreen
        self.present(tabVC, animated: true)
    }
    
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let sighUp = storyBoard.instantiateViewController(withIdentifier: "bSighUp")
        let logIn = storyBoard.instantiateViewController(withIdentifier: "bLogin")
        return [sighUp, logIn]
    }
        

}
    



