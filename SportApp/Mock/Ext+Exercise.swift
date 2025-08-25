import Foundation

// swiftlint:disable file_length

extension ExerciseModel {

    static let smithMachineVerticalLegPress = ExerciseModel(
        id: UUID(uuidString: "6C160CFD-2989-4BF5-8E21-4065D2E7FB4F")!,
        title: nil,
        titleRu: "Вертикальный жим ногами",
        titleEn: "Smith Machine Vertical Leg Press",
        unitType: .withWeight,
        muscleGroups: [.legs],
        equipment: [.machine],
        iconName: "smithMachineVerticalLegPressIcon",
        imageName: "smithMachineVerticalLegPressImage",
        canEdit: false
    )
    static let machineShoulderPress = ExerciseModel(
        id: UUID(uuidString: "0C208CC7-07BF-4832-8B79-B0705C0ED0A3")!,
        title: nil,
        titleRu: "Жим на плечи в тренажёре сидя",
        titleEn: "Seated Machine Shoulder Press",
        unitType: .withWeight,
        muscleGroups: [.shoulders],
        equipment: [.machine],
        iconName: "machineShoulderPressIcon",
        imageName: "machineShoulderPressImage",
        canEdit: false
    )
    static let barbellBenchPress = ExerciseModel(
        id: UUID(uuidString: "8B8D801D-4C49-4EF0-8B79-2432480459C6")!,
        title: nil,
        titleRu: "Жим штанги лёжа",
        titleEn: "Barbell Bench Press",
        unitType: .withWeight,
        muscleGroups: [.chest, .arms, .shoulders],
        equipment: [.barbell, .bench],
        iconName: "barbellBenchPressIcon",
        imageName: "barbellBenchPressImage",
        canEdit: false
    )
    static let dumbbellLateralRaise = ExerciseModel(
        id: UUID(uuidString: "70D0B209-1B9E-4032-B442-E7F2C05AB4EB")!,
        title: nil,
        titleRu: "Махи гантелями в стороны",
        titleEn: "Dumbbell Lateral Raise",
        unitType: .withWeight,
        muscleGroups: [.shoulders],
        equipment: [.dumbbell],
        iconName: "dumbbellLateralRaiseIcon",
        imageName: "dumbbellLateralRaiseImage",
        canEdit: false
    )
    static let pushUps = ExerciseModel(
        id: UUID(uuidString: "B807A6BE-843D-497C-8AB2-BE4AD1336BA9")!,
        title: nil,
        titleRu: "Отжимания",
        titleEn: "Push-Ups",
        unitType: .withoutWeight,
        muscleGroups: [.chest, .arms, .shoulders],
        equipment: [.bodyweight],
        iconName: "pushUpsIcon",
        imageName: "pushUpsImage",
        canEdit: false
    )
    static let diamondPushUps = ExerciseModel(
        id: UUID(uuidString: "3C2794EF-2816-495E-A277-10E52928C4C9")!,
        title: nil,
        titleRu: "Отжимания бриллиантом",
        titleEn: "Diamond Push-Ups",
        unitType: .withoutWeight,
        muscleGroups: [.arms, .chest],
        equipment: [.bodyweight],
        iconName: "diamondPushUpsIcon",
        imageName: "diamondPushUpsImage",
        canEdit: false
    )
    static let pullUp = ExerciseModel(
        id: UUID(uuidString: "10FB8209-8F87-44E8-A018-CAD7EAA4BE3C")!,
        title: nil,
        titleRu: "Подтягивания",
        titleEn: "Pull-Up",
        unitType: .withoutWeight,
        muscleGroups: [.back],
        equipment: [.pullUpBar],
        iconName: "pullUpIcon",
        imageName: "pullUpImage",
        canEdit: false
    )
    static let alternatingDumbbellCurl = ExerciseModel(
        id: UUID(uuidString: "CF858CA9-DBBE-40CE-A500-3FFC08D5A1F0")!,
        title: nil,
        titleRu: "Попеременный подъем гантелей на бицепс",
        titleEn: "Alternating Dumbbell Curl",
        unitType: .withWeight,
        muscleGroups: [.arms],
        equipment: [.dumbbell],
        iconName: "alternatingDumbbellCurlIcon",
        imageName: "alternatingDumbbellCurlImage",
        canEdit: false
    )
    static let bodyweightSquat = ExerciseModel(
        id: UUID(uuidString: "CAF147AA-585D-4CC7-A88D-991DE63BEA9B")!,
        title: nil,
        titleRu: "Приседания без веса",
        titleEn: "Bodyweight Squat",
        unitType: .withoutWeight,
        muscleGroups: [.legs],
        equipment: [.bodyweight],
        iconName: "bodyweightSquatIcon",
        imageName: "bodyweightSquatImage",
        canEdit: false
    )
    static let jumpRope = ExerciseModel(
        id: UUID(uuidString: "E3E81D1B-4AD2-42E0-9F37-A4E8D9B3EF37")!,
        title: nil,
        titleRu: "Прыжки на скакалке",
        titleEn: "Jump Rope",
        unitType: .timer,
        muscleGroups: [.legs, .cardio],
        equipment: [.other],
        iconName: "jumpRopeIcon",
        imageName: "jumpRopeImage",
        canEdit: false
    )
    static let cableTricepPushdown = ExerciseModel(
        id: UUID(uuidString: "65202BE8-E925-4E58-8D51-BE99860C0AC6")!,
        title: nil,
        titleRu: "Разгибание рук на верхнем блоке стоя",
        titleEn: "Cable Tricep Pushdown",
        unitType: .withWeight,
        muscleGroups: [.arms],
        equipment: [.machine],
        iconName: "cableTricepPushdownIcon",
        imageName: "cableTricepPushdownImage",
        canEdit: false
    )
    static let seatedDumbbellBicepCurl = ExerciseModel(
        id: UUID(uuidString: "C8C24498-CE36-404D-BC65-8C09C997329E")!,
        title: nil,
        titleRu: "Сгибание рук с гантелями сидя",
        titleEn: "Seated Dumbbell Bicep Curl",
        unitType: .withWeight,
        muscleGroups: [.arms],
        equipment: [.dumbbell, .bench],
        iconName: "seatedDumbbellBicepCurlIcon",
        imageName: "seatedDumbbellBicepCurlImage",
        canEdit: false
    )
    static let dumbbellBicepCurl = ExerciseModel(
        id: UUID(uuidString: "58C22EF2-B8C9-4CD1-9586-19338E5C2FDA")!,
        title: nil,
        titleRu: "Сгибания рук с гантелями стоя",
        titleEn: "Dumbbell Bicep Curl",
        unitType: .withWeight,
        muscleGroups: [.arms],
        equipment: [.dumbbell],
        iconName: "dumbbellBicepCurlIcon",
        imageName: "dumbbellBicepCurlImage",
        canEdit: false
    )
    static let seatedDumbbellLateralRaise = ExerciseModel(
        id: UUID(uuidString: "B46E827B-AEEA-4A14-AAE2-EB4571874760")!,
        title: nil,
        titleRu: "Сидячие махи гантелями в стороны",
        titleEn: "Seated Dumbbell Lateral Raise",
        unitType: .withWeight,
        muscleGroups: [.shoulders],
        equipment: [.dumbbell],
        iconName: "seatedDumbbellLateralRaiseIcon",
        imageName: "seatedDumbbellLateralRaiseImage",
        canEdit: false
    )
    static let elliptical = ExerciseModel(
        id: UUID(uuidString: "B1E43C34-8F16-4E36-A8D6-2CC951950C1F")!,
        title: nil,
        titleRu: "Эллипс",
        titleEn: "Elliptical",
        unitType: .distance,
        muscleGroups: [.cardio, .legs, .arms],
        equipment: [.cardioMachine],
        iconName: "ellipticalIcon",
        imageName: "ellipticalImage",
        canEdit: false
    )
}

// swiftlint:enable file_length
