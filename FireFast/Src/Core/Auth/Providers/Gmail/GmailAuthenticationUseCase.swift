//
//  GmailAuthenticationUseCase.swift
//  FirebaseLayer
//
//  Created by Behrad Kazemi on 2/16/21.
//

import Foundation
import UIKit
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

struct GmailAuthenticationUseCase: CommonAuthProtocol {
  
  func presentSignIn(on viewController: UIViewController, onSuccess: @escaping (AuthorizationResponseModel) -> (Void), onError: ((Error) -> (Void))?) {
    if let clientId = FirebaseApp.app()?.options.clientID {
      let config = GIDConfiguration(clientID: clientId)
      GIDSignIn.sharedInstance.signIn(with: config, presenting: viewController) { [onSuccess, onError](user, error) in
        
        if let error = error {
          onError?(error)
          return
        }
        if let idToken = user?.authentication.idToken, let accessToken = user?.authentication.accessToken {
          let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
          Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error {
              onError?(error)
              return
            }
            
            let userInformation = AuthorizationResponseModel(email: result?.user.email, name: result?.user.displayName, isVerified: result?.user.isEmailVerified ?? true, userId: result?.user.uid, authResult: result)
            onSuccess(userInformation)
          }
          return
        }
        let error = NSError(domain: "[FireFast] - presentSignIn(on:onSuccess:onError:)", code: -1, userInfo: ["message" : "Could not get idToken or accessToken from the response"])
        onError?(error)
      }
      return
    }
    let error = NSError(domain: "[FireFast] - presentSignIn(on:onSuccess:onError:)", code: -1, userInfo: ["message" : "Could not get clientId from the FirebaseApp"])
    onError?(error)
  }
}
