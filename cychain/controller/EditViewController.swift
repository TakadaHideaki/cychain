import UIKit
import RxSwift
import RxCocoa
import TextFieldEffects
import RSKImageCropper

class EditViewController: UIViewController, UINavigationControllerDelegate, UIScrollViewDelegate, ScrollKeyBoard {

    @IBOutlet weak var myNameTextField: textField!
    @IBOutlet weak var targetNameTextField: textField!
    @IBOutlet weak var messageTextView: textView!
    @IBOutlet weak var postButton: Button!
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    private let viewModel = EditViewModel()
    private let postResurlModel = postResultModel.shared
    private let firebase = SetFirebase()
    let disposeBag = DisposeBag()
    let defaultIcon = R.image.user10()
    let iconSet = ImagePickerController()
    let imageCrop = ImageCrop()
    
    let maxLength = 6
    var previousText = ""
    var lastReplaceRange: NSRange!
    var lastReplacementString = ""
   
    lazy var coverView: UIView = {
        let view = UIView()
        view.frame = self.view.bounds
        view.backgroundColor = .white
        view.alpha = 0.5
        return view
    }()
    
    var indicatorView = { () -> UIActivityIndicatorView in
        var view = UIActivityIndicatorView.init(style: .whiteLarge)
        view.style = .whiteLarge
        view.color = .gray
        return view
    }()
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.tabBarController?.tabBar.isHidden = true
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        delegateSet()
        initialazeUI()
        addUI()
        bind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
         super.viewDidDisappear(animated)
         // TextViewフォーカス外す　＆キーボード閉じる＋View戻す
         messageTextView.resignFirstResponder()
         configureObserver()
     }
    
    func delegateSet() {
          myNameTextField.delegate = self
          targetNameTextField.delegate = self
          messageTextView.delegate = self
          iconSet.delegate = self
          imageCrop.delegate = self
      }
    
    func initialazeUI() {
        tabBarController?.tabBar.isHidden = true
        messageTextView.keyBoardtoolBar(textView: messageTextView)
        self.iconButton.setImage(self.defaultIcon, for: .normal)
        customNavigationBar()
    }
    func addUI() {
        self.view.addSubview(coverView)
        self.view.bringSubviewToFront(coverView)
        indicatorView.center = self.view.center
        self.view.addSubview(indicatorView)
        self.view.bringSubviewToFront(indicatorView)
    }
    
    func bind() {
        let input = EditViewModel.Input(
            iconButtontapped: iconButton.rx.tap.asObservable(),
            postButtontapped: postButton.rx.tap.asObservable(),
            messageTapped: messageTextView.rx.didBeginEditing.asObservable(),
            myNameRelay: myNameTextField.rx.text.orEmpty.asObservable(),
            targetRelay: targetNameTextField.rx.text.orEmpty.asObservable(),
            messageRelay: messageTextView.rx.text.orEmpty.asObservable(),
            imageSelected: iconSet.selectedImage,
            imageCropped: imageCrop.croppedImage
        )
        let output = viewModel.transform(input: input)
        
        //switch_Indicator
        output.SwitchUIHiden
        .debug()
            .drive(self.indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
       
        // Switch_CovetView
        output.SwitchUIHiden.asObservable()
        .debug()
        .skip(1)
        .subscribe(onNext: { [weak self] _ in
            self?.coverView.isHidden = true
        })
        .disposed(by: disposeBag)
        
        //Post済みデータを表示
        output.initialScreenData
            .subscribe(onNext: { [weak self] data in
                self?.iconButton.setImage(data.iconImage, for: .normal)
                self?.myNameTextField.text = data.my
                self?.targetNameTextField.text = data.target
                self?.messageTextView.text = data.message
            })
            .disposed(by: disposeBag)
        
        //PostDataError
        output.NoData
            .subscribe(onNext: { [weak self] data in
                self?.editErrorAletr()
            })
            .disposed(by: disposeBag)
 
        //アイコンボタンタップ（フォトライブラリへ遷移）
        output.onIcButtonClickEvent
            .subscribe(onNext: { [weak self]  in
                self?.iconSet.iconButtonTapped()})
            .disposed(by: disposeBag)
        
        //viewModelから選択画像を受け取りCropVCへ渡す
        output.selectedImage
            .subscribe(onNext: { [weak self]  value in
                self?.imageCrop.RSKImageCropVC(image: value)})
            .disposed(by: disposeBag)
        
        //ViewModelから切り抜き画像のEventを受け取り、アイコンボタンにセット
        output.iconButtonImage
            .skip(1)
            .drive(iconButton.rx.image())
            .disposed(by: disposeBag)
        
        //messageTextViewのLabelの表示/非表示
        output.messageLabelEnable
            .drive( self.messageLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        //投稿ボタンクリック（文字数と投稿数がokなら画面遷移）
        output.nextVC
            .subscribe(onNext: { [weak self] data in
                self?.messageTextView.resignFirstResponder()
                self?.postResurlModel.dataSet(data: data)
                self?.firebase.set(data: data)
                self?.pushVC(vc: R.storyboard.main.PostResultViewController()!, animation: true)
//                self?.navigationController?.pushViewController(vc!, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    
    

    /*

    var editUserData: [String: Any]?
    var iconImage: UIImage?
    
    var pairName: [String: String]?
    
 
    //UserDataを表示
    func userDataSet() {
        
        guard let userData = EditData.sharedInstance.SingletonUserData else { return }
        
        editUserData = userData
        
        guard let myName = userData["my"] as? String,
            let targetName = userData["target"] as? String
            else { return }
        
        myNameTextField.text = myName
        targetNameTextField.text = targetName
        
        
        if let message = userData["message"] as? String {
            if message != "" {
                messageLabel.isHidden = true
                messageTextView.text = message
            } else {
                messageLabel.isHidden = false
            }
        } else {
            messageLabel.isHidden = false
        }
        
        
        if let imageUrl = userData["image"] {
            let url = URL(string: imageUrl as! String)
            // image変換
            do {
                let imageData = try Data(contentsOf: url!)
                let image = UIImage(data:imageData as Data)
                iconRegistButton.setImage(image, for: .normal)
                iconImage = image
                editUserData?["image"] = image
            } catch {
                log.debug("error")
            }
        } else {
            iconRegistButton.setImage(R.image.user10(), for: .normal)
        }
    }
    
    
    @IBAction func iconButtonTapped(_ sender: Any) {
//        iconSet?.iconButtonTapped()
    }
    
    
    @IBAction func senderData(_ sender: Any) {
        
        editUserData!["message"] = messageTextView.text ?? ""
        editUserData?["image"]  = iconRegistButton.currentImage ?? R.image.user10()
        
//        let userDataModel = UserDataModel.sharead
        
//        userDataModel.setData(userData: editUserData!)// modelへ["message":メッセージ, "image" アイコンイメージ]
//        userDataModel.setFirebase()//firebase更新
        pushVC(vc: R.storyboard.main.PostResultViewController()!, animation: true)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        configureObserver()
        messageLabel.isHidden = true
        return  true
    }
    
    */

}
    
   extension EditViewController: UITextFieldDelegate {

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
    
extension EditViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if myNameTextField.markedTextRange != nil {
            return
        }
    }

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
           self.previousText = myNameTextField.text!
           self.lastReplaceRange = range
           self.lastReplacementString = text
           return true
       }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
         
         let newText: String = (messageTextView.text! as NSString).replacingCharacters(in: range, with: text)
         return numberOfLines(orgTextView: textView, newText: newText) <= 6
     }
}
