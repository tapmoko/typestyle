import UIKit
import SnapKit

class ActionConfirmationView: UIView {

  enum Style {
    case copied
    case favorited
    case unfavorited
  }

  var style: Style = .copied {
    didSet {
      switch style {
      case .copied:
        imageView.image = UIImage(systemName: "doc.on.doc")
        textLabel.text = "Copied"
      case .favorited:
        imageView.image = UIImage(systemName: "heart")
        textLabel.text = "Favorited"
      case .unfavorited:
        imageView.image = UIImage(systemName: "heart.slash")
        textLabel.text = "Unfavorited"
      }
    }
  }

  let radius = 10.0
  let imageView = UIImageView()
  let textLabel = UILabel()
  let textLabelPadding = 15.0

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .appDarkBackground
    layer.cornerRadius = radius
    
    snp.makeConstraints { make in
      make.width.equalTo(snp.height)
    }

    // Shadow
    layer.shadowRadius = 8
    layer.shadowOffset = CGSize(width: 0, height: 0)
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.3

    setUpImageView()
    setUpTextLabel()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setUpImageView() {
    imageView.image = UIImage(systemName: "doc.on.doc")
    imageView.tintColor = .appText

    addSubview(imageView)

    imageView.snp.makeConstraints { make in
      make.width.equalTo(30)
      make.height.equalTo(30)
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().offset(-15)
    }
  }

  private func setUpTextLabel() {
    textLabel.text = "Copied"
    textLabel.textColor = .appText
    textLabel.font = UIFont.preferredFont(forTextStyle: .body)
    textLabel.adjustsFontForContentSizeCategory = true

    addSubview(textLabel)

    textLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().offset(20)
      make.leading.equalToSuperview().inset(textLabelPadding)
      make.trailing.equalToSuperview().inset(textLabelPadding)
    }
  }

}
