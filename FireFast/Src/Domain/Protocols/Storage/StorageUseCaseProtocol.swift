//
//  StorageUseCaseProtocol.swift
//  FireFast
//
//  Created by Behrad Kazemi on 4/5/21.
//

import Foundation

public protocol StorageUseCaseProtocol {
  
  func upload(data: Data, path: String, onSuccess: @escaping (UploadInfoModel) -> Void, onError: ((Error) -> Void)?)
  func makeURL(path: String, onSuccess: @escaping (URL) -> Void, onError: ((Error) -> Void)?)
  func delete(path: String, completion: ((Error?) -> Void)?)
}
