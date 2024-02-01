import UIKit

extension CAGradientLayer {
    static func gradientLayer(for style: CustomGradientStyle, in frame: CGRect) -> Self {
        let layer = Self()
        layer.colors = colors(for: style)
        layer.frame = frame
        return layer
    }
    
    private static func colors(for style: CustomGradientStyle) -> [CGColor] {
        let beginColor: UIColor
        let endColor: UIColor

        switch style {
        case .orangeToPurple:
            beginColor = Colors.brightOrange
            endColor = Colors.royalPurple
        case .greyToTeal:
            beginColor = Colors.paleGrey
            endColor = Colors.teal
        case .greyToOrange:
            beginColor = Colors.paleGrey
            endColor = Colors.brightOrange
        }
        return [beginColor.cgColor, endColor.cgColor]
    }
}
