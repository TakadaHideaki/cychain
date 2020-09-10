import Foundation
import RxSwift
import RxCocoa

struct EditViewModel {
    
    let userdefault: SetUserDefault?
    let firebase: SetFirebase?
    private let model = EditModel.shared
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
            let SwitchUIHiden: Driver<Bool>
            let NoData: Observable<Void>
            let initialScreenData: Observable<Texts>
            let onIcButtonClickEvent: Observable<Void>
            let messageTapp: Observable<Void>
            let selectedImage: Observable<UIImage>
            let iconButtonImage: Driver<UIImage>
            let messageLabelEnable: Driver<Bool>
            let nextVC: Observable<Texts>
        }
        
        func transform(input: Input) -> Output {
            //データが表示されるまでIndicatorを回す為のPropaty
            let SwitchUIHiden = model.data
            .skip(1)
                .withLatestFrom(self.model.noData)
                .map{ _ in false}
                .startWith(true)
                .asDriver(onErrorDriveWith: Driver.empty())
                .debug()
            
            //表示用データが無かった時用（通常はあり得ない）
            let NoData = model.noData
                .skip(1)
                .do(onNext: { self.model.deletePostData(data: $0) })
                .map{_ in ()}
                .debug()
            
            //表示用データ
            let initialScreenData = model.data
                .compactMap{$0}
                .skip(1)
                .debug()
            
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
            
            return Output(SwitchUIHiden: SwitchUIHiden,
                          NoData: NoData,
                          initialScreenData: initialScreenData,
                          onIcButtonClickEvent: input.iconButtontapped,
                          messageTapp: input.messageTapped.asObservable(),
                          selectedImage: input.imageSelected,
                          iconButtonImage: input.imageCropped.asDriver(onErrorDriveWith: Driver.empty()),
                          messageLabelEnable: messageTextCountCheck,
                          nextVC: nextVC)
        }
        
    }




