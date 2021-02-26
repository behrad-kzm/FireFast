//
//  GmailSignInDelegate.swift
//  FirebaseLayer
//
//  Created by Behrad Kazemi on 2/16/21.
//

import UIKit
import GoogleSignIn
import FirebaseAuth

class GmailSignInDelegate: NSObject,  GIDSignInDelegate {
  
  var onError: ((Error) -> (Void))?
  var onSuccess: ((AuthorizationResponseModel) -> (Void))?
  
  func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    
    if let error = error {
      onError?(error)
      return
    }
    
    guard let authentication = user.authentication else { return }
    let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
    Auth.auth().signIn(with: credential) { [unowned self](result, error) in
      if let error = error {
        self.onError?(error)
        return
      }
      
      let userInformation = AuthorizationResponseModel(email: signIn.currentUser.profile.email, name: result?.user.displayName, isVerified: true, userId: signIn.currentUser.userID, authResult: result)
      self.onSuccess?(userInformation)
    }

  }
  
}
