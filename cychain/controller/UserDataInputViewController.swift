//
//  DataInput1.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/04/28.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import TextFieldEffects

class UserDataInputViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate, ScrollKeyBoard {

    
    
    @IBOutlet weak var myNameTextField: UITextField!
    @IBOutlet weak var targetNameTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var iconRegistButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var postButton: Button!
    
    private let disposeBag = DisposeBag()

    let userDataModel = UserDataModel.sharead
    let viewModel = UserDataViewModel()
    let defaultIcon = R.image.user10()//写真登録のアイコンイメージ
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
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

        
        bind()
        CharactorError()//文字数チェック
        postCountError()//投稿数チェック
        goNextVC()//画面遷移
        aaa()

    }
    

    
    func bind() {
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
            .bind(to: userDataModel.messageRelay)
            .disposed(by: disposeBag)
        
        //アイコンボタンを監視
        iconRegistButton.rx.tap
            .bind(to: viewModel.onIcButtonClick)
            .disposed(by: disposeBag)
        
        //投稿ボタンを監視
        postButton.rx.tap
            .bind(to: viewModel.onRegisterButtonClick)
            .disposed(by: disposeBag)
        
        
        
        
        //viewmoel => view
        viewModel.buttonImage?
            .drive(iconRegistButton.rx.image())
            .disposed(by: disposeBag)
        
    }
    
    
     //textFieldが未入力or13文字以上でアラート
    func CharactorError() {
        viewModel.isInputTextValid
            .filter{ !$0 }
            .map { _ in () }
            .subscribe(onNext: { _ in
                self.charactorErrorAlert()
            })
            .disposed(by: disposeBag)
    }
    
    //投稿数が10以上でアラート
    func postCountError() {
        viewModel.postsCountCheck
            .filter{ !$0 }
            .map { _ in () }
            .subscribe(onNext: { _ in
                self.RegistationOverAlert(vc: R.storyboard.main.list()!)
            })
            .disposed(by: disposeBag)
    }
    
    
   //投稿ボタンクリック（文字数と投稿数がokなら画面遷移）
    func goNextVC() {
        self.viewModel.goToNext
            .subscribe(onNext: { text1 in
                let vc = InputResultViewController(text1: text1)
                log.debug(self.viewModel.mT)

//                self.presentVC(vc: vc, animation: true)
    })
    .disposed(by: disposeBag)
    }
    

    func aaa() {
        self.viewModel.mT.subscribe(onNext: { aa in
            log.debug(aa)
            log.debug(aa)
            log.debug(self.viewModel.mT)
        })
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

extension UserDataInputViewController: IconSetDelegate {

    func buttonSetDidCropImage(image: UIImage) {
        viewModel.onImageSelected.accept(image)
    }
}



