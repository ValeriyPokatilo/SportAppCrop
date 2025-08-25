import UIKit
import StructureKit
import RxSwift
import RxCocoa
import SnapKit

class StructurKitController: UIViewController {

    private let structureController = StructureController()
    private let disposeBag = DisposeBag()
    
    private var snapshotView: UIView?
    private var searchField = UISearchTextField(frame: .zero)
    private var filterView = FilterView()
    private var tableView = UITableView(frame: .zero, style: .plain)
    private var actionButton = UIButton(type: .system)
    private var plusImageView = UIImageView(frame: .zero)

    private let plusImageViewSize: CGFloat = 58

    private var sourceIndexPath: IndexPath?
    private var currentIndexPath: IndexPath?

    var viewModel: StructurKitViewModelAbstract

    init(_ viewModel: StructurKitViewModelAbstract) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        configureAppearance()
        configureLayout()
        configureTableView()
        configureDynamics()

        if let viewModel = viewModel as? TableViewDidLoad {
            viewModel.viewDidLoad()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let viewModel = viewModel as? TableViewDidAppear {
            viewModel.viewDidAppear()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel is StructuredTableNavigation {
            (navigationController as? BaseNavigationController)?.navigationBarDelegate = self
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (navigationController as? BaseNavigationController)?.navigationBarDelegate === self {
            (navigationController as? BaseNavigationController)?.navigationBarDelegate = nil
        }
    }

    private func configureDynamics() {
        viewModel.title.subscribe(onNext: { [weak self] value in
            self?.title = value
        })
        .disposed(by: disposeBag)

        viewModel.sections.subscribe(onNext: { [weak self] sections in
            self?.structureController.set(structure: sections)
        })
        .disposed(by: disposeBag)

        viewModel.tableSetEditing.subscribe(onNext: { [weak self] value in
            self?.tableView.setEditing(value, animated: false)
        })
        .disposed(by: disposeBag)

        viewModel
            .placeholderView
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] view in
            self?.tableView.backgroundView = view
        })
        .disposed(by: disposeBag)

