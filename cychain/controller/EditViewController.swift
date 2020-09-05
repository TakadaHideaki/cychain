import UIKit

class EditViewController: PostViewController {
    
    private let viewModel = EditViewModel()
    var pairName: [String: String] = [:]
    
    override func initializeUI() {
        self.myNameTextField.text = pairName.map{$0.key}[0]
        self.targetNameTextField.text = pairName.map{$0.value}[0]
        
        super.messageTextView.keyBoardtoolBar(textView: messageTextView)
        super.self.iconRegistButton.setImage(self.defaultIcon, for: .normal)
        super.customNavigationBar()
    }
    
    override func bind() {
        let input = EditViewModel.Input(
            iconButtontapped: iconRegistButton.rx.tap.asObservable(),
            postButtontapped: postButton.rx.tap.asObservable(),
            messageTapped: messageTextView.rx.didBeginEditing.asObservable(),
            myNameRelay: myNameTextField.rx.text.orEmpty.asObservable(),
            targetRelay: targetNameTextField.rx.text.orEmpty.asObservable(),
            messageRelay: messageTextView.rx.text.orEmpty.asObservable(),
            imageSelected: iconSet.selectedImage,
            imageCropped: imageCrop.croppedImage
        )
        let output = viewModel.transform(input: input)
        
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
            .drive(iconRegistButton.rx.image())
            .disposed(by: disposeBag)
        
        //messageTextViewのLabelの表示/非表示
        output.messageLabelEnable
            .drive( self.messageLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        //投稿ボタンクリック（文字数と投稿数がokなら画面遷移）
        output.nextVC
            .subscribe(onNext: {
                self.messageTextView.resignFirstResponder()
                //  self.configureObserver()
                let sb = R.storyboard.main()
                let vc = sb.instantiateViewController(withIdentifier: "PostResultViewController") as? PostResultViewController
                vc?.posedtData = $0
                self.navigationController?.pushViewController(vc!, animated: true)
                /*   let newVC = InputResultViewController.returnVC(data: value)
                 self.navigationController?.pushViewController(newVC, animated: true)*/
            })
            .disposed(by: disposeBag)
    }


/*

UIViewController, UINavigationControllerDelegate,UITextFieldDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UIScrollViewDelegate, ScrollKeyBoard {

    
    
    @IBOutlet weak var myNameTextField: UITextField!
    @IBOutlet weak var targetNameTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var dataSendButton: UIButton!
    @IBOutlet weak var iconRegistButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    

    
    
    var editUserData: [String: Any]?
    var iconImage: UIImage?
    var iconSet: ImagePickerController?
    
    var pairName: [String: String]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialazeUI()
        userDataSet()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // TextViewフォーカス外す　＆キーボード閉じる＋View戻す
        messageTextView.resignFirstResponder()
        configureObserver()
    }
    
    func initialazeUI() {
        myNameTextField.delegate = self
        targetNameTextField.delegate = self
        messageTextView.delegate = self
        tabBarController?.tabBar.isHidden = true
        messageTextView.keyBoardtoolBar(textView: messageTextView)
        customNavigationBar()
        iconSet = ImagePickerController()
//        iconSet?.delegate = self as? (UIViewController & IconSetDelegate)
        iconSet?.delegate = self

    }
    
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
    
    func textViewDidChange(_ textView: UITextView) {
        if myNameTextField.markedTextRange != nil {
            return
        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newText: String = (messageTextView.text! as NSString).replacingCharacters(in: range, with: text)
        return numberOfLines(orgTextView: textView, newText: newText) <= 6
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

//extension EditViewController: IconSetDelegate {
//
//    func buttonSetDidCropImage(image: UIImage) {
//        iconRegistButton?.setImage(image, for: .normal)
//    }
//}
 

*/

}
