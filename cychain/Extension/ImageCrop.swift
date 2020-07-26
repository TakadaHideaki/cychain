import UIKit
import RxSwift
import RxCocoa
import RSKImageCropper

class ImageCrop: NSObject {
    
    weak var delegate: UIViewController?
    //output
    private let image = PublishRelay<UIImage>()
    var croppedImage: Observable<UIImage> {
        return image.asObservable()
    }
    
    //切り抜き画面呼び出し
    func RSKImageCropVC(image: UIImage) {

        let imageCropVC = RSKImageCropViewController(image: image, cropMode: .circle)
        imageCropVC.moveAndScaleLabel.text = "切り取り範囲を選択"
        imageCropVC.cancelButton.setTitle("キャンセル", for: .normal)
        imageCropVC.chooseButton.setTitle("完了", for: .normal)
        imageCropVC.delegate = self
        imageCropVC.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.delegate?.present(imageCropVC, animated: true)
        }
    }
    
}

extension ImageCrop: RSKImageCropViewControllerDelegate {

    //完了押下
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        
        delegate?.dismiss(animated: true)
        // 円形画像を切り取りし
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
            let png = UIImage(data: pngData)!//Imageは円形で余白は透過
            self.image.accept(png)
        }
    }
    //キャンセル押下
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        delegate?.dismiss(animated: true)
    }

}
