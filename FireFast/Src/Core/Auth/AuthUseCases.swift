//
//  AuthUseCases.swift
//  FirebaseLayer
//
//  Created by Behrad Kazemi on 2/12/21.
//

import Foundation
import FirebaseCore
import FirebaseAuth

struct AuthUseCases: AuthUseCasesProtocol {
  func getSignInMethod(forType type: SignInMethodType) -> CommonAuthProtocol {
    switch type {
    case .apple:
      return AppleAuthenticationUseCase()
    case .facebook:
      return FacebookAuthenticationUseCase()
    case .google:
      return GmailAuthenticationUseCase()
    }
  }
  
  func getPasswordSignInMethods() -> PasswordAuthProtocol {
    return PasswordAthenticationUseCase()
  }
  
  func getPhoneNumberSignInMethods() -> PhoneAuthProtocol {
    return PhoneAuthenticationUseCase()
  }
  
  func getUser() -> User? {
    return Auth.auth().currentUser
  }
  
  func signOut() throws {
    try Auth.auth().signOut()
  }
}
