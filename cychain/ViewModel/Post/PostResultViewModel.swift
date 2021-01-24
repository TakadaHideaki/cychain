import Foundation
import RxSwift

struct PostResultViewModel {
    private var model = postResultModel.shared
    private let disposeBag = DisposeBag()
    
    struct Output {
        let cellObj: Observable<[SectionModel]>
    }
    
    func transform() -> Output {

        var items: Observable<[SectionModel]> { model.sectionData.map { value in
               return [SectionModel(sectionTitle: "PostCard",
                                    items: [["my": value[0].my,
                                             "target": value[0].target,
                                             "icon": value[0].iconImage]]),
                       SectionModel(sectionTitle: "Message",
                                    items: [["message": value[0].message]]) ]
               }
           }
        return Output(cellObj: items)
    }
    
}
