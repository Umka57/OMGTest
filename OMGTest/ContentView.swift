import SwiftUI

struct Row: Hashable, Equatable {
    
    var id: Int
    var elements: [Element]
    
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

class DataStore: ObservableObject {
    
    @Published var data: [Row] = []
    
    init() {
        generateData()
        startUpdatingData()
    }
    
    func generateData() {
        for i in 0...150 {
            var elements: [Element] = []
            for j in 0...20 {
                let newElement = Element(id: j, value: Int.random(in: 1...100))
                elements.append(newElement)
            }
            data.append(Row(id: i, elements: elements))
        }
    }
    
    func startUpdatingData() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            DispatchQueue.main.async {
                self.updateRandomElement()
            }
        }
    }
    
    func updateRandomElement() {
        guard !data.isEmpty else { return }
        data.forEach({ row in
            let randomIndex = Int.random(in: 0..<row.elements.count)
            data[row.id].elements[randomIndex].value = Int.random(in: 1...100)
        })
    }
}


struct ContentView: View {
    
    @StateObject var dataStore = DataStore()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                ForEach(dataStore.data, id: \.self) { row in
                    VStack(spacing: 10){
                        
                        Text("\(row.id + 1)")
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            LazyHStack(spacing: 10) {
                                
                                ForEach(dataStore.data[row.id].elements, id: \.self) { item in
                                    Cell(item: item)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                        .padding(.horizontal, 8)
                    }
                    .id(row.id)
                }
            }
        }
        .padding(.vertical)
    }
}


#Preview {
    ContentView()
}

private struct Cell: View {
    
    @State var isTapped: Bool = false
    
    let item: Element
    
    var body: some View {
            Text("\(item.value)")
                .frame(width: isTapped ? (50 * 0.8) : 50, height: isTapped ? (50 * 0.8) : 50)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.yellow, lineWidth: 1)
                )
                .id(item.id)
                .onTapGesture {
                    isTapped = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isTapped = false
                    }
                }
        
        // Не очень понял требование про тап, поэтому есть еще такой вариант, но он перекрывает firstResponder и scrollview не работает
//                .onLongPressGesture(minimumDuration: 30) { (isPressing) in
//                    if isPressing {
//                        withAnimation(.easeInOut) {
//                            isTapped = true
//                        }
//                    } else {
//                        withAnimation(.easeInOut) {
//                            isTapped = false
//                        }
//                    }
//                } perform: {
//                    withAnimation(.easeInOut) {
//                        isTapped = false
//                    }
//                }
    }
}
