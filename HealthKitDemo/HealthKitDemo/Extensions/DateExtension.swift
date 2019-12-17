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
  
/*
THIS METHOD WILL SUBTRACT THE days FROM THE CURRENT DATE AND RETURNS THE DATE AS AS START DATE
EX - SUPPOSE TODAYS DATE IS 27/11/19 AND days = 2
SO IT WILL RETURN 25/11/19 AS START DATE.
*/
  
  func getDateFromNow(whenDifferenceInDays days: Int) -> Date? {
    let calendar = Calendar.current
    
    guard let date = calendar.date(byAdding: .day, value: -(days - 1), to: self) else {
      return nil
    }
    return calendar.startOfDay(for: date)
  }
}
