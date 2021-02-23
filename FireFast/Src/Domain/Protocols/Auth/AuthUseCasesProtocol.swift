//
//  AuthUseCasesProtocol.swift
//  FirebaseLayer
//
//  Created by Behrad Kazemi on 2/12/21.
//

import Foundation
import FirebaseAuth

public protocol AuthUseCasesProtocol {
  
  func getPasswordSignInMethods() -> PasswordAuthProtocol
  func getPhoneNumberSignInMethods() -> PhoneAuthProtocol
  func getSignInMethod(forType: SignInMethodType) -> CommonAuthProtocol

  func getUser() -> User?
  func signOut() throws
}
