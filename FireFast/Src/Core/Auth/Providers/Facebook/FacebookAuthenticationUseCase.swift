//
//  FacebookAuthenticationUseCase.swift
//  FirebaseLayer
//
//  Created by Behrad Kazemi on 2/18/21.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth
import UIKit

struct FacebookAuthenticationUseCase: CommonAuthProtocol {
  
  func presentSignIn(on viewController: UIViewController, onSuccess: @escaping (AuthorizationResponseModel) -> (Void), onError: ((Error) -> (Void))?) {
    let manager = LoginManager()
    
    manager.logIn(permissions: ["public_profile", "email"], from: viewController) { (result, error) in
      
      if let error = error{
        onError?(error)
        return
      }
      
      if (result?.isCancelled)!{
        onError?(NSError(domain: "User canceled login proceed", code: ErrorCodes.Authorization.proceedFailure.code(), userInfo: nil))
        return
      }
      
      let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
      Auth.auth().signIn(with: credential, completion: { (result, error) in
        
        if let error = error {
          onError?(error)
          return
        }
        let userInformation = AuthorizationResponseModel(email: result?.user.email, name: result?.user.displayName, isVerified: result?.user.isEmailVerified ?? true, userId: result?.user.uid, authResult: result)
        onSuccess(userInformation)
      })
    }
  }
}
