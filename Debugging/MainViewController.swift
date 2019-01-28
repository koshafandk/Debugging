//
//  MainViewController.swift
//  Debugging
//
//  Created by Andrew Koshkin on 1/21/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
  
  // MARK: - Private variables
  @IBOutlet private weak var panelView: UIView!
  @IBOutlet private weak var lineView: UIView!
  
  private var testVC = TestViewController(nibName: String(describing: TestViewController.self),
                                                   bundle: Bundle.main)
  
  private var timer: Timer?
  
  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    initConfigure()
  }
  
  override func viewDidLayoutSubviews() {
    configRequestStatusView()
  }
  
  private func configRequestStatusView() {
    panelView.layer.cornerRadius = 10
    panelView.dropShadow(color: .black, opacity: 0.14, offSet: .zero, radius: 10, scale: true)
  }
  
  // MARK: - Setup
  private func initConfigure() {
    setupView()
  }
  
  private func setupView() {
    setupRequestView()
  }
  
  private func setupRequestView() {
    addChild(testVC)
    let statusView: UIView = testVC.view
    
    view.addSubview(panelView)
    panelView.addSubview(statusView)
    statusView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(lineView.snp.bottom).offset(18)
    }
  }
  
  // MARK: - Actions
  private func sendStatus(_ status: Status) {
    NotificationCenter.default.post(name: Notification.Name("statusChanged"),
                                    object: nil,
                                    userInfo: ["Status": status])
  }
  
  @IBAction private func actionTapOnProcessingButton(_ sender: Any) {
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
      self?.sendStatus(.processing)
    }
  }
  
  @IBAction private func actionTapOnErrorButton(_ sender: Any) {
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
      self?.sendStatus(.error)
    }
  }
}
