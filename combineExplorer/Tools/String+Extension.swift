//
//  String+Extension.swift
//  combineExplorer
//
//  Created by Anton Honcharov on 6/14/21.
//

import Foundation

extension String {
  func validateEmail() -> Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return predicate.evaluate(with: self)
  }
  func validatePassword() -> Bool {
    let passwordRegex = "^(?=.*[a-z])(?=.*[$@$#!%*?&]).{8,}$"
    let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
    return predicate.evaluate(with: self)
  }
}
