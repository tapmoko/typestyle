import UIKit
import SnapKit

class ActionConfirmationView: UIView {

  let radius: CGFloat = 10
  let imageView = UIImageView()
  let textLabel = UILabel()
  let textLabelPadding: CGFloat = 15

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
