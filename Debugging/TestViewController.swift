//
//  TestViewController.swift
//  Debugging
//
//  Created by User on 21.01.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

enum Status {
  case processing
  case error
}

class TestViewController: UIViewController {
  
  // MARK: - Private variables
  @IBOutlet private weak var timerLabel: UILabel!
  @IBOutlet private weak var statusLabel: UILabel!
  
  private var status = Status.error
  private var seconds = 100
  
  private var timer: Timer?
  
  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    initConfigure()
  }
  
  // MARK: - Setup
  private func initConfigure() {
    setupView()
    setupNotification()
  }
  
  private func setupView() {
    edgesForExtendedLayout = []
    initAppearanceConfig()
    setAlpha(1.0)
  }
  
  // MARK: - Notification configurations
  private func setupNotification() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(changeStatus),
                                           name: Notification.Name("statusChanged"),
                                           object: nil)
    
  }
  
  @objc private func changeStatus(_ notification: Notification) {
    guard let data = notification.userInfo as? [String: Any],
      let newStatus = data["Status"] as? Status else { return }
    
    if newStatus != status {
      switch newStatus {
      case .error:
        
        timerLabel.text = "Error"
        print(timerLabel.text)
      case .processing:
        break
      }
      status = newStatus
      changeStatusWithAnimation()
    }
  }
  
  private func changeStatusWithAnimation() {
    UIView.animate(withDuration: 0.5, animations: {
      self.makeSubiewsInvisible()
    }, completion: { _ in
      self.setupViewStatus()
      self.view.layoutIfNeeded()
      UIView.animate(withDuration: 0.5, animations: {
        self.setAlpha(1.0)
      })
    })
  }
  
  // MARK: - Appearance configurations
  private func initAppearanceConfig() {
    statusLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
    statusLabel.textColor = .black
    
    timerLabel.font = UIFont.systemFont(ofSize: 35, weight: .medium)
    timerLabel.textAlignment = .center
  }
  
  private func setupViewStatus() {
    switch status {
    case .processing:
      configProcessing()
    case .error:
      configError()
    }
  }
  
  private func resetInitialSettings() {
    timer?.invalidate()
  }
  
  private func setAlpha(_ alpha: CGFloat) {
    statusLabel.alpha = alpha
    timerLabel.alpha = alpha
  }
  
  private func configProcessing() {
    resetInitialSettings()
    statusLabel.text = "Processing"
    
    timerLabel.textColor = #colorLiteral(red: 0.3803921569, green: 0.737254902, blue: 0.7215686275, alpha: 1)
    setTimer()
  }
  
  private func configError() {
    resetInitialSettings()
    statusLabel.text = "Error"
    timerLabel.text = "Error"
    
    timerLabel.textColor = #colorLiteral(red: 0.3803921569, green: 0.737254902, blue: 0.7215686275, alpha: 1)
  }
  
  private func setTimer() {
    timer?.invalidate()
    seconds = 100
    timerLabel.text = getTimerValue(time: seconds)
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
      self.seconds -= 1
      guard self.seconds > 0 else {
        timer.invalidate()
        return
      }
      self.timerLabel.text = self.getTimerValue(time: self.seconds)
    }
  }
  
  func getTimerValue(time: Int) -> String {
    guard time >= 0 else {
      return "00:00"
    }
    let minutes = time / 60 < 10 ? "0\(time / 60)" : "\(time / 60)"
    let seconds = time % 60 < 10 ? "0\(time % 60)" : "\(time % 60)"
    
    return "\(minutes):\(seconds)"
  }
  
  // MARK: - Private methods
  private func makeSubiewsInvisible() {
    setAlpha(0)
  }
}
