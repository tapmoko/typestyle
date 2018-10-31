import UIKit

class StyleCell: UITableViewCell {

  static let identifier = "StyleCell"

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    textLabel?.textColor = .appText
    backgroundColor = .appBackground
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
