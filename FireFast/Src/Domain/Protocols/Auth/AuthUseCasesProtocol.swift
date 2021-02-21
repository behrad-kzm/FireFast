//
//  AuthUseCasesProtocol.swift
//  FirebaseLayer
//
//  Created by Behrad Kazemi on 2/12/21.
//

import Foundation

public protocol AuthUseCasesProtocol {
  
  func getPasswordSignInMethods() -> PasswordAuthProtocol
  func getPhoneNumberSignInMethods() -> PhoneAuthProtocol
  func getSignInMethod(forType: SignInMethodType) -> CommonAuthProtocol

}
