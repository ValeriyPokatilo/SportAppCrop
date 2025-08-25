import Foundation
import SnapKit
import AudioToolbox
import RxSwift
import AVFoundation

final class TimerHeader: UITableViewHeaderFooterView {

    private let timerLabel = UILabel()
    private let stepper = UIStepper()
    private let stopButton = UIImageView()
    private let restartButton = UIImageView()
    private var updateTimer: ParameterBlock<TimerConf>?

    private var countdownTimer: Timer? // ??? ***
    private var backgroundTimer: DispatchSourceTimer?
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid

    private var currentTime: Int = 0
    private var isTimerRunning = false

    private let disposeBag = DisposeBag()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addViews()
        configureLayout()
        configureAppearance()
        setupGestures()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveTimerState),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(restoreTimerState),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: TimerHeaderModel) {
        timerLabel.text = String(model.conf.value)
        stepper.value = Double(model.conf.value)
        updateTimer = model.updateTimer

        model.isRunning?
            .skip(1)
            .subscribe(onNext: { [weak self] isRun in
                if isRun {
                    self?.currentTime = Int(self?.stepper.value ?? 0)
                    self?.startTimer()
                }
            })
            .disposed(by: disposeBag)
    }

    private func configureAppearance() {
        backgroundColor = .baseLevelZero25
        contentView.backgroundColor = .baseLevelZero25

        timerLabel.textColor = .systemGreen
        timerLabel.font = .systemFont(ofSize: 36, weight: .bold)
        timerLabel.textAlignment = .center

        stepper.stepValue = 5
        stepper.minimumValue = 5
        stepper.maximumValue = 999

        stepper.addTarget(
            self,
            action: #selector(stepperValueChanged),
            for: .valueChanged
        )

        stopButton.image = .stopBtn
        stopButton.tintColor = .systemGreen

        restartButton.image = .playBtn
        restartButton.tintColor = .systemGreen
    }

    private func addViews() {
        contentView.addSubview(timerLabel)
        contentView.addSubview(stepper)
        contentView.addSubview(stopButton)
        contentView.addSubview(restartButton)
    }

    private func configureLayout() {
        timerLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        stepper.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.trailing.equalToSuperview().offset(-20)
        }

        let buttonSize = stepper.frame.height * 1.1

        stopButton.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(buttonSize)
        }

        restartButton.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(stopButton.snp.trailing).offset(12)
            make.size.equalTo(buttonSize)
        }
    }

    private func setupGestures() {
        let stopTapGesture = UITapGestureRecognizer(target: self, action: #selector(stopTapped))
        stopButton.isUserInteractionEnabled = true
        stopButton.addGestureRecognizer(stopTapGesture)

        let restartTapGesture = UITapGestureRecognizer(target: self, action: #selector(restartTapped))
        restartButton.isUserInteractionEnabled = true
        restartButton.addGestureRecognizer(restartTapGesture)
    }

    @objc private func stepperValueChanged() {
        let newValue = Int(stepper.value)
        timerLabel.text = String(newValue)
        currentTime = newValue
        updateTimer?(TimerConf(isEnabled: true, value: newValue))
    }

    @objc private func stopTapped() {
        stopTimer()
    }

    @objc private func restartTapped() {
        restartTimer()
    }

    private func startTimer() {
        guard !isTimerRunning, currentTime > 0 else { return }

        isTimerRunning = true
        timerLabel.text = "\(currentTime)"
//        LiveActivityService.makeActivity(value: "\(currentTime)")

        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            if self.currentTime > 0 {
                self.currentTime -= 1
                DispatchQueue.main.async {
                    self.timerLabel.text = "\(self.currentTime)"
                }

//                if let first = LiveActivityService.activities.first {
//                    LiveActivityService.updateActivity(first, value: "\(self.currentTime)")
//                }
            } else {
                self.stopTimer()
                self.triggerHapticFeedback()
            }
        }
    }

    private func stopTimer() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        isTimerRunning = false
        currentTime = Int(stepper.value)
        timerLabel.text = "\(currentTime)"

//        for activity in LiveActivityService.activities {
//            LiveActivityService.endActivity(activity)
//        }

        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
    }

    private func restartTimer() {
        stopTimer()
        currentTime = Int(stepper.value)
        timerLabel.text = "\(currentTime)"
        startTimer()
    }

    private func triggerHapticFeedback() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)

        toggleFlash(on: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.toggleFlash(on: false)
        }
    }

    private func toggleFlash(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video),
              device.hasTorch else { return }

        do {
            try device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            device.unlockForConfiguration()
        } catch {
            print("Ошибка управления фонариком: \(error.localizedDescription)")
        }
    }

    @objc private func saveTimerState() {
        guard isTimerRunning else { return }

        let timestamp = Date().timeIntervalSince1970
        UserDefaults.standard.set(timestamp, forKey: .lastActiveTimestamp)
        UserDefaults.standard.set(currentTime, forKey: .remainingTime)
        UserDefaults.standard.synchronize()
    }

    @objc private func restoreTimerState() {
        guard isTimerRunning else { return }

        let timestamp = UserDefaults.standard.double(forKey: .lastActiveTimestamp)
        let savedTime = UserDefaults.standard.integer(forKey: .remainingTime)

        let elapsedTime = Int(Date().timeIntervalSince1970 - timestamp)
        let newRemainingTime = max(savedTime - elapsedTime, 0)

        currentTime = newRemainingTime
        timerLabel.text = "\(currentTime)"

        if newRemainingTime > 0 {
            startTimer()
        } else {
            stopTimer()
        }
    }

    deinit {
        countdownTimer?.invalidate()

        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )

        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
}
