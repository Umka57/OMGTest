import Foundation

import Combine

class ViewModel: ObservableObject {
    
    @Published var data: [Row] = []
    
    private var timer: AnyCancellable?
    
    init() {
        
        generateData()
        
        timer = Timer.publish(every: 1, on: .main, in: .common)
                    .autoconnect()
                    .sink { [weak self] _ in
                        self?.updateRandomElement()
                    }
    }
    
    func generateRow(rowIndex: Int) {
        if data[rowIndex].elements == [] {
            var elements: [Element] = []
            for j in 0...20 {
                let newElement = Element(id: j, value: Int.random(in: 1...100))
                elements.append(newElement)
            }
            data[rowIndex].elements = elements
        }
        data[rowIndex].isVisible.toggle()
    }
    
    func generateData() {
        for i in 0...150 {
            let elements: [Element] = []
            data.append(Row(id: i, elements: elements))
        }
    }
    
    func updateRandomElement() {
        data.forEach({ row in
            if row.isVisible && row.elements != [] {
                let randomIndex = Int.random(in: 0..<row.elements.count)
                data[row.id].elements[randomIndex].value = Int.random(in: 1...100)
            }
        })
    }
    
    func rowIsInvisible(rowId: Int) {
        data[rowId].isVisible.toggle()
    }
}
