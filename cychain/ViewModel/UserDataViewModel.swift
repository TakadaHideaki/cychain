import Foundation
import RxSwift
import RxCocoa


struct Texts {
    let my: String
    let target: String
    let message: String
    var iconImage = R.image.user12()!
    var isValid: Bool {
        return ![my, target].map { checkChars($0) }.contains(false)
    }
    private func checkChars(_ text: String) -> Bool {
        return text.count > 0 && text.count < 13
    }
}

protocol UserViewModelType {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}


struct UserDataViewModel {
    init(){}
}


extension UserDataViewModel: UserViewModelType {
    struct Input {
        let postButtontapped: Observable<Void>
        let iconButtontapped: Observable<Void>
        let myNameRelay: Observable<String>
        let targetRelay: Observable<String>
        let messageRelay: Observable<String>
        let imageSelected: Observable<UIImage>
        let imageCropped: Observable<UIImage>
    }
    
    struct Output {
        let onIcButtonClickEvent: Observable<Void>
        let characterCountOverrun: Observable<Void>
        let postsCountOver: Observable<Bool>
        let nextVC: Observable<Texts>
        let selectedImage: Observable<UIImage>
        let iconButtonImage: Driver<UIImage>

    }
    
    func transform(input: Input) -> Output {
        //UserDataを纏めるTextsへ
        let substitutionToTexts = Observable
            .combineLatest(input.myNameRelay.asObservable(),
                           input.targetRelay.asObservable(),
                           input.messageRelay.asObservable(),
                           input.imageCropped.asObservable()) { my, target, message, iconImage  in
                            Texts(my: my,
                                  target: target,
                                  message: message,
                                  iconImage: iconImage)
        }
        //投稿数Check
        var postsCheck: Observable<Bool> {
            if let ppstCount = UD.object(forKey: Name.KeyName.uniqueNmame.rawValue) as? [[String : String]]  {
                switch ppstCount.count {
                case 0 ... 10: return Observable.of(true)
                default: return Observable.of(false)
                    
                    //  userDataModel.setUserDefault()
                    //  userDataModel.setFirebase()
                }
            } else {
                //投稿値歴無し
                return Observable.of(true)
                //  userDataModel.setUserDefault()
                //  userDataModel.setFirebase()
            }
        }
        //textField文字数check
        let characterCheck = input.postButtontapped
            .withLatestFrom(postsCheck)
            .filter { $0 }
            .map { _ in () }
            .withLatestFrom(substitutionToTexts) { _, texts in texts }
        //文字数NG
        let overrun = characterCheck.filter { !$0.isValid }.map { _ in () }
        //文字数OK
        let apprppriate = characterCheck.filter { $0.isValid }
        
        
        return Output(onIcButtonClickEvent: input.iconButtontapped,
                      characterCountOverrun: overrun,
                      postsCountOver: postsCheck,
                      nextVC: apprppriate,
                      selectedImage: input.imageSelected,
                      iconButtonImage: input.imageCropped.asDriver(onErrorDriveWith: Driver.empty())
        )
    }
    
    
    
    

}





