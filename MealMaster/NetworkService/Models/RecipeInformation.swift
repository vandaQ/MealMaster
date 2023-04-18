import Foundation

struct RecipeInformation: Decodable {
  let id: Int?
  let title: String?
  let image: String?
  let imageType: String?
  let readyInMinutes: Int?
  let sourceName: String?
  let sourceUrl: String?
  let instructions: String?
  let spoonacularSourceURL: String?
  let extendedIngredients: [ExtendedIngredient]?
  
}

struct ExtendedIngredient: Decodable {
  let aisle: String?
  let amount: Double?
  let id: Int?
  let image: String?
  let name: String?
  let original: String?
  let originalName: String?
}




struct IngredViewModel {
  struct Item: IngredientItemViewModel {
    var name: String
    var image: String
    var id: Int
    
    var fullImage : String { return "https://spoonacular.com/cdn/ingredients_500x500/" + self.image }
  }
  
  var items: [Item]
}
