import Foundation
import SwiftUI

struct ContentView: View {
    @StateObject var model = Model()
    @State var tabSelection = 0
    
    var body: some View {
        VStack {
            AlertView()
        }.environmentObject(model)
    }
}

#Preview {
    ContentView()
}
