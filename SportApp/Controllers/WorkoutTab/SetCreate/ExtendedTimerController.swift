import UIKit

final class ExtendedTimerController: UIViewController {

    private let containerView = UIView()
    private let mainStackView = UIStackView()
    private let titleLabel = UILabel()
    private let timerLabel = UILabel()
    private let descriptionLabel = UILabel()

    private let buttonsStackView = UIStackView()
    private let confirmButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)

    private let controlsStackView = UIStackView()
    private let playButton = UIImageView()
    private let pauseButton = UIImageView()
    private let stopButton = UIImageView()
    private let removeButton = UIButton(type: .system)

    private var timer: Timer?
    private var secondsElapsed: Double = 0

    private let exercise: ExerciseModel
    private let set: SetEntity?

    init(exercise: ExerciseModel, set: SetEntity?) {
        self.exercise = exercise
        self.set = set
        super.init(nibName: nil, bundle: nil)

        addViews()
        configureAppearance()
        configureLayout()
        configureGester()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addViews() {
        view.addSubview(containerView)
        containerView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(timerLabel)
        mainStackView.addArrangedSubview(descriptionLabel)

        controlsStackView.addArrangedSubview(stopButton)
        controlsStackView.addArrangedSubview(playButton)
        controlsStackView.addArrangedSubview(pauseButton)
        mainStackView.addArrangedSubview(controlsStackView)

        mainStackView.addArrangedSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(confirmButton)

        if set != nil {
            mainStackView.addArrangedSubview(removeButton)
        }
    }

    private func configureAppearance() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)

        mainStackView.axis = .vertical
        mainStackView.spacing = 16

        containerView.backgroundColor = .baseLevelZero25
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true

        titleLabel.text = exercise.localizedTitle
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .baseLevelOne

        secondsElapsed = Double(set?.reps ?? 0)

        timerLabel.text = String(format: "%d", Int(secondsElapsed))
        timerLabel.textAlignment = .center
        timerLabel.font = .systemFont(ofSize: 66, weight: .bold)
        timerLabel.textColor = .systemGreen

        descriptionLabel.text = "secStr".localized()
        descriptionLabel.textColor = .baseLevelOne
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textAlignment = .center

        confirmButton.setTitle("saveStr".localized(), for: .normal)
        confirmButton.backgroundColor = .systemGreen
        confirmButton.tintColor = .white
        confirmButton.layer.cornerRadius = 8

        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 8
        buttonsStackView.distribution = .fillEqually

        cancelButton.setTitle("cancelStr".localized(), for: .normal)
        cancelButton.backgroundColor = .systemRed
        cancelButton.tintColor = .white
        cancelButton.layer.cornerRadius = 8

        controlsStackView.axis = .horizontal
        controlsStackView.spacing = 24
        controlsStackView.distribution = .equalCentering

        playButton.image = .playBtn
        playButton.tintColor = .baseLevelOne

        pauseButton.image = .pauseBtn
        pauseButton.tintColor = .baseLevelOne

        stopButton.image = .stopBtn
        stopButton.tintColor = .baseLevelOne

        removeButton.setTitle("deleteStr".localized(), for: .normal)
        removeButton.setTitleColor(.systemRed, for: .normal)

        confirmButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)
    }

    private func configureGester() {
        let stopTapGesture = UITapGestureRecognizer(target: self, action: #selector(stopTimer))
        stopButton.isUserInteractionEnabled = true
        stopButton.addGestureRecognizer(stopTapGesture)

        let pauseTapGesture = UITapGestureRecognizer(target: self, action: #selector(pauseTimer))
        pauseButton.isUserInteractionEnabled = true
        pauseButton.addGestureRecognizer(pauseTapGesture)

        let restartTapGesture = UITapGestureRecognizer(target: self, action: #selector(startTimer))
        playButton.isUserInteractionEnabled = true
        playButton.addGestureRecognizer(restartTapGesture)
    }

    private func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().inset(20)
        }

        mainStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        playButton.snp.makeConstraints { make in
            make.size.equalTo(48)
        }

        pauseButton.snp.makeConstraints { make in
            make.size.equalTo(48)
        }

        stopButton.snp.makeConstraints { make in
            make.size.equalTo(48)
        }

        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }

        confirmButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }

    @objc private func startTimer() {
        UIApplication.shared.isIdleTimerDisabled = true

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.secondsElapsed += 1
            self.timerLabel.text = String(format: "%d", Int(self.secondsElapsed))
        }
        RunLoop.current.add(timer!, forMode: .common)
    }

    @objc private func pauseTimer() {
        timer?.invalidate()
        UIApplication.shared.isIdleTimerDisabled = false
    }

    @objc private func stopTimer() {
        timer?.invalidate()
        timer = nil
        secondsElapsed = 0
        timerLabel.text = "0"
        UIApplication.shared.isIdleTimerDisabled = false
    }

    @objc private func saveTapped() {
        AnalyticsManager.shared.logSetAdded(forExerciseTitle: exercise.titleRu ?? "custom")
        CoreDataManager.shared.saveSet(
            entity: set,
            model: SetModel(
                id: UUID(),
                exerciseId: exercise.id,
                timeStamp: set?.timeStamp ?? Date(),
                weight: 0,
                reps: Int(secondsElapsed)
            ))
        timer?.invalidate()
        UIApplication.shared.isIdleTimerDisabled = false
        dismiss(animated: true, completion: nil)
    }

    @objc private func cancelTapped() {
        timer?.invalidate()
        UIApplication.shared.isIdleTimerDisabled = false
        dismiss(animated: true, completion: nil)
    }

    @objc private func removeTapped() {
        dismiss(animated: true, completion: { [weak self] in
            guard let set = self?.set else { return }
            CoreDataManager.shared.removeSet(set: set)
        })
    }
}
