//
//  MuchPopUpVC.swift
//  cychain
//
//  Created by takadahideaki007 on 2020/03/21.
//  Copyright © 2020 高田英明. All rights reserved.
//

import UIKit
import Lottie

class MuchPopUpVC: UIViewController {
    
    var backFlag: Bool = false    
    
    @IBOutlet weak var animationView: AnimationView!
    
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        animationView.loopMode = .loop
        animationView.play()
    }
    
    
    @IBAction func dismissButton(_ sender: Any) {
        animationView.stop()
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func nextView(_ sender: Any) {
        animationView.stop()
        backFlag = true
        self.dismiss(animated: false)
    }
    
}
