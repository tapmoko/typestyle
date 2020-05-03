import UIKit

protocol AboutButtonTableViewCellDelegate: class {
  func open(link: String)
  func openTip()
}

class AboutButtonTableViewCell: UITableViewCell {

  enum Kind {
    case link(String)
    case tip
  }

  let button = UIButton(type: .system)
  let padding: CGFloat = 20
  let kind: Kind
  weak var delegate: AboutButtonTableViewCellDelegate?

  init(text: String, kind: Kind) {
    self.kind = kind

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

    button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)

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
      make.top.equalToSuperview().inset(padding / 2)
      make.width.lessThanOrEqualToSuperview().inset(padding * 2)
      make.bottom.equalToSuperview().inset(padding / 2)
    }
  }

  @objc func didTapButton() {
    switch kind {
    case .link(let link): delegate?.open(link: link)
    case .tip: delegate?.openTip()
    }
  }

}
