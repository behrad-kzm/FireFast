//
//  UploadInfoModel.swift
//  FireFast
//
//  Created by Behrad Kazemi on 4/5/21.
//

import Foundation

public struct UploadInfoModel {
  public let size: Int
  public let path: String?
  public let updatedAt: Date?
  public let createdAt: Date?
  public let contentType: String?
  
  public init (size: Int, path: String?, updatedAt: Date?, createdAt: Date?, contentType: String?){    
    self.size = size
    self.path = path
    self.updatedAt = updatedAt
    self.createdAt = createdAt
    self.contentType = contentType
  }
}
