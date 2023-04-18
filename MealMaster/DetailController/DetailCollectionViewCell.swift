import UIKit
import Kingfisher

protocol IngredientItemViewModel {
  var name: String { get }
  var image: String { get }
  var id: Int { get }
  var fullImage: String { get }
}

class DetailCollectionViewCell: UICollectionViewCell {
  static let reuseId = "DetailCollectionViewCell"
  
  var ingredientImageView = UIImageView()
  var ingredientLabel = UILabel()
  
  override func prepareForReuse() {
    super.prepareForReuse()
    ingredientImageView.image = nil
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureImage()
    configureLabel()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - configure
  
  func configureImage() {
    addSubview(ingredientImageView)
    ingredientImageView.backgroundColor = .white
    ingredientImageView.contentMode = .scaleToFill
    ingredientImageView.layer.cornerRadius = 10
    ingredientImageView.clipsToBounds      = true
    ingredientImageView.snp.makeConstraints { make in
      make.left.right.equalToSuperview()
      make.top.equalToSuperview()
      make.height.width.equalTo(140)
      
    }
  }
  
  private func configureLabel() {
    addSubview(ingredientLabel)
    ingredientLabel.sizeToFit()
    ingredientLabel.numberOfLines = 0
    ingredientLabel.textColor     = UIColor(red: 22/255, green: 16/255, blue: 34/255, alpha: 1)
    ingredientLabel.font          = UIFont.systemFont(ofSize: 20)
    ingredientLabel.textAlignment = .center
    ingredientLabel.snp.makeConstraints { make in
      make.top.equalTo(ingredientImageView.snp.bottom)
      make.centerX.equalToSuperview()
      make.width.equalTo(140)
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    self.layer.cornerRadius = 5
    self.layer.shadowRadius = 9
    layer.shadowOpacity = 0.3
    layer.shadowOffset = CGSize(width: 5, height: 8)
    
    self.clipsToBounds = false
  }
  
  func set(viewModel: IngredientItemViewModel) {
    ingredientImageView.kf.indicatorType = .activity
    ingredientImageView.kf.setImage(with: URL(string: viewModel.fullImage) , options: [.cacheOriginalImage])
    ingredientLabel.text = viewModel.name
  }
  
}


