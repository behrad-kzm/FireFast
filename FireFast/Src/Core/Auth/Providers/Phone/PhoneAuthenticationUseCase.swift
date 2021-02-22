//
//  PhoneAuthenticationUseCase.swift
//  FirebaseLayer
//
//  Created by Behrad Kazemi on 2/20/21.
//

import Foundation
import FirebaseAuth

struct PhoneAuthenticationUseCase: PhoneAuthProtocol {
  
  func sendCode(phone: String, onSuccess: @escaping (String) -> (Void), onError: ((Error) -> (Void))?) {
    PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { (verificationID, error) in
      if let error = error {
        onError?(error)
        return
      }
      
      if let verificationID = verificationID{
        onSuccess(verificationID)
        return
      }
      
      onError?(NSError(domain: "The verificationID is empty or null", code: -12, userInfo: nil))
    }
  }
  
  func verify(verificationId: String, verificationCode: String, onSuccess: @escaping (AuthorizationResponseModel) -> (Void), onError: ((Error) -> (Void))?) {
    let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: verificationCode)
    Auth.auth().signIn(with: credential, completion: { (result, error) in
      
      if let error = error {
        onError?(error)
        return
      }
      let response = AuthorizationResponseModel(email: result?.user.email, name: result?.user.displayName, isVerified: true, userId: result?.user.uid, authResult: result)
      onSuccess(response)
    })
  }
}
