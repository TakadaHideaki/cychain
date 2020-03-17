//
//  PhotoEdit.swift
//  cychain
//
//  Created by takadahideaki007 on 2020/03/05.
//  Copyright © 2020 高田英明. All rights reserved.
//

//import UIKit
//import RSKImageCropper
//
//protocol ButtonSetDelegate: NSObject {
//    func buttonSetDidCropImage(image: UIImage)
//}
////
////
//class ButtonSet: NSObject, RSKImageCropViewControllerDelegate {
//
//    weak var delegate: (UIViewController & ButtonSetDelegate)?
//
//    var RegistButton: UIButton?
//    var userDataInputVC = UserDataInputViewController()
//    
//    
//    func present(image: UIImage) {
//                
//        log.debug("present")
//        let imageCropVC = RSKImageCropViewController(image: image, cropMode: .circle)
//        imageCropVC.moveAndScaleLabel.text = "切り取り範囲を選択"
//        imageCropVC.cancelButton.setTitle("キャンセル", for: .normal)
//        imageCropVC.chooseButton.setTitle("完了", for: .normal)
//        imageCropVC.delegate = self
//        delegate?.present(imageCropVC, animated: true)
//    }
//    
//    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
//        
//        delegate?.dismiss(animated: true)
//
//        // ここで画像の切り出しを行う
//        delegate?.buttonSetDidCropImage(image: croppedImage)
//
//        log.debug("完了を押した後の処理")
//        RegistButton = userDataInputVC.iconRegistButton
//
//        RegistButton?.setImage(croppedImage, for: .normal)
//
//        // 円形画像を切り取りし
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
//            RegistButton?.setImage(png, for: .normal)
//        }
//    }
//    
//    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
//        delegate?.dismiss(animated: true)
////        dismiss(animated: true, completion: nil)
//        
//    }
//}







//    var RegistButton: UIButton?
//
//    var User = UserDataInputViewController()
//
//    //キャンセルを押した時の処理
//    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
//        dismiss(animated: true, completion: nil)
//        log.debug("キャンセル")
//    }
//    //完了を押した後の処理
//    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
//
//        log.debug("完了を押した後の処理")
//        RegistButton = User.iconRegistButton
//
//
//        dismiss(animated: true)
//        RegistButton?.setImage(croppedImage, for: .normal)
//
////        もし円形で画像を切り取りし、その画像自体を加工などで利用したい場合
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
//            RegistButton?.setImage(png, for: .normal)
//        }
//    }
//}
//
//
//
