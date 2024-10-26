import Foundation
import SwiftUI

struct RecipesList: Hashable{
    let recipeName: String
    let ingredients: String
    let numberOfSteps: String
    let imageName: String
    
    init(recipeName: String = "", ingredients: String = "", numberOfSteps: String = "", imageName: String = "") {
        self.recipeName = recipeName
        self.ingredients = ingredients
        self.numberOfSteps = numberOfSteps
        self.imageName = imageName
    }
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
        RecipesList(recipeName: "Pasta",
                    ingredients: "patate, provola",
                    numberOfSteps: "10 steps",
                    imageName: "pasta"),
        RecipesList(recipeName: "Pizza Salsiccia e Friarielli",
                    ingredients: "salsiccia, friarielli",
                    numberOfSteps: "8 steps",
                    imageName: "pizza")
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
