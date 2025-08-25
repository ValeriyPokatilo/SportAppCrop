import Foundation

// swiftlint:disable file_length
// swiftlint:disable type_body_length

final class MockListExercises {

    static let shared = MockListExercises()

    let array: [ExerciseModel] = [
        .smithMachineVerticalLegPress,
        .machineShoulderPress,
        .barbellBenchPress,
        .dumbbellLateralRaise,
        .pushUps,
        .diamondPushUps,
        .pullUp,
        .alternatingDumbbellCurl,
        .bodyweightSquat,
        .jumpRope,
        .cableTricepPushdown,
        .seatedDumbbellBicepCurl,
        .dumbbellBicepCurl,
        .seatedDumbbellLateralRaise,
        .elliptical
    ]

    private init() {
    }

    func fillData() {
        array.forEach {
            ExerciseStorage.shared.addExercise($0)
        }
    }
}

// swiftlint:enable file_length
// swiftlint:enable type_body_length
