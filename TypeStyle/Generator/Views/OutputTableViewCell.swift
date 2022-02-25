import UIKit

class OutputTableViewCell: UITableViewCell {

  static let identifier = "OutputTableViewCell"

  let outputLabel = UILabel()
  let favoriteImageView = UIImageView()
  let padding = 10.0

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    backgroundColor = .clear

    let selectedView = UIView()
    selectedView.backgroundColor = .appSelected
    selectedBackgroundView = selectedView

    setUpOutputLabel()
    setUpFavoriteImageView()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setUpOutputLabel() {
    outputLabel.textColor = .appText
    outputLabel.font = UIFont.preferredFont(forTextStyle: .body)
    outputLabel.adjustsFontForContentSizeCategory = true
    outputLabel.numberOfLines = 0 // unlimited

    addSubview(outputLabel)

    outputLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(padding)
      make.leading.equalToSuperview().inset(padding)
      make.bottom.equalToSuperview().inset(padding)
    }
  }

  func setUpFavoriteImageView() {
    favoriteImageView.tintColor = .appText
    favoriteImageView.setContentCompressionResistancePriority(
      UILayoutPriority(rawValue: 10000),
      for: .horizontal
    )

    addSubview(favoriteImageView)

    favoriteImageView.snp.makeConstraints { make in
      make.leading.greaterThanOrEqualTo(outputLabel.snp.trailing).offset(padding)
      make.trailing.equalToSuperview().inset(padding)
      make.centerY.equalToSuperview()
      make.width.equalTo(25)
      make.height.equalTo(25)
    }
  }

}
