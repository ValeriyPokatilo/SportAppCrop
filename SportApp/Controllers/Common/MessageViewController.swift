import UIKit
import SnapKit
import RxSwift

final class MessageViewController: UIViewController {

    private let exercise: ExerciseModel
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let messageTextView = UITextView()
    private let actionsStackView = UIStackView()
    private var sendButton = UIButton(type: .system)
    private var cancelButton = UIButton(type: .system)

    init(exercise: ExerciseModel) {
        self.exercise = exercise
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        configureLayout()
        configureAppearance()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageTextView.becomeFirstResponder()
    }

    private func addViews() {
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(messageTextView)
        containerView.addSubview(actionsStackView)
        actionsStackView.addArrangedSubview(cancelButton)
        actionsStackView.addArrangedSubview(sendButton)
    }

    private func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY).offset(-100)
            make.width.equalToSuperview().inset(20)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        messageTextView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.height.equalTo(100)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        actionsStackView.snp.makeConstraints { make in
            make.top.equalTo(messageTextView.snp.bottom).offset(12)
            make.bottom.equalToSuperview().offset(-20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
    }

    private func configureAppearance() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        containerView.backgroundColor = .baseLevelZero25
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true

        titleLabel.text = exercise.localizedTitle
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        messageTextView.returnKeyType = .send
        messageTextView.delegate = self

        actionsStackView.axis = .horizontal
        actionsStackView.spacing = 8
        actionsStackView.distribution = .fillEqually

        cancelButton.setTitle("cancelStr".localized(), for: .normal)
        cancelButton.backgroundColor = .systemRed
        cancelButton.tintColor = .white
        cancelButton.layer.cornerRadius = 8
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)

        sendButton.setTitle("sendStr".localized(), for: .normal)
        sendButton.backgroundColor = .systemGreen
        sendButton.tintColor = .white
        sendButton.layer.cornerRadius = 8
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
    }

    private func sendMessage(text: String) {
        AnalyticsManager.shared.logExerciseMistake(
            exercise.titleRu ?? "custom",
            mistake: text
        )
        dismiss(animated: true)
    }

    @objc private func cancelTapped() {
        dismiss(animated: true)
    }

    @objc private func sendTapped() {
        sendMessage(text: messageTextView.text)
    }
}

extension MessageViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            sendMessage(text: textView.text)
            return false
        }
        return true
    }
}
