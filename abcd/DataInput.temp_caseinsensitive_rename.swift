//
//  postData.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/04/01.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import RSKImageCropper

class DataInput: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate {


    @IBOutlet weak var tableView: UITableView!
    var ref:DatabaseReference!
    var names = [[String:String]]()
    var imageData: NSData!




    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
//        var rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search, target: self, action: "searchButtonTapped")
//        // add the button to navigationBar
//        self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)
    }

    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        switch indexPath.row {
        case 0:
            let iconcell = tableView.dequeueReusableCell(withIdentifier: "iconcell", for: indexPath)
            let button = iconcell.contentView.viewWithTag(3) as? UIButton
            button?.setBackgroundImage(UIImage(named: "hito3"), for: .normal)
            return iconcell
        
        case 1, 2:
            let nameCell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath)
            let title = ["", "From","to", ""]
            let placeHolder = ["", "あなたの名前", "相手の名前", ""]
            let nameText = nameCell.contentView.viewWithTag(1) as? UITextField
            let titleLabel = nameCell.contentView.viewWithTag(2) as? UILabel
            nameText?.placeholder = placeHolder[indexPath.row]
            titleLabel?.text = title[indexPath.row]
            return nameCell
        
        default:
            let messageCell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
            let messageTextView = messageCell.contentView.viewWithTag(4) as? UITextView
            
            return messageCell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }


    @IBAction func iconButton(_ sender: Any) {
       
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let pickerView = UIImagePickerController()
            pickerView.sourceType = .photoLibrary
            pickerView.delegate = self
            self.present(pickerView, animated: true)
        }}
    
    // 写真を選んだ後に呼ばれる処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 選択した写真を取得する
        let image = info[.originalImage] as! UIImage
        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
        
        let imageCropVC = RSKImageCropViewController(image: image, cropMode: .circle)
        imageCropVC.moveAndScaleLabel.text = "切り取り範囲を選択"
        imageCropVC.cancelButton.setTitle("キャンセル", for: .normal)
        imageCropVC.chooseButton.setTitle("完了", for: .normal)
        imageCropVC.delegate = self as! RSKImageCropViewControllerDelegate
        present(imageCropVC, animated: true)

//        // 表示
//        let cellOne = tableView.cellForRow(at: [0, 0])
//        let button = cellOne?.contentView.viewWithTag(3) as? UIButton
//        button?.setImage(image, for: .normal)
    }
       

    



    @IBAction func sendData(_ sender: Any) {
//        Storage.storage().reference(forURL: "gs://abcd-6e08b.appspot.com").child("bb").child("cc").child("imageData").delete()
        
//        if let name3 = UserDefaults.standard.array(forKey: "uniqueNmame"){
//            print(name3)
//            print(name3.count)
//
            UserDefaults.standard.removeObject(forKey: "uniqueNmame")
//
            print(UserDefaults.standard.array(forKey: "uniqueNmame"))
//
//            print("a")
//        }
    }
    
    
    
    @IBAction func senddata(_ sender: Any) {
        
        let cellZero = tableView.cellForRow(at: [0, 0])
        let cellOne = tableView.cellForRow(at: [0, 1])
        let cellTwo = tableView.cellForRow(at: [0, 2])
        let cellThree = tableView.cellForRow(at: [0, 3])
        let imageButton = cellZero?.contentView.viewWithTag(3) as? UIButton
        let nametextField = cellOne?.contentView.viewWithTag(1) as? UITextField
        let targetTextField = cellTwo?.contentView.viewWithTag(1) as? UITextField
        let messageTextView = cellThree?.contentView.viewWithTag(4) as? UITextView
        let buttonImage = imageButton?.currentImage
        imageData = buttonImage?.pngData()! as! NSData
        let myName = nametextField?.text
        let targetName = targetTextField?.text
        let message = messageTextView?.text
        var array = [myName, targetName, message]
        //        let value = ["message": messageTextView?.text!, "image": imageData] as [String : Any]
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child(myName!).child(targetName!).child(userID!)
        let storageRef = Storage.storage().reference(forURL: "gs://abcd-6e08b.appspot.com").child(myName!).child(targetName!).child(userID!).child("imageData")



//        FireStorage Uplode(登録画像）
        storageRef.putData(imageData as Data, metadata: nil){ (metadata, error)in
            guard let metadata = metadata else { return }
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else { return }
                let profileimage = downloadURL.absoluteString
                
                //       Firebase データ送信
                let value = ["message": messageTextView?.text!, "image": profileimage] as [String : Any]
                ref.updateChildValues(value)
            }}

        //      userdefault保存 + 重複削除
        if (UserDefaults.standard.object(forKey: "uniqueNmame") != nil){
            names = (UserDefaults.standard.object(forKey: "uniqueNmame") as? [[String : String]])!
        }
        names.append([myName!:targetName!])

        let oderSet = NSOrderedSet(array: names)
        //           ↑ 代替え可？ let oderSet = Set(names)
        let uniqueNmame = (oderSet.array as? [[String:String]])!
        UserDefaults.standard.set(uniqueNmame, forKey: "uniqueNmame")

        
        //    画面遷移
        let postCard: postCard = self.storyboard?.instantiateViewController(withIdentifier: "postCard") as! postCard
        postCard.array = array as? [String]
        postCard.images = buttonImage
        self.navigationController?.pushViewController(postCard, animated: true)

        
        print(names)
        print(UserDefaults.standard.array(forKey: "uniqueNmame"))

        
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
        let cellOne = tableView.cellForRow(at: [0, 0])
        let button = cellOne?.contentView.viewWithTag(3) as? UIButton
        button?.setImage(croppedImage, for: .normal)
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
            button?.setImage(png, for: .normal)


//            imageView.image = png
            //
            //                let tableViewController: tableViewController = self.storyboard?.instantiateViewController(withIdentifier: "tableViewController") as! tableViewController
            //
            //                tableViewController.images = png
            //                //        self.navigationController?.pushViewController(photo, animated: true)
            //                present(tableViewController, animated: true, completion: nil)
        }
        
    }
}

