import Foundation
import RxSwift

struct InitialModel {
    
    func sentence(fileName: String) -> String  {
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "txt"),
              let fileContents = try? String(contentsOf: fileURL) else { return ""}
        return fileContents
    }
}
