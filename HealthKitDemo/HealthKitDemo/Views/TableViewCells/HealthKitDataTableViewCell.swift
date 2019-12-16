//
//  HealthKitDataTableViewCell.swift
//  HealthKitDemo
//
//  Created by Akshay on 05/12/19.
//  Copyright © 2019 Akshay. All rights reserved.
//

import UIKit

final class HealthKitDataTableViewCell: UITableViewCell {

  // MARK: - IBOutlets
  
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var valueLabel: UILabel!
  
  static var identifier: String {
    return String(describing: self)
  }
  
  
  // MARK: - Configure methods
  
  func configure(date: String, value: Double) {
    dateLabel.text = date
    valueLabel.text = "\(value)"
  }
  
}
