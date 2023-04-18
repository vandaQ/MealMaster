import UIKit

class FavoriteListViewController: UIViewController {
  
  var tableView = UITableView()
  var presenter: FavoriteViewPresenterProtocol!
  
  private var recepieViewModel = RecepieViewModel(cells: [])
  
  override func viewWillAppear(_ animated: Bool) {
    print("reload")
    presenter.getBulk()
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationBar()
    configureTableView()
    configureRightBarButtonItem()
  }
  
  //MARK: - configureItems
  
  private func configureNavigationBar() {
    title = "Favorite recipes"
    navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 254/255, green: 70/255, blue: 113/255, alpha: 1)]
    if #available(iOS 13.0, *) {
      overrideUserInterfaceStyle = .light
    }
  }
  
  func configureTableView() {
    self.tableView = UITableView(frame: view.bounds)
    tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.reuseId)
    setTableViewDelegate()
    tableView.rowHeight = 100
    view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.separatorStyle = .none
  }
  func setTableViewDelegate() {
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  func configureRightBarButtonItem() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .done, target: self, action: #selector(tappedLogout))
  }
  
  @objc func tappedLogout() {
    presenter.popToRoot()
  }
}


//MARK: - UITableViewDelegate, UITableViewDataSource

extension FavoriteListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return recepieViewModel.cells.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseId, for: indexPath) as! FavoriteTableViewCell
    let cellViewModel = recepieViewModel.cells[indexPath.row]
    cell.set(viewModel: cellViewModel)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = recepieViewModel.cells[indexPath.row]
    presenter.showRightDetailVC(info: item)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .delete
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let array = UserFavoriteSaver.shared.getUserArray()
      UserFavoriteSaver.shared.removeId(id: array[indexPath.row])
      recepieViewModel.cells.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .left)
    }
  }
}

//MARK: - FavoriteViewProtocol

extension FavoriteListViewController: FavoriteViewProtocol {
  func reloadTable() {
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
  
  func displayData(viewModel: RecepieViewModel) {
    self.recepieViewModel = viewModel
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
}

