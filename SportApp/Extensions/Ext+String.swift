import Foundation

// swiftlint:disable line_length

extension String {
    static let appName = "MaximumGym"
    static let myMail = "support@xlauncher.app"
    static let remainingTime = "remainingTime"
    static let lastActiveTimestamp = "lastActiveTimestamp"
    static let privacyPolicy = "https://xlauncher.app/gymMapPP.html"
    static let termsOfUse = "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"
    static let subs = "https://apps.apple.com/account/subscriptions"
}

extension String {
    static func makeTotalString(for exercise: ExerciseModel, sets: [SetEntity]) -> String {
        switch exercise.unitType {
        case .withWeight:
            let totalWeight = sets.reduce(0) { $0 + ($1.weight * Double($1.reps)) }
            let totalReps = sets.reduce(0) { $0 + $1.reps }
            let avgWeightPerRep = totalReps > 0 ? totalWeight / Double(totalReps) : 0

            return """
            \("totalStr".localized()) \(Int(totalWeight)) \(exercise.unitType.descriptionWeight) \
            \("dotStr".localized()) \(totalReps) \("repsStr".localized()) \
            \("dotStr".localized()) \(Int(avgWeightPerRep)) \(exercise.unitType.descriptionWeight)/\("repsStr".localized())
            """

        case .withoutWeight, .timer:
            let totalReps = sets.reduce(0) { $0 + Int($1.reps) }
            return "\("totalStr".localized()) \(totalReps) \(exercise.unitType.descriptionReps)"

        case .distance:
            let totalDistance = sets.reduce(0) { $0 + $1.weight }
            let totalTime = sets.reduce(0) { $0 + $1.reps }
            let pace = totalDistance > 0 ? Double(totalTime) / totalDistance : 0

            return """
            \("totalStr".localized()) \(totalDistance) \(exercise.unitType.descriptionWeight) \
            \("dotStr".localized()) \(totalTime) \("minStr".localized()) \
            \("dotStr".localized()) \(String(format: "%.1f", pace)) \("minStr".localized())/\
            \(exercise.unitType.descriptionWeight)
            """
        }
    }

    static func makeResultString(for exercise: ExerciseModel, sets: [SetEntity]) -> String {
        switch exercise.unitType {
        case .withWeight:
            let totalWeight = sets.reduce(0) { $0 + ($1.weight * Double($1.reps)) }

            return "\(Int(totalWeight)) \(exercise.unitType.descriptionWeight)"

        case .withoutWeight, .timer:
            let totalReps = sets.reduce(0) { $0 + Int($1.reps) }
            return "\(totalReps) \(exercise.unitType.descriptionReps)"

        case .distance:
            let totalDistance = sets.reduce(0) { $0 + $1.weight }
            return "\(totalDistance) \(exercise.unitType.descriptionWeight)"
        }
    }

    static func makeResultValue(for exercise: ExerciseModel, sets: [SetEntity]) -> Double {
        switch exercise.unitType {
        case .withWeight:
            let totalWeight = sets.reduce(0) { $0 + ($1.weight * Double($1.reps)) }
            return totalWeight

        case .withoutWeight, .timer:
            let totalReps = sets.reduce(0) { $0 + Int($1.reps) }
            return Double(totalReps)

        case .distance:
            let totalDistance = sets.reduce(0) { $0 + $1.weight }
            return totalDistance
        }
    }
}

extension String {
    var normalizedForSearch: String {
        return self
            .lowercased()
            .replacingOccurrences(of: "ё", with: "е")
            .replacingOccurrences(of: "ъ", with: "ь")
    }
}

extension String {
    func localized() -> String {
        NSLocalizedString(
            self,
            tableName: "AppLocalizable",
            bundle: .main,
            value: self,
            comment: self
        )
    }

    func mgLocalized() -> String {
        NSLocalizedString(
            self,
            tableName: "MGLocalizable",
            bundle: .main,
            value: self,
            comment: self
        )
    }

    func eqLocalized() -> String {
        NSLocalizedString(
            self,
            tableName: "EQLocalizable",
            bundle: .main,
            value: self,
            comment: self
        )
    }
}

// swiftlint:enable line_length
