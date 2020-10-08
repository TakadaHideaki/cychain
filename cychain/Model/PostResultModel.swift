import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct postResultModel {
    static let shared = postResultModel()
    private init() {}
    
    private let sectionDataRelay = BehaviorRelay<[PostDatas]>( value: [PostDatas(my: "",
                                              target: "",
                                              message: "",
                                              iconImage: R.image.user10()! )]
    )
//    private let sectionDataRelay = PublishRelay<[PostDatas]>()
    var sectionData: Observable<[PostDatas]> { return sectionDataRelay.asObservable() }
    
    func dataSet(data: PostDatas) {
        self.sectionDataRelay.accept([data])
    }
}

struct SectionModel {
    var sectionTitle: String
    var items: [Item]

}

extension SectionModel: SectionModelType {
    typealias Item = [String: Any]
    
    init(original: SectionModel, items: [Item] ) {
        self = original
        self.items = items
    }
}
