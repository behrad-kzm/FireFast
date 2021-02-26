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
      Auth.auth().signIn(with: credential, completion: { (authResult, error) in
        
        if let error = error {
          onError?(error)
          return
        }
        let name = (result?.authenticationToken?.value(forKey: "_claims") as? NSObject)?.value(forKey: "_name") as? String
        let email = (result?.authenticationToken?.value(forKey: "_claims") as? NSObject)?.value(forKey: "_email") as? String
        let response = AuthorizationResponseModel(email: email, name: name, isVerified: true, userId: result?.token?.userID, authResult: authResult)
        onSuccess(response)
      })
    }
  }
}
