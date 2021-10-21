//
//  FireFastDecoder.swift
//  FireFast
//
//  Created by Mojtaba Soleimani on 2021-10-10.
//

import Foundation

class FireFastDecoder: JSONDecoder {
  override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
    let decoder = JSONDecoder()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    decoder.dateDecodingStrategy = .formatted(formatter)
    return try decoder.decode(T.self, from: data)
  }
}
