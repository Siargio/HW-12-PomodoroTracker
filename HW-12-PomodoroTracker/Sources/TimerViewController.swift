//
//  ViewController.swift
//  HW-12-PomodoroTracker
//
//  Created by Sergio on 25.08.22.
//

import UIKit
import SnapKit

final class ViewController: UIViewController, CAAnimationDelegate {

    private lazy var timer = Timer()
    private lazy var isStarted = false
    private lazy var isWorkTime = true
    private lazy var isAnimationStarted = false
    private lazy var time = 25
    let foreProgressLayer = CAShapeLayer()
    let backProgressLayer = CAShapeLayer()
    let animation = CABasicAnimation(keyPath: "strokeEND")

    // MARK: - Outlets

    private lazy var timeLabel: UILabel = {
        var label = UILabel()
        label.text = "00:25"
        label.font = .systemFont(ofSize: 50)
        label.textColor = UIColor(named: "ColorButtonTexField")
        return label
    } ()

    private lazy var playPauseButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = UIColor(named: "ColorButtonTexField")
        button.addTarget(self, action: #selector(playPauseButtonAction), for: .touchUpInside)
        return button
    } ()

    private lazy var imageView: UIImageView = {
        let image = UIImage(named: "Circle-PNG-Transparent-Image")
        let imageView = UIImageView(image: image)
        return imageView
    } ()

    // MARK: - Add stack

    private lazy var timeAndButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        self.view.addSubview(stackView)
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(playPauseButton)
        return stackView
    } ()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
        setupView()
        drawBackLayer()
    }

    // MARK: - Setup

    private func setupHierarchy() {
        view.addSubview(timeLabel)
        view.addSubview(playPauseButton)
        view.addSubview(imageView)
    }

    private func setupView() {
        view.backgroundColor = UIColor(named: "ColorBackground")
    }

    private func setupLayout() {
        timeAndButtonStackView.snp.makeConstraints {
            $0.centerX.centerY.equalTo(view)
            $0.width.equalTo(140)
            $0.height.equalTo(100)
        }

        imageView.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.centerY.equalTo(view)
            $0.width.equalTo(249)
            $0.height.equalTo(249)
        }
    }

    // MARK: - Animation

    private func drawBackLayer() {
        backProgressLayer.path = UIBezierPath(arcCenter:
                                              CGPoint(x: view.frame.midX, y: view.frame.midY),
                                              radius: 110,
                                              startAngle: -90.degreesToRadians,
                                              endAngle: 270.degreesToRadians,
                                              clockwise: true).cgPath
        backProgressLayer.strokeColor = UIColor(named: "ColorButtonTexField")?.cgColor
        backProgressLayer.fillColor = UIColor.clear.cgColor
        backProgressLayer.lineWidth = 5
        view.layer.addSublayer(backProgressLayer)
    }

    private func drawForLayer() {
        foreProgressLayer.path = UIBezierPath(arcCenter:
                                              CGPoint(x: view.frame.midX, y: view.frame.midY),
                                              radius: 110,
                                              startAngle: -90.degreesToRadians,
                                              endAngle: 270.degreesToRadians,
                                              clockwise: true).cgPath
        foreProgressLayer.strokeColor = UIColor.black.cgColor
        foreProgressLayer.fillColor = UIColor.clear.cgColor
        foreProgressLayer.lineWidth = 7
        view.layer.addSublayer(foreProgressLayer)
    }

    private func startResumeAnimation() {
        if !isAnimationStarted {
            startAnimation()
        } else {
            resumeAnimation()
        }
    }

    private func startAnimation() {
        resetAnimation()
        foreProgressLayer.strokeEnd = 0.0
        animation.keyPath = "strokeEnd"
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = CFTimeInterval(time)
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        animation.isAdditive = true
        animation.fillMode = CAMediaTimingFillMode.forwards
        foreProgressLayer.add(animation, forKey: "strokeEnd")
        isAnimationStarted = true
    }

    private func resetAnimation() {
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0.0
        foreProgressLayer.beginTime = 0.0
        foreProgressLayer.strokeEnd = 0.0
        isAnimationStarted = false
    }

    private func pauseAnimation() {
        let pausedTime = foreProgressLayer.convertTime(CACurrentMediaTime(), from: nil)
        foreProgressLayer.speed = 0.0
        foreProgressLayer.timeOffset = pausedTime
    }

    private func resumeAnimation() {
        let pausedTime = foreProgressLayer.timeOffset
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0.0
        foreProgressLayer.beginTime = 0.0

        let timeSiencePaused = foreProgressLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        foreProgressLayer.beginTime = timeSiencePaused
    }

    private func stopAnimation() {
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0.0
        foreProgressLayer.beginTime = 0.0
        foreProgressLayer.strokeEnd = 0.0
        foreProgressLayer.removeAllAnimations()
        isAnimationStarted = false
    }

    @objc func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        stopAnimation()
    }

    // MARK: - Action

    @objc private func playPauseButtonAction() {
        if !isStarted {
            drawForLayer()
            startResumeAnimation()
            startTimer()
            isStarted = true
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            timer.invalidate()
            isStarted = false
            pauseAnimation()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }

    @objc func updateTimer() {
        if time < 1 && isWorkTime {
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            timer.invalidate()
            time = 5
            isWorkTime = false
            isStarted = false
            timeLabel.text = "00:05"
            timeLabel.textColor = UIColor.systemGreen
            playPauseButton.tintColor = UIColor.systemGreen
            backProgressLayer.strokeColor = UIColor.systemGreen.cgColor
        } else if time < 1 && !isWorkTime {
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            timer.invalidate()
            time = 25
            isWorkTime = true
            isStarted = false
            timeLabel.text = "00:25"
            timeLabel.textColor = UIColor(named: "ColorButtonTexField")
            playPauseButton.tintColor = UIColor(named: "ColorButtonTexField")
            backProgressLayer.strokeColor = UIColor(named: "ColorButtonTexField")?.cgColor
        } else {
            time -= 1
            timeLabel.text = formatTime()
        }
    }

    func formatTime() -> String {
        let minutes = Int(time) / 60 % 60
        let second = Int(time) % 60
        return String(format: "%02i:%02i", minutes, second)
    }
}
