import Foundation

protocol ListViewProtocol: AnyObject {
  func failure(error: Error)
  func displayData(viewModel: RecepieViewModel)
  func reloadData(viewModel: RecepieViewModel)
}

protocol ListViewPresenterProtocol: AnyObject {
  init(view: ListViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
  var complexSearch: ComplexSearch? { get set }
  var offset: Int? { get set }
  func getRecepies()
  func search(search: String?, params: [String: String])
  func loadMore()
  func showLeftDetailVC(info: RecepieCellViewModel?)
}

class ListPresenter: ListViewPresenterProtocol {
  weak var view: ListViewProtocol?
  var router: RouterProtocol?
  let networkService: NetworkServiceProtocol!
  let network = NetworkDataFetcher()
  var complexSearch: ComplexSearch?
  var offset: Int?
  
  required init(view: ListViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol) {
    self.view = view
    self.networkService = networkService
    self.router = router
    getRecepies()
  }
  
  func getRecepies() {
    network.getRecepies(serchTerm: nil, params: ["number": "10"]) { [weak self] complexSearch in
      guard let self = self else { return }
      guard let complexSearch = complexSearch else { return }
      self.complexSearch = complexSearch
      self.offset = complexSearch.offset
      let cells = complexSearch.results.map({ item in
        self.convertToCellViewModel(from: item)
      })
      
      let cellViewModel = RecepieViewModel(cells: cells)
      self.view?.displayData(viewModel: cellViewModel)
    }
  }
  
  func search(search: String?, params: [String: String]) {
    network.getRecepies(serchTerm: search, params: params) { [weak self] complexSearch in
      guard let self = self else { return }
      guard let complexSearch = complexSearch else { return }
      self.complexSearch = complexSearch
      
      let cells = complexSearch.results.map({ item in
        self.convertToCellViewModel(from: item)
      })
      let cellViewModel = RecepieViewModel(cells: cells)
      self.view?.reloadData(viewModel: cellViewModel)
    }
  }
  
  private func convertToCellViewModel(from result: Result1) -> RecepieViewModel.Cell {
    return RecepieViewModel.Cell(name: result.title ?? "",
                                 image: result.image ?? "",
                                 id: result.id ?? 0)
  }
  
  func loadMore() {
    network.getRecepies(serchTerm: nil, params: nextPageParams()) { [weak self] complexSearch in
      guard let self = self else { return }
      guard let complexSearch = complexSearch else { return }
      self.complexSearch = complexSearch
      
      let cells = complexSearch.results.map({ item in
        self.convertToCellViewModel(from: item)
      })
      let cellViewModel = RecepieViewModel(cells: cells)
      self.view?.displayData(viewModel: cellViewModel)
    }
  }
  
  private func nextPageParams() -> [String: String] {
    var paramNextPage = [String:String]()
    offset! += 10
    paramNextPage["offset"] = String(offset!)
    return paramNextPage
  }
  
  func showLeftDetailVC(info: RecepieCellViewModel?) {
    router?.showDetailVC(info: info)
  }
  
}

