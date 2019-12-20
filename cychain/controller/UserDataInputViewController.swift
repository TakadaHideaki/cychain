//
//  DataInput1.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/04/28.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import RSKImageCropper
import TextFieldEffects


class UserDataInputViewController: UIViewController, UINavigationControllerDelegate ,UIImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate{
    
    
    @IBOutlet weak var myNameTextField: UITextField!
    @IBOutlet weak var targetNameTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var iconRegistButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    let defaultIconImage = UIImage(named: "user10")

    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        myNameTextField.delegate = self
        targetNameTextField.delegate = self
        messageTextView.delegate = self
        keyBoardtoolBar()
        customNavigationBar()
        
        //写真投稿ボタンの画像を設定
        self.iconRegistButton.setImage(self.defaultIconImage, for: .normal)
    }
    
    
    @IBAction func call_PhotoLibrary(_ sender: Any) {
        //iconボタン押した処理
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let pickerView = UIImagePickerController()
            pickerView.sourceType = .photoLibrary
            pickerView.delegate = self
            self.present(pickerView, animated: true)
        }
    }
    
    // 写真を選んだ後に呼ばれる処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage  // 選択した写真を取得する
        self.dismiss(animated: true)
        
        let imageCropVC = RSKImageCropViewController(image: image, cropMode: .circle)
        imageCropVC.moveAndScaleLabel.text = "切り取り範囲を選択"
        imageCropVC.cancelButton.setTitle("キャンセル", for: .normal)
        imageCropVC.chooseButton.setTitle("完了", for: .normal)
        imageCropVC.delegate = self
        present(imageCropVC, animated: true)
    }
    
    
    //データ入力後の投稿ボタン
    @IBAction func postAction(_ sender: Any) {
        
        let myname = myNameTextField.text?.deleteSpace() ?? ""
        let targetname = targetNameTextField.text?.deleteSpace() ?? ""
        let messageText = messageTextView.text ?? ""
        let iconImage = iconRegistButton.currentImage ?? self.defaultIconImage

        var registData: [String : Any] = [
            "my": myname,
            "target": targetname,
            "message": messageText,
            "image": iconImage as Any,
        ]
        
        var value: [String: Any] = ["message": messageText]
        
        let ref = Database.database().reference().child("\(myname)/\(targetname)/\(USER_ID!)")
        //↓で写真保存されてしまっているので最後の”image”は取れない？
        let storageRef = STORAGE.child("\(myname)/\(targetname)/\(USER_ID!)/\("imageData")")
        
        let ResultVC = self.storyboard?.instantiateViewController(withIdentifier: "InputResultVC") as! InputResultViewController
        
        
        func registIconImage() {
            if iconImage == self.defaultIconImage {
                registData["image"] = nil
                ref.setValue(value)

            } else {
                //写真投稿有り→ storageに写真保存
                if let imageData = iconImage?.pngData() {
                    storageRef.putData(imageData, metadata: nil){ (metadata, error)in

                        guard metadata != nil else { return }
                        storageRef.downloadURL { (url, error) in
                            guard let downloadURL = url else { return }
                            let profileimage = downloadURL.absoluteString

                            // Firebaseに写真とmessageを保存
                            value["image"] = profileimage
                            ref.updateChildValues(value)
                        }
                    }
                }
            } //nil対策は必要か？　else if image == nil || image == UIImage(named: "user10")
        }
        
        if myname.isEmpty || targetname.isEmpty {
            alert(title: "名前を入力して下さい", message: "", actiontitle: "OK")
            
            
        } else if myname.count >= 13 || targetname.count >= 13 {
            alert(title: "名前は１３文字までです", message: "", actiontitle: "OK")
            
            
        } else {
            
            //投稿履歴が有る
            if var registNames = UD.object(forKey: UdKey.keys.uniqueNmame.rawValue) as? [[String : String]]  {
                
                //投稿数>10で登録数オーバーアラート
                if registNames.count > 10 {
                    
                    let cancel = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil)
                    let sendList = UIAlertAction(title: "登録リストへ",style: UIAlertAction.Style.default,handler:{(action:UIAlertAction!) -> Void in
                        let list = self.storyboard?.instantiateViewController(withIdentifier: "list") as! InputDataListViewController
                        self.navigationController?.pushViewController(list, animated: true)})
                    cansel_Send_Alert(title: "登録数オーバー", message: "リストから登録数を減らして下さい", actions: [cancel, sendList])
                    
                    
                } else {
                    //投稿数<10　(UD.count 0-10)
                    //全く同じ名前の投稿でなければUDに名前保存
                    if !registNames.contains([myname:targetname]) {
                        registNames += [[myname:targetname]]
                        UD.set(registNames, forKey: UdKey.keys.uniqueNmame.rawValue)
                    }
                    registIconImage()
                }
                
            } else {
                //投稿値歴無し
                UD.set([[myname:targetname]], forKey: UdKey.keys.uniqueNmame.rawValue)
                registIconImage()
            }
            
            //names_messageArray == [myname, targetname, messageText]
            ResultVC.registData = registData
            self.navigationController?.pushViewController(ResultVC, animated: true)
        }
        
        // キーボード閉じる
        func keyboardWillHide(notification: Notification?) {
            let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double
            UIView.animate(withDuration: duration!) {
                self.view.transform = CGAffineTransform.identity
            }
        }
    }
    

    
    //textviewを６行までに制限
    let maxLength = 6
    var previousText = ""
    var lastReplaceRange: NSRange!
    var lastReplacementString = ""
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        self.previousText = myNameTextField.text!
        self.lastReplaceRange = range
        self.lastReplacementString = text
        return true
    }
    
    
    // Notificationを設定
    func configureObserver() {
        
        let notification = NotificationCenter.default
        notification.addObserver(
            self,
            selector: #selector(self.keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        notification.addObserver(
            self,
            selector: #selector(self.keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    // Notificationを削除
    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // キーボードが現れたときにviewをずらす
    @objc func keyboardWillShow(notification: Notification?) {
        let rect = (notification?.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: duration!) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -(rect?.size.height)!)
        }
    }
    // キーボードが消えたときにviewを戻す
    @objc func keyboardWillHide(notification: Notification?) {
        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!) {
            self.view.transform = CGAffineTransform.identity
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isTouch(touches: touches, view: messageTextView) {
            self.configureObserver()
        }
    }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        removeObserver()
        self.messageLabel.isHidden = false
    }

    
    
    func isTouch(touches: Set<UITouch>, view:UIView) -> Bool{
        for touch: AnyObject in touches {
            let t: UITouch = touch as! UITouch
            if t.view?.tag == view.tag {
                self.configureObserver()
                messageLabel.isHidden = true
                return true
            }
        }
        return false
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newText: String = (messageTextView.text! as NSString).replacingCharacters(in: range, with: text)
        return numberOfLines(orgTextView: textView, newText: newText) <= 6
    }
    
    
    func numberOfLines(orgTextView: UITextView, newText: String) -> Int {
        
        let cloneTextView = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(try! NSKeyedArchiver.archivedData(withRootObject: orgTextView, requiringSecureCoding: false)) as! UITextView
        
        cloneTextView.text = newText + " "
        
        let layoutManager = cloneTextView.layoutManager
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var numberOfLines = 0
        var index = 0
        var lineRange = NSRange()
        
        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange);
            numberOfLines = numberOfLines + 1
        }
        return numberOfLines
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        myNameTextField.resignFirstResponder()
        targetNameTextField.resignFirstResponder()
        return  true
    }
    
    
    func keyBoardtoolBar() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        toolBar.barStyle = UIBarStyle.default
        toolBar.sizeToFit()
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(commitButtonTapped))
        toolBar.items = [spacer, commitButton]
        messageTextView.inputAccessoryView = toolBar // textViewのキーボードにツールバーを設定

    }
    @objc func commitButtonTapped() {
        self.view.endEditing(true)
    }   
}


extension UserDataInputViewController: RSKImageCropViewControllerDelegate {
    //キャンセル
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        dismiss(animated: true, completion: nil)
    }

    //完了を押した後の処理
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        dismiss(animated: true)
        iconRegistButton?.setImage(croppedImage, for: .normal)
        // imageView.image = croppedImage

        //円形画像
        if controller.cropMode == .circle {
            UIGraphicsBeginImageContext(croppedImage.size)
            let layerView = UIImageView(image: croppedImage)
            layerView.frame.size = croppedImage.size
            layerView.layer.cornerRadius = layerView.frame.size.width * 0.5
            layerView.clipsToBounds = true
            let context = UIGraphicsGetCurrentContext()!
            layerView.layer.render(in: context)
            let capturedImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            let pngData = capturedImage.pngData()!
            //円形で余白透過
            let png = UIImage(data: pngData)!
            iconRegistButton?.setImage(png, for: .normal)
        }
    }
}







