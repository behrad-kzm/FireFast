//
//  UseCaseProvider.swift
//  FirebaseLayer
//
//  Created by Behrad Kazemi on 2/12/21.
//

import Foundation
import Firebase
import GoogleSignIn
import FBSDKCoreKit

public struct UseCaseProvider: CloudUseCaseProvider {
  
  public init(){}
  
  public static func application(application: UIApplication, didFinishLaunchingWithOptions launchingOptions: [UIApplication.LaunchOptionsKey : Any]?){
    ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchingOptions)
    FirebaseApp.configure()
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
  
}
