import UIKit

protocol AboutButtonTableViewCellDelegate: class {
  func open(link: String)
}

class AboutButtonTableViewCell: UITableViewCell {

  let button = UIButton()
  let padding: CGFloat = 20
  let link: String
  weak var delegate: AboutButtonTableViewCellDelegate?

  init(text: String, link: String) {
    self.link = link

    super.init(style: .default, reuseIdentifier: nil)

    backgroundColor = .appBackground

    let selectedView = UIView()
    selectedView.backgroundColor = .appBackground
    selectedBackgroundView = selectedView

    setUpButton(text: text)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setUpButton(text: String) {
    button.setTitleColor(.appText, for: .normal)
    button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
    button.titleLabel?.adjustsFontForContentSizeCategory = true
    button.titleLabel?.numberOfLines = 0 // unlimited

    button.addTarget(self, action: #selector(openLink), for: .touchUpInside)

    let attributes: [NSAttributedString.Key: Any] = [
      NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
      NSAttributedString.Key.foregroundColor: UIColor.appText
    ]
    let underlinedText = NSAttributedString(string: text,
                                            attributes: attributes)
    button.setAttributedTitle(underlinedText, for: .normal)

    addSubview(button)

    button.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().offset(padding / 2)
      make.width.lessThanOrEqualToSuperview().offset(-padding * 2)
      make.bottom.equalToSuperview().offset(-padding / 2)
    }
  }

  @objc func openLink() {
    delegate?.open(link: link)
  }

}
