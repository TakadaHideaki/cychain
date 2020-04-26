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

class EditViewController: UIViewController, UINavigationControllerDelegate,UITextFieldDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UIScrollViewDelegate, ScrollKeyBoard {
    
    
    @IBOutlet weak var myNameTextField: UITextField!
    @IBOutlet weak var targetNameTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var dataSendButton: UIButton!
    @IBOutlet weak var iconRegistButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    var editUserData: [String: Any]?
    var iconImage: UIImage?
    var iconSet: IconSet?


    override func viewDidLoad() {
        super.viewDidLoad()
        initialazeUI()
        userDataSet()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
         super.viewDidDisappear(animated)
         // TextViewフォーカス外す　＆キーボード閉じる＋View戻す
         messageTextView.resignFirstResponder()
         configureObserver()
     }
    
    func initialazeUI() {
        myNameTextField.delegate = self
        targetNameTextField.delegate = self
        messageTextView.delegate = self
        tabBarController?.tabBar.isHidden = true
        messageTextView.keyBoardtoolBar(textView: messageTextView)
        customNavigationBar()
        iconSet = IconSet()
        iconSet?.delegate = self as? (UIViewController & IconSetDelegate)
    }
        
        //UserDataを表示
    func userDataSet() {
        
        guard let userData = EditData.sharedInstance.SingletonUserData else { return }
        
        editUserData = userData
        
        guard let myName = userData["my"] as? String,
            let targetName = userData["target"] as? String
            else { return }
        
        myNameTextField.text = myName
        targetNameTextField.text = targetName

        
        if let message = userData["message"] as? String {
            if message != "" {
                messageLabel.isHidden = true
                messageTextView.text = message
            } else {
                messageLabel.isHidden = false
            }
        } else {
            messageLabel.isHidden = false
        }
        
        
        if let imageUrl = userData["image"] {
            let url = URL(string: imageUrl as! String)
            // image変換
            do {
                let imageData = try Data(contentsOf: url!)
                let image = UIImage(data:imageData as Data)
                iconRegistButton.setImage(image, for: .normal)
                iconImage = image
                editUserData?["image"] = image
            } catch {
                log.debug("error")
            }
        } else {
            iconRegistButton.setImage(UIImage(named: "user10"), for: .normal)
        }
    }
    
    
    @IBAction func iconButtonTapped(_ sender: Any) {
        iconSet?.callPhotoLibraly()

        
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
//            let pickerView = UIImagePickerController()
//            pickerView.sourceType = .photoLibrary
//            pickerView.delegate = self
//            self.present(pickerView, animated: true)
//        }
    }
    
    
    // 写真を選んだ後に呼ばれる処理
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        let image = info[.originalImage] as! UIImage // 選択した写真を取得する
//        self.dismiss(animated: true)
//
//        let imageCropVC = RSKImageCropViewController(image: image, cropMode: .circle)
//        imageCropVC.moveAndScaleLabel.text = "切り取り範囲を選択"
//        imageCropVC.cancelButton.setTitle("キャンセル", for: .normal)
//        imageCropVC.chooseButton.setTitle("完了", for: .normal)
//        imageCropVC.delegate = self
//        present(imageCropVC, animated: true)
//    }
    
    
    @IBAction func senderData(_ sender: Any) {
        
//        guard let data = editUserData,
//            let my = data["my"] as? String ,
//            let target = data["target"] as? String
//            else { return }
   
        
        editUserData!["message"] = messageTextView.text ?? ""

        editUserData?["image"]  = iconRegistButton.currentImage ?? UIImage(named: "user10")
        
        let userDataModel = UserDataModel.sharead
        userDataModel.setData(userData: editUserData!)
        
        userDataModel.setUserDfault()
        userDataModel.setFirebase()
        
        switchVC(view: "InputResultVC", animation: true)

        
//
//
//        var message_image: [String: Any] = ["message": editUserData!["message"] as Any]
//        let ref = Database.database().reference().child("\(my)/\(target)/\(USER_ID!)")
//        let storageRef = STORAGE.child("\(my)/\(target)/\(USER_ID!)/\("imageData")")
//        let inputResultVC = self.storyboard?.instantiateViewController(withIdentifier: "InputResultVC") as! InputResultViewController

//        //アイコンがデフォルトのまま
//        if  iconImage == UIImage(named: "user10") {
//            ref.setValue(message_image)
//
//        } else {
//            if let imageData = iconImage?.pngData() {
//                //  FireStorage 画像更新
//                storageRef.putData(imageData, metadata: nil){ (metadata, error)in
//
//                    guard metadata != nil else { return }
//                    storageRef.downloadURL { (url, error) in
//                        guard let downloadURL = url else { return }
//                        let profileimage = downloadURL.absoluteString
//
//                        message_image["image"] = profileimage
//                    }
//                }
//                ref.updateChildValues(message_image)
//            }
//        }
       //postCardViewにデータを送って画面遷移
//        inputResultVC.registData = editUserData
//        self.navigationController?.pushViewController(inputResultVC, animated: true)

        // キーボード閉じる
//        func keyboardWillHide(notification: Notification?) {
//            let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double
//            UIView.animate(withDuration: duration!) {
//                self.view.transform = CGAffineTransform.identity
//            }
//        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        configureObserver()
        messageLabel.isHidden = true
        return  true
    }

    
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
    
    func textViewDidChange(_ textView: UITextView) {
        if myNameTextField.markedTextRange != nil {
            return
        }
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

extension EditViewController: IconSetDelegate {

    func buttonSetDidCropImage(image: UIImage) {
        iconRegistButton?.setImage(image, for: .normal)
    }
}




//extension EditViewController: RSKImageCropViewControllerDelegate {
//    //キャンセルを押した時の処理
//    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
//        dismiss(animated: true, completion: nil)
//    }
//    //完了を押した後の処理
//    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
//        dismiss(animated: true)
//        iconRegistButton?.setImage(croppedImage, for: .normal)
//        //        imageView.image = croppedImage
//        //もし円形で画像を切り取りし、その画像自体を加工などで利用したい場合
//        if controller.cropMode == .circle {
//            UIGraphicsBeginImageContext(croppedImage.size)
//            let layerView = UIImageView(image: croppedImage)
//            layerView.frame.size = croppedImage.size
//            layerView.layer.cornerRadius = layerView.frame.size.width * 0.5
//            layerView.clipsToBounds = true
//            let context = UIGraphicsGetCurrentContext()!
//            layerView.layer.render(in: context)
//            let capturedImage = UIGraphicsGetImageFromCurrentImageContext()!
//            UIGraphicsEndImageContext()
//            let pngData = capturedImage.pngData()!
//            //このImageは円形で余白は透過です。
//            let png = UIImage(data: pngData)!
//            iconRegistButton?.setImage(png, for: .normal)
//        }
//    }
//}
