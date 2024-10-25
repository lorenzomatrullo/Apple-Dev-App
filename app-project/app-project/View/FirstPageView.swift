import Foundation
import SwiftUI

struct FirstPageView: View {
    @EnvironmentObject var model: Model
    
    var body: some View {
        VStack (alignment: .leading) {
            Spacer().frame(height: 30)
            
            Text("   Recipes").font(.title).bold()
            
            
            NavigationView {
                List {
                    ForEach (self.model.recipes, id: \.self) { item in
                        NavigationLink (destination: MealPage(item)) {
                            RecipesView(item)
                        }
                    }
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                }
            }.padding(.top, -10)
        }
    }
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            FirstPageView().environmentObject(Model())
        }
    }
}
