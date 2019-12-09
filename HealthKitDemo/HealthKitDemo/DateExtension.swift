//
//  DateExtension.swift
//  HealthKitDemo
//
//  Created by Akshay on 27/11/19.
//  Copyright © 2019 Akshay. All rights reserved.
//

import Foundation

extension Date {
  var stringValue: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    return dateFormatter.string(from: self)
  }
  
  func getStartDateFor(diffInDays: Int) -> Date? {
    let calendar = Calendar.current
  
    guard let date = calendar.date(byAdding: .day, value: -(diffInDays - 1), to: self) else {
      return nil
    }
    return calendar.startOfDay(for: date)
  }
}
