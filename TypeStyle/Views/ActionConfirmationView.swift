import UIKit
import SnapKit

class ActionConfirmationView: UIView {

  let radius: CGFloat = 10
  let checkmarkLabel = UILabel()
  let textLabel = UILabel()
  let textLabelPadding: CGFloat = 10

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

    setUpCheckmarkLabel()
    setUptextLabel()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setUpCheckmarkLabel() {
    checkmarkLabel.text = "✓"
    checkmarkLabel.textColor = .appText
    checkmarkLabel.font = UIFont.preferredFont(forTextStyle: .title1)
    checkmarkLabel.adjustsFontForContentSizeCategory = true

    addSubview(checkmarkLabel)

    checkmarkLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().offset(-10)
    }
  }

  func setUptextLabel() {
    textLabel.text = "Copied"
    textLabel.textColor = .appText
    textLabel.font = UIFont.preferredFont(forTextStyle: .body)
    textLabel.adjustsFontForContentSizeCategory = true

    addSubview(textLabel)

    textLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().offset(15)
      make.leading.equalToSuperview().inset(textLabelPadding)
      make.trailing.equalToSuperview().inset(textLabelPadding)
    }
  }

}
