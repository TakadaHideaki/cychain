import UIKit
import RxSwift
import RxCocoa
import TextFieldEffects
import RSKImageCropper

class PostViewController: UIViewController, ScrollKeyBoard {

    
    
    @IBOutlet weak var myNameTextField: UITextField!
    @IBOutlet weak var targetNameTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var iconRegistButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var postButton: Button!
    
    private let disposeBag = DisposeBag()
    private let viewModel = PostViewModel()
    private let defaultIcon = R.image.user10()
    private let iconSet = ImagePickerController()
    private let imageCrop = ImageCrop()
    
    //TextViewのpropaty
    let maxLength = 6
    var previousText = ""
    var lastReplaceRange: NSRange!
    var lastReplacementString = ""
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateSet()
        initializeUI()
        bind()
//                UD.removeObject(forKey: Name.KeyName.uniqueNmame.rawValue)
    }
    
    func delegateSet() {
        myNameTextField.delegate = self
        targetNameTextField.delegate = self
        messageTextView.delegate = self
        iconSet.delegate = self
        imageCrop.delegate = self
    }
    
    func initializeUI() {
        messageTextView.keyBoardtoolBar(textView: messageTextView)
        customNavigationBar()
        self.iconRegistButton.setImage(self.defaultIcon, for: .normal)
    }
    
    
    private func bind() {
        let input = PostViewModel.Input(
            postButtontapped: postButton.rx.tap.asObservable(),
            iconButtontapped: iconRegistButton.rx.tap.asObservable(),
            messageTapped: messageTextView.rx.didBeginEditing.asObservable() ,
            myNameRelay: myNameTextField.rx.text.orEmpty.map{( $0.deleteSpace())},
            targetRelay: targetNameTextField.rx.text.orEmpty.map{( $0.deleteSpace())},
            messageRelay: messageTextView.rx.text.orEmpty.asObservable(),
            imageSelected: iconSet.selectedImage,
            imageCropped: imageCrop.croppedImage
        )
        
        let output = viewModel.transform(input: input)
        
        //アイコンボタンタップ（フォトライブラリへ遷移）
        output.onIcButtonClickEvent
            .subscribe(onNext: { self.iconSet.iconButtonTapped()})
            .disposed(by: disposeBag)
        
        //viewModelから選択画像を受け取りCropVCへ渡す
        output.selectedImage
            .subscribe(onNext: { self.imageCrop.RSKImageCropVC(image: $0)})
            .disposed(by: disposeBag)
        
        //ViewModelから切り抜き画像のEventを受け取り、アイコンボタンにセット
        output.iconButtonImage
            .skip(1)
            .drive(iconRegistButton.rx.image())
            .disposed(by: disposeBag)
        
        //textField.Text >14 or 0 _Alert
        output.characterCountOverrun
            .subscribe(onNext: { self.charactorErrorAlert()})
            .disposed(by: disposeBag)
        
        //投稿数>10_Alert
        output.postsCountOver
            .filter{ !$0 }
            .map { _ in () }
            .subscribe(onNext: { self.RegistationOverAlert(vc: R.storyboard.main.list()!)})
            .disposed(by: disposeBag)
        
        //messageTextView_Tapp
        output.messageTapp
            .subscribe(onNext: {
                log.debug("messageTapp")
//                self.configureObserver() //
//                self.messageLabel.isHidden = true
            }
        )
            .disposed(by: disposeBag)

        //投稿ボタンクリック（文字数と投稿数がokなら画面遷移）
        output.nextVC
            .subscribe(onNext: {
                self.messageTextView.resignFirstResponder()
                self.configureObserver()

                let sb = R.storyboard.main()
                let vc = sb.instantiateViewController(withIdentifier: "PostResultViewController") as? PostResultViewController
                vc?.posedtData = $0
                log.debug($0)
                self.navigationController?.pushViewController(vc!, animated: true)
                /*   let newVC = InputResultViewController.returnVC(data: value)
                 self.navigationController?.pushViewController(newVC, animated: true)*/
            })
            .disposed(by: disposeBag)
        
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
    
extension PostViewController: UITextFieldDelegate {
    
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
    
}

extension PostViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        configureObserver()
        self.messageLabel.isHidden = true
        return  true
    }
    
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
    
    
    
}

    





