//
//  RemoteConfigUseCase.swift
//  abseil
//
//  Created by Behrad Kazemi on 5/4/21.
//

import Foundation
import FirebaseRemoteConfig

public struct RemoteConfigUseCase: RemoteConfigUseCasesProtocol {

  let remoteConfig: RemoteConfig
  let settings: RemoteConfigSettings
  
  init(fetchInterval: TimeInterval) {
    self.remoteConfig = RemoteConfig.remoteConfig()
    self.settings = RemoteConfigSettings()
    self.settings.minimumFetchInterval = fetchInterval
    self.remoteConfig.configSettings = settings
    self.remoteConfig.setDefaults(fromPlist: "FireFastRemoteConfigDefaults")
  }
  
  public func get<T>(key: String, onSuccess: @escaping (T) -> Void, onError: ((Error) -> Void)?) where T : Decodable, T : Encodable {
    fetch {
      if let dict = self.remoteConfig[key].jsonValue as? [String: Any] {
        if let result: T = dict.asObject() {
          onSuccess(result)
        }
        let error = NSError(domain: "Cannot decode object to the desired result type. Please specify a correct format for decoding.",
                            code: ErrorCodes.RemoteConfig.codable.code(),
                            userInfo: nil)
        onError?(error)
        return
      }
    } onError: { (error) in
      onError?(error)
    }
    if let dict = self.remoteConfig[key].jsonValue as? [String: Any] {
      if let result: T = dict.asObject() {
        onSuccess(result)
      }
      let error = NSError(domain: "Cannot decode object to the desired result type. Please specify a correct format for decoding.",
                          code: ErrorCodes.RemoteConfig.codable.code(),
                          userInfo: nil)
      onError?(error)
      return
    }
  }
  
  public func get(key: String, onSuccess: @escaping (Bool) -> Void, onError: ((Error) -> Void)?) {
    fetch {
      onSuccess(self.remoteConfig[key].boolValue)
    } onError: { (error) in
      onError?(error)
    }
    onSuccess(self.remoteConfig[key].boolValue)
  }
  
  public func get(key: String, onSuccess: @escaping (String) -> Void, onError: ((Error) -> Void)?) {
    fetch {
      if let result = self.remoteConfig[key].stringValue {
          onSuccess(result)
      }
    } onError: { (error) in
      onError?(error)
    }
    if let result = self.remoteConfig[key].stringValue {
        onSuccess(result)
    }
  }
  
  public func get(key: String, onSuccess: @escaping (NSNumber) -> Void, onError: ((Error) -> Void)?) {
    fetch {
      onSuccess(self.remoteConfig[key].numberValue)
    } onError: { (error) in
      onError?(error)
    }
    onSuccess(self.remoteConfig[key].numberValue)
  }
  
  public func get(key: String, onSuccess: @escaping (Data) -> Void, onError: ((Error) -> Void)?) {
    fetch {
      onSuccess(self.remoteConfig[key].dataValue)
    } onError: { (error) in
      onError?(error)
    }
    onSuccess(self.remoteConfig[key].dataValue)
  }
  
  private func fetch(onSuccess: @escaping () -> Void, onError: ((Error) -> Void)?){
    remoteConfig.fetch() { (status, error) -> Void in
      if status == .success {
        self.remoteConfig.activate() { [onSuccess](changed, error) in
          if let error = error {
            onError?(error)
          }
            onSuccess()
            return
        }
      } else {
        let defaultError = NSError(domain: "Unknown Error", code: ErrorCodes.RemoteConfig.unknown.code(), userInfo: nil)
        onError?(error ?? defaultError)
      }
    }
  }
  
}
