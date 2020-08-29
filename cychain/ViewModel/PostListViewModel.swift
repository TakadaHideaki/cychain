import Foundation
import RxSwift
import RxCocoa

struct PostListViewModel {
    let userdefault: SetUserDefault?
    let firebase: SetFirebase?
//    let model = PostListModel()
    private let disposeBag = DisposeBag()
    private let key = Name.KeyName.uniqueNmame.rawValue
    init(ud: SetUserDefault = SetUserDefault(), fb: SetFirebase = SetFirebase()) {
          self.userdefault = ud
          self.firebase = fb
      }
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
        
//        model.observeUserDefault(complete: { complete in
//        cellObj.accept([PostListSectionModel(items: complete)])

        //cell表示用データをuserDefaultから取得
        UD.rx.observe([[String: String]].self, self.key)
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



                //Cell削除→ 表示用Cellデータから該当データ(名前)を削除
        //        let resetpostList = { (udData : [[String: String]]) -> Observable<[[String: String]]> in
        //            //            postList = Observable.just([PostListSectionModel(items: udData)])
        //            let a = cellObj.value
        //            log.debug(a)
        ////            cellObj.accept([PostListSectionModel(items: udData)])
        //            return Observable.just(udData)
        //        }
        
        
//            .flatMap { //表示用CellDataセット
//                return resetpostList($0)
//        }
//            .flatMap { //delete(firebase)
//                return self.firebase!.delete(data: $0)
//        }

