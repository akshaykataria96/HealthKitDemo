//
//  UIViewControllerExtension.swift
//  HealthKitDemo
//
//  Created by Akshay on 17/12/19.
//  Copyright © 2019 Akshay. All rights reserved.
//

import UIKit

enum storyboard: String {
  case Main = "Main"
}

extension UIViewController {
  
  static func OfClass(Storyboard sb: storyboard) -> UIViewController? {
    let storyboard = UIStoryboard(name: sb.rawValue, bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: self.viewControllerIdentifier())
  }
  
  static func viewControllerIdentifier() -> String {
    return String(describing: self)
  }
}
