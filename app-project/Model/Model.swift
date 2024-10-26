import Foundation
import SwiftUI

struct RecipesList: Hashable {
    let recipeName: String
    let ingredients: String
    let numberOfSteps: Int
    let imageName: String
    let timeToCook : Int
    let steps: [RecipeStep] // Array of steps
    
    init(recipeName: String = "", ingredients: String = "", numberOfSteps: Int = 0, imageName: String = "", timeToCook: Int = 0, steps: [RecipeStep] = [])
    {
        self.recipeName = recipeName
        self.ingredients = ingredients
        self.numberOfSteps = numberOfSteps
        self.imageName = imageName
        self.timeToCook = timeToCook
        self.steps = steps
    }
}

// Wrapper for steps variables
struct RecipeStep : Hashable {
    let step: String
    let imageName: String
    let description: String
    //let usesTimer: Bool
    //let timerTime : Float
}

struct MealPageModel: Identifiable {
    var id = UUID()
    var meal: RecipesList
    var time: Int
    
    init (meal: RecipesList = RecipesList(), time: Int = 1) {
        self.meal = meal
        self.time = time
    }
}



class Model: ObservableObject {

    let recipes: [RecipesList] = [
        
        RecipesList(
            recipeName: "Pasta",
            ingredients: "patate, provola",
            numberOfSteps: 10,
            imageName: "pasta",
            timeToCook: 15,
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
                """
                ),
                
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
        ),
        
        RecipesList(recipeName: "Pizza Salsiccia e Friarielli",
                    ingredients: "salsiccia, friarielli",
                    numberOfSteps: 8,
                    imageName: "pizza",
                    timeToCook: 8,
                    steps:
                        [
                        RecipeStep(
                            step: "1. Preparare la pasta",
                            imageName: "pasta",
                            description: """
                        Ingredients:
                        - 2 Heck 97% Sausages
                        - 1 260g Neapolitan Dough ball
                        - 80g Fior Di Latte Mozzarella
                        - 10g Smoked Mozzarella (scamorza)
                        - A pinch of grated Hard Cheese
                        - 2 handfuls of cooked Friarielli
                        """
                        ),
                        
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
                ),
    ]
    
    
    @Published var mealPage = MealPageModel()
    @Published var displayingMealPage = false
    @Published var followNavigationLink = false
    
    @Published var displayTabBar = true
    @Published var tabBarChanged = true
    @Published var tabViewSelectedIndex = Int.max {
        didSet {
            tabBarChanged = true
        }
    }
}
