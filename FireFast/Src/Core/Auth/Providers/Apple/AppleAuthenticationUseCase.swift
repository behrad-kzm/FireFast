//
//  AppleAuthenticationUseCase.swift
//  FirebaseLayer
//
//  Created by Behrad Kazemi on 2/16/21.
//

import Foundation
import UIKit
import AuthenticationServices

struct AppleAuthenticationUseCase: CommonAuthProtocol {
  
  static let delegate: AppleSignInDelegate? = AppleSignInDelegate()
  
  func presentSignIn(on viewController: UIViewController, onSuccess: @escaping (AuthorizationResponseModel) -> (Void), onError: ((Error) -> (Void))?) {
    let nonce = Utils.randomNonceString()
    let request = createAppleIDRequest(nonce: nonce)
    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    AppleAuthenticationUseCase.delegate?.nonce = request.nonce
    AppleAuthenticationUseCase.delegate?.onSuccess = onSuccess
    AppleAuthenticationUseCase.delegate?.onError = onError
    authorizationController.delegate = AppleAuthenticationUseCase.delegate
    authorizationController.presentationContextProvider = viewController
    authorizationController.performRequests()
  }
  
  private func createAppleIDRequest(nonce: String) -> ASAuthorizationAppleIDRequest{
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]
    request.nonce = Utils.sha256(nonce)
    
    return request
  }
}

extension UIViewController: ASAuthorizationControllerPresentationContextProviding {
  public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.view.window!
  }
}
