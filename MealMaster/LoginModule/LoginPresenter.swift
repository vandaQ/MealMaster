import Foundation

struct AlertState {
  var title: String
  var message: String
}

struct LoginState {
  var alert: AlertState?
  var isLoading: Bool = false
}

protocol LoginViewProtocol: AnyObject {
  func render(state: LoginState)
}

protocol LoginViewPresenterProtocol: AnyObject {
  func login(username: String, password: String)
  func registration(username: String, password: String)
}

final class LoginPresenter: LoginViewPresenterProtocol {
  private weak var view: LoginViewProtocol?
  private let router: RouterProtocol
  private let authService: AuthService
  private let mainQueue: DispatchQueue
  private let alertDelay: Double = 2
  
  private var state: LoginState = .init() {
    didSet {
      view?.render(state: state)
    }
  }
  
  init(
    view: LoginViewProtocol,
    router: RouterProtocol,
    authService: AuthService,
    mainQueue: DispatchQueue = .main
  ) {
    self.view = view
    self.router = router
    self.authService = authService
    self.mainQueue = mainQueue
  }
  
  func login(username: String, password: String) {
    state.isLoading = true
    guard !username.isEmpty else {
      return alert(title: "Empty field", message: "Enter login")
    }
    
    guard !password.isEmpty else {
      return alert(title: "Empty field", message: "Enter password")
    }
    
    guard let password = Int(password) else {
      return alert(title: "Incorrect password", message: "Password is not numeric")
    }
    
    authService.signIn(with: .init(username: username, password: password)) { [weak self] result in
      guard let self else { return }
      
      switch result {
      case .success:
        successLogin()
      case let .failure(error):
        alert(title: "Login failed", message: error.description)
      }
      state.isLoading = false
    }
  }
  
  func registration(username: String, password: String) {
    guard !username.isEmpty else {
      return alert(title: "Empty field", message: "Enter login")
    }
    
    guard !password.isEmpty else {
      return alert(title: "Empty field", message: "Enter password")
    }
    
    guard let password = Int(password) else {
      return alert(title: "Incorrect password", message: "Password is not numeric")
    }
    
    authService.signUp(with: .init(username: username, password: password)) { [weak self] result in
      guard let self else { return }
      
      switch result {
      case .success():
        successRegistration()
      case let .failure(error):
        alert(title: "Enter new information or log in", message: error.description)
      }
    }
  }
  
  
  private func alert(title: String, message: String) {
    state.alert = .init(title: title, message: message)
    
    mainQueue.asyncAfter(deadline: .now() + alertDelay) {
      self.state.alert = nil
    }
  }
  
  private func successLogin() {
    alert(title: "Glad to see you again", message: "")
    mainQueue.asyncAfter(deadline: .now() + alertDelay) {
      self.router.showTabbarVC()
    }
  }
  
  private func successRegistration() {
    alert(title: "Registration successful", message: "")
    
    mainQueue.asyncAfter(deadline: .now() + alertDelay) {
      self.router.showTabbarVC()
    }
  }
}
