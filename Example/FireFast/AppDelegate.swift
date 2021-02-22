//
//  AppDelegate.swift
//  FireFast
//
//  Created by behrad-kzm on 02/21/2021.
//  Copyright (c) 2021 behrad-kzm. All rights reserved.
//

import UIKit
import FireFast

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FireFast.UseCaseProvider.application(application: application, didFinishLaunchingWithOptions: launchOptions)
    return true
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    return FireFast.UseCaseProvider.application(application: app, open: url, options: options)
  }
}
