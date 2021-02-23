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
  
  func getUser() -> AuthorizationResponseModel? {
    if let user = Auth.auth().currentUser {
      return AuthorizationResponseModel(email: user.email, name: user.displayName, isVerified: user.isEmailVerified, userId: user.uid, authResult: nil)
    }
    return nil
  }
  
  func signOut() throws {
    try Auth.auth().signOut()
  }
}
