import Foundation

protocol LoginViewProtocol: AnyObject {
}

protocol LoginViewPresenterProtocol: AnyObject {
  init(view: LoginViewProtocol, router: RouterProtocol)
  func successLogin()
}

class LoginPresenter: LoginViewPresenterProtocol {
  weak var view: LoginViewProtocol?
  var router: RouterProtocol?
  
  
  required init(view: LoginViewProtocol, router: RouterProtocol) {
    self.view = view
    self.router = router
  }
  
  
  func successLogin() {
    router?.showTabbarVC()
  }
  
}
