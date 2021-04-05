//
//  UseCaseProvider.swift
//  FirebaseLayer
//
//  Created by Behrad Kazemi on 2/12/21.
//

import Foundation
import FirebaseCore
import GoogleSignIn
import FBSDKCoreKit

public struct UseCaseProvider: CloudUseCaseProvider {
  public static func application(application: UIApplication, didFinishLaunchingWithOptions launchingOptions: [UIApplication.LaunchOptionsKey : Any]?){
    FirebaseApp.configure()
    ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchingOptions)
  }
  
  public static func application(application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
    if ApplicationDelegate.shared.application(application, open: url, options: options){
      return true
    }
    return GIDSignIn.sharedInstance().handle(url)
  }
  
  public static func makeAuthUseCases() -> AuthUseCasesProtocol {
    return AuthUseCases()
  }
  
  public static func makeFirestoreUseCases() -> FirestoreUseCasesProtocol {
    return FirestoreUseCases()
  }
  
  public static func makeStorageUseCases(_ path: String?) -> StorageUseCaseProtocol {
    return StorageUseCases(bucketURLPath: path)
  }
}
