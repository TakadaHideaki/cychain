import UIKit
import RxSwift
import RxCocoa
import TextFieldEffects
import RSKImageCropper

class EditViewController: UIViewController, UINavigationControllerDelegate, UIScrollViewDelegate {
    
    private let viewModel = EditViewModel()
    private let postResurlModel = postResultModel.shared
    private let firebase = SetFirebase()
    private let disposeBag = DisposeBag()
    private let defaultIcon = R.image.user12()!
    private let iconSet = ImagePickerController()
    private let imageCrop = ImageCrop()
    private var profileView = ProfileView()
    
    let waitingView = WatingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialazeUI()
        delegateSet()
        customNavigationBar()
        bind()
        bindScrollTextFieldWhenShowKeyboard()
   
    }
    
//    override func viewDidLayoutSubviews() {
//        profileView.profileBaseView.frame = self.view.bounds
//        view.addSubview(profileView.profileBaseView)
//        waitingView.frame = self.view.bounds
//        self.view.addSubview(waitingView)
//      }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // TextViewからフォーカスを外してキーボード閉じ、Viewを戻す
        profileView.msgTextView.resignFirstResponder()
    }
    
    func delegateSet() {
        profileView.msgTextView.delegate = self
        iconSet.delegate = self
        imageCrop.delegate = self
    }
    
    func initialazeUI() {
        profileView.profileBaseView.frame = self.view.bounds
        waitingView.frame = self.view.bounds
        view.addSubview(profileView.profileBaseView)
        self.view.addSubview(waitingView)
        tabBarController?.tabBar.isHidden = true
        profileView.msgTextView.keyBoardtoolBar(textView: profileView.msgTextView)
    }
    
    func bind() {
        let input = EditViewModel.Input(
            iconButtontapped: profileView.iconButton.rx.tap.asObservable(),
            postButtontapped: profileView.postButton.rx.tap.asObservable(),
            messageTapped: profileView.msgTextView.rx.didBeginEditing.asObservable(),
            myNameRelay: profileView.myNameTextField.rx.text.orEmpty.asObservable(),
            targetRelay: profileView.targetNameTextField.rx.text.orEmpty.asObservable(),
            messageRelay: profileView.msgTextView.rx.text.orEmpty.asObservable(),
            imageSelected: iconSet.selectedImage,
            imageCropped: imageCrop.croppedImage
        )
        
        let output = viewModel.transform(input: input)
        
//        output.searchingUI.asObservable()
//            .bind(onNext: { _ in self.addView() })
//        .disposed(by: disposeBag)
        
        // Searching_Indicator
        output.searchingUI
            .drive(waitingView.indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        // Searching_CovetView
        output.searchingUI
            .scan(true) { state, _ in !state}
            .drive(waitingView.rx.isHidden)
            .disposed(by: disposeBag)

        //最初に画面にPostDataを表示する
        output.initScreenData
            .bind(to: profileView.rx.binder)
            .disposed(by: disposeBag)
        
        //PostDataError
        output.NoData
            .bind(onNext: { self.editErrorAletr() })
            .disposed(by: disposeBag)
        
        //アイコンボタンタップ（フォトライブラリへ遷移）
        output.onIcButtonClickEvent
            .bind(onNext: { self.iconSet.iconButtonTapped()})
            .disposed(by: disposeBag)
        
        //viewModelから選択画像を受け取りCropVCへ渡す
        output.selectedImage
            .bind(onNext: { self.imageCrop.RSKImageCropVC(image: $0) })
            .disposed(by: disposeBag)
        
        //ViewModelから切り抜き画像のEventを受け取り、アイコンボタンにセット
        output.iconButtonImage
            .drive(profileView.iconButton.rx.image())
            .disposed(by: disposeBag)
        
        //messageTextViewのLabelの表示/非表示
        output.messageLabelEnable
            .drive(profileView.msgLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        //投稿ボタンクリック（文字数と投稿数がokなら画面遷移）
        output.nextVC
            .bind(onNext: {
                self.profileView.msgTextView.resignFirstResponder()
                self.postResurlModel.dataSet(data: $0)
                self.firebase.set(data: $0)
                self.pushVC(vc: R.storyboard.main.PostResultViewController()!, animation: true)
            })
            .disposed(by: disposeBag)
    }
    
//    func addView() {
//        log.debug("addView")
//        waitingView.frame = self.view.bounds
//        self.view.addSubview(waitingView)
//    }
}

extension Reactive where Base: ProfileView {
    var binder: Binder<PostDatas> {
        return Binder(self.base) { me, data in
            me.myNameTextField.text = data.my
            me.targetNameTextField.text = data.target
            me.msgTextView.text = data.message
            me.iconButton.setImage(data.iconImage, for: .normal)
        }
    }
}
    
extension EditViewController: UITextViewDelegate {
    
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let maxLength = 6
        let newText: String = (profileView.msgTextView.text! as NSString).replacingCharacters(in: range, with: text)
        return numberOfLines(orgTextView: textView, newText: newText) <= maxLength
    }
}



//    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
//        self.previousText = myNameTextField.text!
//        self.lastReplaceRange = range
//        self.lastReplacementString = text
//        return true
//    }
    
        


//extension Reactive where Base: UIButton {
//    var b: Binder<UIImage> {
//    return Binder(self.base) { me, image in
//        me.setImage(image, for: .normal)
//    }
//  }
//}

//       output.initialScreenData.map{$0.iconImage}
//            .bind(to: self.iconButton.rx.image())
//            .disposed(by: disposeBag)