        viewModel.showAlert.subscribe(onNext: { [weak self] conf in
            guard let conf else {
                return
            }

            self?.showAlert(conf: conf)
        })
        .disposed(by: disposeBag)
    }

    private func addViews() {
        view.addSubview(tableView)
        
        if viewModel is Searchable {
            view.addSubview(searchField)
            view.addSubview(filterView)
        }
        
        if viewModel is Actionable {
            view.addSubview(actionButton)
        }
        
        if viewModel is Plusable {
            view.addSubview(plusImageView)
        }
    }

    private func configureLayout() {
        switch viewModel { 
        case is Searchable:
            searchField.snp.remakeConstraints { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(8)
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().offset(-20)
            }
            
            filterView.snp.remakeConstraints { make in
                make.top.equalTo(searchField.snp.bottom).offset(8)
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().offset(-20)
            }
            
            tableView.snp.remakeConstraints { make in
                make.top.equalTo(filterView.snp.bottom)
                make.bottom.equalToSuperview()
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
            }

        case is Actionable:
            tableView.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.bottom.equalTo(actionButton.snp.top).offset(-8)
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
            }

            actionButton.snp.remakeConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-12)
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().offset(-20)
            }

        default:
            tableView.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        if viewModel is Plusable {
            plusImageView.snp.remakeConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-30)
                make.size.equalTo(plusImageViewSize)
                make.trailing.equalToSuperview().offset(-30)
           }
        }
    }

    private func configureTableView() {
        tableView.separatorStyle = viewModel.separatorStyle
        tableView.sectionHeaderHeight = CGFloat.leastNonzeroMagnitude
        tableView.sectionFooterHeight = CGFloat.leastNonzeroMagnitude
        tableView.backgroundColor = viewModel.backgroundColor
        tableView.sectionHeaderTopPadding = .zero
        tableView.registerClasses(with: viewModel.registerClasses)
        tableView.registerHeaderFooter(with: viewModel.headerFooterTypes)
        structureController.register(tableView)

        let longPressGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleLongPressGesture(_:))
        )
        longPressGesture.minimumPressDuration = 0.3
        tableView.addGestureRecognizer(longPressGesture)
    }

    private func configureAppearance() {
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .systemGreen

        view.backgroundColor = viewModel.backgroundColor

        if let leftBarButtonItem = viewModel.leftBarButtonItem {
            navigationItem.leftBarButtonItem = leftBarButtonItem
        }

        if let rightBarButtonItem = viewModel.rightBarButtonItem {
            navigationItem.rightBarButtonItem = rightBarButtonItem
        }
        
        searchField.addTarget(
            self,
            action: #selector(textFieldDidChange),
            for: .editingChanged
        )
        searchField.delegate = self
        searchField.returnKeyType = .search

        if let viewModel = viewModel as? Actionable {
            actionButton.setTitle(viewModel.actionTitle, for: .normal)
            actionButton.setTitleColor(viewModel.actionTitleColor, for: .normal)
            actionButton.backgroundColor = viewModel.actionBkgColor
            actionButton.isUserInteractionEnabled = true
            actionButton.layer.cornerRadius = 5
            actionButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true

            actionButton.rx.tap.subscribe { _ in
                viewModel.actionTapped()
            }
            .disposed(by: self.disposeBag)

            viewModel.actionEnabled
                .drive(onNext: { [weak actionButton] value in
                    actionButton?.isEnabled = value
                    actionButton?.alpha = value ? 1 : 0.5
                })
                .disposed(by: disposeBag)

            viewModel.actionIsHidden
                .drive(onNext: { [weak actionButton] value in
                    actionButton?.alpha = value ? 0 : 1
                })
                .disposed(by: disposeBag)
        }
        
        if let searchableViewModel = viewModel as? Searchable {
            filterView.equipmentTap = { [weak self] in
                self?.view.endEditing(true)
                searchableViewModel.equipmentTapped()
            }
            
            filterView.muscleTap = { [weak self] in
                self?.view.endEditing(true)
                searchableViewModel.muscleTapped()
            }
            
            filterView.unitTypeTap = { [weak self] in
                self?.view.endEditing(true)
                searchableViewModel.unitTypeTapped()
            }
            
            filterView.clearTap = { [weak self] in
                self?.view.endEditing(true)
                searchableViewModel.clearTapped()
            }
            
            searchableViewModel.filter
                .drive(onNext: { [weak filterView] state in
                    filterView?.configure(with: state)
                })
                .disposed(by: disposeBag)
        }
        
        if let plusable = viewModel as? Plusable {
            plusImageView.image = .plusCircleImg
            plusImageView.tintColor = .systemGreen
            plusImageView.backgroundColor = viewModel.backgroundColor
            plusImageView.layer.cornerRadius = plusImageViewSize / 2
            
            let plusTapGesture = UITapGestureRecognizer(
                target: self,
                action: #selector(plusTapped)
            )
            plusImageView.isUserInteractionEnabled = true
            plusImageView.addGestureRecognizer(plusTapGesture)
            plusable.plusIsHidden
                .drive(onNext: { [weak plusImageView] value in
                    plusImageView?.alpha = value ? 0 : 1
                })
                .disposed(by: disposeBag)
        }
    }

    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: tableView)

        switch gesture.state {
        case .began:
            guard let indexPath = tableView.indexPathForRow(at: location),
                  let cell = tableView.cellForRow(at: indexPath) else { return }

            let cellType = type(of: cell)
            guard viewModel.movableCells.contains(where: { $0 == cellType }) else { return }

            sourceIndexPath = indexPath
            currentIndexPath = indexPath

            snapshotView = cell.snapshotView(afterScreenUpdates: true)
            snapshotView?.center = cell.center
            snapshotView?.alpha = 0.8
            snapshotView?.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)

            tableView.addSubview(snapshotView!)
            cell.isHidden = true

        case .changed:
            let newLocation = gesture.location(in: tableView)
            snapshotView?.center.y = newLocation.y

            if let targetIndexPath = tableView.indexPathForRow(at: newLocation),
               let current = currentIndexPath, targetIndexPath != current,
               let targetCell = tableView.cellForRow(at: targetIndexPath) {

                let targetCellType = type(of: targetCell)
                if viewModel.movableCells.contains(where: { $0 == targetCellType }) {
                    tableView.moveRow(at: current, to: targetIndexPath)
                    currentIndexPath = targetIndexPath
                }
            }

        case .ended, .cancelled:
            guard let source = sourceIndexPath,
                  let target = currentIndexPath else { break }

            if source.row != target.row {
                viewModel.moveRows(from: source.row, to: target.row)
                tableView.reloadData()
            }

            DispatchQueue.main.asyncAfter(deadline: .now() ) { [weak self] in
                guard let self = self else { return }
                if let finalCell = self.tableView.cellForRow(at: target) {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.snapshotView?.center = finalCell.center
                        self.snapshotView?.alpha = 0
                    }) { _ in
                        finalCell.isHidden = false
                        self.snapshotView?.removeFromSuperview()
                        self.snapshotView = nil
                    }
                }
            }

            sourceIndexPath = nil
            currentIndexPath = nil

        default:
            break
        }
    }
    
    @objc private func plusTapped() {
        (viewModel as? Plusable)?.plusTapped()
    }

    private func showAlert(conf: AlertConfiguration) {
        let alertController = UIAlertController(
            title: conf.title,
            message: conf.message,
            preferredStyle: conf.preferredStyle
        )

        conf.actions.forEach { alertController.addAction($0) }
        present(alertController, animated: true)
    }
}

extension StructurKitController: UINavigationBarDelegate {
    func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        if let viewModel = viewModel as? StructuredTableNavigation {
            return viewModel.shouldReturn()
        }
        return true
    }
}

extension StructurKitController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.resignFirstResponder()
    }
    
    @objc private func textFieldDidChange() {
        (viewModel as? Searchable)?.searchText.accept(searchField.text)
    }
}
