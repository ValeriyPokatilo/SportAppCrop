import Foundation
import StructureKit
import RxSwift
import RxCocoa

final class IndicatorDetailsViewController: StructurKitController {}

final class IndicatorDetailsViewModel: StructurKitViewModelAbstract {

    let title = BehaviorRelay<String?>(value: "")
    let sections = BehaviorRelay(value: [StructureSection]())
    let registerClasses: [UITableViewCell.Type] = [ChartCell.self, IndicatorRecordsCell.self]

    var recordEdit: DoubleParametersBlock<RecordEntity?, IndicatorEntity?>?

    private let indicator: IndicatorEntity
    private let disposeBag = DisposeBag()
    private let indicatorsStorage = IndicatorsStorage.shared

    init(indicator: IndicatorEntity) {
        self.indicator = indicator
        if let indTitle = indicator.title, let indUnit = indicator.unit {
            title.accept("\(indTitle) (\(indUnit))")
        }

        configureDynamics()
    }

    private func configureDynamics() {
        indicatorsStorage
            .indicatorsObservable
            .subscribe(onNext: { [weak self] _ in
                self?.buildCells()
            })
            .disposed(by: disposeBag)
    }

    private func buildCells() {
        var rows = [Structurable]()
        var section = StructureSection(identifier: "section")

        if let records = indicator.records as? Set<RecordEntity> {
            rows.append(ChartCellModel(
                id: indicator.id,
                unitString: indicator.unit ?? "",
                values: records
                    .sorted(by: { $0.timestamp ?? Date() < $1.timestamp ?? Date() })
                    .map({Double($0.value)})
            ))

            rows.append(IndicatorRecordsCellModel(
                id: indicator.title,
                indicator: indicator,
                recordEdit: { [weak self] record, indicator in
                    self?.recordEdit?(record, indicator)
                }
            ))
        }

        section.rows = rows
        sections.accept([section])
    }
}
