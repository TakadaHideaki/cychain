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


//class UserDataInputViewController: UIViewController, UINavigationControllerDelegate ,UIImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate, ScrollKeyBoard {
    class UserDataInputViewController: UIViewController, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate, ScrollKeyBoard {
    
    
    @IBOutlet weak var myNameTextField: UITextField!
    @IBOutlet weak var targetNameTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var iconRegistButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    var buttonSet: ButtonSet?
    
    
    let defaultIcon = UIImage(named: "user10")//写真登録のアイコンイメージ
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // TextViewフォーカス外す　＆キーボード閉じる＋View戻す
        messageTextView.resignFirstResponder()
        configureObserver()
    }
    
    func initializeUI() {
        myNameTextField.delegate = self
        targetNameTextField.delegate = self
        messageTextView.delegate = self
        messageTextView.keyBoardtoolBar(textView: messageTextView)
        customNavigationBar()
        self.iconRegistButton.setImage(self.defaultIcon, for: .normal) //写真投稿ボタンの画像を設定
        buttonSet = ButtonSet()
        buttonSet?.delegate = self as? (UIViewController & ButtonSetDelegate)
        
    }
    
    //アイコン登録ボタン押した処理(フォトライブラリ呼び出し)
    @IBAction func call_PhotoLibrary(_ sender: Any) {
        buttonSet?.photoLibraly()
        }
    
    // 写真選択後
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let image = info[.originalImage] as! UIImage  // 選択した写真を取得する
//        self.dismiss(animated: true)
//
//        let imageCropVC = RSKImageCropViewController(image: image, cropMode: .circle)
//        imageCropVC.moveAndScaleLabel.text = "切り取り範囲を選択"
//        imageCropVC.cancelButton.setTitle("キャンセル", for: .normal)
//        imageCropVC.chooseButton.setTitle("完了", for: .normal)
//        imageCropVC.delegate = self
//        present(imageCropVC, animated: true)
//    }
     
    
    //データ入力後の投稿ボタン
    @IBAction func postAction(_ sender: Any) {
        
        guard let myname = myNameTextField.text?.deleteSpace(),
            let targetname = targetNameTextField.text?.deleteSpace(),
            let iconImage = iconRegistButton.currentImage
            else { return }
        let messageText = messageTextView.text ?? ""
        
        //入力データを格納
        let inputData: [String: Any] = [
            "my": myname,
            "target": targetname,
            "message": messageText,
            "image": iconImage as Any,
        ]
        
        let singleton = UserDataModelSingleton.sharead
        singleton.setData(userData: inputData)
        

        //名前未入力アラート
        if myname.isEmpty || targetname.isEmpty {
            noNameAlert()
        }
        //名前文字数オーバーアラート
        if myname.count >= 13 || targetname.count >= 13 {
            overCharacterAlert()
        }
        //投稿履歴有り
        if let UDData = UD.object(forKey: UDKey.keys.uniqueNmame.rawValue) as? [[String : String]]  {

            switch UDData.count {
            case 0 ... 10:
                singleton.setUserDfault(my:myname, target: targetname)
                singleton.setFirebase(userData: inputData)
            default: RegistationOverAlert() //登録数オーバーアラート
            }
        } else {
            //投稿値歴無し
            singleton.setUserDfault(my:myname, target: targetname)
            singleton.setFirebase(userData: inputData)
        }

        switchVC(view: "InputResultVC", animation: true)
    }
    
    
    func noNameAlert() {
        alert(title: "名前を入力して下さい", message: "", actiontitle: "OK")
    }
    
    func overCharacterAlert() {
        alert(title: "名前は１３文字までです", message: "", actiontitle: "OK")
    }
    
    func RegistationOverAlert(){
        let cancel = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil)
        let sendList = UIAlertAction(title: "登録リストへ",style: UIAlertAction.Style.default,handler:{(action:UIAlertAction!) -> Void in
            self.switchVC(view: "list", animation: true)
        })
        cansel_Send_Alert(title: "登録数オーバー", message: "リストから登録数を減らして下さい", actions: [cancel, sendList])
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
        return numberOfLines(orgTextView: textView, newText: newText) <= maxLength
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
//extension UserDataInputViewController: RSKImageCropViewControllerDelegate {
//    //キャンセルボタンが押されたらフォトライブラリをdissmiss
//    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
//        dismiss(animated: true, completion: nil)
//    }
//
//    //完了を押したらフォトライブラリを閉じてアイコンボタンに選択した写真をセット
//    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
//
//        dismiss(animated: true)
//
//        iconRegistButton?.setImage(croppedImage, for: .normal)
//
//        //円形画像
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
//            //円形で余白透過
//            let png = UIImage(data: pngData)!
//            iconRegistButton?.setImage(png, for: .normal)
//        }
//    }
//}







//extension UserDataInputViewController: UIImagePickerControllerDelegate {
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        log.debug("imagePickerController")
//        self.dismiss(animated: true)
//
//        buttonSet = ButtonSet()
//        buttonSet?.delegate = self
//        buttonSet?.present(image: info[.originalImage] as! UIImage)
//    }
//}
//
extension UserDataInputViewController: ButtonSetDelegate {

    func buttonSetDidCropImage(image: UIImage) {
        iconRegistButton?.setImage(image, for: .normal)
    }
}



    
//    func a(b: UIViewController) {
//                self.present(b, animated: true)
//
//    }
    






