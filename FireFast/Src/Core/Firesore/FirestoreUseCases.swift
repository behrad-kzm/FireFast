//
//  FirestoreUseCases.swift
//  FireFast
//
//  Created by Behrad Kazemi on 2/25/21.
//

import Foundation
import FirebaseFirestore

struct FirestoreUseCases: FirestoreUseCasesProtocol {
  var snapshot: DocumentSnapshot?
  let database = Firestore.firestore()
  
  func collection<T: Codable>(forType: T.Type, collectionName: String) -> GenericCollection<T>{
    return GenericCollection<T>(base: database.collection(collectionName))
  }
  
  func getDictionaryFrom<T: Codable>(codable: T) throws -> [String: Any] {
    return try codable.asDictionary().castToFirebase()
  }
}
