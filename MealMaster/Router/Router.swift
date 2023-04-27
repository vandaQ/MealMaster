import Foundation
import UIKit

protocol RouterMain {
  var navigationController: UINavigationController? { get set }
  var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
  func showLogin()
  func showTabbarVC()
  func showDetailVC(info: RecepieCellViewModel?)
  func popToRoot()
}

class Router: RouterProtocol {
  
  var navigationController: UINavigationController?
  var assemblyBuilder: AssemblyBuilderProtocol?
  
  init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
    self.navigationController = navigationController
    self.assemblyBuilder = assemblyBuilder
  }
  
  func showLogin() {
    if let navigationController = navigationController {
      guard let loginVC = assemblyBuilder?.createLoginModule(router: self) else { return }
      navigationController.viewControllers = [loginVC]
    }
  }
  
  func showTabbarVC() {
    if let navigationController = navigationController {
      guard let tabBarVC = assemblyBuilder?.createTabbarModule(router: self) else { return }
      guard let navListVC = assemblyBuilder?.createListNavContr(router: self) else { return }
      guard let navFavoriteVC = assemblyBuilder?.createFavoriteNavContr(router: self) else { return }
      tabBarVC.viewControllers = [navListVC, navFavoriteVC]
      navigationController.setViewControllers([tabBarVC], animated: true)
    }
  }
  
  func showDetailVC(info: RecepieCellViewModel?) {
    if let navigationController = navigationController {
      guard let detailVC = assemblyBuilder?.createDetailModule(info: info, router: self) else { return }
      navigationController.pushViewController(detailVC, animated: true)
    }
  }
  
  func popToRoot() {
    if let navigationController = navigationController {
      guard let loginVC = assemblyBuilder?.createLoginModule(router: self) else { return }
      navigationController.setViewControllers([loginVC], animated: false)
    }
  }
}

