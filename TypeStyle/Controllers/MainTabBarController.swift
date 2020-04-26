import UIKit

class MainTabBarController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let stylesVC = TypeStyleViewController(transformerMode: .styles)
    stylesVC.tabBarItem = UITabBarItem(title: "Styles",
                                       image: UIImage(systemName: "bold.italic.underline"),
                                       tag: 0)

    let decorationsVC = TypeStyleViewController(transformerMode: .decorations)
    decorationsVC.tabBarItem = UITabBarItem(title: "Decorations",
                                            image: UIImage(systemName: "wand.and.stars"),
                                            tag: 1)

    let emoticonsVC = TypeStyleViewController(transformerMode: .emoticons)
    emoticonsVC.tabBarItem = UITabBarItem(title: "Emoticons",
                                          image: UIImage(systemName: "smiley"),
                                          tag: 2)

    let aboutVC = AboutViewController()
    aboutVC.tabBarItem = UITabBarItem(title: "About",
                                      image: UIImage(systemName: "info.circle"),
                                      tag: 3)

    viewControllers = [stylesVC, decorationsVC, emoticonsVC, aboutVC]
    view.tintColor = .appText
  }

}
