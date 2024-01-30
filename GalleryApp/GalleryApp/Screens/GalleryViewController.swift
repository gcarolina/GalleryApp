import UIKit

final class GalleryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        let gradientLayer = CAGradientLayer.gradientLayer(for: .greyToPurple, in: view.bounds)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
