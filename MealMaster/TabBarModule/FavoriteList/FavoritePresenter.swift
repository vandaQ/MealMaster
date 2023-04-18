import Foundation

protocol FavoriteViewProtocol: AnyObject {
  func reloadTable()
  func displayData(viewModel: RecepieViewModel)
}

protocol FavoriteViewPresenterProtocol: AnyObject {
  init(view: FavoriteViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
  func getBulk()
  func showRightDetailVC(info: RecepieCellViewModel?)
  func popToRoot()
}


class FavoritePresenter: FavoriteViewPresenterProtocol {
  weak var view: FavoriteViewProtocol?
  var router: RouterProtocol?
  let networkService: NetworkServiceProtocol!
  let network = NetworkDataFetcher()
  var bulk: [FavoriteBulkElement]?
  
  
  required init(view: FavoriteViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol) {
    self.view = view
    self.networkService = networkService
    self.router = router
    getBulk()
  }
  
  
  func getBulk() {
    network.getRecepesInformationBulk(serchTerm: nil, params: convertToParams()) {  [weak self] bulk in
      guard let self = self else { return }
      guard let bulk = bulk else { return }
      self.bulk = bulk
      
      let cells = bulk.map({ item in
        self.convertToCellViewModel(from: item)
      })
      
      let cellViewModel = RecepieViewModel(cells: cells)
      self.view?.displayData(viewModel: cellViewModel)
    }
  }
  
  func convertToParams() -> [String: String] {
    var bulk = [String:String]()
    let array = UserFavoriteSaver.shared.getUserArray()
    let stringArray = array.map {String($0)}
    let joinedString = stringArray.joined(separator: ",")
    bulk[Ids.ids] = joinedString
    return bulk
  }
  
  
  private func convertToCellViewModel(from result: FavoriteBulkElement) -> RecepieViewModel.Cell {
    return RecepieViewModel.Cell(name: result.title ?? "",
                                 image: result.image ?? "",
                                 id: result.id ?? 0)
  }
  
  func showRightDetailVC(info: RecepieCellViewModel?) {
    router?.showDetailVC(info: info)
  }
  
  func popToRoot() {
    router?.popToRoot()
  }
}
