import Foundation

final class UserSettings {
  
  static let shared = UserSettings()
  private init() {}
  
  private let userDefaults = UserDefaults.standard
  
  private struct KeysDefaults {
    static let userDictionaryKey = "users"
  }
  
  func getUserDictionary() -> Dictionary<String, Int> {
    let users = userDefaults.value(forKey: KeysDefaults.userDictionaryKey) as? Dictionary<String, Int> ?? Dictionary<String, Int>()
    return users
  }
  
  func addUser(nickname: String, password: Int) {
    var users = getUserDictionary()
    users[nickname] = password
    userDefaults.set(users, forKey: KeysDefaults.userDictionaryKey)
  }
  
  func userExists(nickname: String, password: Int) -> Bool {
    let users = getUserDictionary()
    return users.contains(where: { $0.key == nickname && $0.value == password })
  }
  
  func nickExist(nickname: String) -> Bool {
    let users = getUserDictionary()
    return users.contains(where: { $0.key == nickname })
  }
  
  func passExist(pass: Int) -> Bool {
    let users = getUserDictionary()
    return users.contains(where: { $0.value == pass })
  }
}

extension UserSettings: UserSettingsType {
}
