//
//  HealthKitManager.swift
//  HealthKitDemo
//
//  Created by Akshay on 23/11/19.
//  Copyright © 2019 Akshay. All rights reserved.
//

import Foundation
import HealthKit

enum HealthkitSetupError: Error {
  case notAvailableOnDevice
  case dataTypeNotAvailable
  case authorizationFailed
}

typealias CompletionHandler = (([[String: Double]]?, Error?) -> Void)


protocol HealthStoreProtocol {
  func requestAuthorization(forRead read: Bool,
                            write: Bool,
                            completion: @escaping (Bool,Error?) -> Void)
  func getSteps(From startDate: Date, To endDate: Date, completion: @escaping CompletionHandler)
  func getDistance(From startDate: Date, To endDate: Date, completion: @escaping CompletionHandler)
}


final class HealthKitManager {
  
  // MARK: - Fileprivate variables
  
  fileprivate let healthStore: HKHealthStore
  
  // MARK: - Init method
  
  init(healthStore: HKHealthStore = HKHealthStore()){
    self.healthStore = healthStore
  }
  
  // MARK: - Fileprivate methods
  
  fileprivate func dataTypesToRead() -> Set<HKObjectType>? {
    guard let distanceWalkingRunningType = HKQuantityType.quantityType(forIdentifier:.distanceWalkingRunning),
      let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
        return nil
    }
    
    let dataTypesToRead: Set<HKObjectType> = [distanceWalkingRunningType, stepsType]
    return dataTypesToRead
  }
  
  fileprivate func dataTypesToWrite() -> Set<HKSampleType>? {
    guard let distanceWalkingRunningType = HKQuantityType.quantityType(forIdentifier:.distanceWalkingRunning),
      let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
        return nil
    }
    
    let dataTypesToWrite: Set<HKSampleType> = [distanceWalkingRunningType, stepsType]
    return dataTypesToWrite
  }
  
  fileprivate func record(data: inout [[String: Double]], date: Date, quantity: HKQuantity) {
    // THE DATA IS BEING STORED IN A DICTIONARY
    // WHERE KEY -> DATE & VALUE -> STEPS/DISTANCE IN (COUNT/KM)
    
    var recordDict: [String: Double] = [:]
    
    if quantity.is(compatibleWith: HKUnit.meter()) {
      let distance = quantity.doubleValue(for: HKUnit.meter()) / 1000.0
      recordDict[date.stringValue] = distance
    }
      
    else if quantity.is(compatibleWith: HKUnit.count()) {
      let count = quantity.doubleValue(for: HKUnit.count())
      recordDict[date.stringValue] = count
    }
    
    data.append(recordDict)
  }
  
  fileprivate func performCollectionQuery(sampleType: HKQuantityType, startDate: Date, endDate: Date, completion: @escaping CompletionHandler) {
    let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
    var interval = DateComponents()
    interval.day = 1
    
    
    let query = HKStatisticsCollectionQuery(quantityType: sampleType,
                                            quantitySamplePredicate: predicate,
                                            options: [.cumulativeSum],
                                            anchorDate: startDate,
                                            intervalComponents: interval)
    
    query.initialResultsHandler = { query, results, error in
      if error != nil {
        completion(nil, error)
        return
      }
      
      if let myResults = results {
        
        var data: [[String : Double]] = []
        
        myResults.enumerateStatistics(from: startDate, to: endDate) { [weak self] statistics, stop in
          
          if let quantity = statistics.sumQuantity() {
            self?.record(data: &data, date: statistics.endDate, quantity: quantity)
          }
          else {
            if statistics.quantityType.identifier == HKQuantityTypeIdentifier.stepCount.rawValue {
              let quantity = HKQuantity(unit: HKUnit.count(), doubleValue: 0.0)
              self?.record(data: &data, date: statistics.endDate, quantity: quantity)
            }
            else if statistics.quantityType.identifier == HKQuantityTypeIdentifier.distanceWalkingRunning.rawValue {
              let quantity = HKQuantity(unit: HKUnit.meter(), doubleValue: 0.0)
              self?.record(data: &data, date: statistics.endDate, quantity: quantity)
            }
          }
        }
        completion(data, nil)
        return
      }
      
      completion(nil, HealthkitSetupError.notAvailableOnDevice)
    }
    
    self.healthStore.execute(query)
  }
    
  fileprivate func fetchData(For sampleType: HKQuantityType, from startDate: Date, to endDate: Date, completion: @escaping CompletionHandler) {
    performCollectionQuery(sampleType: sampleType,
                           startDate: startDate,
                           endDate: endDate,
                           completion: completion)
  }

}

// MARK: - HealthStoreProtocol methods implementation
// MARK: -

extension HealthKitManager: HealthStoreProtocol {

  func requestAuthorization(forRead read: Bool, write: Bool, completion: @escaping (Bool, Error?) -> Void) {
    
    guard HKHealthStore.isHealthDataAvailable() else {
      completion(false, HealthkitSetupError.notAvailableOnDevice)
      return
    }
    
    guard let readData: Set<HKObjectType> = dataTypesToRead() else {
      completion(false, HealthkitSetupError.dataTypeNotAvailable)
      return
    }
    
    guard let writeData: Set<HKSampleType> = dataTypesToWrite() else {
      completion(false, HealthkitSetupError.dataTypeNotAvailable)
      return
    }
    
    healthStore.requestAuthorization(toShare: write == true ? writeData : nil,
                                     read:    read == true  ? readData  : nil,
                                     completion: completion)
  }
  
  func getSteps(From startDate: Date, To endDate: Date, completion: @escaping CompletionHandler) {
    guard let sampleTypeSteps = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) else {
      completion(nil, HealthkitSetupError.dataTypeNotAvailable)
      return
    }
    fetchData(For: sampleTypeSteps, from: startDate, to: endDate, completion: completion)
  }
  
  func getDistance(From startDate: Date, To endDate: Date, completion: @escaping CompletionHandler) {
    guard let sampleTypeDistance = HKQuantityType.quantityType(forIdentifier:
      HKQuantityTypeIdentifier.distanceWalkingRunning) else {
      completion(nil, HealthkitSetupError.dataTypeNotAvailable)
      return
    }
    fetchData(For: sampleTypeDistance, from: startDate, to: endDate, completion: completion)
  }
  
}
