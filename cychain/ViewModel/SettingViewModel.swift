import Foundation
import RxSwift
import RxCocoa

struct SettingViewModel {
    private let model = SettingModel()
    private let disposeBag = DisposeBag()
}

extension SettingViewModel: ViewModelType {
 
    struct Input {
        let didSelectedCell: Observable<IndexPath>
    }
    
    struct Output {
        let cellObj: Observable<[SettingSectionModel]>
        let selectedCellEvent: Observable<SettingViewModel.Settings>
        let logOutEvent: Observable<LogOut>
        let signOutEvent: Observable<SignOut>
    }
    
     func transform(input: Input) -> Output {
        
        let cellObj = BehaviorRelay<[SettingSectionModel]>(
            value: [SettingSectionModel(sectionTitle: model.sectionTitle[0],
                                        items: model.account),
                    SettingSectionModel(sectionTitle: model.sectionTitle[1],
                                        items: model.other)
            ]
        )
        
       let menu = input.didSelectedCell
            .do(onNext: { self.cellTapEvent(indexPath: $0)})
            .compactMap { Settings(index: $0) }
        
        let logOut = model.logOutEvent.skip(1)
        let signOut = model.signOutEvent.skip(1)

        return Output(cellObj: cellObj.asObservable(),
                      selectedCellEvent: menu,
                      logOutEvent: logOut,
                      signOutEvent: signOut
        )
    }
    
    
    
    enum Settings {
        case logOut
        case signOut
        case inquiry
        case terms
        case privacy
        init?(index: IndexPath) {
            switch (index.section, index.row) {
            case (0, 0):
                self = .logOut
            case (0, 1):
                self = .signOut
            case (1, 0):
                self = .inquiry
            case (1, 1):
                self = .terms
            case (1, 2):
                self = .privacy
            default:
                return nil
            }
        }
    }
     func cellTapEvent(indexPath: IndexPath) {
        guard let selectedMenu = Settings(index: indexPath) else { return }
        switch selectedMenu  {
        case .logOut: model.logOut()
        case .signOut: model.signOut()
        case .inquiry, .terms, .privacy: break
        }
    }
    
    
    
    
    
    
    
}




