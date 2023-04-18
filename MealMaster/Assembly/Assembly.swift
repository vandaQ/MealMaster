import Foundation
import UIKit

protocol AssemblyBuilderProtocol {
  func createLoginBuilder(router: RouterProtocol) -> UIViewController
  func createTabbarModule(router: RouterProtocol) -> UITabBarController
  func createListNavContr(router: RouterProtocol) -> UINavigationController
  func createFavoriteNavContr(router: RouterProtocol) -> UINavigationController
  func createDetailModule(info: RecepieCellViewModel?, router: RouterProtocol) -> UIViewController
}

class AssemblyBuilder: AssemblyBuilderProtocol {
  
  func createLoginBuilder(router: RouterProtocol) -> UIViewController {
    let view = LoginViewController()
    let presenter = LoginPresenter(view: view, router: router)
    view.presenter = presenter
    return view
  }
  
  func createTabbarModule(router: RouterProtocol) -> UITabBarController {
    let view = TabBarViewController()
    let networkService = NetworkService()
    let presenter = TabbarPresenter(view: view, networkService: networkService, router: router)
    view.presenter = presenter
    return view
  }
  
  func createListModule(router: RouterProtocol) -> UIViewController {
    let view = RecipeListController()
    let networkService = NetworkService()
    let presenter = ListPresenter(view: view, networkService: networkService, router: router)
    view.presenter = presenter
    return view
  }
  
  func createFavoritModule(router: RouterProtocol) -> UIViewController {
    let view = FavoriteListViewController()
    let networkService = NetworkService()
    let presenter = FavoritePresenter(view: view, networkService: networkService, router: router)
    view.presenter = presenter
    return view
  }
  
  func createListNavContr(router: RouterProtocol) -> UINavigationController {
    let leftVC = self.createListModule(router: router)
    let navLeftVC = self.createNavController(vc: leftVC, itemName: "Recipe List", itemImage: "list.bullet")
    return navLeftVC
  }
  
  func createFavoriteNavContr(router: RouterProtocol) -> UINavigationController {
    let rightVC = self.createFavoritModule(router: router)
    let navRightVC = self.createNavController(vc: rightVC,  itemName: "Favorite recipes", itemImage: "heart.circle.fill")
    return navRightVC
  }
  
  func createDetailModule(info: RecepieCellViewModel?, router: RouterProtocol) -> UIViewController {
    let view = DetailViewController()
    let networkService = NetworkService()
    let presenter = DetailPresenter(view: view, networkService: networkService, info: info)
    view.presenter = presenter
    return view
  }
  
  func createNavController(vc: UIViewController, itemName: String, itemImage: String) -> UINavigationController {
    let item = UITabBarItem(title: itemName, image: UIImage(named: itemImage)?.withAlignmentRectInsets(.init(top: 10, left: 0, bottom: 0, right: 0)), tag: 0)
    item.titlePositionAdjustment = .init(horizontal: 0, vertical: 5)
    let navController = UINavigationController(rootViewController: vc)
    navController.tabBarItem = item
    return navController
  }
}
