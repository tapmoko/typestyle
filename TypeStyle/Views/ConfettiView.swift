import UIKit
import QuartzCore

class ConfettiView: UIView {

  private var emitter: CAEmitterLayer?

  private let colors: [UIColor] = [#colorLiteral(red: 0.95, green: 0.40, blue: 0.28, alpha: 1.0), #colorLiteral(red: 1.00, green: 0.78, blue: 0.36, alpha: 1.0), #colorLiteral(red: 0.48, green: 0.78, blue: 0.64, alpha: 1.0), #colorLiteral(red: 0.30, green: 0.75, blue: 0.85, alpha: 1.0)]
  private let intensity: Float = 0.5

  func start() {
    emitter = CAEmitterLayer()

    emitter?.emitterPosition = CGPoint(x: frame.size.width / 2.0, y: 0)
    emitter?.emitterShape = .line
    emitter?.emitterSize = CGSize(width: frame.size.width, height: 1)

    let cells = colors.map { confettiCell(withColor: $0) }

    emitter?.emitterCells = cells
    layer.addSublayer(emitter!)
  }

  func stop() {
    emitter?.birthRate = 0
  }

  private func confettiCell(withColor color: UIColor) -> CAEmitterCell {
    let confettiCell = CAEmitterCell()

    confettiCell.contents = UIImage(named: "confetti")?.cgImage
    confettiCell.scale = 0.4
    confettiCell.color = color.cgColor

    confettiCell.birthRate = 10
    confettiCell.lifetime = 8
    confettiCell.lifetimeRange = 0
    confettiCell.velocity = 175
    confettiCell.velocityRange = 40
    confettiCell.emissionLongitude = .pi
    confettiCell.emissionRange = .pi
    confettiCell.spin = 1.75
    confettiCell.spinRange = 2
    confettiCell.scaleRange = 0.5
    confettiCell.scaleSpeed = -0.05
    return confettiCell
  }

}
