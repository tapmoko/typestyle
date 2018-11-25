import UIKit

class AboutLabelTableViewCell: UITableViewCell {

  let label = UILabel()
  let padding: CGFloat = 20

  init(text: String) {
    super.init(style: .default, reuseIdentifier: nil)

    backgroundColor = .appBackground

    let selectedView = UIView()
    selectedView.backgroundColor = .appBackground
    selectedBackgroundView = selectedView

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
      make.top.equalToSuperview().offset(padding / 2)
      make.left.equalToSuperview().offset(padding)
      make.right.equalToSuperview().offset(-padding)
      make.bottom.equalToSuperview().offset(-padding / 2)
    }
  }

}
