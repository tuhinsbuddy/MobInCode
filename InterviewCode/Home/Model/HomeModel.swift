
import Foundation

struct HomeModel {
    let index: Int
    let title: String
    let childs: [String]
    
    init(index: Int, title: String, childs: [String]) {
        self.index = index
        self.title = title
        self.childs = childs
    }
}
