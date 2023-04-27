import Foundation

struct SignInCredentials {
  var username: String
  var password: Int
}

protocol UserSettingsType {
  func userExists(nickname: String, password: Int) -> Bool
}

enum AuthServiceError: Error {
  case userNotFound
}

extension AuthServiceError: CustomStringConvertible {
  var description: String {
    switch self {
    case .userNotFound:
      return "User with such login and password was not found"
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
}
