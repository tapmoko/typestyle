import UIKit

class AboutLabelView: UIView {

  let label = UILabel()
  let padding: CGFloat = 20

  init(text: String) {
    super.init(frame: .zero)

    backgroundColor = .appBackground

    setUpLabel()
    label.text = text
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setUpLabel() {
    label.textColor = .appText
    label.font = UIFont.preferredFont(forTextStyle: .body)
    label.adjustsFontForContentSizeCategory = true
    label.numberOfLines = 0 // unlimited

    addSubview(label)

    label.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(padding / 2)
      make.leading.equalToSuperview().inset(padding)
      make.trailing.equalToSuperview().inset(padding)
      make.bottom.equalToSuperview().inset(padding / 2)
    }
  }

}
