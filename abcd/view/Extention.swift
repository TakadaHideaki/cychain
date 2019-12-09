//
//  Items.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/10/04.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit
import GoogleMobileAds
import MessageUI
import RSKImageCropper
import XCGLogger




class Extention: UIViewController {
    
}

extension UIViewController {
    
    
    func switchVC(view: String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: view)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    
    
    func alert(title:String,message:String,actiontitle:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actiontitle, style: .default))
        self.present(alert, animated: true)
    }
    
    
    
    
    func sendAlert(title:String,message:String,vcId: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let sendButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler:{(action:UIAlertAction!) -> Void in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: vcId)
            self.navigationController?.pushViewController(vc!, animated: true)
        })
        alert.addAction(sendButton)
        self.present(alert, animated: true)
    }
    
    
    
    func cansel_Send_Alert(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        present(alert, animated: true)
    }
    
    
    
    
    func sendMail() {
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
            mail.setToRecipients(["cychaincontact@gmail.com"])
            mail.setSubject("お問い合わせ")
            mail.setMessageBody("お問い合わせ内容", isHTML: false)
            self.present(mail, animated: true, completion: nil)
            
        } else {
            alert(title: "No Mail Accounts", message: "Please set up mail accounts", actiontitle: "OK")
        }
    }
    
 
    
    func admob() {

        var admobView = GADBannerView()
        admobView = GADBannerView(adSize:kGADAdSizeBanner)
        admobView.adUnitID = ADMB_ID
        let tabBarHeight = self.tabBarController?.tabBar.frame.size.height
        admobView.frame.origin = CGPoint(x:0, y:self.view.frame.size.height - tabBarHeight! - admobView.frame.height)
        admobView.frame.size = CGSize(width:self.view.frame.width, height:admobView.frame.height)
        
        admobView.rootViewController = self
        admobView.load(GADRequest())
        self.view.addSubview(admobView)
        print()
    }
    
    
    
    func indicator() {
        
        let indicatorView = UIActivityIndicatorView()
        indicatorView.center = view.center
        indicatorView.style = .whiteLarge
        indicatorView.color = .black
        view.addSubview(indicatorView)
    }
    
    func customNavigationBar() {
//
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let bar = self.navigationController?.navigationBar
        bar?.tintColor = .darkGray
        bar?.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(rawValue: 0.1)),
                                    .kern: Float(2.0)]
        bar?.setBackgroundImage(UIImage(), for: .default)
        bar?.shadowImage = UIImage()
    }
    
}



extension UITextField {
    
    func underLine(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}


extension String {
     
    func deleteSpace() -> String {
        return replacingOccurrences(of: " ", with: "")
    }
}



struct UdKey {
        enum keys: String {
        case uniqueNmame
        case block
    }
}








