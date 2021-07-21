//
//  GenericCollection.swift
//  FireFast
//
//  Created by Behrad Kazemi on 2/25/21.
//

import Foundation
import FirebaseFirestore
public struct GenericCollection<T: Codable> {
  
  private let base: CollectionReference
  
  public init (base: CollectionReference){
    self.base = base
  }
  
  public func paginate() -> AutoPaginator<T> {
    return AutoPaginator(base: base)
  }
  
  public func get(documentId id: String, onSuccess: @escaping ((T?) -> Void), onError: ((Error) -> Void)?){
    base.document(id).getDocument { (document, error) in
      if let error = error{
        onError?(error)
        return
      }
      if let baseDictionary = document?.data(){
        let dictionary = baseDictionary.castToCodables()
        do {
          let model: T = try dictionary.objectWithError()
          onSuccess(model)
          return
        } catch let error {
          let customError = NSError(domain: "[FireFast] - get(documentId:onSuccess:onError:)", code: 400, userInfo: ["message": "Can not conver document to dictionary", "info": error])
          onError?(customError)
          return
        }
      }
      onSuccess(nil)
    }
  }
  
  public func getAll( onSuccess: @escaping (([T]) -> Void), onError: ((Error) -> Void)?) {
    base.getDocuments() { (querySnapshot, error) in
      if let error = error{
        onError?(error)
        return
      }
      
      let result = querySnapshot!.documents.compactMap { (document) -> T? in
        do {
           return try document.data().castToCodables().objectWithError()
        } catch let error {
          let customError = NSError(domain: "[FireFast] - getAll(onSuccess:onError:)", code: 400, userInfo: ["message": "Can not conver document to dictionary", "info": error])
          onError?(customError)
          return nil
        }
      }
      onSuccess(result)
      return
    }
  }
  
  public func find(query: @escaping (CollectionReference) -> Query, onSuccess: @escaping (([T]) -> Void), onError: ((Error) -> Void)?) {
    query(base).addSnapshotListener { (querySnapshot, error) in
      if let error = error{
        onError?(error)
        return
      }
      let result = querySnapshot!.documents.compactMap { (document) -> T? in
        do {
           return try document.data().castToCodables().objectWithError()
        } catch let error {
          let customError = NSError(domain: "[FireFast] - getAll(onSuccess:onError:)", code: 400, userInfo: ["message": "Can not conver document to dictionary", "info": error])
          onError?(customError)
          return nil
        }
      }
      onSuccess(result)
      return
    }
  }
  
  public func upsert(dictionary: [String: Any], withId id: String? = nil, completionHandler: ((Error?) -> Void)?){
    if let id = id {
      base.document(id).setData(dictionary.castToFirebase()) { (error) in
        completionHandler?(error)
      }
      return
    }
    base.addDocument(data: dictionary.castToFirebase(), completion: completionHandler)
  }
  
  public func upsert(document: T, withId id: String? = nil, completionHandler: ((Error?) -> Void)?){
    
    do {
      let fields = try document.asDictionary()
      upsert(dictionary: fields, withId: id, completionHandler: completionHandler)
      return
    } catch let error {
      let customError = NSError(domain: "[FireFast] - upsert(document:withId:completionHandler:)", code: 400, userInfo: ["message": "Can not conver document to dictionary", "info": error])
      completionHandler?(customError)
    }
  }
  
  public func update(document: T, forDocumentId id: String, completionHandler: ((Error?) -> Void)?){
    do {
      let fields = try document.asDictionary()
      update(fields: fields, forDocumentId: id, completionHandler: completionHandler)
      return
    } catch let error {
      let customError = NSError(domain: "[FireFast] - update(document:forDocumentId:completionHandler:)", code: 400, userInfo: ["message": "Can not conver document to dictionary", "info": error])
      completionHandler?(customError)
    }
  }
  
  public func update(fields: [String: Any], forDocumentId id: String, completionHandler: ((Error?) -> Void)?){
    let doc = base.document(id)
    doc.updateData(fields.castToFirebase()) { (error) in
      completionHandler?(error)
    }
  }
  
  public func delete(fieldNames: [String], fromDocumentWithId id: String, completionHandler: ((Error?) -> Void)?){
    var query =  [String: Any]()
    for element in fieldNames{
      query[element] = FieldValue.delete()
    }
    base.document(id).updateData(query) { err in
      completionHandler?(err)
    }
  }
  
  public func delete(documentId id: String, completionHandler: ((Error?) -> Void)?){
    base.document(id).delete() { err in
      completionHandler?(err)
    }
  }
}
