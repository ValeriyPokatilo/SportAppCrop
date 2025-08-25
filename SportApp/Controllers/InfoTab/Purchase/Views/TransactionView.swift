import UIKit
import SnapKit
import StoreKit
import RxSwift

final class TransactionView: UIView {

    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let subscriptionLabel = UILabel()
    private let dateLabel = UILabel()
    private let manageButton = UIButton(type: .system)
    private let privacyButton = UIButton(type: .system)
    private let termsButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)

    private let parent: PurchaseController
    private let transaction: Transaction

    init(parent: PurchaseController, transaction: Transaction) {
        self.parent = parent
        self.transaction = transaction
        super.init(frame: .zero)

        addViews()
        configureAppearance()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addViews() {
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subscriptionLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(manageButton)
        containerView.addSubview(privacyButton)
        containerView.addSubview(termsButton)
        containerView.addSubview(cancelButton)
    }

    private func configureAppearance() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)

        titleLabel.text = "subInfoStr".localized()
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)

        containerView.backgroundColor = .baseLevelZero25
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true

        subscriptionLabel.text = Subscriptions(rawValue: transaction.productID)?.localizedTitle
        subscriptionLabel.font = .systemFont(ofSize: 13)
        if let date = transaction.expirationDate {
            dateLabel.font = .systemFont(ofSize: 13)
            dateLabel.text = "\("expDateStr".localized()): \(formattedDate(from: date))"
        }

        manageButton.setTitle("Manage subscriptions", for: .normal)
        manageButton.setTitleColor(.white, for: .normal)
        manageButton.layer.cornerRadius = 8
        manageButton.backgroundColor = .systemGreen
        manageButton.addTarget(self, action: #selector(manageTapped), for: .touchUpInside)

        configureLink(privacyButton, with: "Privacy Policy")
        configureLink(termsButton, with: "Terms Of Use")
        privacyButton.addTarget(self, action: #selector(privacyTapped), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(termsTapped), for: .touchUpInside)

        cancelButton.setTitle("cancelStr".localized(), for: .normal)
        cancelButton.setTitleColor(.systemRed, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
    }

    private func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview().inset(20)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        subscriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(subscriptionLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        manageButton.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        privacyButton.snp.makeConstraints { make in
            make.top.equalTo(manageButton.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(termsButton.snp.width)
            make.trailing.equalTo(termsButton.snp.leading).offset(-8)
        }

        termsButton.snp.makeConstraints { make in
            make.top.equalTo(manageButton.snp.bottom).offset(12)
            make.trailing.equalToSuperview().offset(-20)
        }

        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(termsButton.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-10)
        }
    }

    private func configureLink(_ button: UIButton, with title: String) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .clear
        button.tintColor = .white
        button.layer.cornerRadius = 8
    }

    private func openURLInBrowser(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    @objc private func privacyTapped() {
        openURLInBrowser(.privacyPolicy)
    }

    @objc private func termsTapped() {
        openURLInBrowser(.termsOfUse)
    }

    @objc private func manageTapped() {
        openURLInBrowser(.subs)
    }

    @objc func cancelTapped() {
        parent.dismiss(animated: true)
    }

    private func formattedDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
}
