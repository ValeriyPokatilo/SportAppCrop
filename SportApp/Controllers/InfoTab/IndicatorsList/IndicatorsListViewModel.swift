import Foundation
import StructureKit
import RxSwift
import RxCocoa

final class IndicatorsListViewController: StructurKitController {}

final class IndicatorsListViewModel: StructurKitViewModelAbstract {

    let title = BehaviorRelay<String?>(value: "indicatorsStr".localized())
    let sections = BehaviorRelay(value: [StructureSection]())
    let registerClasses: [UITableViewCell.Type] = [IndicatorCell.self]
    var rightBarButtonItem: UIBarButtonItem?
    let placeholderView: BehaviorRelay<UIView?> = .init(value: nil)
    var plusIsHidden: Driver<Bool> {
        plusIsHiddenState.asDriver().map({ $0 })
    }
    var plusIsHiddenState: BehaviorRelay<Bool> = .init(value: false)

    var indicatorEdit: ParameterBlock<IndicatorEntity?>?
    var recordEdit: DoubleParametersBlock<RecordEntity?, IndicatorEntity?>?
    var showCreateIndicator: EmptyBlock?
    var showPurchaseView: EmptyBlock?
    var showIndicatorDetails: ParameterBlock<IndicatorEntity>?

    private let indicatorsStorage = IndicatorsStorage.shared
    private let indicators = BehaviorRelay(value: [IndicatorEntity]())
    private let disposeBag = DisposeBag()

    init() {
        configureControl()
        configureDynamics()
    }

    private func configureControl() {
        rightBarButtonItem = UIBarButtonItem(
            image: .plusImg,
            style: .plain,
            target: self,
            action: #selector(plusTap)
        )
    }

    private func configureDynamics() {
        indicatorsStorage
            .indicatorsObservable
            .subscribe(onNext: { [weak self] indicators in
                self?.indicators.accept(indicators)
            })
            .disposed(by: disposeBag)

        indicators
            .subscribe(onNext: { [weak self] _ in
                self?.buildCells()
            })
            .disposed(by: disposeBag)
    }

    private func buildCells() {
        var rows = [Structurable]()
        var section = StructureSection(identifier: "section")

        if indicators.value.isEmpty {
            plusIsHiddenState.accept(true)
            placeholderView.accept(
                PlaceholderView(
                    title: "newIndicatorStr".localized(),
                    createBlock: { [weak self] in
                        self?.showCreateIndicator?()
                    }
                )
            )
        } else {
            placeholderView.accept(nil)
            plusIsHiddenState.accept(false)

            indicators.value.forEach { item in
                rows.append(IndicatorCellModel(
                    id: item.id,
                    indicator: item,
                    plusTapAction: { [weak self] in
                        self?.recordEdit?(nil, item)
                    },
                    editTapAction: { [weak self] in
                        self?.indicatorEdit?(item)
                    },
                    recordEdit: { [weak self] record, indicator in
                        self?.recordEdit?(record, indicator)
                    },
                    moreAction: { [weak self] in
                        self?.showIndicatorDetails?(item)
                    }
                ))
            }
        }

        section.rows = rows
        sections.accept([section])
    }

    @objc private func plusTap() {
        if PurchaseManager.shared.rights == .all {
            indicatorEdit?(nil)
        } else {
            if indicators.value.count < 2 {
                indicatorEdit?(nil)
            } else {
                showPurchaseView?()
            }
        }
    }
}
