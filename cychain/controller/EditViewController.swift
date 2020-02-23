//
//  edit2.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/05/01.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import RSKImageCropper

class EditViewController: UIViewController, UINavigationControllerDelegate,UITextFieldDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UIScrollViewDelegate {
    
    
    
    @IBOutlet weak var myNameTextField: UITextField!
    @IBOutlet weak var targetNameTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var dataSendButton: UIButton!
    @IBOutlet weak var iconRegistButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    //var data: [String: String]? だと上手くいかなかった
    var userData: [String:String]!
    var iconImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        initialazeUI()
    }
    
    func initialazeUI() {
        myNameTextField.delegate = self
        targetNameTextField.delegate = self
        messageTextView.delegate = self
        tabBarController?.tabBar.isHidden = true
        addKeyBoardtoolBar()
        customNavigationBar()
        
        
        myNameTextField.text = userData["my"]
        targetNameTextField.text = userData["target"]
        if userData["message"] != "" {
            messageLabel.isHidden = true
            messageTextView.text = userData["message"]
        } else {
            messageLabel.isHidden = false
        }
        let setImage = iconImage ?? UIImage(named: "user10")
        iconRegistButton.setImage(setImage, for: .normal)
    }
    
    
    @IBAction func call_photoLibrary(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let pickerView = UIImagePickerController()
            pickerView.sourceType = .photoLibrary
            pickerView.delegate = self
            self.present(pickerView, animated: true)
        }
    }
    // 写真を選んだ後に呼ばれる処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        let image = info[.originalImage] as! UIImage // 選択した写真を取得する
        self.dismiss(animated: true)
        
        let imageCropVC = RSKImageCropViewController(image: image, cropMode: .circle)
        imageCropVC.moveAndScaleLabel.text = "切り取り範囲を選択"
        imageCropVC.cancelButton.setTitle("キャンセル", for: .normal)
        imageCropVC.chooseButton.setTitle("完了", for: .normal)
        imageCropVC.delegate = self
        present(imageCropVC, animated: true)
    }
    
    
    @IBAction func senderData(_ sender: Any) {
                
        let myName = myNameTextField.text ?? ""
        let targetName = targetNameTextField.text ?? ""
        self.userData["message"] = messageTextView.text ?? ""
        iconImage = iconRegistButton.currentImage ?? UIImage(named: "user10")
        var value: [String: Any] = ["message": userData["message"] as Any]
        
        
        let ref = Database.database().reference().child("\(myName)/\(targetName)/\(USER_ID!)")
        let storageRef = STORAGE.child("\(myName))/\(targetName))/\(USER_ID!)/\("imageData")")        
        
        let inputResultVC = self.storyboard?.instantiateViewController(withIdentifier: "InputResultViewController") as! InputResultViewController
        
        //アイコンがデフォルトのまま
        if  iconImage == UIImage(named: "user10") {
            ref.setValue(value)
        
        } else {
            if let imageData = iconImage?.pngData() {
                //  FireStorage Uplode(登録画像）
                storageRef.putData(imageData, metadata: nil){ (metadata, error)in
                    
                    guard metadata != nil else { return }
                    storageRef.downloadURL { (url, error) in
                        guard let downloadURL = url else { return }
                        let profileimage = downloadURL.absoluteString
                        
                        value["image"] = profileimage
                    }
                }
                ref.updateChildValues(value)
            
            }
        }
        //postCardViewにデータを送って画面遷移
            inputResultVC.registData = userData
            self.navigationController?.pushViewController(inputResultVC, animated: true)

        
        //        キーボード閉じる
        func keyboardWillHide(notification: Notification?) {
            let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double
            UIView.animate(withDuration: duration!) {
                self.view.transform = CGAffineTransform.identity
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        myNameTextField.resignFirstResponder()
        targetNameTextField.resignFirstResponder()
        return  true
    }
    
    
    func addKeyBoardtoolBar() {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        toolBar.barStyle = UIBarStyle.default
        toolBar.sizeToFit()
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(commitButtonTapped))
        toolBar.items = [spacer, commitButton]
        messageTextView.inputAccessoryView = toolBar
    }
    @objc func commitButtonTapped() {
        self.view.endEditing(true)
    }
    
    
    
    let maxLength = 4
    var previousText = ""
    var lastReplaceRange: NSRange!
    var lastReplacementString = ""
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        self.previousText = myNameTextField.text!
        self.lastReplaceRange = range
        self.lastReplacementString = text
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if myNameTextField.markedTextRange != nil {
            return
        }
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
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func keyboardWillShow(notification: Notification?) {
        let rect = (notification?.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: duration!) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -(rect?.size.height)!)
        }
    }
    
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
        messageLabel.isHidden = false
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
}





extension EditViewController: RSKImageCropViewControllerDelegate {
    //キャンセルを押した時の処理
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        dismiss(animated: true, completion: nil)
    }
    //完了を押した後の処理
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        dismiss(animated: true)
        iconRegistButton?.setImage(croppedImage, for: .normal)
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
            iconRegistButton?.setImage(png, for: .normal)
        }
    }
}
