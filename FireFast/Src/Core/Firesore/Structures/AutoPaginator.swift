//
//  AutoPaginator.swift
//  FireFast
//
//  Created by Behrad Kazemi on 2/25/21.
//

import Foundation
import FirebaseFirestore
public class AutoPaginator<T: Codable> {
  
  let base: CollectionReference
  public var customPageQuery: (Query) -> (Query)
  public var firstQuery: Query?
  public var firstSnapshot: DocumentSnapshot?
  public var currentSnapshot: DocumentSnapshot?
  public var maximumRefreshLimit: Int = 1000
  
  public init (base: CollectionReference, query: @escaping (Query) -> (Query) = { previous in return previous }){
    self.base = base
    self.customPageQuery = query
  }
  
  ///Load first documents by  defined queries and reset all parameters of paginator variables (affects on: firstQuery, firstSnapshot, currentSnapshot)
  public func firstRequest(pageSize: Int, orderByFieldName fieldName: String? = nil, descending: Bool = true, onSuccess: @escaping (([T]) -> Void), onError: ((Error) -> Void)?) {

    var query = base.limit(to: pageSize)
    
    if let fieldName = fieldName{
      query = query.order(by: fieldName, descending: descending)
    }
    
    query = customPageQuery(query)
    
    firstQuery = query
    
    query.addSnapshotListener { [weak self](querySnapshot, error) in
      
      if let error = error{
        onError?(error)
        return
      }
      self?.firstSnapshot = querySnapshot?.documents.first
      self?.currentSnapshot = querySnapshot?.documents.last
      let result = querySnapshot!.documents.compactMap { (document) -> T? in
        return document.data().object()
      }
      
      onSuccess(result)
      return
    }
  }
  
  ///load new page of data (affects on:  currentSnapshot)
  public func loadNext(onSuccess: @escaping (([T]) -> Void), onError: ((Error) -> Void)?){
    guard let query = firstQuery else {
      let error = NSError(domain: "You need to call firstRequest() before use loadNext()", code: ErrorCodes.Firestore.needInitialize.code(), userInfo: nil)
      onError?(error)
      return
    }
    guard let previousSnapshot = currentSnapshot else {
      let error = NSError(domain: "Couldn't find previous request document snapshot, try calling firstRequest() function", code: ErrorCodes.Firestore.needInitialize.code(), userInfo: nil)
      onError?(error)
      return
    }
    
    query.start(afterDocument: previousSnapshot).addSnapshotListener { [weak self](querySnapshot, error) in
      
      if let error = error{
        onError?(error)
        return
      }
      self?.currentSnapshot = querySnapshot?.documents.last
      let result = querySnapshot!.documents.compactMap { (document) -> T? in
        return document.data().object()
      }
      
      onSuccess(result)
      return
    }
  }
  
  ///load all new data end to the first document retrieved from firstRequest with defined limit (affects on: firstSnapshot)
  public func refresh(onSuccess: @escaping (([T]) -> Void), onError: ((Error) -> Void)?) {
    
    guard var query = firstQuery else {
      let error = NSError(domain: "You need to call firstRequest() before use loadNext()", code: ErrorCodes.Firestore.needInitialize.code(), userInfo: nil)
      onError?(error)
      return
    }
    
    guard let endSnapshot = firstSnapshot else {
      let error = NSError(domain: "Couldn't find first request document snapshot, try calling firstRequest() function", code: ErrorCodes.Firestore.needInitialize.code(), userInfo: nil)
      onError?(error)
      return
    }
    
    query = query.limit(to: maximumRefreshLimit)
    query.end(beforeDocument: endSnapshot).addSnapshotListener { [weak self](querySnapshot, error) in
      
      if let error = error{
        onError?(error)
        return
      }
      self?.firstSnapshot = querySnapshot?.documents.first
      let result = querySnapshot!.documents.compactMap { (document) -> T? in
        return document.data().object()
      }
      
      onSuccess(result)
      return
    }
  }
}
