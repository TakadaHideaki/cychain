import Foundation
import RxDataSources

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

