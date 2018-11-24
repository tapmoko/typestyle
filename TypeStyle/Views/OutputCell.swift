import UIKit

class OutputCell: UITableViewCell {

  static let identifier = "OutputCell"

  let outputLabel = UILabel()
  let padding: CGFloat = 10

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    backgroundColor = .appBackground

    let selectedView = UIView()
    selectedView.backgroundColor = .appSelected
    selectedBackgroundView = selectedView

    setUpOutputLabel()
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
      make.top.equalToSuperview().offset(padding)
      make.left.equalToSuperview().offset(padding)
      make.right.equalToSuperview().offset(-padding)
      make.bottom.equalToSuperview().offset(-padding)
    }
  }

}
