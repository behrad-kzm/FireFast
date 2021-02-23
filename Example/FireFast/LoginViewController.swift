//
//  LoginViewController.swift
//  FireFast_Example
//
//  Created by Behrad Kazemi on 2/23/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import FireFast
class LoginViewController: UIViewController {

  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  let authenticator = FireFast.UseCaseProvider.makeAuthUseCases()
  
  ///Signing in the user with email and password
  @IBAction func signInClicked(_ sender: Any) {
    guard let email = emailTextField.text, let password = passwordTextField.text else {
      popAlert(title: "Empty input", message: "Fill text fields first!")
      return
    }
    authenticator.getPasswordSignInMethods().signInWith(email: email, password: password) { [unowned self](loginInfo) -> (Void) in
      self.popAlert(title: "Success", message: "Signed in successfully!")
    } onError: { [unowned self](error) -> (Void) in
      self.popAlert(title: "Error", message: "\(error.localizedDescription)")
    }
  }
  
  ///Signing up the user with email and password
  @IBAction func signUpButton(_ sender: Any) {
    guard let email = emailTextField.text, let password = passwordTextField.text else {
      popAlert(title: "Empty input", message: "Fill text fields first!")
      return
    }
    authenticator.getPasswordSignInMethods().signUpWith(email: email, password: password) { [unowned self]() -> (Void) in
      self.popAlert(title: "Success", message: "Signed up successfully and sent verification link to the email address!")
    } onError: { [unowned self](error) -> (Void) in
      self.popAlert(title: "Error", message: "\(error.localizedDescription)")
    }
  }
  
  ///Sign in with providers, Each button has a specific tag same like SignInMethodType's rawValue
  @IBAction func loginByProvider(_ sender: UIButton) {
    if let type = SignInMethodType(rawValue: sender.tag) {
      presentLoginFor(method: type)
      return
    }
    //Implement login by phone using the usecases
  }
  
  func presentLoginFor(method: SignInMethodType){
    authenticator.getSignInMethod(forType: method).presentSignIn(on: self) { [unowned self](loginInfo) -> (Void) in
      self.popAlert(title: "Success", message: "\(String(describing: loginInfo.email)) \n \(String(describing: loginInfo.name))")
    } onError: { [unowned self](error) -> (Void) in
      self.popAlert(title: "Error", message: "\(error.localizedDescription)")
    }
  }
  
  func popAlert(title: String, message: String){
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
}
