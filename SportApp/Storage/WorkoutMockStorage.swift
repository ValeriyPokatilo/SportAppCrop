import Foundation

// swiftlint:disable line_length

extension Template {
    static let gymStart = Template(
        titleRu: "Быстрый старт в зале",
        titleEn: "Gym Quick Start",
        level: .junior,
        descRu: "Простая тренировка на 1 день с 8 упражнениями для всех основных групп мышц.",
        descEn: "Simple 1-day workout with 8 exercises for all major muscle groups.",
        image: "junuorGym",
        workouts: [
            WorkoutModel(
                id: UUID(),
                title: "Gym Start",
                exerciseIds: [
                    ExerciseModel.elliptical.id,
                    ExerciseModel.barbellBenchPress.id,
                    ExerciseModel.pullUp.id,
                    ExerciseModel.alternatingDumbbellCurl.id
                ]
            )
        ]
    )

    static let homeStart = Template(
        titleRu: "Быстрый старт дома",
        titleEn: "Home Quick Start",
        level: .junior,
        descRu: "Простая тренировка на 1 день с 8 упражнениями для всех основных групп мышц. Идеально для выполнения дома, без специального оборудования.",
        descEn: "Simple 1-day workout with 8 exercises for all major muscle groups. Perfect for training at home with no equipment.",
        image: "juniorHome",
        workouts: [
            WorkoutModel(
                id: UUID(),
                title: "Home Start",
                exerciseIds: [
                    ExerciseModel.jumpRope.id,
                    ExerciseModel.pushUps.id,
                    ExerciseModel.pullUp.id,
                    ExerciseModel.bodyweightSquat.id
                ]
            )
        ]
    )
}

// swiftlint:enable line_length
