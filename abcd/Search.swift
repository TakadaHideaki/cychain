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


class Search: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var myNameTextField: UITextField!
    @IBOutlet var searchNameTextField: UITextField!
    @IBOutlet weak var label: labele!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var noPostLabel: UILabel!
    @IBOutlet weak var searchButton: customButton!
    @IBOutlet weak var indicator: NVActivityIndicatorView!
    
  
    var accounts: [String] = []
    var nonBlockAccounts: [String] = []
    var nonBlockValues = [[String: Any]]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myNameTextField.delegate = self
        searchNameTextField.delegate = self
        admob()
        indicator()
        labelHidden()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        myNameTextField.text = ""
        searchNameTextField.text = ""
        labelHidden()
    }
    
    
    @IBAction func searchButton(_ sender: Any) {
        
        let myName = myNameTextField.text!.deleteSpace()
        let searchName = searchNameTextField.text!.deleteSpace()
        print(searchName)
        
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
                    self.nomutch()
                
                } else {
                    
                    var data = DataSnapshot.value as! [String: [String : Any]]
                    self.accounts = [String](data.keys)
                    self.nonBlockValues = [[String: Any]](data.values)
 
                    if let blockAccount = UD.array(forKey: "block") as? [String]  {
                        // マッチ有り、ブロックアアカウント削除
                        self.accounts = self.accounts.filter { !blockAccount.contains($0) }
                        switch self.accounts.count {
                        case 0:   //ブロックアカウント削除後マッチ無し
                            self.nomutch()
                        default : //ブロックアカウント削除後マッチ有り
                            blockAccount.forEach {
                                data.removeValue(forKey: $0)
                            }
                            self.nonBlockValues = [[String: Any]](data.values)
                            self.mutch()
                        }
                    } else {
                        //マッチ有りブロック無し
                        self.mutch()
                    }
                }
            })
        }
    }

    
    @IBOutlet weak var matchbutton: UIButton!
    @IBAction func matchbutton(_ sender: Any) {
        
        self.indicator.startAnimating()
        
        let myName = myNameTextField.text!.deleteSpace()
        let searchName = searchNameTextField.text!.deleteSpace()

        let result: Result = self.storyboard?.instantiateViewController(withIdentifier: "result") as! Result
        let MatchResult2: ManyResult = self.storyboard?.instantiateViewController(withIdentifier: "result2") as! ManyResult


        func sendResult() {
            self.navigationController?.pushViewController(result, animated: true)
        }

        func sendResult2() {
             self.navigationController?.pushViewController(MatchResult2, animated: true)
        }
        
            switch self.accounts.count {
            case 1: //マッチ１件（ブロック削除済み）
                result.names = [myName, searchName]
                result.account = self.accounts[0]
                result.value = self.nonBlockValues[0]
                sendResult()

            default: //マッチ複数件（ブロック削除済み）
                MatchResult2.names = [myName, searchName]
                MatchResult2.account = self.accounts
                MatchResult2.value = self.nonBlockValues
                sendResult2()
            }
        self.indicator.stopAnimating()
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        myNameTextField.resignFirstResponder()
        searchNameTextField.resignFirstResponder()
        return  true
    }
    
    
    private func mutch() {
        self.indicator.stopAnimating()
        AudioServicesPlaySystemSound(1003);
        AudioServicesDisposeSystemSoundID(1003);
        self.matchbutton.isHidden = false
        self.label.isHidden = false
        self.label2.isHidden = false
        self.noPostLabel.isHidden = true
    }
    
    
    private func nomutch() {
        self.indicator.stopAnimating()
        self.noPostLabel.isHidden = false
        self.matchbutton.isHidden = true
        self.label.isHidden = true
        self.label2.isHidden = true
    }
    
    
    private func labelHidden() {
        matchbutton.isHidden = true
        label.isHidden = true
        label2.isHidden = true
        noPostLabel.isHidden = true
    }
    



}
