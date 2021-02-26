//
//  ErrorCodes.swift
//  FireFast
//
//  Created by Behrad Kazemi on 2/26/21.
//

import Foundation
public enum ErrorCodes {
  
  public enum Authorization: Int {
    
    case serializationFailure
    case proceedFailure
    case nullData
    
    public func code() -> Int {
      let firestoreCode = 1000
      return (self.rawValue + firestoreCode) * -1
    }
  }
  
  public enum Firestore: Int {
    
    case decodeFailure
    case needInitialize
    
    public func code() -> Int {
      let firestoreCode = 2000
      return (self.rawValue + firestoreCode) * -1
    }
  }
  
}
