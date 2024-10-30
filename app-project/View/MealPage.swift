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

                VStack(alignment: .leading) {
                    HStack {
                        Text("TIME:")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text("\(meal.timeToCook) minutes")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("DIFFICULTY:")
                            .font(.headline)
                        
                        Spacer()
                        
                        Text(meal.difficulty)
                            .font(.subheadline)
                    }
                    //.padding(.vertical, 5)
                    
                    HStack {
                        Text("PORTIONS:")
                            .font(.headline)
                        
                        Spacer()
                        
                        Text("\(meal.portions)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("CALORIES:")
                            .font(.headline)
                        
                        Spacer()
                        
                        Text("\(meal.calories)kcal")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 10)
                
                Section(header: Text("Ingredients")
                    .font(.headline)
                    .foregroundColor(.primary)
                ) {
                    // Split the ingredients string into an array
                    let ingredientsList = meal.ingredients.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                    
                    ForEach(ingredientsList, id: \.self) { ingredient in
                        HStack {
                            Text(ingredient)
                                .font(.subheadline)
                            Spacer()
                        }
                    }
                }
                
            }
            
            NavigationLink(destination: StepPageView(meal)) {
                Text("START")
                    .font(.system(size: 25))
                    .bold()
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle("Meal Page")
        .navigationBarTitleDisplayMode(.inline)
    }
}
