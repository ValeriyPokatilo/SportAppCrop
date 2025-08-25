import Foundation
import StructureKit
import RxCocoa
import RxSwift

final class InfoTabViewController: StructurKitController {}

final class InfoTabViewModel: StructurKitViewModelAbstract {

    let title = BehaviorRelay<String?>(value: "tabBarTitleInfoStr".localized())
    let sections = BehaviorRelay(value: [StructureSection]())
    let registerClasses: [UITableViewCell.Type] = [InfoCell.self]

    var showIndicatorsList: EmptyBlock?
    var showDefaultUnit: EmptyBlock?
    var showServiceMenu: EmptyBlock?
    var showPurchaseMenu: EmptyBlock?

    private var confStorage = ConfStorage.shared
    private let disposeBag = DisposeBag()

    init() {
        configureDynamics()
    }

    private func configureDynamics() {
        confStorage.confObservable.subscribe(onNext: { [weak self] _ in
            self?.buildCells()
        })
        .disposed(by: disposeBag)
    }

    private func buildCells() {
        var rows = [Structurable]()
        var section = StructureSection(identifier: "section")

        rows.append(createSubscriptionsRow())
        rows.append(createIndicatorRow())
        rows.append(createUnitRow())
        rows.append(createFeatureRow())
        rows.append(createBugRow())

        #if DEBUG
            rows.append(createDebugRow())
        #endif

        section.rows = rows
        sections.accept([section])
    }

    private func createSubscriptionsRow() -> Structurable {
        return InfoCellModel(
            id: "subscriptions",
            item: .subscriptions,
            didSelect: { [weak self] _ in
                self?.showPurchaseMenu?()
                return true
            }
        )
    }

    private func createIndicatorRow() -> Structurable {
        return InfoCellModel(
            id: "indicators",
            item: .indicators,
            didSelect: { [weak self] _ in
                self?.showIndicatorsList?()
                return true
            }
        )
    }

    private func createUnitRow() -> Structurable {
        return InfoCellModel(
            id: "units",
            item: .defaultUnits,
            didSelect: { [weak self] _ in
                self?.showDefaultUnit?()
                return true
            }
        )
    }

    private func createFeatureRow() -> Structurable {
        return InfoCellModel(
            id: "feature",
            item: .feature,
            didSelect: { [weak self] _ in
                AnalyticsManager.shared.logFeatureRequested()
                self?.openMailClient(subject: "requestFeatureStr".localized(), recipient: .myMail)
                return true
            }
        )
    }

    private func createBugRow() -> Structurable {
        return InfoCellModel(
            id: "bug",
            item: .bug,
            didSelect: { [weak self] _ in
                AnalyticsManager.shared.logBugReported()
                self?.openMailClient(subject: "reportBugStr".localized(), recipient: .myMail)
                return true
            }
        )
    }

    private func createDebugRow() -> Structurable {
        return InfoCellModel(
            id: "debug",
            item: .debugMenu,
            didSelect: { [weak self] _ in
                self?.showServiceMenu?()
                return true
            }
        )
    }

    private func openMailClient(subject: String, recipient: String) {
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedRecipient = recipient.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        if let url = URL(string: "mailto:\(encodedRecipient)?subject=\(encodedSubject)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
