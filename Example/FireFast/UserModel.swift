//
//  UserModel.swift
//  FireFast_Example
//
//  Created by Behrad Kazemi on 3/2/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import FireFast
import FirebaseFirestore

public struct UserModel: Codable{
  
  public let currentLocation: GeoPoint
  public let name: String
  public let birthDate: Timestamp?
  public let serverTime: CodableServerTimestamp?
  public let email: String
  public let path: String
}
