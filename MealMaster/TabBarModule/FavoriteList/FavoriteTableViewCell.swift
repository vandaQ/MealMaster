import UIKit
import Kingfisher

class FavoriteTableViewCell: UITableViewCell {
  
  static let reuseId = "FavoriteTableViewCell"
  
  var recepieImageView = UIImageView()
  var recepieNameLabel = UILabel()
  var id: Int = 0
  
  override func prepareForReuse() {
    super.prepareForReuse()
    recepieImageView.image = nil
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureImage()
    configureLabels()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func set(viewModel: RecepieCellViewModel) {
    recepieImageView.kf.indicatorType = .activity
    recepieImageView.kf.setImage(with: URL(string: viewModel.image) , options: [.cacheOriginalImage])
    recepieNameLabel.text = viewModel.name
    id = viewModel.id
  }
  
  func configureImage() {
    recepieImageView.contentMode = .scaleToFill
    addSubview(recepieImageView)
    recepieImageView.layer.cornerRadius = 10
    recepieImageView.clipsToBounds      = true
    recepieImageView.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.left.equalToSuperview().inset(20)
      make.height.equalTo(80)
      make.width.equalTo(100)
    }
  }
  
  func configureLabels() {
    addSubview(recepieNameLabel)
    recepieNameLabel.numberOfLines = 0
    recepieNameLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.left.equalTo(recepieImageView.snp.right).offset(10)
      make.height.equalTo(recepieImageView)
      make.right.equalTo(-20)
    }
  }
}
