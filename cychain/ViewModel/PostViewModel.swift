import Foundation
import RxSwift
import RxCocoa

struct PostDatas {
    let my: String
    let target: String
    var message: String
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
        let myNameRelay: Observable<String>
        let targetRelay: Observable<String>
        let messageRelay: Observable<String>
        let imageSelected: Observable<UIImage>
        let imageCropped: Observable<UIImage>
    }
    
    struct Output {
        let onIcButtonClickEvent: Observable<Void>
        let selectedImage: Observable<UIImage>
        let iconButtonImage: Driver<UIImage>
        let messageLabelEnable: Driver<Bool>
        let postsCountOver: Observable<Void>
        let characterCountOverrun: Observable<Void>
        let nextVC: Observable<PostDatas>
    }
    
    func transform(input: Input) -> Output {
        
        //　投稿数Check
        var postsCheck: Observable<Bool> {
            return Observable.just(
                UD.array(forKey: Name.KeyName.uniqueNmame.rawValue)!.count < 10
            )
        }
        //　PostDataをTextsへ格納
        let substitutionToTexts = Observable
            .combineLatest(input.myNameRelay.asObservable(),
                           input.targetRelay.asObservable(),
                           input.messageRelay.asObservable(),
                           input.imageCropped.asObservable()) { my, target, message, iconImage  in
                            PostDatas(my: my,
                                  target: target,
                                  message: message,
                                  iconImage: iconImage)
        }
        .share()
        
        // 投稿数チェック
        let postCountCheck = input.postButtontapped.withLatestFrom(postsCheck)
        // 投稿数NG
        let postsCountOver = postCountCheck .filter { !$0 }.map { _ in () }
        // 投稿数OK　→　文字数チェック
        let postsCountCleared = postCountCheck.filter { $0 }.map { _ in () }
            .withLatestFrom(substitutionToTexts) { _, texts in texts }
        // 文字数NG
        let overrun = postsCountCleared.filter { !$0.isValid }.map { _ in () }
        // 文字数OK
        let cleared = postsCountCleared.filter { $0.isValid }
            .do(onNext: {
                self.userdefault?.setUd(data: $0)
                self.firebase?.set(data: $0) })
        
        //Labelの表示/非表示制御
        let messageTextCountCheck = input.messageRelay
            .map{ return $0.count > 0 }
            .asDriver(onErrorDriveWith: Driver.empty())
        
        
        return Output(onIcButtonClickEvent: input.iconButtontapped,
                      selectedImage: input.imageSelected,
                      iconButtonImage: input.imageCropped.asDriver(onErrorDriveWith: Driver.empty()),
                      messageLabelEnable: messageTextCountCheck,
                      postsCountOver: postsCountOver,
                      characterCountOverrun: overrun,
                      nextVC: cleared
        )
    }
}
