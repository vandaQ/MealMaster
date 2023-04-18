import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let navController = UINavigationController()
    let assemblyBuilder = AssemblyBuilder()
    let router = Router(navigationController: navController, assemblyBuilder: assemblyBuilder)
    router.showLogin()
    
    window = UIWindow(windowScene: windowScene)
    window?.rootViewController = navController
    window?.makeKeyAndVisible()
  }
  
}

