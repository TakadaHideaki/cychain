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


class UserDataInputViewController: UIViewController, UINavigationControllerDelegate ,UIImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate, ScrollKeyBoard, modelDelegate {
    
    
    func did() {
        log.debug("a")
    }
    

    
    @IBOutlet weak var myNameTextField: UITextField!
    @IBOutlet weak var targetNameTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var iconRegistButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    let defaultIconImage = UIImage(named: "user10")//写真登録のアイコンイメージ
    let model = UserDataModel()

    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        
//        model = UserDataModel()
        model.delegate = self
    }
    
    func initializeUI() {
        myNameTextField.delegate = self
        targetNameTextField.delegate = self
        messageTextView.delegate = self
        messageTextView.keyBoardtoolBar(textView: messageTextView)
        customNavigationBar()
        self.iconRegistButton.setImage(self.defaultIconImage, for: .normal) //写真投稿ボタンの画像を設定
    }
    
    //アイコン登録ボタン押した処理(フォトライブラリ呼び出し)
    @IBAction func call_PhotoLibrary(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let pickerView = UIImagePickerController()
            pickerView.sourceType = .photoLibrary
            pickerView.delegate = self
            self.present(pickerView, animated: true)
        }
    }
    
    // 写真選択後
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
        

//        model.setName(name2: "aaa")
   
        

        let myname = myNameTextField.text?.deleteSpace() ?? ""
        let targetname = targetNameTextField.text?.deleteSpace() ?? ""
        let messageText = messageTextView.text ?? ""
        let iconImage = iconRegistButton.currentImage ?? self.defaultIconImage

        //入力データを格納
//        var registData: [String: Any] = [
//            "my":      myname,
//            "target":  targetname,
//            "message":  messageText,
//            "image":    iconImage as Any,
//        ]
        
        var registData: [String: Any] = [
            "my":     myNameTextField.text?.deleteSpace() ?? "",
            "target":  targetNameTextField.text?.deleteSpace() ?? "",
            "message": messageTextView.text ?? "",
            "image":   iconRegistButton.currentImage ?? self.defaultIconImage as Any,
        ]
        
        model.set(my: myNameTextField.text?.deleteSpace() ?? "",
                  target: targetNameTextField.text?.deleteSpace() ?? "",
                  message: messageTextView.text ?? "",
                  icon: iconRegistButton.currentImage ?? self.defaultIconImage!
        )
        
        
        
        

        
        
        
        
        
        
        
        
        

        var value: [String: Any] = ["message": messageText]

        let ref = Database.database().reference().child("\(myname)/\(targetname)/\(USER_ID!)")

        //最後のimageDataは無用だがこれでリリースしたので変更しない
        let storageRef = STORAGE.child("\(myname)/\(targetname)/\(USER_ID!)/\("imageData")")

        let ResultVC = self.storyboard?.instantiateViewController(withIdentifier: "InputResultVC") as! InputResultViewController

        //アイコン写真を登録しなかっ場合
        func registIconImage() {
            if iconImage == self.defaultIconImage {
                registData["image"] = nil //登録データに写真を登録しない
                ref.setValue(value) //Firebaseに登録

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
            }
        }

        //名前未入力で登録ボタンが押された時
        if myname.isEmpty || targetname.isEmpty {
            alert(title: "名前を入力して下さい", message: "", actiontitle: "OK")

            //名前の入力文字数ーオーバー
        } else if myname.count >= 13 || targetname.count >= 13 {
            alert(title: "名前は１３文字までです", message: "", actiontitle: "OK")


        } else {

            //投稿履歴が有る時
            if var registNames = UD.object(forKey: UDKey.keys.uniqueNmame.rawValue) as? [[String : String]]  {

                //投稿数>10で登録数オーバーアラート
                if registNames.count > 10 {

                    let cancel = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil)
                    let sendList = UIAlertAction(title: "登録リストへ",style: UIAlertAction.Style.default,handler:{(action:UIAlertAction!) -> Void in
                        self.switchVC(view: "list", animation: true)
                    })
                    cansel_Send_Alert(title: "登録数オーバー", message: "リストから登録数を減らして下さい", actions: [cancel, sendList])


                } else {
                    //投稿数<10　(UD.count 0-10)
                    //全く同じ名前の投稿でなければUDに名前保存
                    if !registNames.contains([myname:targetname]) {
                        registNames += [[myname:targetname]]
                        UD.set(registNames, forKey: UDKey.keys.uniqueNmame.rawValue)
                    }
                    registIconImage()
                }

            } else {
                //投稿値歴無し
                UD.set([[myname:targetname]], forKey: UDKey.keys.uniqueNmame.rawValue)
                registIconImage()
            }

            //names_messageArray == [myname, targetname, messageText]
            ResultVC.registData = registData
            self.navigationController?.pushViewController(ResultVC, animated: true)
        }
        // フォーカスは外す　＆　キーボード閉じる　&　View戻す
        messageTextView.resignFirstResponder()
        configureObserver()
    }
    
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField)  {
        messageTextView.isSelectable = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageTextView.isSelectable = true
        messageTextView.isEditable = true
        myNameTextField.resignFirstResponder()
        targetNameTextField.resignFirstResponder()
        return  true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        configureObserver()
        self.messageLabel.isHidden = true
        return  true
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

    
    //メッセージを６行に制限
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

//アイコンの写真を丸くする処理
extension UserDataInputViewController: RSKImageCropViewControllerDelegate {
    //キャンセルボタンが押されたらフォトライブラリをdissmiss
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        dismiss(animated: true, completion: nil)
    }

    //完了を押したらフォトライブラリを閉じてアイコンボタンに選択した写真をセット
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        dismiss(animated: true)
        iconRegistButton?.setImage(croppedImage, for: .normal)

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







