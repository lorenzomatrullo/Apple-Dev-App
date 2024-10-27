import Foundation
import SwiftUI

struct RecipesView: View {
    private var recipes: RecipesList
    
    init(_ recipes: RecipesList) {
        self.recipes = recipes
    }
    
    var body: some View {
        
        HStack (alignment: .center, spacing: 5) {
            Image(self.recipes.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .offset(x: -10, y: 5)
            
            
            VStack (alignment: .leading) {
                Text (recipes.recipeName)
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                
                
                Text (String(recipes.numberOfSteps) + " steps")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
    }
}
