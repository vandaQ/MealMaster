import Foundation

protocol TabbarViewProtocol: AnyObject {
}

protocol TabbarViewPresenterProtocol: AnyObject {
  init(view: TabbarViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
}

class TabbarPresenter: TabbarViewPresenterProtocol {
  weak var view: TabbarViewProtocol?
  var router: RouterProtocol?
  let networkService: NetworkServiceProtocol!
  
  required init(view: TabbarViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol) {
    self.view = view
    self.networkService = networkService
    self.router = router
  }
}

