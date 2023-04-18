import UIKit
import Kingfisher

class RecipeListController: UIViewController {
  
  var tableView = UITableView()
  var segmentControl = UISegmentedControl()
  var refreshControl = UIRefreshControl()
  var timer: Timer?
  
  var presenter: ListViewPresenterProtocol?
  
  private var recepieViewModel = RecepieViewModel(cells: [])
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTableView()
    configureSegmentControl()
    configureNavigationBar()
    configureSearchBar()
    configureRefresh()
  }
  
  //MARK: - configureItems
  
  private func configureNavigationBar() {
    navigationController?.hidesBarsOnSwipe = true
    navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 254/255, green: 70/255, blue: 113/255, alpha: 1)]
    if #available(iOS 13.0, *) {
      overrideUserInterfaceStyle = .light
    }
  }
  
  private func configureTableView() {
    self.tableView = UITableView(frame: view.bounds)
    tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.reuseId)
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
  
  private func configureSearchBar() {
    let searchController = UISearchController(searchResultsController: nil)
    searchController.searchBar.delegate = self
    navigationItem.searchController = searchController
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.obscuresBackgroundDuringPresentation = false
    
  }
  private func configureSegmentControl() {
    let arrayItems = ["American", "European", "Italian", "French", "All"]
    segmentControl = UISegmentedControl(items: arrayItems)
    segmentControl.sizeToFit()
    segmentControl.selectedSegmentTintColor = UIColor(red: 239/255, green: 79/255, blue: 65/255, alpha: 1)
    segmentControl.addTarget(self, action: #selector(segmentControlTapped), for: .valueChanged)
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: segmentControl)
  }
  
  @objc func segmentControlTapped(param: UISegmentedControl) {
    switch param.selectedSegmentIndex {
    case 0:
      presenter?.search(search: nil, params: ParamsCuisine.american)
    case 1:
      presenter?.search(search: nil, params: ParamsCuisine.european)
    case 2:
      presenter?.search(search: nil, params: ParamsCuisine.italian)
    case 3:
      presenter?.search(search: nil, params: ParamsCuisine.french)
    case 4:
      presenter?.search(search: nil, params: ParamsCuisine.allCusines)
    default:
      presenter?.search(search: nil, params: ParamsCuisine.allCusines)
    }
  }
  
  func configureRefresh(){
    tableView.addSubview(refreshControl)
    refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
  }
  
  @objc func refresh() {
    print("refresh")
    presenter?.getRecepies()
    refreshControl.endRefreshing()
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if scrollView.contentOffset.y > scrollView.contentSize.height / 3 {
      presenter?.loadMore()
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension RecipeListController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return recepieViewModel.cells.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
    let cellViewModel = recepieViewModel.cells[indexPath.row]
    cell.set(viewModel: cellViewModel)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = recepieViewModel.cells[indexPath.row]
    presenter?.showLeftDetailVC(info: item)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
}

//MARK: - TabBarViewProtocol
extension RecipeListController: ListViewProtocol {
  
  func failure(error: Error) {
    print(error.localizedDescription)
    let alert = UIAlertController(title: "Данные не загружены", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Ок", style: .default)
    alert.addAction(action)
    self.present(alert, animated: true)
  }
  
  func reloadData(viewModel: RecepieViewModel) {
    self.recepieViewModel = viewModel
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
  
  func displayData(viewModel: RecepieViewModel) {
    self.recepieViewModel.cells.append(contentsOf: viewModel.cells)
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
}

extension RecipeListController: UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
      self.presenter?.search(search: searchText, params: ParamsCuisine.allCusines)
    })
    
    let totalResult = presenter?.complexSearch?.totalResults
    if totalResult == 0 {
      let alert = UIAlertController(title: "Нет рецептов с таким названием", message: "", preferredStyle: .alert)
      let action = UIAlertAction(title: "Ок", style: .default)
      alert.addAction(action)
      self.present(alert, animated: true)
    }
    
  }
}
