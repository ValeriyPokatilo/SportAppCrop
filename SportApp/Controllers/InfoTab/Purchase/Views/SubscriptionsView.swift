import UIKit
import SnapKit
import StoreKit
import RxSwift
import RxCocoa

// swiftlint:disable type_body_length

final class SubscriptionsView: UIView {

    private let containerView = UIView()
    private let loader = UIActivityIndicatorView(style: .large)
    private let titleLabel = UILabel()
    private let benefitLabel = UILabel()
    private let weekButton = UIButton(type: .system)
    private let monthButton = UIButton(type: .system)
    private let annualButton = UIButton(type: .system)
    private let privacyButton = UIButton(type: .system)
    private let termsButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    private let restoreButton = UIButton(type: .system)

    private let purchaseManager = PurchaseManager.shared
    private let products = BehaviorRelay<[Product]>(value: [])
    private let disposeBag = DisposeBag()

    private let parent: PurchaseController

    init(parent: PurchaseController) {
        self.parent = parent
        super.init(frame: .zero)
        configureDynamics()
        loadSubscriptions()

        addViews()
        configureAppearance()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureDynamics() {
        products
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] products in
                self?.handleProducts(products)
            })
            .disposed(by: disposeBag)
    }

    private func addViews() {
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(benefitLabel)
        containerView.addSubview(weekButton)
        containerView.addSubview(monthButton)
        containerView.addSubview(annualButton)
        containerView.addSubview(privacyButton)
        containerView.addSubview(termsButton)
        containerView.addSubview(restoreButton)
        containerView.addSubview(cancelButton)
        containerView.addSubview(loader)
   }

    private func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview().inset(20)
        }

        loader.snp.makeConstraints { make in
            make.center.equalTo(monthButton.snp.center)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        benefitLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        weekButton.snp.makeConstraints { make in
            make.top.equalTo(benefitLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        monthButton.snp.makeConstraints { make in
            make.top.equalTo(weekButton.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        annualButton.snp.makeConstraints { make in
            make.top.equalTo(monthButton.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        restoreButton.snp.makeConstraints { make in
            make.top.equalTo(annualButton.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        privacyButton.snp.makeConstraints { make in
            make.top.equalTo(restoreButton.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(termsButton.snp.width)
            make.trailing.equalTo(termsButton.snp.leading).offset(-8)
        }

        termsButton.snp.makeConstraints { make in
            make.top.equalTo(restoreButton.snp.bottom).offset(12)
            make.trailing.equalToSuperview().offset(-20)
        }

        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(termsButton.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-10)
        }
    }

    private func configureAppearance() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)

        loader.startAnimating()

        titleLabel.text = "subscriptionsStr".localized()
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)

        benefitLabel.text = Benefits.benefitsString
        benefitLabel.font = .systemFont(ofSize: 13)
        benefitLabel.numberOfLines = 0

        containerView.backgroundColor = .baseLevelZero25
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true

        configurePurchase(weekButton)
        configurePurchase(monthButton)
        configurePurchase(annualButton)
        configureLink(privacyButton, with: "Privacy Policy")
        configureLink(termsButton, with: "Terms Of Use")
        configureLink(cancelButton, with: "cancelStr".localized())
        configureLink(restoreButton, with: "restoreStr".localized())

        cancelButton.setTitleColor(.systemRed, for: .normal)

        restoreButton.setTitleColor(.white, for: .normal)
        restoreButton.backgroundColor = .systemBlue
        restoreButton.alpha = 0

        privacyButton.addTarget(self, action: #selector(privacyTapped), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(termsTapped), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(restoreTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
    }

    private func configureLink(_ button: UIButton, with title: String) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .clear
        button.tintColor = .white
        button.layer.cornerRadius = 8
    }

    private func configurePurchase(_ button: UIButton) {
        button.backgroundColor = .systemGreen
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.alpha = 0
    }

    private func handleProducts(_ products: [Product]) {
        products.forEach { pr in
            switch Subscriptions(rawValue: pr.id) {
            case .proWeekly:
                weekButton.alpha = 1
                weekButton.setTitle(
                    pr.displayName + " - " + pr.displayPrice + " " + "perWeekStr".localized(),
                    for: .normal
                )
                weekButton.rx.tap.subscribe { [weak self] _ in
                    self?.purchase(product: pr)
                }
                .disposed(by: self.disposeBag)
            case .proMonth:
                monthButton.alpha = 1
                monthButton.setTitle(
                    pr.displayName + " - " + pr.displayPrice + " " + "perMonthStr".localized(),
                    for: .normal
                )
                monthButton.rx.tap.subscribe { [weak self] _ in
                    self?.purchase(product: pr)
                }
                .disposed(by: self.disposeBag)
            case .proAnnual:
                annualButton.alpha = 1
                annualButton.setTitle(
                    pr.displayName + " - " + pr.displayPrice + " " + "perYearStr".localized(),
                    for: .normal
                )
                annualButton.rx.tap.subscribe { [weak self] _ in
                    self?.purchase(product: pr)
                }
                .disposed(by: self.disposeBag)
            case .none:
                return
            }
        }
        restoreButton.alpha = 1
    }

    @objc private func privacyTapped() {
        openURLInBrowser(.privacyPolicy)
    }

    @objc private func termsTapped() {
        openURLInBrowser(.termsOfUse)
    }

    @objc func cancelTapped() {
        parent.dismiss(animated: true)
    }

    @objc func restoreTapped() {
        loader.startAnimating()

        purchaseManager.restorePurchases { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.loader.stopAnimating()
                    self?.parent.dismiss(animated: true)
                }
            case .failure(let error):
                let title = error.localizedDescription
                let actions = [
                    UIAlertAction(
                        title: "okStr".localized(),
                        style: .default,
                        handler: nil
                    )
                ]

                DispatchQueue.main.async {
                    self?.loader.stopAnimating()
                    self?.parent.showAlert?(title, actions)
                }

                AnalyticsManager.shared.logError("Restore error")
            }
        }
    }

    private func purchase(product: Product) {
        loader.startAnimating()
        purchaseManager.purchase(
            product: product,
            completion: { result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self.parent.dismiss(animated: true)
                        self.loader.stopAnimating()
                    }
                case .failure(let failure):
                    let title = "purchaseErrorStr".localized()
                    let actions = [
                        UIAlertAction(
                            title: "cancelStr".localized(),
                            style: .destructive,
                            handler: { [weak self] _ in
                                self?.parent.dismiss(animated: true)
                            }
                        ),
                        UIAlertAction(
                            title: "retryStr".localized(),
                            style: .default,
                            handler: { [weak self] _ in
                                self?.purchase(product: product)
                            })
                    ]

                    DispatchQueue.main.async {
                        self.parent.showAlert?(title, actions)
                        self.loader.stopAnimating()
                    }

                    AnalyticsManager.shared.logError("Purchase: \(product.id) - \(failure.localizedDescription)")
                }
            })
    }

    private func openURLInBrowser(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    private func loadSubscriptions() {
        loader.startAnimating()

        Task {
            do {
                try await purchaseManager.loadProducts()
                let loaded = purchaseManager.products
                products.accept(loaded)
                loader.stopAnimating()
            } catch let error {
                let title = "loadSubsErrorStr".localized()
                let actions = [
                    UIAlertAction(
                        title: "cancelStr".localized(),
                        style: .destructive,
                        handler: { [weak self] _ in
                            self?.parent.dismiss(animated: true)
                        }
                    ),
                    UIAlertAction(
                        title: "retryStr".localized(),
                        style: .default,
                        handler: { [weak self] _ in
                            self?.loadSubscriptions()
                        })
                ]

                self.loader.stopAnimating()
                self.parent.showAlert?(title, actions)

                AnalyticsManager.shared.logError("Load subscriptions - \(error.localizedDescription)")
                loader.stopAnimating()
            }
        }
    }
}

// swiftlint:enable type_body_length
