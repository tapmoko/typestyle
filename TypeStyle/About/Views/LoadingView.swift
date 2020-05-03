import UIKit
import SnapKit

class LoadingView: UIView {

  let radius: CGFloat = 10
  let activityIndicator = UIActivityIndicatorView()
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

    setUpActivityIndicator()
    setUpTextLabel()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setUpActivityIndicator() {
    addSubview(activityIndicator)

    activityIndicator.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().offset(-15)
    }
  }

  private func setUpTextLabel() {
    textLabel.text = "Loading..."
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

  func start() {
    activityIndicator.startAnimating()
  }

  func stop() {
    activityIndicator.stopAnimating()
  }

}
