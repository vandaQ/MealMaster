import Foundation

struct SignInCredentials {
  var username: String
  var password: Int
}

protocol UserSettingsType {
  func userExists(nickname: String, password: Int) -> Bool
  func addUser(nickname: String, password: Int)
}

enum AuthServiceError: Error {
  case userNotFound
  case userExists
}

extension AuthServiceError: CustomStringConvertible {
  var description: String {
    switch self {
    case .userNotFound:
      return "User with such login and password was not found"
    case .userExists:
     return "A user with this information is already registered"
    }
  }
}

final class AuthService {
  private let userSettings: UserSettingsType
  
  init(userSettings: UserSettingsType = UserSettings.shared) {
    self.userSettings = userSettings
  }
  
  func signIn(
    with credentials: SignInCredentials,
    completion: @escaping (Result<Void, AuthServiceError>) -> Void
  ) {
    if userSettings.userExists(nickname: credentials.username, password: credentials.password) {
      completion(.success(()))
    } else {
      completion(.failure(.userNotFound))
    }
  }
  
  func signUp(
    with credentials: SignInCredentials,
    completion: @escaping (Result<Void, AuthServiceError>) -> Void
  ) {
    if userSettings.userExists(nickname: credentials.username, password: credentials.password) {
      completion(.failure(.userExists))
    } else {
      completion(.success((addUser(with: credentials))))
    }
  }
  
  func addUser(with crefentials: SignInCredentials) {
    userSettings.addUser(nickname: crefentials.username, password: crefentials.password)
  }
  

}
