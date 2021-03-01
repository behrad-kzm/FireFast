//
//  ResetPasswordUseCasesProtocol.swift
//  FireFast
//
//  Created by Behrad Kazemi on 3/1/21.
//

import Foundation

public protocol ResetPasswordUseCasesProtocol {
  
  func sendCode(forEmail email: String, onSuccess: @escaping () -> (Void), onError: ((Error) -> (Void))?)
  func verify(code: String, onSuccess: @escaping (_ email: String?) -> (Void), onError: ((Error) -> (Void))?)
  func setNew(password: String, code: String, onSuccess: @escaping () -> (Void), onError: ((Error) -> (Void))?)
}
