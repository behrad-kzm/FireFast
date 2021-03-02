//
//  Codable+Ext.swift
//  abseil
//
//  Created by Behrad Kazemi on 2/25/21.
//

import Foundation
import FirebaseFirestore

extension Encodable {
  func asDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      throw NSError(domain: "Can't encode model to dictionary.\(self)", code: -1, userInfo: nil)
    }
    return dictionary
  }
}

extension Dictionary where Key == String, Value: Any {
  
  func castToCodables() -> [String: Any] {
    
    var resultDictionary = self
    for key in resultDictionary.keys {
      if let val = resultDictionary[key] as? GeoPoint, let locData = try? JSONEncoder().encode(val), let newValue = try? JSONSerialization.jsonObject(with: locData, options: .allowFragments) as? Value{
        resultDictionary[key] = newValue
      }
      //TODO
    }
    return resultDictionary
  }
  
  func object<T: Decodable>() -> T? {
    if let data = try? JSONSerialization.data(withJSONObject: self, options: []) {
      return try? JSONDecoder().decode(T.self, from: data)
    } else {
      return nil
    }
  }
}

