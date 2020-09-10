import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct postResultModel {
    static let shared = postResultModel()
    private init() {}
    
    let sectionDataRelay = BehaviorRelay<[Texts]>( value: [Texts(my: "",
                                              target: "",
                                              message: "",
                                              iconImage: R.image.user10()! )]
    )
    
    var sectionData: Observable<[Texts]> {
        return sectionDataRelay.asObservable()
    }
    
    func dataSet(data: Texts) {
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
