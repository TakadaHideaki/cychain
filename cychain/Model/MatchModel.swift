import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class MatchModel {
    
    static let shared = MatchModel()
    private init() {}
    
    var singleMatch: [String: [String: Any]]?
    var reportData: [String: String]?
    var blockID: Observable<String>?
    var data: [String: [String: Any]]?
    var iDAray = [String]()
    var values = [[String: Any]]()
    let sectionTitle = ["PostCard", "Message"]
    
    func setData(data: MatchData) {
        
        let user = data.searchWord.userName
        let search = data.searchWord.searchName
        let id = data.data.map{$0.0}[0]
        let msg = data.data.map{$0.1}[0]["message"]as? String ?? ""
        let icon = R.image.user12()!
        
        if let stringImage = data.data.map({$0.1})[0]["image"] as? String {
            convertURLtoUIImage(stringImage: stringImage, { complete in
                self.singleMatch = [id:["user": user, "search": search, "msg": msg, "image": complete]]
            })
        } else {
            self.singleMatch = [id:["user": user, "search": search, "msg": msg, "image": icon]]
        }
        
        self.reportData = ["user": user, "search": search, "msg": msg]
        self.blockID = Observable.just(id)
        
        var data = data.data
        data.forEach {
            if let urlImage = $0.value["image"] as? String {
                let id = $0.key
                var img: UIImage?
                convertURLtoUIImage(stringImage: urlImage, { complete in
                    img = complete
                })
                data[id]!["image"] = img
                self.iDAray += [id]
                self.values += [data[id]!]
            
            } else {
                let id = $0.key
                data[id]?["image"] = R.image.user12()!
                self.iDAray += [id]
                self.values += [data[id]!]
            }
        }
    }
    
    func convertURLtoUIImage(stringImage: String, _ complete: @escaping (UIImage) -> ()) {

        let url = URL(string: stringImage) //let url = urlString.flatMap(URL.init)でも可
        DispatchQueue.global().async {
            do {
                let imageData = try Data(contentsOf: url!)
                DispatchQueue.main.async {
                    complete(UIImage(data:imageData as Data)!)
                }
            } catch {
                return
            }
        }
    }
    
    func registBlockID(blockID: String) {
        var block = UD.array(forKey: Name.KeyName.block.rawValue) ?? []
        block += [blockID]
        UD.set(block, forKey: Name.KeyName.block.rawValue)
    }
}

struct MatchSectionModel {
    var sectionTitle: String
    var items: [Item]
}

extension MatchSectionModel: SectionModelType {
    
    typealias Item = [String:[String: Any]]
    
    init(original: MatchSectionModel, items: [Item] ) {
        self = original
        self.items = items
    }
}

