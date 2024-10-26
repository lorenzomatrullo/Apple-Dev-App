import Foundation
import SwiftUI

struct FirstPageView: View {
    @EnvironmentObject var model: Model
    
    var body: some View {
        NavigationView {
            List {
                ForEach(self.model.recipes, id: \.self) { item in
                    NavigationLink(destination: MealPage(item)) {
                        RecipesView(item)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Text("Recipes")
                .font(.title)
                .bold()
                .foregroundColor(.primary)
                .padding(.top, 15)
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FirstPageView().environmentObject(Model())
    }
}
