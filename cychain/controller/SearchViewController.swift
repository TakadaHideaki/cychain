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
    @IBOutlet weak var mutchLabel: labele!
    @IBOutlet weak var mutchLabel2: UILabel!
    @IBOutlet weak var noPostLabel: UILabel!
    @IBOutlet weak var searchButton: Button!
    @IBOutlet weak var indicator: NVActivityIndicatorView!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var popButton: UIButton!
    
    lazy var mutchiUserData = [String: [String: Any]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialazeUI()
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
    
    
    @IBAction func searchAction(_ sender: Any) {
        
        //textfieldのnil対策をしているが,強制アンラップは避けた方がいいか？
        //(56行目で空ならアラートの処理をしている)
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
                    //dataは [UID: [message: メッセージ, profile: 投稿写真]]
                    //強制キャストの解除が上手くいかない
                    //self.mutchingUserDataじゃなくて
                    //このスコープ何の変数を作って最後にself.mutchingUserDataに代入した方がいいのか？
                    self.mutchiUserData = DataSnapshot.value as! [String: [String : Any]]

                    //もしもブロックユーザー登録があれば
                    if let blockUserID = UD.array(forKey: UDKey.keys.block.rawValue) as? [String]  {
                        blockUserID.forEach {
                            //マッチしたユーザーとブロックユーザーが一致したら
                            //ブロックユーザーをひ表示させない様にする
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

    
    @IBOutlet weak var matchbutton: UIButton!
    @IBAction func matchbutton(_ sender: Any) {
        
//        self.indicator.startAnimating()
        
        guard let myName = myNameTextField.text?.deleteSpace() else { return }
        guard let searchName = searchNameTextField.text?.deleteSpace() else { return }
        
        let resultVC = self.storyboard?.instantiateViewController(withIdentifier: "SeachResultVC") as! SeachResultViewCotroller
        let resultListVC = self.storyboard?.instantiateViewController(withIdentifier: "SeachResultListVC") as! SeachResultListViewCOntroller
        
        switch self.mutchiUserData.count {
        case 1: //マッチ１件
            resultVC.names = [myName, searchName]
            resultVC.mutchiUserData = self.mutchiUserData
            self.navigationController?.pushViewController(resultVC, animated: true)
            
        default: //マッチ複数件
            resultListVC.names = [myName, searchName]
            resultListVC.mutchingUserData = self.mutchiUserData
            self.navigationController?.pushViewController(resultListVC, animated: true)
        }
//        self.indicator.stopAnimating()
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.animationView.isHidden = false
            self.matchbutton.isHidden = false
            self.mutchLabel.isHidden = false
            self.mutchLabel2.isHidden = false
        }
    }
    
    
    private func nomutch() {
        self.indicator.stopAnimating()
        noPostLabel.isHidden = false
        popButton.isHidden = false
        matchbutton.isHidden = true
        mutchLabel.isHidden = true
        mutchLabel2.isHidden = true
        animationView.isHidden = true
    }
    
    
    private func labelHidden() {
        noPostLabel.isHidden = true
        matchbutton.isHidden = true
        mutchLabel.isHidden = true
        mutchLabel2.isHidden = true
        popButton.isHidden = true
        animationView.isHidden = true
        
    }
    



}
