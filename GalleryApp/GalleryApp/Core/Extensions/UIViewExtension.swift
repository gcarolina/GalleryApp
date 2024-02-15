import UIKit

extension UIView {
    func setupShadow() {
        layer.shadowColor = Colors.paleGrey.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 3
        layer.masksToBounds = false
    }
}
