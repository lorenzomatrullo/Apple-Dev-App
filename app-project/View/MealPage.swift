import Foundation
import SwiftUI

struct MealPage: View {
    @EnvironmentObject var model: Model
    @State var showPageInvalidMessage = false
    @State var errorMessage = ""
    
    private var meal: RecipesList
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    init(_ meal: RecipesList) {
        self.meal = meal
    }
    
    var body: some View {
        VStack {
            Form {
                RecipesView(meal)
                
                VStack (alignment: .leading) {
                    Text("TIME: " + String(meal.timeToCook) + " minutes")
                    Text("DIFFICULTY: ⭐️⭐️⭐️")
                }
                .padding(.top, 20)
            }
            
            NavigationLink(destination: StepPageView(meal)) {
                Image(systemName: "arrowshape.right.fill")
            }
            .font(Font.system(size: 30))
            .foregroundStyle(.green)
            .tint(.red)
            .buttonStyle(.bordered)
            
        }
        .navigationTitle("Meal Page")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MealPage_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMeal = RecipesList(
            recipeName: "Pasta",
            ingredients: "patate, provola",
            numberOfSteps: 10,
            imageName: "pasta",
            timeToCook: 10,
            steps: []
        )
        MealPage(sampleMeal).environmentObject(Model())
    }
}
