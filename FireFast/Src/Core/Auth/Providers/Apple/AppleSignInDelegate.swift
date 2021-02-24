//
//  AppleSignInDelegate.swift
//  FirebaseLayer
//
//  Created by Behrad Kazemi on 2/16/21.
//

import Foundation
import AuthenticationServices
import FirebaseAuth

class AppleSignInDelegate: NSObject,  ASAuthorizationControllerDelegate {
  
  var onError: ((Error) -> (Void))?
  var onSuccess: ((AuthorizationResponseModel) -> (Void))?
  var nonce: String?
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    onError?(error)
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let appleIDToken = appleIDCredential.identityToken else {
        onError?(NSError(domain: "Unable to fetch identity token", code: -10, userInfo: nil))
        return
      }
      
      guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
        onError?(NSError(domain: "Unable to serialize token string", code: -10, userInfo: ["description": appleIDToken.debugDescription]))
        return
      }
      
      let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
      Auth.auth().signIn(with: credential) { [unowned self](result, error) in
        
        if let error = error {
          self.onError?(error)
          return
        }
        
        let userInformation = AuthorizationResponseModel(email: result?.user.email, name: result?.user.displayName , isVerified: true, userId: result?.user.uid, authResult: result)
        self.onSuccess?(userInformation)
        
      }
      return
    }
    
    onError?(NSError(domain: "Unable to serialize credential", code: -10, userInfo: ["description": authorization.debugDescription]))
    
  }
}
