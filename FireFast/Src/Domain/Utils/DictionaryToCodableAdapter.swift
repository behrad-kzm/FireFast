//
//  DictionaryToCodableAdapter.swift
//  FireFast
//
//  Created by Behrad Kazemi on 5/4/21.
//

import Foundation

extension Dictionary where Key == String, Value: Any {
  
  func asObject<T: Decodable>() -> T? {
    if let data = try? JSONSerialization.data(withJSONObject: self, options: []) {
      return try? JSONDecoder().decode(T.self, from: data)
    } else {
      return nil
    }
  }
}
