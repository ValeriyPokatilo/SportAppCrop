import UIKit
import RxCocoa

protocol Searchable {
    var searchText: BehaviorRelay<String?> { get }
    var filter: Driver<ExerciseFilter> { get }
    func equipmentTapped()
    func muscleTapped()
    func unitTypeTapped()
    func clearTapped()
}
