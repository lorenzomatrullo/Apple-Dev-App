import Foundation
import SwiftUI

struct RecipesView: View {
    private var meal: RecipesList
    
    init(_ recipes: RecipesList) {
        self.meal = recipes
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            mealImage
            
            VStack(alignment: .leading) {
                mealName
                mealSteps
                mealAttributes
            }
        }
    }
    
    private var mealImage: some View {
        Image(self.meal.imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 70, height: 70)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .offset(x: -10, y: 5)
    }
    
    private var mealName: some View {
        Text(meal.recipeName)
            .font(.system(size: 18))
            .fontWeight(.medium)
    }
    
    private var mealSteps: some View {
        Text("\(meal.numberOfSteps) steps")
            .font(.footnote)
            .foregroundColor(.gray)
    }
    
    private var mealAttributes: some View {
        HStack(spacing: 5) {
            difficultyLabel
            
            if meal.vegetarian {
                dietaryLabel(text: "Vegetarian", color: .green)
            }
            
            if meal.lactoseFree {
                dietaryLabel(text: "Lactose Free", color: .blue)
            }
            
            if meal.glutenFree {
                dietaryLabel(text: "Gluten Free", color: .orange)
            }
        }
    }
    
    private var difficultyLabel: some View {
        let difficultyColor: Color = meal.difficulty == "Easy" ? .green : .yellow // Adjust color based on difficulty

        return HStack(spacing: 5) {
            Image(systemName: "fork.knife.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)

            Text(meal.difficulty)
                .font(.system(size: 14))
                .bold()
                .foregroundColor(.black)
        }
        .padding(5)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black.opacity(0.3), lineWidth: 2)
        )
    }
    
    private func dietaryLabel(text: String, color: Color) -> some View {
        Text(text)
            .font(.system(size: 14))
            .bold()
            .padding(5)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black.opacity(0.3), lineWidth: 2)
            )
    }
}
