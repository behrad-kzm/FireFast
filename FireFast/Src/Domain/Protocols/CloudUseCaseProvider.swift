//
//  UseCaseProvider.swift
//  FirebaseLayer
//
//  Created by Behrad Kazemi on 2/12/21.
//

import Foundation
import GoogleSignIn
import UIKit

public protocol CloudUseCaseProvider {
  
  static func application(application: UIApplication, didFinishLaunchingWithOptions launchingOptions: [UIApplication.LaunchOptionsKey : Any]?)
  static func application(application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool
  static func makeAuthUseCases() -> AuthUseCasesProtocol
  static func makeFirestoreUseCases() -> FirestoreUseCasesProtocol
  static func makeStorageUseCases(_ path: String?) -> StorageUseCaseProtocol
  static func makeCloudFunctionUseCases() -> FunctionUseCasesProtocol
}
