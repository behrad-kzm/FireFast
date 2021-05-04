//
//  RemoteConfigUseCasesProtocol.swift
//  FireFast
//
//  Created by Behrad Kazemi on 5/4/21.
//

import Foundation

public protocol RemoteConfigUseCasesProtocol {
  
  func get<T: Codable>(key: String, onSuccess: @escaping (T) -> Void, onError: ((Error) -> Void)?)
  func get(key: String, onSuccess: @escaping (Bool) -> Void, onError: ((Error) -> Void)?)
  func get(key: String, onSuccess: @escaping (String) -> Void, onError: ((Error) -> Void)?)
  func get(key: String, onSuccess: @escaping (NSNumber) -> Void, onError: ((Error) -> Void)?)
  func get(key: String, onSuccess: @escaping (Data) -> Void, onError: ((Error) -> Void)?)
}
