//
//  EmailSignInInfoModel.swift
//  FirebaseLayer
//
//  Created by Behrad Kazemi on 2/12/21.
//

import Foundation
import FirebaseAuth

public struct AuthorizationResponseModel {
  
  public let email: String?
  public let name: String?
  public let isVerified: Bool
  public let userId: String?
  public let authResult: AuthDataResult?
  
}
