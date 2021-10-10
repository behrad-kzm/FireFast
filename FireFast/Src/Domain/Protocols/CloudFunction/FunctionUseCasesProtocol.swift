//
//  FunctionUseCasesProtocol.swift
//  FireFast
//
//  Created by Behrad Kazemi on 4/29/21.
//

import Foundation

public protocol FunctionUseCasesProtocol {
  func call<T: Codable>(name: String, parameters: [String: Any]?, decoder: JSONDecoder, onSuccess: @escaping (T) -> Void, onError: ((Error) -> Void)?)
}
