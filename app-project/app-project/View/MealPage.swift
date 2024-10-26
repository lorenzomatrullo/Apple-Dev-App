import Foundation
import SwiftUI

struct MealPage: View {
    @EnvironmentObject var model: Model
    @State var showPageInvalidMessage = false
    @State var errorMessage = ""
    
    private var meal: RecipesList
    @State var time: Int = 10
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    init(_ meal: RecipesList) {
        self.meal = meal
    }
    
    
    var body: some View {
        VStack {
            Form {
                RecipesView(meal)
                
                HStack {
                    Text("TIME:").font(.subheadline)
                    
                    TextField("", value: $time, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .onChange(of: time) { value in
                            if value == 0 {
                                time = 1
                            }
                        }
                }
                .padding(.top, 20)
            }
            
            
            // Button to navigate to StepPageView
            NavigationLink(destination: StepPageView(meal)) {
                Text("Let's Cook")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
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
            steps: []
        )
        MealPage(sampleMeal).environmentObject(Model())
    }
}
