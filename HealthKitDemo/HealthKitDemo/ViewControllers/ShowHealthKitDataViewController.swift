//
//  ShowHealthKitDataViewController.swift
//  HealthKitDemo
//
//  Created by Akshay on 05/12/19.
//  Copyright © 2019 Akshay. All rights reserved.
//

import UIKit

final class ShowHealthKitDataViewController: UIViewController {
  
  // MARK: - Public variables
  
  public var healthKitData: [[String: Double]] = []
  
  // MARK: - IBOutlet
  
  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView.separatorStyle = .none
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTableView()
  }
  
  
  // MARK: - Fileprivate methods
  
  fileprivate func configureTableView() {
    tableView.register(UINib(nibName: HealthKitDataTableViewCell.identifier, bundle: nil),
                       forCellReuseIdentifier: HealthKitDataTableViewCell.identifier)
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.estimatedRowHeight = 44
    tableView.rowHeight = UITableView.automaticDimension
    
  }
  
  fileprivate func confiureCell(cell: HealthKitDataTableViewCell, indexPath: IndexPath) {
    let healthData = healthKitData[indexPath.row]
    if let (key, value) = healthData.first {
      cell.configure(date: key, value: value)
    }
  }

}


// MARK: - UITableViewDataSource methods implementation
// MARK: -

extension ShowHealthKitDataViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return healthKitData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: HealthKitDataTableViewCell.identifier) as! HealthKitDataTableViewCell
    confiureCell(cell:cell, indexPath: indexPath)
    return cell
  }
  
}

// MARK: - UITableViewDelegate methods implementation
// MARK: -

extension ShowHealthKitDataViewController: UITableViewDelegate { }
