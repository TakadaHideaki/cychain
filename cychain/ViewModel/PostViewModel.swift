import Foundation
import RxSwift
import RxCocoa

struct Texts {
    let my: String
    let target: String
    let message: String
    var iconImage: UIImage

    var isValid: Bool {
        return ![my, target].map { checkChars($0) }.contains(false)
    }
    private func checkChars(_ text: String) -> Bool {
        return text.count > 0 && text.count < 13
    }
}

struct PostViewModel {
    let userdefault: SetUserDefault?
    let firebase: SetFirebase?
    private let disposeBag = DisposeBag()
    
      init(ud: SetUserDefault = SetUserDefault(), fb: SetFirebase = SetFirebase()) {
          self.userdefault = ud
          self.firebase = fb
      }
}

extension PostViewModel: ViewModelType {
    struct Input {
        let postButtontapped: Observable<Void>
        let iconButtontapped: Observable<Void>
        let messageTapped: Observable<Void>
        let myNameRelay: Observable<String>
        let targetRelay: Observable<String>
        let messageRelay: Observable<String>
        let imageSelected: Observable<UIImage>
        let imageCropped: Observable<UIImage>
    }
    
    struct Output {
        let onIcButtonClickEvent: Observable<Void>
        let messageTapp: Observable<Void>
        let selectedImage: Observable<UIImage>
        let iconButtonImage: Driver<UIImage>
        let messageLabelEnable: Driver<Bool>
        let postsCountOver: Observable<Bool>
        let characterCountOverrun: Observable<Void>
        let nextVC: Observable<Texts>
    }
    
    func transform(input: Input) -> Output {
        
        //① 投稿数Check
        var postsCheck: Observable<Bool> {
            return Observable.just(
                UD.array(forKey: Name.KeyName.uniqueNmame.rawValue)!.count < 10
            )
        }
        //② PostDataを纏めTextsへ
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
        
        //③ 投稿ボタン押下→投稿数クリア(①) →Textsに投稿データをセット(②)
        let postButtonTap = input.postButtontapped
            .withLatestFrom(postsCheck)
            .filter { $0 }
            .map { _ in () }
            .withLatestFrom(substitutionToTexts) { _, texts in texts }
       
        // ③→ 文字数NG
        let overrun = postButtonTap.filter { !$0.isValid }.map { _ in () }
   
        // ③→ 文字数OK
        let apprppriate = postButtonTap.filter { $0.isValid }
            .do(onNext: {
                self.userdefault?.setUd(data: $0)
                self.firebase?.set(data: $0)
//                Observable.from(optional: $0)
            })
        
        //Labelの表示/非表示制御
        let messageTextCountCheck = input.messageRelay
            .map{ return $0.count > 0 }
            .asDriver(onErrorDriveWith: Driver.empty())
        
        
        return Output(onIcButtonClickEvent: input.iconButtontapped,
                      messageTapp: input.messageTapped,
                      selectedImage: input.imageSelected,
                      iconButtonImage: input.imageCropped.asDriver(onErrorDriveWith: Driver.empty()),
                      messageLabelEnable: messageTextCountCheck,
                      postsCountOver: postsCheck,
                      characterCountOverrun: overrun,
                      nextVC: apprppriate
        )
    }
}
