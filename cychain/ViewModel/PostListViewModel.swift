import Foundation
import RxSwift
import RxCocoa

struct PostListViewModel {
    let userDa = setUserDefault()
    let readUserDefault = ReadUserDefault()
    private let disposeBag = DisposeBag()
    private let postListRelay = BehaviorRelay<[PostListSectionModel]>(value: [PostListSectionModel(items: [["": ""]])])
    var postList: Observable<[PostListSectionModel]> {
        return postListRelay.asObservable()
    }
//    init(){}
//    init() {
//        self.readUserDefault = ReadUserDefault()
//    }
}
extension PostListViewModel: ViewModelType {

    struct Input {
        let onDeleteCell: Observable<IndexPath>
        let onSelectedCell: Observable<IndexPath>
    }
    
    struct Output {
         let cellObj: Observable<[PostListSectionModel]>
         let p = BehaviorRelay<[PostListSectionModel]>(value: [PostListSectionModel(items: [["": ""]])])
//        let dele: Observable<IndexPath>
        let deleteCompleted: Observable<[[String:String]]>
     }
    
        func transform(input: Input) -> Output {

        let damy = [["a": "b"], ["c": "d"],["v": "v"]]
        self.postListRelay.accept([PostListSectionModel(items: damy)])

        /* // damyData
        var items: Observable<[PostListSectionModel]>!
        let damy = [["a": "b"], ["c": "d"],["v": "v"]]
        items = Observable.just([PostListSectionModel(items: damy)])
         */
        

            let selected = {
                //値渡し
                //編集画面へ画面遷移
            }

            let resetCellObj = {(indexPath: IndexPath) -> [[String: String]] in
                
                var postLists = self.postListRelay.value[indexPath.section]
                postLists.items.remove(at: indexPath.row)
                self.postListRelay.accept([postLists])
                return postLists.items
            }
            
            let a = input.onDeleteCell
                .map { return resetCellObj($0)}
                .map { return self.userDa.reset(data: $0)}
                
      
//        return Output(cellObj: self.postList)
            return Output(cellObj: self.postList,
//                          dele: input.onDeleteCell
                deleteCompleted: a
            )

    }
    
}

//init() {
//     self.readUserDefault = ReadUserDefault()
//     let items: Observable<[PostListSectionModel]>
//     if let ud = readUserDefault?.a() {
//         //        let my = ud.map{$0.keys.sorted()}.flatMap{$0}
//         //        let target = ud.map{$0.values.sorted()}.flatMap{$0}
//         items = Observable
//         .just([PostListSectionModel(/*myname: my,*/items: ud)])
//     }
// }




//extension PostListViewModel: ViewModelType {
//
//    struct Input {
//        let postData: Observable<[Texts]>
//    }
//
//    struct Output {
//        let cellObj: Observable<[PostListSectionModel]>
//    }
//    func transform(input: Input) -> Output {
//
//        var List: Observable<[PostListSectionModel]>
//
//        var a = readUserDefault!.postDataList
//
//
//
//
//        return Output(cellObj: List)
//    }
//
//}

