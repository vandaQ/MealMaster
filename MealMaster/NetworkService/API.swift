import Foundation

struct API {
  static let scheme = "https"
  static let host = "api.spoonacular.com"
  
  static let complexSearch = "/recipes/complexSearch"
  static let idInformation = "/information"
  static let informationBulk = "/recipes/informationBulk"  
}

struct Ids {
  static let ids = "ids"
}

struct ParamsCuisine {
  static let american = ["cuisine":"American"]
  static let european = ["cuisine":"European"]
  static let italian = ["cuisine":"Italian"]
  static let french = ["cuisine":"French"]
  static let allCusines = ["":""]
}
