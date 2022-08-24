//
//  ViewController.swift
//  HW-12-PomodoroTracker
//
//  Created by Sergio on 25.08.22.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

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
        //drawBackLayer()
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

    // MARK: - Action

    @objc private func playPauseButtonAction() {
    }
}
