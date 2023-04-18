import UIKit
import SnapKit
import SafariServices

class DetailViewController: UIViewController {
  
  let scrollView = UIScrollView()
  let contentView = UIView()
  
  let topView = UIView()
  var topImage = UIImageView()
  var favoriteButton = UIButton()
  let baseImage = UIImage(named: "heart")
  let filledImage = UIImage(named: "heart.fill")
  
  let middleView = UIView()
  let recepieNameLabel = UILabel()
  let textLabel = UILabel()
  var collectionView: UICollectionView!
  
  let instructionsTextView = UITextView()
  var safariButton = UIButton()
  var urlSaf: String?
  
  var presenter: DetailViewPresenterProtocol!
  
  private var ingredientViewModel = IngredViewModel(items: [])
  var recepieViewModel = RecepieViewModel(cells: [])

  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationBar()
    configureScrollView()
    self.presenter.setDataToView()
  }
  
  //MARK: - configure view
  func configureNavigationBar() {
    view.backgroundColor = .white
    navigationController?.navigationBar.tintColor = .white
    if #available(iOS 13.0, *) {
      overrideUserInterfaceStyle = .light
    }
  }
  
  private func configureScrollView() {
    scrollView.delegate = self
    scrollView.minimumZoomScale = 2
    scrollView.maximumZoomScale = 1.001
    
    view.addSubview(scrollView)
    scrollView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.left.right.equalToSuperview()
      make.height.equalTo(240)
    }
    
    scrollView.addSubview(contentView)
    contentView.snp.makeConstraints { make in
      make.top.equalTo(scrollView).inset(-100)
      make.left.right.equalTo(scrollView)
      make.bottom.equalTo(scrollView)
      make.centerX.equalTo(scrollView)
    }
    
    configureTopView()
    configureMiddleView()
    configureBottomView()
  }
  
  private func configureTopView() {
    topImage.contentMode = .scaleToFill
    topImage.layer.cornerRadius = 10
    topImage.clipsToBounds      = true
    
    contentView.addSubview(topView)
    topView.snp.makeConstraints { make in
      make.top.equalTo(contentView)
      make.left.right.equalTo(contentView)
      make.bottom.equalTo(contentView)
    }
    
    topView.addSubview(topImage)
    topImage.snp.makeConstraints { make in
      make.top.equalTo(topView)
      make.left.right.equalTo(topView)
      make.height.equalTo(240)
    }
    
  }
  
  func configureMiddleView() {
    view.addSubview(middleView)
    middleView.snp.makeConstraints { make in
      make.top.equalTo(scrollView.snp.bottom)
      make.left.right.equalToSuperview()
      make.height.equalTo(300)
    }
    
    configureFavotiteButton()
    middleView.addSubview(favoriteButton)
    favoriteButton.snp.makeConstraints { make in
      make.top.equalTo(middleView.snp.top).inset(2)
      make.right.equalTo(middleView.snp.right).inset(2)
      make.height.width.equalTo(32)
    }
    
    recepieNameLabel.numberOfLines = 0
    recepieNameLabel.textColor     =  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    recepieNameLabel.font          = UIFont.boldSystemFont(ofSize: 21)
    recepieNameLabel.textAlignment = .center
    recepieNameLabel.sizeToFit()
    
    middleView.addSubview(recepieNameLabel)
    recepieNameLabel.snp.makeConstraints { make in
      make.top.equalTo(middleView).inset(2)
      make.left.right.equalTo(middleView).inset(32)
      make.height.equalTo(60)
    }
    
    textLabel.numberOfLines = 0
    textLabel.text = "For recepie we will need these ingredients:"
    textLabel.textColor     =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    textLabel.font          = UIFont.systemFont(ofSize: 19)
    textLabel.textAlignment = .left
    textLabel.sizeToFit()
    
    middleView.addSubview(textLabel)
    textLabel.snp.makeConstraints { make in
      make.top.equalTo(recepieNameLabel.snp.bottom)
      make.left.right.equalTo(middleView).inset(20)
      make.height.equalTo(30)
    }
    
    configureCollectionView()
  }
  
  private func configureBottomView() {
    view.addSubview(instructionsTextView)
    instructionsTextView.showsVerticalScrollIndicator = false
    instructionsTextView.font = .systemFont(ofSize: 19, weight: .regular)
    instructionsTextView.textAlignment = .left
    instructionsTextView.isScrollEnabled = true
    instructionsTextView.isUserInteractionEnabled = true
    instructionsTextView.isEditable = false
    instructionsTextView.showsVerticalScrollIndicator = true
    instructionsTextView.snp.makeConstraints { make in
      make.top.equalTo(middleView.snp.bottom)
      make.left.right.equalToSuperview().inset(20)
      make.height.equalTo(145)
    }
    
    
    safariButton = UIButton(type: .system)
    safariButton.backgroundColor  = UIColor(red: 239/255, green: 79/255, blue: 65/255, alpha: 1)
    safariButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23)
    safariButton.setTitleColor(.white, for: .normal)
    safariButton.layer.cornerRadius = 20
    safariButton.setTitle("Открыть в Safari", for: .normal)
    safariButton.addTarget(self, action: #selector(didTaped), for: .touchUpInside)
    view.addSubview(safariButton)
    safariButton.snp.makeConstraints { make in
      make.bottom.equalToSuperview().inset(40)
      make.centerX.equalToSuperview()
      make.width.equalTo(240)
      make.height.equalTo(60)
    }
    
  }
  
  @objc func didTaped() {
    guard let url = urlSaf else { return }
    guard let urlString = URL(string: url) else { return }
    let safariVC = SFSafariViewController(url: urlString)
    present(safariVC, animated: true)
  }
  
  private func configureFavotiteButton() {
    favoriteButton.sizeToFit()
    favoriteButton.setBackgroundImage(chooseBackgroundImage(), for: .normal)
    favoriteButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
  }
  
  @objc func buttonPressed(sender: UIButton) {
    guard let id = presenter.info?.id else { return }
    saveId(id: id)
  }
  
  private func chooseBackgroundImage() -> UIImage? {
    guard let id = presenter.info?.id else { return nil }
    if UserFavoriteSaver.shared.idExist(id: id) {
      return filledImage
    } else {
      return baseImage
    }
  }
  
  private func saveId(id: Int) {
    if UserFavoriteSaver.shared.idExist(id: id) {
      return
    } else {
      UserFavoriteSaver.shared.addID(id: id)
      favoriteButton.setBackgroundImage(filledImage, for: .normal)
    }
  }
  
  private func configureCollectionView() {
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: setUpFlowLayout())
    collectionView.showsVerticalScrollIndicator = false
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 120)
    
    middleView.addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.top.equalTo(textLabel.snp.bottom)
      make.left.right.equalToSuperview()
      make.height.equalTo(200)
    }
    collectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: DetailCollectionViewCell.reuseId)
    setCollectionDelegate()
  }
  
  func setUpFlowLayout() -> UICollectionViewFlowLayout {
    let layout = UICollectionViewFlowLayout()
    layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = CGFloat(20)
    return layout
  }
  
  func setCollectionDelegate() {
    collectionView.delegate = self
    collectionView.dataSource = self
  }
}

