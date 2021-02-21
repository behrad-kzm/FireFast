//
//  CommonAuthProtocol.swift
//  FirebaseLayer
//
//  Created by Behrad Kazemi on 2/17/21.
//

import Foundation
import FirebaseAuth
import GoogleSignIn

public protocol CommonAuthProtocol {
  
  func presentSignIn(on viewController: UIViewController, onSuccess: @escaping (AuthorizationResponseModel)->(Void), onError: ((Error) -> (Void))?)
  
}
