import Foundation
import SwiftUI

struct RecipesView: View {
    private var meal: RecipesList
    
    init(_ recipes: RecipesList) {
        self.meal = recipes
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            Image(self.meal.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .offset(x: -10, y: 5)
            
            VStack(alignment: .leading) {
                Text(meal.recipeName)
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                
                Text("\(meal.numberOfSteps) steps")
                    .font(.footnote)
                    .foregroundColor(.gray)
                
                HStack(spacing: 5) { // Horizontal stack for labels
                    if meal.vegan {
                        Text("Vegan")
                            .font(.system(size: 14))
                            .bold()
                            .padding(5)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black.opacity(0.3), lineWidth: 2)
                            )
                    }
                    
                    if meal.lactoseFree {
                        Text("Lactose Free")
                            .font(.system(size: 14))
                            .bold()
                            .padding(5)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black.opacity(0.3), lineWidth: 2)
                            )
                    }
                    
                    if meal.glutenFree {
                        Text("Gluten Free")
                            .font(.system(size: 14))
                            .bold()
                            .padding(5)
                            .background(.orange)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black.opacity(0.3), lineWidth: 2)
                            )
                    }
                }
            }
        }
    }
}
