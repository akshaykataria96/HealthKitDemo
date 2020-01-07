//
//  RequestAuthenticationViewController.swift
//  HealthKitDemo
//
//  Created by Akshay on 17/12/19.
//  Copyright © 2019 Akshay. All rights reserved.
//

import UIKit

final class RequestAuthenticationViewController: UIViewController {
  
  // MARK: - Fileprivate variables
  
  fileprivate lazy var healthKitManager: HealthKitManager = {
    let manager = HealthKitManager()
    return manager
  }()

  
  // MARK: - Lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - IBActions
  
  @IBAction func requestAuthentication(_ sender: UIButton) {
    healthKitManager.requestAuthorization { [weak self] (authorized, error) in
      if error != nil {
        print("HealthKit Authtorization Failed")
        return
      } else if authorized {
        self?.pushFetchHealthDataViewController()
      }
    }
  }
  
  // MARK: - Fileprivate methods
  
  fileprivate func pushFetchHealthDataViewController() {
    DispatchQueue.main.async {
      if let fetchHealthDataVC = FetchHealthDataViewController.ofClass(Storyboard: .Main) as? FetchHealthDataViewController {
        self.navigationController?.pushViewController(fetchHealthDataVC, animated: true)
      }
    }
  }
  
}
