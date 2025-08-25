import Foundation
import StructureKit
import RxSwift
import RxCocoa

final class ExerciseInfoViewController: StructurKitController {}

final class ExerciseInfoViewModel: StructurKitViewModelAbstract, TableViewDidLoad {

    let title = BehaviorRelay<String?>(value: "")
    let sections = BehaviorRelay(value: [StructureSection]())
    let registerClasses: [UITableViewCell.Type] = [
        SetsArviveCell.self,
        ImageCell.self,
        ExerciseSegmentedCell.self,
        LabelCell.self,
        ExerciseGroupCell.self,
        ChartCell.self
    ]
    let placeholderView: BehaviorRelay<UIView?> = .init(value: nil)
    var rightBarButtonItem: UIBarButtonItem?

    var sendReport: ParameterBlock<ExerciseModel>?
    var showEdit: ParameterBlock<ExerciseModel>?

    private var exercise: ExerciseModel
    private let setArchive: BehaviorRelay<[SetArchive]> = .init(value: [])
    private let currentIndex: BehaviorRelay<Int> = .init(value: 0)
    private let disposeBag = DisposeBag()
    private let confStorage = ConfStorage.shared
    private let exerciseStorage = ExerciseStorage.shared
    private let coreDataManager = CoreDataManager.shared

    init(exercise: ExerciseModel) {
        self.exercise = exercise
        self.title.accept(exercise.localizedTitle)

        currentIndex.accept(ConfStorage.shared.conf.currentInfoTab ?? 0)
        configureControl()
        configureDynamics()
    }

    func viewDidLoad() {
        let sets = coreDataManager.fetchWorkoutSetsGroupedByDate(for: exercise.id)
        setArchive.accept(sets)
    }

    private func configureControl() {
        if exercise.canEdit ?? true {
            rightBarButtonItem = UIBarButtonItem(
                image: .editImg,
                style: .plain,
                target: self,
                action: #selector(editTap)
            )
        }
    }

    private func configureDynamics() {
        setArchive.subscribe(onNext: { [weak self] _ in
            self?.buildCells()
        })
        .disposed(by: disposeBag)

        currentIndex.subscribe(onNext: { [weak self] _ in
            self?.buildCells()
        })
        .disposed(by: disposeBag)

        exerciseStorage.exercisesObservable
            .subscribe(onNext: { [weak self] items in
                guard let self else { return }
                guard let updatedExercise = items.first(where: { $0.id == self.exercise.id }) else {
                    return
                }
                self.exercise = updatedExercise
                self.title.accept(updatedExercise.title)
                self.buildCells()
            })
            .disposed(by: disposeBag)
    }

    private func buildCells() {
        var rows = [Structurable]()
        var section = StructureSection(identifier: "section")

        rows += createHeaderRows()

        switch currentIndex.value {
        case 0:
            placeholderView.accept(nil)
            rows += createInfoTabRows()
        case 1:
            rows += createHistoryTabRows()
        default:
            return
        }

        section.rows = rows
        sections.accept([section])
    }

    private func createHeaderRows() -> [Structurable] {
        return [
            ExerciseSegmentedCellModel(
                id: "segmented",
                index: currentIndex.value,
                valueChanged: { [weak self] index in
                    self?.currentIndex.accept(index)
                    self?.updateConf(index: index)
                }
            )
        ]
    }

    private func createInfoTabRows() -> [Structurable] {
        var rows: [Structurable] = []

        rows.append(ImageCellModel(id: "image", imageName: exercise.imageName))

        rows.append(LabelCellModel(
            id: "desc",
            text: ExerciseStringService.makeDescString(exercise)
        ))

        rows.append(LabelCellModel(
            id: "muscleTitle",
            text: "musclesStr".localized(),
            size: 12,
            weight: .bold
        ))

        rows.append(
            ExerciseGroupCellModel(
                id: "muscleImgs",
                muscleImages: MuscleButton<MuscleGroup>(groups: exercise.muscleGroups ?? [.other]),
                equipmentImages: nil
            )
        )

        rows.append(LabelCellModel(
            id: "equipmentTitle",
            text: "equipmentsStr".localized(),
            size: 12,
            weight: .bold
        ))

        rows.append(
            ExerciseGroupCellModel(
                id: "equipmentImgs",
                muscleImages: nil,
                equipmentImages: MuscleButton<Equipment>(groups: exercise.equipment ?? [.other])
            )
        )

        if !(exercise.canEdit ?? true) {
            rows.append(LabelCellModel(
                id: "error",
                text: "reportMistakeStr".localized(),
                color: .systemRed,
                size: 14,
                alignment: .center,
                didSelect: { [weak self] _ in
                    guard let self else {
                        return false
                    }
                    self.sendReport?(self.exercise)
                    return true
                }
            ))
        }

        return rows
    }

    private func createHistoryTabRows() -> [Structurable] {
        var rows: [Structurable] = []
        let sets = setArchive.value

        if sets.isEmpty {
            placeholderView.accept(PlaceholderView(
                title: "noHistoryStr".localized(),
                showButton: false,
                createBlock: nil
            ))
        } else {
            placeholderView.accept(nil)

            let values = setArchive.value
                .reversed()
                .map { String.makeResultValue(for: exercise, sets: $0.sets) }

            rows.append(
                ChartCellModel(
                    id: exercise.id,
                    unitString: exercise.unitType.descriptionWeight,
                    values: values.map { Double($0) }
                )
            )

            setArchive.value.forEach { arch in
                rows.append(
                    SetsArviveCellModel(exercise: exercise, archive: arch, showSetView: nil)
                )
            }
        }

        return rows
    }

    private func updateConf(index: Int) {
        var lastConf = confStorage.conf
        lastConf.currentInfoTab = index
        confStorage.updateConfiguration(lastConf)
    }

    @objc private func editTap() {
        showEdit?(exercise)
    }
}
