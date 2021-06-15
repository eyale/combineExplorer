//
//  ViewController.swift
//  combineExplorer
//
//  Created by Anton Honcharov on 6/11/21.
//

import UIKit
import Combine

class FormVC: UIViewController {
  // MARK: - Properties

  // Combine Subscribers
  var emailSubscriber: AnyCancellable?
  var passwordSubscriber: AnyCancellable?
  // Combine dispose bag and Model instance
  private var subscribers: [AnyCancellable] = []
  private var formViewModel = FormViewModel()

  // MARK: - IBOutlets
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var emailErrorHint: UILabel!

  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var passwordErrorHint: UILabel!

  @IBOutlet weak var loginButton: UIButton!

  @IBOutlet weak var wrapper: UIStackView!
}

// MARK: - Life cycle
extension FormVC {
  override func viewDidLoad() {
    super.viewDidLoad()

    initAnimation()
    setupTextFields()
    setupLogingButton()
    setupPasswordIcon()

    bindTextFields()
    initCombineSubscriprions()
  }
}

// MARK: - Set up
extension FormVC {
  func bindTextFields() {
    emailTextField.addTarget(self,
                             action: #selector(emailChanged),
                             for: .editingChanged)
    passwordTextField.addTarget(self,
                                action: #selector(passwordChanged),
                                for: .editingChanged)
  }
  func initCombineSubscriprions() {
    let email = formViewModel
      .emailPublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] emailErrorHint in
        guard let `self` = self else { return }

        self.emailErrorHint.text = emailErrorHint
      }

    emailSubscriber = AnyCancellable(email)


    let password = formViewModel
      .passwordPublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] passwordErrorHint in
        guard let `self` = self else { return }

        self.passwordErrorHint.text = passwordErrorHint
      }

    passwordSubscriber = AnyCancellable(password)

    // I didn't figured out how without this code beyond validation function is not working
    formViewModel.isFormValid
      .map { $0 != nil }
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { (isEnable) in
        if isEnable {
          self.loginButton.alpha = 1.0
        } else {
          self.loginButton.alpha = 0.5
        }
        self.loginButton.isEnabled = isEnable
      })
      .store(in: &subscribers)

  }

  func setupTextFields() {
    emailTextField.keyboardType = .twitter
    emailTextField.autocapitalizationType = .none
    emailTextField.autocorrectionType = .no

    passwordTextField.keyboardType = .twitter
    passwordTextField.autocorrectionType = .no
    passwordTextField.autocapitalizationType = .none
    passwordTextField.isSecureTextEntry = true
  }

  func setupLogingButton() {
    loginButton.isEnabled = false
    loginButton.alpha = 0.5

    loginButton.backgroundColor = .clear
    loginButton.layer.cornerRadius = 5
    loginButton.layer.backgroundColor = UIColor.systemBlue.cgColor
  }

  func initAnimation() {
    wrapper.alpha = 0.0
    UIView.animate(withDuration: 1,
                   delay: 0,
                   usingSpringWithDamping: 1,
                   initialSpringVelocity: 1,
                   options: []) {
      self.wrapper.alpha = 1
      self.wrapper.layoutIfNeeded()
    }
  }
  func setupPasswordIcon() {
    if let passwordIcon = UIImage(systemName: "eye") /*, let passwordIconSlash = UIImage(systemName: "eye.slash") */ {
      let imageView = UIImageView(frame: CGRect(x: 15,
                                                y: 13,
                                                width: 20,
                                                height: 15))
      passwordTextField.tintColor = .lightGray
      imageView.image = passwordIcon

      let imageContainerView = UIView(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: CGFloat(passwordTextField.frame.width / 7),
                                                    height: passwordTextField.frame.height))

      imageContainerView.addSubview(imageView)
      passwordTextField.rightView = imageContainerView
      passwordTextField.rightViewMode = .always
    }
  }
}
// MARK: - IBActions
extension FormVC {
  @IBAction func onLoginButtonTap(sender: UIButton) {
    let alert = UIAlertController(title: "...login processing",
                                  message: "Sending data to server to log you in...",
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Close",
                                  style: .default,
                                  handler: { action in
                                    print("Alert action tapped")
                                  }))

    self.present(alert, animated: true, completion: nil)
  }
  @IBAction func emailChanged(_ sender: UITextField) {
    formViewModel.email = sender.text ?? ""
  }
  @IBAction func passwordChanged(_ sender: UITextField) {
    formViewModel.password = sender.text ?? ""
  }
}
// MARK: - Navigation
// MARK: - Network Manager calls
// MARK: - Extensions
