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

struct GmailAuthenticationUseCase: CommonAuthProtocol {

  static var delegate: GmailSignInDelegate? = GmailSignInDelegate()
  
  func presentSignIn(on viewController: UIViewController, onSuccess: @escaping (AuthorizationResponseModel) -> (Void), onError: ((Error) -> (Void))?) {
    
    GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
    GmailAuthenticationUseCase.delegate?.onSuccess = onSuccess
    GmailAuthenticationUseCase.delegate?.onError = onError
    GIDSignIn.sharedInstance()?.delegate = GmailAuthenticationUseCase.delegate
    GIDSignIn.sharedInstance()?.presentingViewController = viewController
    GIDSignIn.sharedInstance()?.signIn()
  }
}
