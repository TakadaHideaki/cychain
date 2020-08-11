import Foundation
import RxSwift
import RxCocoa

struct PostListViewModel {
    let userdefault = setUserDefault()
    let firebase = setFirebase()
    private let disposeBag = DisposeBag()
    private let key = Name.KeyName.uniqueNmame.rawValue
}

extension PostListViewModel: ViewModelType {

    struct Input {
        let onDeleteCell: Observable<IndexPath> //Cell削除が押された
        let onSelectedCell: Observable<IndexPath> //Cellが選択された
    }
    
    struct Output {
        let cellObj: Observable<[PostListSectionModel]>? //表示用データ
        let selectedPairName: Observable<[String:String]>? //　セルタップでラップした名前を返す
        let deleteCompleted: Observable<Void> //　セル削除の処理が完了
     }
    
     func transform(input: Input) -> Output {
        
        var cellObj = BehaviorRelay<[PostListSectionModel]>(value: [])
        //damyData
        // self.postListRelay.accept([PostListSectionModel(items: [["a": "b"], ["c": "d"],["v": "v"]])])
        
        //cell表示用データをuserDefaultから取得
        UD.rx.observe([[String: String]].self, self.key)
            .subscribe(onNext: {
                if let value = $0 {
                     cellObj.accept([PostListSectionModel(items: value)])
                }
            })
            .disposed(by: disposeBag)

        
        //Cell押下で該当の名前(ペア)を取得
        var selectedPairNames: Observable<[String:String]>? {
            input.onSelectedCell
                .withLatestFrom(cellObj) { indexPath, _  in
                    return self.userdefault.readUserdefault(indexPath:indexPath)
            }
        }
            
        //Cell削除→ 表示用Cellデータから該当データ(名前)を削除
        let resetpostList = { (udData : [[String: String]]) -> Observable<[[String: String]]> in
            //            postList = Observable.just([PostListSectionModel(items: udData)])
            cellObj.accept([PostListSectionModel(items: udData)])
            return Observable.just(udData)
        }
        //Cell削除　→ userDefault削除、表示データ削除、Firebase削除
        let resetCellObj = input.onDeleteCell
            .flatMapLatest{ //delete(userdegfault)
                return self.userdefault.reset(indexPath: $0)
        }
            .flatMap { //表示用CellDataセット
                return resetpostList($0)
        }
            .flatMap { //delete(firebase)
                return self.firebase.delete(data: $0)
        }
        
        return Output(cellObj: cellObj.asObservable(),
                      selectedPairName: selectedPairNames,
                      deleteCompleted: resetCellObj )
    }
    
}

