import Foundation

struct Row: Hashable, Equatable {
    
    var id: Int
    var elements: [Element]
    var isVisible: Bool = false
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Row, rhs: Row) -> Bool {
        lhs.id == rhs.id
    }
}

struct Element: Hashable, Equatable {
    
    var id: Int
    var value: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Element, rhs: Element) -> Bool {
        lhs.id == rhs.id
    }
}
