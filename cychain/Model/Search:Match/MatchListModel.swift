import Foundation
import RxDataSources

struct MultipleSectionModel {
    var items: [Item]
}
extension MultipleSectionModel: SectionModelType {
    typealias Item = [String]
    
    init(original: MultipleSectionModel, items: [Item] ) {
        self = original
        self.items = items
    }
}
