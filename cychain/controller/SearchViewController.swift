//
//  serachViewController.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/01/11.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import AudioToolbox
import NVActivityIndicatorView
import GoogleMobileAds
import Lottie




class SearchViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var myNameTextField: UITextField!
    @IBOutlet var searchNameTextField: UITextField!
    @IBOutlet weak var noPostLabel: UILabel!
    @IBOutlet weak var searchButton: Button!
    @IBOutlet weak var indicator: NVActivityIndicatorView!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var popButton: UIButton!
    
    
    lazy var mutchiUserData = [String: [String: Any]]()
    var muchPopUpVC: MuchPopUpVC?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        initialazeUI()

        muchPopUpVC = self.storyboard?.instantiateViewController(withIdentifier: "MuchPopUpVC") as? MuchPopUpVC
    }
    
    func initialazeUI() {
        myNameTextField.delegate = self
        searchNameTextField.delegate = self
        indicator()
        labelHidden()
        customNavigationBar()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        myNameTextField.text = ""
        searchNameTextField.text = ""
        labelHidden()
    }
    
    
    override func viewWillLayoutSubviews() {
        _ = self.initViewLayout
    }
    lazy var initViewLayout : Void = {
        admob()
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let presented = self.presentedViewController else { return }
            if type(of: presented) == MuchPopUpVC.self {
                if muchPopUpVC?.backFlag == true {
                    muchPopUpVC?.backFlag = false

                    if self.mutchiUserData.count == 1 {
                        switchVC(view: "SeachResultVC", animation: false)
                    } else {
                        switchVC(view: "SeachResultListVC", animation: false)
                    }
                }
            }
        }
    
    
    
    
    @IBAction func searchAction(_ sender: Any) {
        

        let myName = myNameTextField.text?.deleteSpace() ?? ""
        let searchName = searchNameTextField.text?.deleteSpace() ?? ""

        self.view.endEditing(true)

        if myName.isEmpty || searchName.isEmpty {
            self.alert(title: "名前を入力して下さい", message: "", actiontitle: "OK")
            return

        } else {

            indicator.startAnimating()

            let ref = Database.database().reference().child("\(myName)/\(searchName)/")
            ref.observeSingleEvent(of: .value, with: { (DataSnapshot) in
                //マッチ無し
                if DataSnapshot.value is NSNull {
                    self.nomutch()//マッチ無しラベルを表示

                } else {
                    //マッチ有り
                    //data == [UID: [message: メッセージ, profile: 投稿写真]]
                    self.mutchiUserData = DataSnapshot.value as! [String: [String : Any]]

                    //ブロックユーザー登録があったま場合
                    if let blockUserID = UD.array(forKey: UDKey.keys.block.rawValue) as? [String]  {
                        blockUserID.forEach {
                            //マッチしたユーザーとブロックユーザーが一致したら
                            //ブロックユーザーを表示させない処理
                            if self.mutchiUserData.keys.contains($0) {
                                self.mutchiUserData[$0] = nil // [UID　(←コレがblockなら削除): [message: メッセージ, profile: 投稿写真]]
                            }
                        }
                    }
                    if self.mutchiUserData.isEmpty {
                        self.nomutch() //ブロックアカウント削除後マッチ無し
                    } else {
                        self.mutch() //ブロックアカウント削除後マッチ有り
                    }
                }
            })
        }
    }

    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        myNameTextField.resignFirstResponder()
        searchNameTextField.resignFirstResponder()
        return  true
    }
    
    
    private func mutch() {
        self.indicator.stopAnimating()
        animationView.isHidden = false
        animationView.play()
        AudioServicesPlaySystemSound(1003)
        AudioServicesDisposeSystemSoundID(1003)
        noPostLabel.isHidden = true
        popButton.isHidden = true
        
        guard let myName = myNameTextField.text?.deleteSpace(),
            let searchName = searchNameTextField.text?.deleteSpace()
            else { return }
        
        let singleton = MatchData.sharedInstance
        singleton.SingletonUserData = self.mutchiUserData
        singleton.SingletonNames = [myName, searchName]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if let muchPopUpVC = self.muchPopUpVC {
                self.present(muchPopUpVC, animated: false)
            }
        }
    }
    
    
    private func nomutch() {
        self.indicator.stopAnimating()
        noPostLabel.isHidden = false
        popButton.isHidden = false
        animationView.isHidden = true
    }
    
    private func labelHidden() {
        noPostLabel.isHidden = true
        popButton.isHidden = true
        animationView.isHidden = true
    }
    

}
