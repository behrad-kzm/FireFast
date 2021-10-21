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
    decoder.dateDecodingStrategy = .iso8601
    return try decoder.decode(T.self, from: data)
  }
}
