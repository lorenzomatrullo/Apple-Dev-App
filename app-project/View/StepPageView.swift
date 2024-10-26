import Foundation
import SwiftUI


struct CookingState {
    var currentStep: Int
}


struct StepPageView: View {
    @EnvironmentObject var model: Model
    
    private var meal: RecipesList
    
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
      
      // To keep track of the curent progress
      @State private var cookingState = CookingState(currentStep: 0)
    

    init(_ meal: RecipesList) {
        self.meal = meal
    }
    
    var body: some View {
        VStack(alignment: .center) {
            
            Text("Let's cook \(meal.recipeName)")
                    .font(.largeTitle)
                    .padding(.top, 10)
            
            // Display the recipe image
            Image(meal.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                

            
            // Add some space
            Spacer().frame(height: 20)

            // Display the current step information
            Text("Step: \(cookingState.currentStep + 1) of \(meal.numberOfSteps)")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 10)
                .padding(.vertical, 5)

            // Step description
            Text("\(meal.steps[cookingState.currentStep].description)")
                .padding(.bottom, 10)

            Spacer()
            
            // HStack for navigation buttons
            HStack {
                
                if(cookingState.currentStep > 0)
                {
                    // Button to return to the previous step
                    Button(action: {
                        if cookingState.currentStep > 0 {
                            cookingState.currentStep -= 1
                        }
                    }) {
                        Text("Previous Step")
                            .padding()
                            .background(Color.blue.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }
                }
                // Button to progress to the next step
                Button(action: {
                    if cookingState.currentStep < meal.numberOfSteps - 1 {
                        cookingState.currentStep += 1
                    }
                }) {
                    Text("Next Step")
                        .padding()
                        .background(Color.green.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
            }
            .padding(.top, 20)
        }
        .padding()
    }
}

struct StepPage_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMeal = RecipesList(
            recipeName: "Pasta",
            ingredients: "patate, provola",
            numberOfSteps: 10,
            imageName: "pasta",
            steps:
                [
                RecipeStep(
                    step: "1. Preparare la pasta",
                    imageName: "pasta",
                    description: """
                    Let’s gather all the ingredients and place them on a clean, accessible table. When you’re ready with everything on the table, say ‘ready.’

                    Ingredients:
                    • Olive oil
                    • Garlic
                    • Canned tomato sauce
                    • Salt
                    • Pepper
                    • Fresh basil leaves (optional)
                    • Pasta (spaghetti, penne, or your choice)
                    • Grated Parmesan or Pecorino cheese (optional)
                    """),
                
                RecipeStep(
                    step: "2. Preparare le patate",
                    imageName: "patate",
                    description: "Place tomatoes in a large pot and cover with cold water. Bring just to a boil. Pour off water, and cover again with cold water. Peel the skin off tomatoes and cut into small pieces."
                ),
                
                RecipeStep(
                    step: "3. Cuocere la pasta",
                    imageName: "pasta",
                    description: "Meanwhile, heat olive oil in a large skillet or pan, making sure there is enough to cover the bottom of the pan, and sauté garlic until opaque but not browned. Stir in tomato paste. Immediately stir in the tomatoes, salt, and pepper. Reduce heat, and simmer until pasta is ready, adding basil at the end."
                ),
                
                RecipeStep(
                    step: "3. Cuocere la pasta",
                    imageName: "pasta",
                    description: "Drain pasta, do not rinse in cold water. Toss with a bit of olive oil, then mix into the sauce."
                ),
            ]
        )
        StepPageView(sampleMeal).environmentObject(Model())
    }
}
