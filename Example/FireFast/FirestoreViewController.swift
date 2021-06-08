//
//  FirestoreViewController.swift
//  FireFast_Example
//
//  Created by Behrad Kazemi on 3/2/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import FireFast
import FirebaseFirestore
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
  @IBAction func setQuery(_ sender: Any) {
    let insertableDocument = UserModel(currentLocation: GeoPoint(latitude: 37, longitude: 53), name: "Behrad", birthDate: Timestamp(seconds: Int64(Date.timeIntervalSinceReferenceDate), nanoseconds: 0), serverTime: .fillByServer, email: "bez@bezbes.com", path: "/users/test", data: MetaData(uid: UUID().uuidString, creationDate: .fillByServer))
    
    let collection = FireFast.UseCaseProvider.makeFirestoreUseCases().collection(forType: UserModel.self, collectionName: "users")
    collection.upsert(document: insertableDocument, completionHandler: { (error) in
      print("BOOOOK", error)
    })
  }
}
