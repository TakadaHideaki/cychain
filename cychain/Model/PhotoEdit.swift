import UIKit
import RxSwift
import RxCocoa
import RSKImageCropper

class IconSet: NSObject, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

//    weak var delegate: (UIViewController & IconSetDelegate)?
    weak var delegate: UIViewController?
 
    //output
    private let image = PublishRelay<UIImage>()
    var SelectedImage: Observable<UIImage> {
        return image.asObservable()
    }
 
    
    func iconButtonTapped() {

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerView = UIImagePickerController()
            pickerView.sourceType = .photoLibrary  //PhotoLibraryから画像を選択
            pickerView.delegate = self
            pickerView.modalPresentationStyle = .fullScreen
            delegate?.present(pickerView, animated: true)
        }
    }
    
    // UIImagepickerのdelegat 画像選択後呼び出し
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            self.image.accept(image) // 選択した写真を取得する
        }
        delegate?.dismiss(animated: false)
    }
}
    






