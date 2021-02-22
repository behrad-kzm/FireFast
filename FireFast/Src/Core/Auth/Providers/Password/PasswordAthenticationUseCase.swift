//
//  PasswordAthenticationUseCase.swift
//  FirebaseLayer
//
//  Created by Behrad Kazemi on 2/16/21.
//

import Foundation
import FirebaseAuth

struct PasswordAthenticationUseCase: PasswordAuthProtocol {

  func signUpWith(email: String, password: String,  onSuccess: @escaping () -> (Void), onError: ( (Error) -> (Void))?) {
    
    Auth.auth().createUser(withEmail: email, password: password)  { (result, error) in
      
      if error != nil {
        onError?(error!)
        return
      }
      result?.user.sendEmailVerification(completion: nil)
      onSuccess()
    }
  }
  
  func signInWith(email: String, password: String, onSuccess: @escaping (AuthorizationResponseModel) -> (Void), onError: ((Error) -> (Void))?) {
    
    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
      
      if error != nil {
        onError?(error!)
        return
      }

      let information = AuthorizationResponseModel(email: email, name: nil, isVerified: result?.user.isEmailVerified ?? false, userId: result?.user.uid, authResult: result)
      
      onSuccess(information)
    }
  }
}
