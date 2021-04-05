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
  
  public func upload(data: Data, path: String, onSuccess: @escaping (UploadInfoModel) -> Void, onError: ((Error) -> Void)?){
    let fileReference = storageReference.child(path)
    fileReference.putData(data, metadata: nil) { [fileReference](metaData, error) in
      guard let metadata = metaData else {
        let metaDataError = NSError(domain: "Metadata for uploaded file is null", code: ErrorCodes.Storage.nullData.code(), userInfo: nil)
        onError?(metaDataError)
        return
      }
      fileReference.downloadURL { [onError](url, error) in
        guard let downloadURL = url else {
          let urlError = NSError(domain: "Download url for the file is null", code: ErrorCodes.Storage.nullData.code(), userInfo: nil)
          onError?(urlError)
          return
        }
        let info = UploadInfoModel(size: Int(metadata.size), path: downloadURL.absoluteString, updatedAt: metadata.updated, createdAt: metadata.timeCreated, contentType: metadata.contentType)
        onSuccess(info)
      }

    }
  }
}