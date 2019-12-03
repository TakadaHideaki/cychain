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


class DataInput: UIViewController, UINavigationControllerDelegate ,UIImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate{
    
    
    @IBOutlet weak var myName: UITextField!
    @IBOutlet weak var targetName: UITextField!
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var icon: UIButton!
    @IBOutlet weak var messageLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        myName.delegate = self
        targetName.delegate = self
        message.delegate = self
        toolBar()
        let defaultIcon = UIImage(named: "user10")
        self.icon.setImage(defaultIcon, for: .normal)   
    }
    
    

    
    @IBAction func icon(_ sender: Any) {
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
    
    
    
    @IBAction func sendData(_ sender: Any) {
        

     

        let myname = myName.text!.deleteSpace()
        let targetname = targetName.text!.deleteSpace()
        let messageText = message.text
        let imageData = icon.currentImage!.pngData()! as NSData
        
        let names_messageArray = [myname, targetname, messageText]
        var value = ["message": self.message.text!, "image": ""] as [String : Any]
        
        let ref = Database.database().reference().child("\(myname)/\(targetname)/\(USER_ID!)")
        let storageRef = STORAGE.child("\(myname)/\(targetname)/\(USER_ID!)/\("imageData")")
        
        let postCard: PostCard = self.storyboard?.instantiateViewController(withIdentifier: "postCard") as! PostCard
        
        
        let registerName = UD.array(forKey: "uniqueNmame")
        //投稿数>11で登録数オーバーアラート
        if registerName?.count != nil && registerName!.count > 10 {

            let cancel = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil)
            let sendList = UIAlertAction(title: "登録リストへ",style: UIAlertAction.Style.default,handler:{(action:UIAlertAction!) -> Void in
                let list = self.storyboard?.instantiateViewController(withIdentifier: "list") as! List
                self.navigationController?.pushViewController(list, animated: true)})
            
            cansel_Send_Alert(title: "登録数オーバー", message: "リストから登録数を減らして下さい", actions: [cancel, sendList])
        
        
            
        } else if myname.isEmpty || targetname.isEmpty {
            alert(title: "名前を入力して下さい", message: "", actiontitle: "OK")
            return


        } else if myname.count >= 13 || targetname.count >= 13 {
            alert(title: "名前は１３文字までです", message: "", actiontitle: "OK")
            return
            
        
        } else {
            // 投稿履歴有り(重複削除 → ud保存)
            if var names = UD.object(forKey: "uniqueNmame") as? [[String : String]] {
                names += [[myname:targetname]]
                let oderSet = NSOrderedSet(array: names)
                let castnames = (oderSet.array as? [[String:String]])!
                UD.set(castnames, forKey: "uniqueNmame")

            } else {
                // 初投稿(ud保存のみ)
                let names = [[myname:targetname]]
                UD.set(names, forKey: "uniqueNmame")
            }
            
            
            //写真投稿無し
            if  icon.currentImage == UIImage(named: "user10") {
                value["image"] = nil
                ref.setValue(value)
                
            } else {
                //写真投稿有り(storageに写真保存)
                let imageData = icon.currentImage!.pngData()! as NSData
                storageRef.putData(imageData as Data, metadata: nil){ (metadata, error)in
                    
                    guard let metadata = metadata else { return }
                    storageRef.downloadURL { (url, error) in
                        guard let downloadURL = url else { return }
                        let profileimage = downloadURL.absoluteString
                        
                        // Firebase保存
                        value["image"] = profileimage
                        ref.updateChildValues(value)
                    }
                }
                postCard.images = icon.currentImage
            }
            postCard.names_messageArray = names_messageArray as? [String]
            self.navigationController?.pushViewController(postCard, animated: true)
        }
        
        
            //        キーボード閉じる
        func keyboardWillHide(notification: Notification?) {
            let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double
            UIView.animate(withDuration: duration!) {
                self.view.transform = CGAffineTransform.identity
            }
        }
    }
    
    
    //textviewを６行までに制限
    let maxLength = 4
    var previousText = ""
    var lastReplaceRange: NSRange!
    var lastReplacementString = ""
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        self.previousText = myName.text!
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
        )}
    
    //     Notificationを削除
    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    //     キーボードが現れたときにviewをずらす
    @objc func keyboardWillShow(notification: Notification?) {
        let rect = (notification?.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: duration!) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -(rect?.size.height)!)
        }
    }
    //     キーボードが消えたときにviewを戻す
    @objc func keyboardWillHide(notification: Notification?) {
        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!) {
            self.view.transform = CGAffineTransform.identity
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isTouch(touches: touches, view: message) {
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
        
        let newText: String = (message.text! as NSString).replacingCharacters(in: range, with: text)
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
        myName.resignFirstResponder()
        targetName.resignFirstResponder()
        return  true
    }
    
    
    func toolBar() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        toolBar.barStyle = UIBarStyle.default
        toolBar.sizeToFit()
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(commitButtonTapped))
        toolBar.items = [spacer, commitButton]
        message.inputAccessoryView = toolBar // textViewのキーボードにツールバーを設定

    }
    @objc func commitButtonTapped() {
        self.view.endEditing(true)
    }   
}


extension DataInput: RSKImageCropViewControllerDelegate {
    //キャンセルを押した時の処理
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    //完了を押した後の処理
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        dismiss(animated: true)
        icon?.setImage(croppedImage, for: .normal)
        //        imageView.image = croppedImage
        
        //もし円形で画像を切り取りし、その画像自体を加工などで利用したい場合
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
            //このImageは円形で余白は透過です。
            let png = UIImage(data: pngData)!
            icon?.setImage(png, for: .normal)
        }
    }
}







