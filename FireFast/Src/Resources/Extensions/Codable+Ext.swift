//
//  Codable+Ext.swift
//  abseil
//
//  Created by Behrad Kazemi on 2/25/21.
//

import Foundation

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

    func object<T: Decodable>() -> T? {
        if let data = try? JSONSerialization.data(withJSONObject: self, options: []) {
            return try? JSONDecoder().decode(T.self, from: data)
        } else {
            return nil
        }
    }
}

