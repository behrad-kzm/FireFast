//
//  EmailAuthProtocol.swift
//  FirebaseLayer
//
//  Created by Behrad Kazemi on 2/16/21.
//

import Foundation

public protocol PasswordAuthProtocol {
  
  func signUpWith(email: String, password: String, onSuccess: @escaping ()->(Void), onError: ((Error) -> (Void))?)
  
  func signInWith(email: String, password: String, onSuccess: @escaping (AuthorizationResponseModel)->(Void), onError: ((Error) -> (Void))?)
  
}
