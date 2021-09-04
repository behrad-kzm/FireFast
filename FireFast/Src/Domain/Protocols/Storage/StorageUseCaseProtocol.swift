//
//  StorageUseCaseProtocol.swift
//  FireFast
//
//  Created by Behrad Kazemi on 4/5/21.
//

import FirebaseStorage

public protocol StorageUseCaseProtocol {
  func upload(data: Data, path: String, contentType: StorageContentType?, onSuccess: @escaping (UploadInfoModel) -> Void, progressCompleted: ((Double) -> Void)?, onError: ((Error) -> Void)?) -> StorageUploadTask
  func makeURL(path: String, onSuccess: @escaping (URL) -> Void, onError: ((Error) -> Void)?)
  func delete(path: String, completion: ((Error?) -> Void)?)
}
