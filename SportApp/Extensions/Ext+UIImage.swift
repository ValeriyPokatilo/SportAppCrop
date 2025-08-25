import UIKit

extension UIImage {
    // Tabs
    static let mainTabImg = UIImage(systemName: "play.circle")
    static let exercisesTabImg = UIImage(systemName: "list.bullet.circle")
    static let infoTabImg = UIImage(systemName: "info.circle")

    // Checkbox
    static let checkMarkEmptyImg = UIImage(systemName: "square")
    static let checkMarkFillImg = UIImage(systemName: "checkmark.square.fill")

    // Swipe menu
    static let trashImg = UIImage(systemName: "trash.circle")
    static let editImg = UIImage(systemName: "square.and.pencil.circle")

    // Set
    static let checkOkImg = UIImage(systemName: "checkmark.circle.fill")
    static let plusImg = UIImage(systemName: "plus")
    static let plusCircleImg = UIImage(systemName: "plus.circle.fill")
    static let editCircleImg = UIImage(systemName: "square.and.pencil.circle")
    static let clearCircleImg = UIImage(systemName: "xmark.circle")
    static let playImg = UIImage(systemName: "play.fill")
    static let pauseImg = UIImage(systemName: "pause.fill")
    static let stopImg = UIImage(systemName: "stop.fill")
    static let previousImg = UIImage(systemName: "arrowshape.turn.up.backward.badge.clock")
    static let infoImg = UIImage(systemName: "info.circle.fill")
    static let folderImg = UIImage(systemName: "folder.circle.fill")
    static let restartFillImg = UIImage(systemName: "arrow.clockwise.square.fill")
    static let templateImg = UIImage(systemName: "archivebox")
    static let finalizeImg = UIImage(systemName: "flag.pattern.checkered.2.crossed")
    static let chevronLeftImg = UIImage(systemName: "chevron.left.circle")
    static let chevronRightImg = UIImage(systemName: "chevron.right.circle")
    static let dotImg = UIImage(systemName: "smallcircle.filled.circle")
    static let closeImg = UIImage(systemName: "xmark")
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
