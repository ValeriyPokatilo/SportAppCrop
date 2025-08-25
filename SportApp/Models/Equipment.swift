import UIKit

enum Equipment: Codable, TitledEnum, CaseIterable {

    static var allTitle: String = "allEquipmentsStr".localized()

    case plate
    case machine
    case cardioMachine
    case kettlebell
    case dumbbell
    case barbell
    case resistanceBand
    case ball
    case bench
    case parallelBars
    case pullUpBar
    case rope
    case other
    case bodyweight

    var raw: String {
        switch self {
        case .plate:
            "plate"
        case .machine:
            "machine"
        case .cardioMachine:
            "cardioMachine"
        case .kettlebell:
            "kettlebell"
        case .dumbbell:
            "dumbbell"
        case .barbell:
            "barbell"
        case .resistanceBand:
            "resistanceBand"
        case .bodyweight:
            "bodyweight"
        case .ball:
            "ball"
        case .bench:
            "bench"
        case .parallelBars:
            "parallelBars"
        case .pullUpBar:
            "pullUpBar"
        case .rope:
            "rope"
        case .other:
            "other"
        }
    }

    var title: String {
        switch self {
        case .plate:
            "plate".eqLocalized()
        case .machine:
            "machine".eqLocalized()
        case .cardioMachine:
            "cardioMachine".eqLocalized()
        case .kettlebell:
            "kettlebell".eqLocalized()
        case .dumbbell:
            "dumbbell".eqLocalized()
        case .barbell:
            "barbell".eqLocalized()
        case .resistanceBand:
            "resistanceBand".eqLocalized()
        case .bodyweight:
            "bodyweight".eqLocalized()
        case .ball:
            "ball".eqLocalized()
        case .bench:
            "bench".eqLocalized()
        case .parallelBars:
            "parallelBars".eqLocalized()
        case .pullUpBar:
            "pullUpBar".eqLocalized()
        case .rope:
            "rope".eqLocalized()
        case .other:
            "other".eqLocalized()
        }
    }

    var image: UIImage? {
        switch self {
        case .plate:
            UIImage(named: "plate")
        case .machine:
            UIImage(named: "machine")
        case .cardioMachine:
            UIImage(named: "cardioMachine")
        case .kettlebell:
            UIImage(named: "kettlebell")
        case .dumbbell:
            UIImage(named: "dumbbell")
        case .barbell:
            UIImage(named: "barbell")
        case .resistanceBand:
            UIImage(named: "resistanceBand")
        case .bodyweight:
            UIImage(named: "bodyweight")
        case .ball:
            UIImage(named: "ball")
        case .bench:
            UIImage(named: "bench")
        case .parallelBars:
            UIImage(named: "parallelBars")
        case .pullUpBar:
            UIImage(named: "pullUpBar")
        case .rope:
            UIImage(named: "rope")
        case .other:
            UIImage(named: "otherEq")
        }
    }

    var enumTitle: String {
        title
    }
}
