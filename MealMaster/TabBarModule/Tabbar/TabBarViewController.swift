import UIKit

class TabBarViewController: UITabBarController {
  
  var presenter: TabbarViewPresenterProtocol!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if #available(iOS 13.0, *) {
      overrideUserInterfaceStyle = .light
    }
  }
}

extension TabBarViewController: TabbarViewProtocol {
}

