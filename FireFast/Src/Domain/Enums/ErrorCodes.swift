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
      let authorizationErrorCode = 1000
      return (self.rawValue + authorizationErrorCode) * -1
    }
  }
  
  public enum Firestore: Int {
    
    case decodeFailure
    case needInitialize
    
    public func code() -> Int {
      let firestoreErrorCode = 2000
      return (self.rawValue + firestoreErrorCode) * -1
    }
  }
  
  public enum Storage: Int {
    
    case nullData
    
    public func code() -> Int {
      let storageErrorCode = 3000
      return (self.rawValue + storageErrorCode) * -1
    }
  }
  
  public enum RemoteConfig: Int {
    
    case codable
    case unknown
    
    public func code() -> Int {
      let remoteConfigErrorCode = 4000
      return (self.rawValue + remoteConfigErrorCode) * -1
    }
  }
}
