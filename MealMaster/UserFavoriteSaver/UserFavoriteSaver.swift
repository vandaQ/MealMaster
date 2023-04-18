import Foundation

final class UserFavoriteSaver {
  
  static let shared = UserFavoriteSaver()
  private init() {}
  
  private let userDefaults = UserDefaults.standard
  
  private struct KeysDefaults {
    static let recepieId = "id"
  }
  
  func getUserArray() -> [Int] {
    let iDs = userDefaults.value(forKey: KeysDefaults.recepieId) as? [Int] ?? []
    return iDs
  }
  
  func addID(id: Int) {
    var iDs = getUserArray()
    iDs.append(id)
    userDefaults.set(iDs, forKey: KeysDefaults.recepieId)
  }
  
  func removeId(id: Int) {
    var iDs = getUserArray()
    if let index = iDs.firstIndex(of: id) {
      iDs.remove(at: index)
    }
    userDefaults.set(iDs, forKey: KeysDefaults.recepieId)
  }
  
  func idExist(id: Int) -> Bool {
    let iDs = getUserArray()
    return iDs.contains(where: {$0 == id})
  }
  
  
}
