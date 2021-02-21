//
//  PhoneAuthProtocol.swift
//  FirebaseLayer
//
//  Created by Behrad Kazemi on 2/20/21.
//

import Foundation

public protocol PhoneAuthProtocol {
  
  func sendCode(phone: String, onSuccess: @escaping (_ verificationId: String)->(Void), onError: ((Error) -> (Void))?)
  
  func verify(verificationId: String, verificationCode: String, onSuccess: @escaping (AuthorizationResponseModel)->(Void), onError: ((Error) -> (Void))?)
  
}
