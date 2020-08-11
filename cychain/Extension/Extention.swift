import UIKit
import GoogleMobileAds
import MessageUI
import RSKImageCropper
import XCGLogger
import Firebase



extension UIViewController {
    
    //viewの切り替え
    
    func presentVC(vc: UIViewController, animation: Bool) {
        self.navigationController?.pushViewController(vc, animated: animation)
    }
    
    
    func pushVC(vc: UIViewController, animation: Bool) {
        self.present(vc, animated: animation)
    }
    

    //問合せ
    func sendMail() {
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
            mail.setToRecipients(["cychaincontact@gmail.com"])
            mail.setSubject("お問い合わせ")
            mail.setMessageBody("お問い合わせ内容", isHTML: false)
            self.present(mail, animated: true, completion: nil)
            
        } else {
            sendMailErrorAlert()
        }
    }
    
 
    
    func admob() {
        
        var admobView = GADBannerView()
        admobView = GADBannerView(adSize:kGADAdSizeBanner)
        admobView.adUnitID = ADMB_ID
//        admobView.frame.origin = CGPoint(x:0, y:self.view.frame.size.height - 80 - admobView.frame.height)
        
        let safeAreaHeight = self.view.safeAreaInsets.bottom
        
        admobView.frame.origin = CGPoint(x:0, y:self.view.frame.size.height - safeAreaHeight - admobView.frame.height)
        admobView.frame.size = CGSize(width:self.view.frame.width, height:admobView.frame.height)
        admobView.rootViewController = self
        admobView.load(GADRequest())
        self.view.addSubview(admobView)
    }
    
    
    //インディケーター
    func indicator() {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.center = view.center
        indicatorView.style = .whiteLarge
        indicatorView.color = .black
        view.addSubview(indicatorView)
    }
    

    //ナビゲーションバー
    func customNavigationBar() {
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


extension UITextView {
    //textFieldのエンターは閉じるじゃ無くて改行になるから
    func keyBoardtoolBar(textView: UITextView) {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        toolBar.barStyle = .default
        toolBar.sizeToFit()
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let commitButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(commitButtonTapped))
        toolBar.items = [spacer, commitButton]
        textView.inputAccessoryView = toolBar // textViewのキーボード上部にツールバーを設定
    }
    @objc func commitButtonTapped() {
        self.resignFirstResponder()
    }
}

class DismissControllerSegue: UIStoryboardSegue {
    override func perform() {
        self.source.dismiss(animated: true, completion: nil)
    }
}


func setIconStorage(icon: UIImage, ref: StorageReference, complete: @escaping (String) -> ()) {
    
    var imageURL: String?
    
    if let imageData = icon.pngData() {
        
        ref.putData(imageData, metadata: nil) { (metadata, error) in
            
            guard metadata != nil else { return }
            
            ref.downloadURL { (url, error) in
                
                guard let downloadURL = url else { return }
                
                imageURL = downloadURL.absoluteString
                complete(imageURL ?? "")
            }
        }
    }
}



    









