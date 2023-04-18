import Foundation

struct Bulk: Decodable {
  let bulk: [FavoriteBulkElement]
}

struct FavoriteBulkElement: Decodable {
  let id: Int?
  let title: String?
  let sourceUrl: String?
  let image: String?
  let imageType: String?
  let instructions: String?
  let spoonacularSourceURL: String?
}
