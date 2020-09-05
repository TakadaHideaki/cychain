import Foundation
import RxSwift
import RxCocoa

struct EditViewModel {
    
    let userdefault: SetUserDefault?
    let firebase: SetFirebase?
    private let disposeBag = DisposeBag()
    
      init(ud: SetUserDefault = SetUserDefault(), fb: SetFirebase = SetFirebase()) {
          self.userdefault = ud
          self.firebase = fb
      }
}
    
    extension EditViewModel: ViewModelType {
        
        struct Input {
            let iconButtontapped: Observable<Void>
            let postButtontapped: Observable<Void>
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
            let nextVC: Observable<Texts>
        }
        
        func transform(input: Input) -> Output {
            
            //　① PostDataを纏めTextsへ
            let substitutionToTexts = Observable
                .combineLatest(input.myNameRelay.asObservable(),
                               input.targetRelay.asObservable(),
                               input.messageRelay.asObservable(),
                               input.imageCropped.asObservable()) { my, target, msg, img  in
                                Texts(my: my,
                                      target: target,
                                      message: msg,
                                      iconImage: img)
            }
            //　② EditButtonTap→ ①Execution
            let nextVC = input.postButtontapped
                .withLatestFrom(substitutionToTexts) { _, texts in texts }
                .do(onNext: {
                    self.firebase?.set(data: $0)
                })
            //LabelのHidden
            let messageTextCountCheck = input.messageRelay
                .map{ return $0.count > 0 }
                .asDriver(onErrorDriveWith: Driver.empty())
            
            return Output(onIcButtonClickEvent: input.iconButtontapped,
                          messageTapp: input.messageTapped.asObservable(),
                          selectedImage: input.imageSelected,
                          iconButtonImage: input.imageCropped.asDriver(onErrorDriveWith: Driver.empty()),
                          messageLabelEnable: messageTextCountCheck,
                          nextVC: nextVC)
        }
        
    }




