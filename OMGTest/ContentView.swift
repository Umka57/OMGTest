import SwiftUI

struct ContentView: View {
    
    @StateObject var vm = ViewModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                ForEach(vm.data, id: \.self) { row in
                    VStack(spacing: 10){
                        
                        Text("\(row.id + 1)")
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            LazyHStack(spacing: 10) {
                                
                                ForEach(vm.data[row.id].elements, id: \.self) { item in
                                    Cell(item: item)
                                }
                                
                            }
                            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        }
                    }
                    .id(row.id)
                    .onAppear {
                        vm.generateRow(rowIndex: row.id)
                    }
                    .onDisappear {
                        vm.rowIsInvisible(rowId: row.id)
                    }
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