//MARK: - extensions UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return ingredientViewModel.items.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.reuseId, for: indexPath) as! DetailCollectionViewCell
    let cells = ingredientViewModel.items[indexPath.item]
    cell.set(viewModel: cells)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 140, height: 180)
  }
  
}

//MARK: - DetailViewProtocol

extension DetailViewController: DetailViewProtocol {
  func setAll(data: RecipeInformation) {
    self.instructionsTextView.text = data.instructions
    removeUnneededText()
    guard let url = data.sourceUrl else { return }
    self.urlSaf = url
  }
  
  func displayData(viewModel: IngredViewModel) {
    self.ingredientViewModel.items.append(contentsOf: viewModel.items)
    DispatchQueue.main.async {
      self.collectionView.reloadData()
    }
  }
  
  func setInfo(info: RecepieCellViewModel?) {
    guard let nameLabel = info?.name else { return }
    
    self.recepieNameLabel.text = nameLabel
    guard let image = info?.image else { return }
    topImage.kf.indicatorType = .activity
    topImage.kf.setImage(with: URL(string: image) , options: [.cacheOriginalImage])
  }
  
  func removeUnneededText() {
    let text: Set<String> = ["<ol>", "</ol>", "<li>", "</li>", "<p>", "</p>", "span", "/span", "<>", "</>", "<></>"]
    for element in text {
      let change = instructionsTextView.text.replacingOccurrences(of: element, with: "")
      instructionsTextView.text = change
    }
  }
}

extension DetailViewController: UIScrollViewDelegate {
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return topImage
  }
  
  func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
    scrollView.zoomScale = 1
  }
  
}

