import UIKit

protocol TitledEnum {
    var enumTitle: String { get }
    var image: UIImage? { get }
    static var allTitle: String { get }
}
