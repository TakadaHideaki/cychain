//
//  FirestViewController.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/01/09.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit

class first: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func post(_ sender: Any) {
        
//        self.performSegue(withIdentifier: "post", sender: nil)
    }
    
    
    
    @IBAction func seach(_ sender: Any) {
//        self.performSegue(withIdentifier: "search", sender: nil)

    }
    

    @IBAction func a(_ sender: Any) {
        
        let postData: dataInput = self.storyboard?.instantiateViewController(withIdentifier: "postData") as! dataInput
        
                self.navigationController?.pushViewController(postData, animated: true)
    }
    
    
    
    
    
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
