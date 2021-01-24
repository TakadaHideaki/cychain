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
            let searchingUI: Driver<Bool>
            let NoData: Observable<Void>
            let initScreenData: Observable<PostDatas>
            let onIcButtonClickEvent: Observable<Void>
            let messageTapp: Observable<Void>
            let selectedImage: Observable<UIImage>
            let iconButtonImage: Driver<UIImage>
            let messageLabelEnable: Driver<Bool>
            let nextVC: Observable<PostDatas>
        }
        
        func transform(input: Input) -> Output {
            //データが表示されるまでIndicatorを回す為のPropaty
            let Applicable = model.data.map{ _ in false}
            let NA = model.noData.map{ _ in false }
            
            let searchingUI = Observable
                .of(Applicable, NA)
                .merge()
                .startWith(true)
                .asDriver(onErrorDriveWith: Driver.empty())
            
            //表示用データが無かった時用（通常はあり得ない）
            let NoData = model.noData
                .skip(1)
                .do(onNext: { self.model.deletePostData(data: $0) })
                .map{_ in ()}
            
            //表示用データ
            let archive = model.data
                .compactMap{$0}
            
            //　① PostDataを纏めTextsへ
            let substitutionToTexts = Observable
                .combineLatest(input.myNameRelay.asObservable(),
                               input.targetRelay.asObservable(),
                               input.messageRelay.asObservable(),
                               input.imageCropped.asObservable()) { my, target, msg, img  in
                                PostDatas(my: my,
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
            
            return Output(searchingUI: searchingUI,
                          NoData: NoData,
                          initScreenData: archive,
                          onIcButtonClickEvent: input.iconButtontapped,
                          messageTapp: input.messageTapped.asObservable(),
                          selectedImage: input.imageSelected,
                          iconButtonImage: input.imageCropped.asDriver(onErrorDriveWith: Driver.empty()),
                          messageLabelEnable: messageTextCountCheck,
                          nextVC: nextVC)
        }
        
    }
