//
//  ResetPasswordUseCases.swift
//  FireFast
//
//  Created by Behrad Kazemi on 3/1/21.
//

import Foundation
import FirebaseAuth

public struct ResetPasswordUseCases: ResetPasswordUseCasesProtocol {
  
  public func sendCode(forEmail email: String, onSuccess: @escaping () -> (Void), onError: ((Error) -> (Void))?) {
    Auth.auth().sendPasswordReset(withEmail: email) { (error) in
      
      if let error = error {
        onError?(error)
        return
      }
      onSuccess()
    }
  }
  
  public func verify(code: String, onSuccess: @escaping (String?) -> (Void), onError: ((Error) -> (Void))?) {
    Auth.auth().verifyPasswordResetCode(code) { (email, error) in
      
      if let error = error {
        onError?(error)
        return
      }
      onSuccess(email)
    }
  }
  
  public func setNew(password: String, code: String, onSuccess: @escaping () -> (Void), onError: ((Error) -> (Void))?) {
    Auth.auth().confirmPasswordReset(withCode: code, newPassword: password) { (error) in
      if let error = error {
        onError?(error)
        return
      }
      onSuccess()
    }
  }
}
