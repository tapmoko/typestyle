import UIKit
import SnapKit

class CopiedView: UIView {

  let radius: CGFloat = 10
  let checkmarkLabel = UILabel()
  let copiedLabel = UILabel()
  let copiedLabelPadding: CGFloat = 10

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
    setUpCopiedLabel()
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

  func setUpCopiedLabel() {
    copiedLabel.text = "Copied"
    copiedLabel.textColor = .appText
    copiedLabel.font = UIFont.preferredFont(forTextStyle: .body)
    copiedLabel.adjustsFontForContentSizeCategory = true

    addSubview(copiedLabel)

    copiedLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().offset(15)
      make.leading.equalToSuperview().inset(copiedLabelPadding)
      make.trailing.equalToSuperview().inset(copiedLabelPadding)
    }
  }

}
