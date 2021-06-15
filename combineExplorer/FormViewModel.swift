//
//  FormViewModel.swift
//  combineExplorer
//
//  Created by Anton Honcharov on 6/14/21.
//

import Foundation
import Combine


/*
 project was based on code base related to article
 https://medium.com/mindful-engineering/saying-hello-to-combine-framework-part-1-30d9c07210df
 https://github.com/Mindinventory/CombinePart-1/tree/master/CombineWithMVVM
*/

class FormViewModel {
  // Properties to track
  @Published var email = ""
  @Published var password = ""

  // PassthroughSubject - passes upstream value downstream
  let emailPublisher = PassthroughSubject<String, Never>()
  let passwordPublisher = PassthroughSubject<String, Never>()

  var validatedEmail: AnyPublisher<String?, Never> {
    return $email
      .map { email in
        guard email.count != 0 else {
          self.emailPublisher.send("Email can't be blank")
          return nil
        }

        guard email.validateEmail() else {
          self.emailPublisher.send("Check your email. It must contain @ sign")
          return nil
        }

        self.emailPublisher.send("")
        return email
      }
      .eraseToAnyPublisher()
  }

  var validatePassword: AnyPublisher<String?, Never> {
    return $password
      .map { password in
        guard password.count != 0 else {
          self.passwordPublisher.send("Password can't be blank")
          return nil
        }
        guard password.validatePassword() else {
          self.passwordPublisher.send("Password must contain "
                                        + "at least one uppercase letter, lowercase letter, "
                                        + "number digit, special characters and "
                                        + "is minimum eight char long")
          return nil
        }

        self.passwordPublisher.send("")
        return password
      }.eraseToAnyPublisher()
  }

  var isFormValid: AnyPublisher<(String, String)?, Never> {
    return Publishers.CombineLatest(validatedEmail, validatePassword)
      .map { email, password in
        guard
          let emailVal = email,
          let passwordVal = password,
          emailVal.validateEmail(),
          passwordVal.validatePassword() else {
          return nil
        }

        return (emailVal, passwordVal)
      }.eraseToAnyPublisher()
  }

}
