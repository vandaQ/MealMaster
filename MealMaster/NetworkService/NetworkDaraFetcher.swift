import Foundation

protocol NetworkFetcher {
  func getRecepies(serchTerm: String?, params: [String:String], completion: @escaping  (ComplexSearch?) -> Void )
  func getRecepieFromIdInformation(id: Int?, params: [String:String], completion: @escaping  (RecipeInformation?) -> Void )
  func getRecepesInformationBulk(serchTerm: String?, params: [String:String], completion: @escaping  ([FavoriteBulkElement]?) -> Void )
}

class NetworkDataFetcher: NetworkFetcher {
  let networkService = NetworkService()
  
  func getRecepies(serchTerm: String?, params: [String:String], completion: @escaping  (ComplexSearch?) -> Void ) {
    networkService.request(path: API.complexSearch, params: params, searchTerm: serchTerm) { (data, error) in
      if let error = error {
        print("Error \(error.localizedDescription)")
        completion(nil)
      }
      
      let decode = self.decodeJSON(type: ComplexSearch.self, from: data)
      print(String(decoding: data!, as: UTF8.self))
      completion(decode)
    }
  }
  
  func getRecepieFromIdInformation(id: Int?, params: [String:String], completion: @escaping  (RecipeInformation?) -> Void ) {
    guard let id = id else { return }
    let path = "/recipes/" + String(id) + API.idInformation
    networkService.request(path: path, params: params, searchTerm: nil) { (data, error) in
      if let error = error {
        print("Error \(error.localizedDescription)")
        completion(nil)
      }
      
      let decode = self.decodeJSON(type: RecipeInformation.self, from: data)
      print(String(decoding: data!, as: UTF8.self))
      completion(decode)
    }
  }
  
  func getRecepesInformationBulk(serchTerm: String?, params: [String:String], completion: @escaping  ([FavoriteBulkElement]?) -> Void ) {
    networkService.request(path: API.informationBulk, params: params, searchTerm: serchTerm) { (data, error) in
      if let error = error {
        print("Error \(error.localizedDescription)")
        completion(nil)
      }
      
      let decode = self.decodeJSON(type: [FavoriteBulkElement].self, from: data)
      print(String(decoding: data!, as: UTF8.self))
      completion(decode)
    }
  }
  
  
  private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
    let decoder = JSONDecoder()
    guard let data = from else { return nil }
    do {
      let obj = try decoder.decode(type.self, from: data)
      return obj
    } catch let jsonError {
      print("Failed to decode JSON", jsonError)
      return nil
    }
  }
}
