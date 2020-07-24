import UIKit
import RxSwift
import RxCocoa
import TextFieldEffects
import RSKImageCropper

class UserDataInputViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate, ScrollKeyBoard {
    
    
    
    @IBOutlet weak var myNameTextField: UITextField!
    @IBOutlet weak var targetNameTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var iconRegistButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var postButton: Button!
    
    private let disposeBag = DisposeBag()
    private let userDataModel = UserDataModel.sharead
    private let viewModel = UserDataViewModel()
    private let defaultIcon = R.image.user10()
    private let iconSet = IconSet()
    private let imageCrop = ImageCrop()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        //        selectedImage()    //フォトライブラリから選択した画像を受け取る
        //        croppedImage()    //RSKImageCropVCから切り抜かれた画像を受け取る
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
        self.iconRegistButton.setImage(self.defaultIcon, for: .normal)
        
        iconSet.delegate = self
        imageCrop.delegate = self
        
        bind() 
    }
    
    
    
    
    
    private func bind() {
        
        let input = UserDataViewModel.Input(
            postButtontapped: postButton.rx.tap.asObservable(),
            iconButtontapped: iconRegistButton.rx.tap.asObservable(),
            myNameRelay: myNameTextField.rx.text.orEmpty.map{( $0.deleteSpace())},
            targetRelay: targetNameTextField.rx.text.orEmpty.map{( $0.deleteSpace())},
            messageRelay: messageTextView.rx.text.orEmpty.asObservable(),
            imageSelected: iconSet.SelectedImage,
            imageCropped: imageCrop.croppedImage
        )
        
        let output = viewModel.transform(input: input)
        
        //アイコンボタンタップ（フォトライブラリへ遷移）
        output.onIcButtonClickEvent
            .subscribe (onNext: { _ in
                self.iconSet.iconButtonTapped()
            })
            .disposed(by: disposeBag)
        
        //textFieldが未入力or13文字以上でアラート
        output.characterCountOverrun
            .subscribe(onNext: { _ in
                self.charactorErrorAlert()
            })
            .disposed(by: disposeBag)
        
        //投稿数が10以上でアラート
        output.postsCountOver
            .filter{ !$0 }
            .map { _ in () }
            .subscribe(onNext: { _ in
                self.RegistationOverAlert(vc: R.storyboard.main.list()!)
            })
            .disposed(by: disposeBag)
        
        //投稿ボタンクリック（文字数と投稿数がokなら画面遷移）
        output.nextVC
            .subscribe(onNext: { value in
                log.debug(value)
                //                self.presentVC(vc: vc, animation: true)
            })
            .disposed(by: disposeBag)
        
        //viewModelから選択画像を受け取りCropVCへ渡す
        output.selectedImage
            .subscribe(onNext: { image in
                log.debug(image)
                self.imageCrop.RSKImageCropVC(image: image)
            })
            .disposed(by: disposeBag)
        
        //ViewModelから切り抜き画像のEventを受け取り、アイコンボタンにセット
        output.iconButtonImage
            .drive(iconRegistButton.rx.image())
            .disposed(by: disposeBag)
        

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



/*
         
        //view => viewModl
        //myNameTextFieldを監視
        myNameTextField.rx.text.orEmpty
            .map{( $0.deleteSpace())}
            .bind(to: viewModel.myNameRelay)
            .disposed(by: disposeBag)
        
        //targetNameTextFieldを監視
        targetNameTextField.rx.text.orEmpty
            .map{( $0.deleteSpace())}
            .bind(to: viewModel.targetRelay)
            .disposed(by: disposeBag)
        
        //textViewを監視
        messageTextView.rx.text.orEmpty
            .bind(to: viewModel.messageRelay)
            .disposed(by: disposeBag)
        
        //アイコンボタンを監視
        iconRegistButton.rx.tap
            .bind(to: viewModel.iconButtontapped)
            .disposed(by: disposeBag)
        
        //投稿ボタンを監視
        postButton.rx.tap
            .bind(to: viewModel.postButtontapped)
            .disposed(by: disposeBag)
          
    }
    
    
     //textFieldが未入力or13文字以上でアラート
    func CharactorError() {
        viewModel.outputs?.characterCountOverrun
            .subscribe(onNext: { _ in
                self.charactorErrorAlert()
            })
            .disposed(by: disposeBag)
    }
    
    //投稿数が10以上でアラート
    func postCountError() {
        viewModel.outputs?.postsCountCheck
            .filter{ !$0 }
            .map { _ in () }
            .subscribe(onNext: { _ in
                self.RegistationOverAlert(vc: R.storyboard.main.list()!)
            })
            .disposed(by: disposeBag)
    }
    
    
   //投稿ボタンクリック（文字数と投稿数がokなら画面遷移）
    func goNextVC() {
        self.viewModel.outputs?.nextVC
            .subscribe(onNext: { value in
                
                log.debug(value)
//                self.presentVC(vc: vc, animation: true)
    })
    .disposed(by: disposeBag)
    }
    
    //アイコンボタンタップ（フォトライブラリへ遷移）
    func sendToPhotoLibrary() {
        self.viewModel.outputs?.onIcButtonClickEvent
            .subscribe (onNext: { _ in
                self.iconSet?.iconButtonTapped()
            })
            .disposed(by: disposeBag)
    }
    

    //フォトライブラリから選択した画像を受け取る
    func selectedImage() {
        self.iconSet?.SelectedImage
            .subscribe(onNext: { image in
                self.viewModel.onImageSelectedRelay.onNext(image)
            })
        .disposed(by: disposeBag)
    }
    
    //viewModelから選択画像を受け取りCropVCへ渡す
    func sendToCropVC() {
        self.viewModel.outputs?.onImageSelectedEvent
            .subscribe(onNext: { image in
                log.debug(image)
                self.imageCrop?.RSKImageCropVC(image: image)

            })
        .disposed(by: disposeBag)
    }
    
    //CropVCから切り抜き画像を受け取りViewModelへ送る
    func croppedImage() {
        self.imageCrop?.croppedImage
            .subscribe(onNext: { image in
                self.viewModel.croppedImageRelay.accept(image)
            })
        .disposed(by: disposeBag)
    }
    
    //ViewModelから切り抜き画像のEventを受け取り
    //アイコンボタンに切り抜き画像をセットする
    func setIconButtonImage() {
        self.viewModel.iconButtonImage
            .drive(iconRegistButton.rx.image())
            .disposed(by: disposeBag)
    }
 
 */
