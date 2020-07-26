import UIKit
import RxSwift
import RxCocoa

class ImagePickerController: NSObject, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    weak var delegate: UIViewController?
 
    //output
    private let image = PublishRelay<UIImage>()
    var selectedImage: Observable<UIImage> {
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
    
