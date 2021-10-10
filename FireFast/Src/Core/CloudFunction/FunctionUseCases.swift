//
//  FunctionUseCases.swift
//  FireFast
//
//  Created by Behrad Kazemi on 4/29/21.
//

import Foundation
import FirebaseFunctions

struct FunctionUseCases: FunctionUseCasesProtocol {
  
  func call<T: Codable>(name: String, parameters: [String: Any]?, decoder: JSONDecoder = FireFastDecoder(), onSuccess: @escaping (T) -> Void, onError: ((Error) -> Void)?) {
    Functions.functions().httpsCallable(name).call(parameters) { (result, err) in
      if let err = err {
        onError?(err)
        return
      }
      if let dictionary = result?.data as? [String: Any], let model: T = dictionary.object() {
        onSuccess(model)
        return
      }
      let error = NSError(domain: "Unable to decode dictionary to the desired model", code: ErrorCodes.Authorization.serializationFailure.code(), userInfo: nil)
      onError?(error)
    }
  }
}
