import UIKit
import SnapKit

class CopiedView: UIView {

  let radius: CGFloat = 10
  let copiedLabel = UILabel()
  let copiedLabelPadding: CGFloat = 10

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .appText
    layer.cornerRadius = radius
    
    snp.makeConstraints { make in
      make.width.equalTo(snp.height)
    }

    // Shadow
    layer.shadowRadius = 8
    layer.shadowOffset = CGSize(width: 0, height: 0)
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.3

    setUpCopiedLabel()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setUpCopiedLabel() {
    copiedLabel.text = "Copied ✓"
    copiedLabel.textColor = .appBackground
    copiedLabel.font = UIFont.preferredFont(forTextStyle: .body)

    addSubview(copiedLabel)

    copiedLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.left.equalToSuperview().offset(copiedLabelPadding)
      make.right.equalToSuperview().offset(-copiedLabelPadding)
    }
  }

}
