import Foundation
import RxSwift
import RxCocoa

struct PostResultViewModel {
    private let disposeBag = DisposeBag()
}

extension PostResultViewModel: ViewModelType {
    
    struct Input {
        let postData: Observable<[Texts]>
    }
    
    struct Output {
        let cellObj: Observable<[SectionModel]>
    }
    
    func transform(input: Input) -> Output {
        
        var items: Observable<[SectionModel]> { input.postData.map { value in
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
