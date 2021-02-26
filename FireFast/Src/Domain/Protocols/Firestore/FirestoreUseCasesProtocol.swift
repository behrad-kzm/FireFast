//
//  FirestoreUseCasesProtocol.swift
//  abseil
//
//  Created by Behrad Kazemi on 2/25/21.
//

import Foundation

public protocol FirestoreUseCasesProtocol {
  func collection<T: Encodable>(forType: T.Type, collectionName: String) -> GenericCollection<T>
}
