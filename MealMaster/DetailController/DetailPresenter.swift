import Foundation

protocol DetailViewProtocol: AnyObject {
  func setInfo(info: RecepieCellViewModel?)
  func displayData(viewModel: IngredViewModel)
  func setAll(data: RecipeInformation)
}

protocol DetailViewPresenterProtocol: AnyObject {
  init(view: DetailViewProtocol, networkService: NetworkServiceProtocol, info: RecepieCellViewModel?)
  func setDataToView()
  func getDataFromId()
  var info: RecepieCellViewModel? { get set }
  var recipeInfo: RecipeInformation? { get set }
}

class DetailPresenter: DetailViewPresenterProtocol {
  weak var view: DetailViewProtocol?
  let networkService: NetworkServiceProtocol!
  let network = NetworkDataFetcher()
  var info: RecepieCellViewModel?
  var recipeInfo: RecipeInformation?
  
  
  required init(view: DetailViewProtocol, networkService: NetworkServiceProtocol, info: RecepieCellViewModel?) {
    self.view = view
    self.networkService = networkService
    self.info = info
    getDataFromId()
  }
  
  func setDataToView() {
    self.view?.setInfo(info: info)
  }
  
  func getDataFromId() {
    guard let info = info?.id else { return }
    network.getRecepieFromIdInformation(id: info, params: ["" : ""]) {  [weak self]  recipeInformation in
      guard let self = self else { return }
      guard let recipeInformation = recipeInformation else { return }
      self.recipeInfo = recipeInformation
      let items = recipeInformation.extendedIngredients?.map({ item in
        self.convertToIngredientCellViewModel(from: item)
      })
      let itemViewModel = IngredViewModel(items: items ?? [])
      self.view?.displayData(viewModel: itemViewModel)
      self.view?.setAll(data: recipeInformation)
    }
  }
  
  private func convertToIngredientCellViewModel(from model: ExtendedIngredient) ->  IngredViewModel.Item {
    return IngredViewModel.Item(name: model.name ?? "",
                                image: model.image ?? "" ,
                                id: model.id ?? 0)
    
  }
  
}
