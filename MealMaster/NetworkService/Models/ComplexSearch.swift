import Foundation

struct ComplexSearch: Decodable {
  let results: [Result1]
  let offset: Int?
  let number: Int?
  let totalResults: Int?
}

struct Result1: Decodable  {
  let id: Int?
  let title: String?
  let image: String?
  let imageType: ImageType?
}

enum ImageType: String, Decodable  {
  case jpg = "jpg"
}


struct RecepieViewModel {
  
  struct Cell: RecepieCellViewModel {
    var name: String
    var image: String
    var id: Int
  }
  
  var cells: [Cell]
}