/*






//protocol UserViewModelOutputs {
//
//    var nextVC: Observable<Texts> { get }
//    var iconButtonImage: Driver<UIImage> { get }
//    var characterCountOverrun: Observable<Void> { get }
//    var postsCountCheck: Observable<Bool> { get }
//    var onIcButtonClickEvent: Observable<Void> { get }
//    var onImageSelectedEvent: Observable<UIImage> { get }
//
//}

//protocol viewModelType {
//    var outputs: UserViewModelOutputs? { get }
//}


//class UserDataViewModel: viewModelType {
    
    var iconSet: IconSet?
    var outputs: UserViewModelOutputs?
    private let disposeBag = DisposeBag()
    
    
    // Input: View => ViewModel
//    let onRegisterButtonClick = PublishRelay<Void>()
//    let onIcButtonClick = PublishRelay<Void>()
//    let myNameRelay = BehaviorRelay<String>(value: "")
//    let targetRelay = BehaviorRelay<String>(value: "")
//    let messageRelay = BehaviorRelay<String>(value: "")
//    let croppedImageRelay = BehaviorRelay<UIImage>(value: R.image.user10()!)
////    let croppedImageRelay = PublishRelay<UIImage>()
//
//    let cropImage = Observable<UIImage>?.self
    
    init() {
        self.outputs = self
        self.iconSet = IconSet()
    }
    
}
    

extension UserDataViewModel: UserViewModelOutputs {
 
    //アイコンボタン押下をViewControllerへ通知
    var onIcButtonClickEvent: Observable<Void> {
        return self.onIcButtonClick.asObservable()
    }
    //選択された画像を受け取りViewControllerへ通知
    var onImageSelectedEvent: Observable<UIImage> {
        return self.onImageSelectedRelay.asObservable()
    }
    //切り抜き画像(アイコンボタン用画像)をViewControllerへ送る
    var iconButtonImage: Driver<UIImage> {
        return croppedImageRelay.asDriver(onErrorDriveWith: Driver.empty())
    }
    //UserDataを纏める
    var SubstitutionToTexts: Observable<Texts> { Observable
        .combineLatest(myNameRelay.asObservable(),
                       targetRelay.asObservable(),
                       messageRelay.asObservable(),
                       croppedImageRelay.asObservable()) { my, target, message, iconImage  in
                        Texts(my: my,
                              target: target,
                              message: message,
                              iconImage: iconImage)
        }
    }
    //textField文字数check
    var charactorCountCheck: Observable<Texts> {
        return onRegisterButtonClick
            .withLatestFrom(postsCountCheck)
            .filter { $0 }
            .map { _ in () }
            .withLatestFrom(SubstitutionToTexts) { _, texts in texts }
    }
    //文字数NG
    var characterCountOverrun: Observable<Void> {
        charactorCountCheck.filter { !$0.isValid }.map { _ in () }
    }
    //文字数OK
    var nextVC: Observable<Texts> {
        charactorCountCheck.filter { $0.isValid }
    }
    //投稿数Check
    var postsCountCheck: Observable<Bool> {
        if let ppstCount = UD.object(forKey: Name.KeyName.uniqueNmame.rawValue) as? [[String : String]]  {
            switch ppstCount.count {
            case 0 ... 10: return Observable.of(true)
            default: return Observable.of(false)
                
                //  userDataModel.setUserDefault()
                //  userDataModel.setFirebase()
            }
        } else {
            //投稿値歴無し
            return Observable.of(true)
            //  userDataModel.setUserDefault()
            //  userDataModel.setFirebase()
        }
    }
    
}
 
 */
    


    
    
 

    
    
 

    
    
    
    
    
    
    
    
    
    /**
     
     //文字数と投稿数が両方check
     var nextVC: Observable<(String, String)> {
     
     let charactorCountCheck = Observable
     .combineLatest(myNameRelay.asObservable(),
     targetRelay.asObservable()) {
     my, target in (my, target)
     }
     return onRegisterButtonClick
     .withLatestFrom(postsCountCheck)
     .filter { $0 }
     .map { _ in () }
     .withLatestFrom(charactorCountCheck) { _, isValid in isValid }
     .filter { [unowned self] in
     self.checkChars($0.0) && self.checkChars($0.1)
     }
     }
     func checkChars(_ text: String) -> Bool {
     return text.count > 0 && text.count < 13
     }
     
     */
    
    
    
    
    

    

/*
    //文字数と投稿数が両方check
    var nextVC: Observable<Bool> {
        let postPossibleCheck = Observable
            .combineLatest(isInputTextValid, postsCountCheck) {
                $0 && $1
        }
        return onRegisterButtonClick
            .withLatestFrom(postPossibleCheck) { _, isValid in isValid }
            .filter { $0 }
    }
}
 */

        
    /*

    init() {
        //textField文字数check
        let charactorCheck = Observable
            .combineLatest(myNameRelay.asObservable(),
                           targetRelay.asObservable())
            .map { my, target in
                return (my.count > 0 && my.count < 13 ) && ( target.count > 0 && target.count < 13)
        }
        self.isInputTextValid = onRegisterButtonClick
            .withLatestFrom(charactorCheck) { _, isValid in isValid }
        
        //投稿数Check
        self.postsCountCheck = { () -> Observable<Bool> in
            
            if let UDData = UD.object(forKey: Name.KeyName.uniqueNmame.rawValue) as? [[String : String]]  {
                switch UDData.count {
                case 0 ... 10: return Observable.of(true)
                default: return Observable.of(false)
                    //  userDataModel.setUserDefault()
                    //  userDataModel.setFirebase()
                }
            } else {
                //投稿値歴無し
                return Observable.of(true)
                //  userDataModel.setUserDefault()
                //  userDataModel.setFirebase()
            }
        }()
        
        //文字数と投稿数が両方check
        let postPossibleCheck = Observable
            .combineLatest(isInputTextValid, postsCountCheck) {
                $0 && $1
        }
        self.goToNext = onRegisterButtonClick
            .withLatestFrom(postPossibleCheck) { _, isValid in isValid }
            .filter { $0 }
//            .withLatestFrom(myNameRelay) { _, text1 in text1 }
        
        

        self.iconButtonImage = self.onImageSelected
            .asDriver(onErrorDriveWith: Driver<UIImage>.empty())
        
        self.outputs = self

    }
        */
  

        
           /*
            self.onRegisterButtonClick
            .withLatestFrom(self.buttonImage)
            .subscribe(onNext: { selectedImage in
            // 画像をアップロードする処理...
            })
            .disposed(by: disposeBag)
            */
    /*

class UserDataViewModel: UserViewModelInputs, UserViewModelInputs, viewModelType {
    var input: UserViewModelInputs
    var outputs: UserViewModelOutputs
    var inptus: UserViewModelInputs { return self }
    var outPuts: UserViewModelOutputs { return self }
*/




 