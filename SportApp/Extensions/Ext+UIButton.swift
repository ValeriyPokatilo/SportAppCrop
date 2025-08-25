import UIKit

extension UIButton {
    func setImageSize(_ size: CGSize) {
        if imageView != nil {
            guard let image = self.image(for: .normal) else { return }

            let newImage = UIGraphicsImageRenderer(size: size).image { _ in
                image.draw(in: CGRect(origin: .zero, size: size))
            }

            self.setImage(newImage, for: .normal)
            self.setImage(newImage, for: .highlighted)
            self.setImage(newImage, for: .selected)
        }
    }
}
