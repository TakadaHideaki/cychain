//
//  FirestViewController.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/01/09.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SelectViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.XCGloger?.debug(USER_ID!)
        
        admob()
        customNavigationBar()
    }    
    @IBAction func post(_ sender: Any) {
        
        let dataInputVC = self.storyboard?.instantiateViewController(withIdentifier: "UserDataInputVC") as! UserDataInputViewController
        self.navigationController?.pushViewController(dataInputVC, animated: true)
    }
}


