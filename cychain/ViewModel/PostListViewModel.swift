import Foundation
import RxSwift
import RxCocoa

struct PostListViewModel {
    let userdefault: SetUserDefault?
    let firebase: SetFirebase?
    private let disposeBag = DisposeBag()
    private let key = Name.KeyName.uniqueNmame.rawValue
    
    init(ud: SetUserDefault = SetUserDefault(), fb: SetFirebase = SetFirebase()) {
          self.userdefault = ud
          self.firebase = fb
      }
}

extension PostListViewModel: ViewModelType {

    struct Input {
        let onDeleteCell: Observable<IndexPath>
        let onSelectedCell: Observable<IndexPath>
    }
    
    struct Output {
        let cellObj: Observable<[PostListSectionModel]>?
        let selectedPairName: Observable<[String:String]>?
        let deleteCompleted: Observable<Void>
     }
    
    func transform(input: Input) -> Output {
        
        var cellObj = BehaviorRelay<[PostListSectionModel]>(value: [])
        //cell表示用データをuserDefaultから取得
        userdefault?.postListCellObj
            .subscribe(onNext: {
                if let value = $0 {
                    cellObj.accept([PostListSectionModel(items: value)])
                }
            })
            .disposed(by: disposeBag)
        
        //Cell押下 該当の名前(ペア)取得
        var selectedPairNames: Observable<[String:String]>? {
            input.onSelectedCell
                .withLatestFrom(cellObj) { indexPath, _  in
                    return cellObj.value[indexPath.section].items[indexPath.row]
            }
        }
        //Cell削除　→ userDefault削除、表示データ削除、Firebase削除
        let resetCellObj = input.onDeleteCell
            .flatMapLatest{ //delete(userdegfault)
                return self.userdefault!.reset(indexPath: $0)
        }
        .do(onNext: {self.firebase!.delete(data: $0)})
        .map{_ in ()}
        
        return Output(cellObj: cellObj.asObservable(),
                      selectedPairName: selectedPairNames,
                      deleteCompleted: resetCellObj )
    }
}
