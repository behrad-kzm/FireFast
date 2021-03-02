//
//  FirestoreViewController.swift
//  FireFast_Example
//
//  Created by Behrad Kazemi on 3/2/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import FireFast

class FirestoreViewController: UIViewController {
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  @IBAction func runQuery(_ sender: Any) {
    let collection = FireFast.UseCaseProvider.makeFirestoreUseCases().collection(forType: UserModel.self, collectionName: "users")
    collection.get(documentId: "kjnNVKz9CxNwCqGT7PK7") { (model) in
      print("this is the query result", model)
    } onError: { (error) in
      print(error)
    }
  }
}
