import UIKit
import RxSwift
import RxCocoa
import TextFieldEffects
import RSKImageCropper

class PostViewController: UIViewController {
    
    final private let viewModel = PostViewModel()
    let postResurlModel = postResultModel.shared
    let disposeBag = DisposeBag()
    let defaultIcon = R.image.user10()
    let iconSet = ImagePickerController()
    let imageCrop = ImageCrop()
    var profileView: ProfileView!

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        customNavigationBar()
        delegateSet()
        bind()
        bindScrollTextFieldWhenShowKeyboard()
    }
    
    override func viewDidLayoutSubviews() {
        profileView.profileBaseView.frame = self.view.bounds
        view.addSubview(profileView.profileBaseView)
    }
    
    func delegateSet() {
        profileView.msgTextView.delegate = self
        iconSet.delegate = self
        imageCrop.delegate = self
    }
    
    func initializeUI() {
        profileView = ProfileView()
        profileView.msgTextView.keyBoardtoolBar(textView: profileView.msgTextView)
        //textFieldを２つ設置した時に発生するLayoutConstraintエラー(バグ?)対応
        profileView.myNameTextField.autocorrectionType = .no
        profileView.targetNameTextField.autocorrectionType = .no
        
    }
    
     func bind() {
        let input = PostViewModel.Input(
            postButtontapped: profileView.postButton.rx.tap.asObservable(),
            iconButtontapped: profileView.iconButton.rx.tap.asObservable().share(),
            myNameRelay: profileView.myNameTextField.rx.text.orEmpty.map{( $0.deleteSpace())},
            targetRelay: profileView.targetNameTextField.rx.text.orEmpty.map{( $0.deleteSpace())},
            messageRelay: profileView.msgTextView.rx.text.orEmpty.asObservable(),
            imageSelected: iconSet.selectedImage.share(),
            imageCropped: imageCrop.croppedImage
        )
        
        let output = viewModel.transform(input: input)
        
        //アイコンボタンタップ（フォトライブラリへ遷移）
        output.onIcButtonClickEvent
            .bind(onNext: { self.iconSet.iconButtonTapped() })
            .disposed(by: disposeBag)
        
        //PhotoLiblalyから選択画像を受け取り画像切り抜きClass(CropVC)へ渡す
        output.selectedImage
            .bind(onNext: { self.imageCrop.RSKImageCropVC(image: $0) })
            .disposed(by: disposeBag)
        
        //ViewModelから切り抜き画像のEventを受け取り、アイコンボタンにセット
        output.iconButtonImage
            .skip(1)
            .drive(profileView.iconButton.rx.image())
            .disposed(by: disposeBag)
        
        //textField.Text >14 or 0 _Alert
        output.characterCountOverrun
        .bind(onNext: { self.charactorErrorAlert() })
        .disposed(by: disposeBag)
        
        //投稿数>10_Alert
        output.postsCountOver
            .bind(onNext: { self.RegistationOverAlert(vc: R.storyboard.main.list()!)})

            .disposed(by: disposeBag)
        
        //messageTextViewのLabelの表示/非表示
        output.messageLabelEnable
            .drive( profileView.msgLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        //投稿ボタンクリック（文字数と投稿数がokなら画面遷移）
        output.nextVC
            .bind(onNext: {
                self.profileView.msgTextView.resignFirstResponder()
                self.postResurlModel.dataSet(data: $0)
                self.pushVC(vc: R.storyboard.main.PostResultViewController()!, animation: true)
            })
            .disposed(by: disposeBag)
    }
    


}
extension PostViewController: UITextViewDelegate {
    
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
    
    //メッセージを６行に制限
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let maxLength = 6
        let newText: String = (profileView.msgTextView.text! as NSString).replacingCharacters(in: range, with: text)
        return numberOfLines(orgTextView: textView, newText: newText) <= maxLength
    }
}
