import UIKit

struct ActionButton: Hashable {
    let title: String
    let color: UIColor
    let tapAction: EmptyBlock

    static func == (lhs: ActionButton, rhs: ActionButton) -> Bool {
        lhs.title == rhs.title
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}
