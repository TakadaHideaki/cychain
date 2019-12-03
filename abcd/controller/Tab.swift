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

class Tab: ButtonBarPagerTabStripViewController {

    @IBOutlet weak var label: LTMorphingLabel!
    

    override func viewDidLoad() {
        
        UInavigationBar()
        
        settings.style.buttonBarBackgroundColor = .clear
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.buttonBarItemFont = .systemFont(ofSize: 16)
        settings.style.buttonBarItemTitleColor = .black
        settings.style.selectedBarBackgroundColor = .black // 選択中のButtonBarインジケーターの色
        settings.style.selectedBarHeight = 2  // 選択中のButtonBarインジケーターの太さ
        settings.style.buttonBarLeftContentInset = 30  // ButtonBarの左端の余白
        settings.style.buttonBarRightContentInset = 30
        settings.style.buttonBarMinimumLineSpacing = 30  // Button間のスペース
        settings.style.buttonBarItemLeftRightMargin = 10 // Button内の余白
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
    }
    
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let sighUp = storyBoard.instantiateViewController(withIdentifier: "bSighUp")
        let logIn = storyBoard.instantiateViewController(withIdentifier: "bLogin")
        
        return [sighUp, logIn]
    }
    

}
    



