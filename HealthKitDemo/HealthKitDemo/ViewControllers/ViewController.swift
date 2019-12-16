//
//  ViewController.swift
//  HealthKitDemo
//
//  Created by Akshay on 23/11/19.
//  Copyright © 2019 Akshay. All rights reserved.
//

import UIKit

enum DataType {
  case distance
  case steps
}

final class ViewController: UIViewController {
  
  // MARK: - Fileprivate variables
  
  fileprivate lazy var healthKitManager: HealthKitManager = {
    let manager = HealthKitManager()
    return manager
  }()
  
  fileprivate var healthKitData : [[String: Double]]?
  
  // MARK: - IBActions
  
  @IBAction func showStepsData(_ sender: UIButton) {
    fetchDataFor(numberOfDays: 10, dataType: .steps) { [weak self] (response, error) in
      if let healthKitData = response {
        self?.pushShowHealthTableViewController(data: healthKitData)
      }
    }
  }
  
  
  @IBAction func showDistanceData(_ sender: UIButton) {
    fetchDataFor(numberOfDays: 10, dataType: .distance) { [weak self] (response, error) in
      if let healthKitData = response {
        self?.pushShowHealthTableViewController(data: healthKitData)
      }
    }
  }
  
  // MARK: - Viewlifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    requestHealthKitAuthorization()
  }
  
  // MARK: - Fileprivate methods
  
  fileprivate func fetchDataFor(numberOfDays: Int, dataType: DataType, completion: @escaping CompletionHandler) {
    // TO FETCH TODAYS DATA, KEEP numberOfDays = 1
    
    let endDate = Date()
    guard let startDate = endDate.getDateFromNow(whenDifferenceInDays: numberOfDays) else {
      return
    }
    
    switch dataType {
    case .distance:
      healthKitManager.getDistance(From: startDate, To: endDate) { (response, error) in
        completion(response, error)
      }
    case .steps:
      healthKitManager.getSteps(From: startDate, To: endDate) { (response, error) in
        completion(response, error)
      }
    }
  }
  
  fileprivate func requestHealthKitAuthorization() {
    healthKitManager.requestAuthorization(forRead: true, write: false) { (authorized, error) in
      if error != nil {
        print("HealthKit Authtorization Failed")
        return
      }
    }
  }
  
  fileprivate func pushShowHealthTableViewController(data: [[String: Double]]) {
    if let showHealthVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShowHealthKitDataViewController") as? ShowHealthKitDataViewController {
      showHealthVC.healthKitData = data
      DispatchQueue.main.async {
        self.navigationController?.pushViewController(showHealthVC, animated: true)
      }
    }
  }
  
}

