//
//  StorageUseCases.swift
//  FireFast
//
//  Created by Behrad Kazemi on 4/5/21.
//

import Foundation
import FirebaseStorage

public struct StorageUseCases: StorageUseCaseProtocol {
  
  public let storage: Storage
  let storageReference: StorageReference
  
  public init(bucketURLPath: String? = nil){
    if let url = bucketURLPath {
      self.storage = Storage.storage(url: url)
    } else {
      self.storage = Storage.storage()
    }
    self.storageReference = storage.reference()
  }
  
  public func listAll(_ storagePath: String, completion: @escaping ([String]) -> Void) {
    let fileReference = storageReference.child(storagePath)
    fileReference.listAll { result, err in
      completion(result.items.map { $0.fullPath})
    }
  }
  
  public func upload(data: Data, path: String, contentType: StorageContentType? = nil, onSuccess: @escaping (UploadInfoModel) -> Void, progressCompleted: ((Double) -> Void)?, onError: ((Error) -> Void)?) -> StorageUploadTask {
    let fileReference = storageReference.child(path)
    let metadata = StorageMetadata()
    metadata.contentType = contentType?.rawValue
    let task = fileReference.putData(data, metadata: metadata) { (metaData, error) in
      if let error = error {
        onError?(error)
      }
      guard let metadata = metaData else {
        let metaDataError = NSError(domain: "Metadata for uploaded file is null", code: ErrorCodes.Storage.nullData.code(), userInfo: nil)
        onError?(metaDataError)
        return
      }
      let info = UploadInfoModel(size: Int(metadata.size), path: path, updatedAt: metadata.updated, createdAt: metadata.timeCreated, contentType: metadata.contentType)
      onSuccess(info)
    }
    task.observe(.progress) { progress in
      if let prog = progress.progress {
        progressCompleted?(prog.fractionCompleted)
      }
    }
    return task
  }
  
  public func makeURL(path: String, onSuccess: @escaping (URL) -> Void, onError: ((Error) -> Void)?) {
    let fileReference = storageReference.child(path)
    fileReference.downloadURL { (url, error) in
      if let error = error {
        onError?(error)
      }
      guard let downloadURL = url else {
        let urlError = NSError(domain: "Download url for the file is null", code: ErrorCodes.Storage.nullData.code(), userInfo: nil)
        onError?(urlError)
        return
      }
      onSuccess(downloadURL)
    }
  }
  
  public func delete(path: String, completion: ((Error?) -> Void)?) {
    let fileReference = storageReference.child(path)
    fileReference.delete(completion: completion)
  }
}
