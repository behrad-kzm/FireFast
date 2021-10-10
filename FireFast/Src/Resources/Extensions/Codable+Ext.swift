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
  
  func unwrap<T: Codable>(type: T.Type, value: Value?) -> Value? {
    if let val = value as? T, let locData = try? JSONEncoder().encode(val), let newValue = try? JSONSerialization.jsonObject(with: locData, options: .allowFragments) as? Value{
      return newValue
    }
    return nil
  }
  
  func castToCodables() -> [String: Any] {
    
    var resultDictionary = self
    for key in resultDictionary.keys {
      
      if let newValue = unwrap(type: GeoPoint.self, value: resultDictionary[key]){
        resultDictionary[key] = newValue
        continue
      }
      if let newValue = unwrap(type: Timestamp.self, value: resultDictionary[key]){
        resultDictionary[key] = newValue
        continue
      }
      
      if let val = resultDictionary[key] as? DocumentReference {
        let castedReference = val.path
        resultDictionary[key] = castedReference as? Value
      }
      
      if let val = resultDictionary[key] as? [String: Any] {
        resultDictionary[key] = val.castToCodables() as? Value
      }
    }
    return resultDictionary
  }
  
  public func castToFirebase() -> [String: Any] {
    
    var resultDictionary = self
    for key in resultDictionary.keys {
      guard let currentValue = resultDictionary[key] as? [String: Any] else {
        continue
      }
      
      if let newValue: GeoPoint = currentValue.object(decoder: FireFastDecoder()), let value = newValue as? Value {
        resultDictionary[key] = value
        continue
      }
      
      if let newValue: Timestamp = currentValue.object(decoder: FireFastDecoder()), let value = newValue as? Value {
        resultDictionary[key] = value
        continue
      }
      
      if let _: DummyServerTimestamp = currentValue.object(decoder: FireFastDecoder()) {
        
        resultDictionary[key] = FieldValue.serverTimestamp() as? Value
        continue
      }
      
      if let newValue = resultDictionary[key] as? DocumentReference {
        let castedReference = newValue.path
        resultDictionary[key] = castedReference as? Value
        continue
      }
      
      if let newValue = currentValue.castToFirebase() as? Value {
        resultDictionary[key] = newValue
      }
    }
    return resultDictionary
  }
  
  func object<T: Decodable>(decoder: JSONDecoder) -> T? {
    do {
      let data = try JSONSerialization.data(withJSONObject: self, options: [])
      do {
        let object = try decoder.decode(T.self, from: data)
        return object
      } catch let err {
        print("error on converting to object with err: \(err)")
        return nil
      }
    } catch let err {
      print("error on converting to object with err: \(err)")
      return nil
    }
  }
  
  func objectWithError<T: Decodable>() throws -> T {
    do {
      let data = try JSONSerialization.data(withJSONObject: self, options: [])
      return try JSONDecoder().decode(T.self, from: data)
      
    } catch let error {
      let customError = NSError(domain: "[FireFast] - objectWithError", code: 400, userInfo: ["message": "Can not conver document to dictionary", "info": error])
      throw customError
    }
  }
}

