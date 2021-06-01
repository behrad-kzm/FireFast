/*
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import FirebaseFirestore

#if compiler(>=5.1)
  /// A type that can initialize itself from a Firestore Timestamp, which makes
  /// it suitable for use with the `@ServerTimestamp` property wrapper.
  ///
  /// Firestore includes extensions that make `Timestamp` and `Date` conform to
  /// `ServerTimestampWrappable`.
  public protocol ServerTimestampWrappable {
    /// Creates a new instance by converting from the given `Timestamp`.
    ///
    /// - Parameter timestamp: The timestamp from which to convert.
    static func wrap(_ timestamp: Timestamp) throws -> Self

    /// Converts this value into a Firestore `Timestamp`.
    ///
    /// - Returns: A `Timestamp` representation of this value.
    static func unwrap(_ value: Self) throws -> Timestamp
  }

  extension Date: ServerTimestampWrappable {
    public static func wrap(_ timestamp: Timestamp) throws -> Self {
      return timestamp.dateValue()
    }

    public static func unwrap(_ value: Self) throws -> Timestamp {
      return Timestamp(date: value)
    }
  }

  extension Timestamp: ServerTimestampWrappable {
    public static func wrap(_ timestamp: Timestamp) throws -> Self {
      return timestamp as! Self
    }

    public static func unwrap(_ value: Timestamp) throws -> Timestamp {
      return value
    }
  }

  /// A property wrapper that marks an `Optional<Timestamp>` field to be
  /// populated with a server timestamp. If a `Codable` object being written
  /// contains a `nil` for an `@ServerTimestamp`-annotated field, it will be
  /// replaced with `FieldValue.serverTimestamp()` as it is sent.
  ///
  /// Example:
  /// ```
  /// struct CustomModel {
  ///   @ServerTimestamp var ts: Timestamp?
  /// }
  /// ```
  ///
  /// Then writing `CustomModel(ts: nil)` will tell server to fill `ts` with
  /// current timestamp.
  @propertyWrapper
  public struct ServerTimestamp<Value>: Codable
    where Value: ServerTimestampWrappable & Codable {
    var value: Value?

    public init(wrappedValue value: Value?) {
      self.value = value
    }

    public var wrappedValue: Value? {
      get { value }
      set { value = newValue }
    }

    // MARK: Codable

    public init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      if container.decodeNil() {
        value = nil
      } else {
        value = try Value.wrap(try container.decode(Timestamp.self))
      }
    }

    public func encode(to encoder: Encoder) throws {
      var container = encoder.singleValueContainer()
      if let value = value {
        try container.encode(Value.unwrap(value))
      } else {
        try container.encode(FieldValue.serverTimestamp())
      }
    }
  }

  extension ServerTimestamp: Equatable where Value: Equatable {}

  extension ServerTimestamp: Hashable where Value: Hashable {}
#endif // compiler(>=5.1)

/// A compatibility version of `ServerTimestamp` that does not use property
/// wrappers, suitable for use in older versions of Swift.
///
/// Wraps a `Timestamp` field to mark that it should be populated with a server
/// timestamp. If a `Codable` object being written contains a `.pending` for an
/// `FieldValueServerTimestamp` field, it will be replaced with
/// `FieldValue.serverTimestamp()` as it is sent.
///
/// Example:
/// ```
/// struct CustomModel {
///   var ts: FieldValueServerTimestamp
/// }
/// ```
///
/// Then `CustomModel(ts: .fillByServer)` will tell server to fill `ts` with current
/// timestamp.

public enum FieldValueServerTimestamp: Codable, Equatable {
  case fillByServer

  /// When being read (decoded) from Firestore, non-nil Timestamp will be mapped
  /// to `decoded`. When being written (encoded) to Firestore,
  /// `decoded(stamp)` will set the field value to `stamp`.
  case decoded(Timestamp)

  public var timestamp: Timestamp? {
    switch self {
    case .fillByServer:
      return .none
    case let .decoded(timestamp):
      return .some(timestamp)
    }
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if container.decodeNil() {
      self = .fillByServer
    } else {
      let value = try container.decode(Timestamp.self)
      self = .decoded(value)
    }
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case .fillByServer:
      try container.encode(DummyServerTimestamp())
    case let .decoded(value: value):
      try container.encode(value)
    }
  }
}

public struct DummyServerTimestamp: Codable {}
