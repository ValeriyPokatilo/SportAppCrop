import UIKit
import SnapKit
import AudioToolbox

final class MainTimerView: UIView {

    private let timerLabel = UILabel()
    private let stepper = UIStepper()
    private let stopButton = UIImageView()
    private let restartButton = UIImageView()
    private var updateTimer: ParameterBlock<TimerConf>?

    private var countdownTimer: Timer?
    private var currentTime: Int = 0
    private var isTimerRunning = false
    
    init() {
        super.init(frame: .zero)

        addViews()
        configureLayout()
        configureAppearance()
        setupGestures()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: TimerHeaderModel) {
        timerLabel.text = String(model.conf.value)
        stepper.value = Double(model.conf.value)
        updateTimer = model.updateTimer
    }

    private func configureAppearance() {
        backgroundColor = .baseLevelZero25

        timerLabel.textColor = .systemGreen
        timerLabel.font = .systemFont(ofSize: 36, weight: .bold)
        timerLabel.textAlignment = .center

        stepper.stepValue = 5
        stepper.minimumValue = 0
        stepper.maximumValue = 999

        stepper.addTarget(
            self,
            action: #selector(stepperValueChanged),
            for: .valueChanged
        )

        stopButton.image = .stopImg
        stopButton.tintColor = .systemGreen

        restartButton.image = .restartFillImg
        restartButton.tintColor = .systemGreen
    }

    private func addViews() {
        addSubview(timerLabel)
        addSubview(stepper)
        addSubview(stopButton)
        addSubview(restartButton)
    }

    private func configureLayout() {
        timerLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        stepper.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.trailing.equalToSuperview().offset(-20)
        }

        let buttonSize = stepper.frame.height * 1.1

        stopButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(buttonSize)
        }

        restartButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
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
        guard !isTimerRunning, currentTime > 0 else {
            return
        }

        isTimerRunning = true

        currentTime -= 1
        timerLabel.text = "\(currentTime)"

        countdownTimer = Timer.scheduledTimer(
            withTimeInterval: 1.0,
            repeats: true
        ) { [weak self] _ in
            guard let self = self else {
                return
            }

            if self.currentTime > 0 {
                self.currentTime -= 1
                self.timerLabel.text = "\(self.currentTime)"
            } else {
                self.stopTimer()
                triggerHapticFeedback()
            }
        }
    }

    private func stopTimer() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        isTimerRunning = false
        currentTime = Int(stepper.value)
        timerLabel.text = "\(currentTime)"
    }

    private func restartTimer() {
        stopTimer()
        currentTime = Int(stepper.value)
        timerLabel.text = "\(currentTime)"
        startTimer()
    }

    private func triggerHapticFeedback() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
