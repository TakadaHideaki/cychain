//
//  FirestViewController.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/01/09.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit
import GoogleMobileAds

class FirstView: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(USER_ID!)
        admob()
        UInavigationBar()
    }    
    @IBAction func post(_ sender: Any) {
        
        let dataInput = self.storyboard?.instantiateViewController(withIdentifier: "DataInput1") as! DataInput
        self.navigationController?.pushViewController(dataInput, animated: true)
    }
}


