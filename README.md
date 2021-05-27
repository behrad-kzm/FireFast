# FireFast

[![CI Status](https://img.shields.io/travis/behrad-kzm/FireFast.svg?style=flat)](https://travis-ci.org/behrad-kzm/FireFast)
[![Version](https://img.shields.io/cocoapods/v/FireFast.svg?style=flat)](https://cocoapods.org/pods/FireFast)
[![License](https://img.shields.io/cocoapods/l/FireFast.svg?style=flat)](https://cocoapods.org/pods/FireFast)
[![Platform](https://img.shields.io/cocoapods/p/FireFast.svg?style=flat)](https://cocoapods.org/pods/FireFast)

<img src="https://github.com/behrad-kzm/FireFast/blob/main/FireFastAppIcon.png">

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Authentications

There are couple of functions in `FireFast.UseCaseProvider.makeAuthUseCases()`, you can use to authenticate users with the Firebase:

 ```ruby
    public protocol AuthUseCasesProtocol {
  
        func getPasswordSignInMethods() -> PasswordAuthProtocol
        func getPhoneNumberSignInMethods() -> PhoneAuthProtocol
        func getSignInMethod(forType: SignInMethodType) -> CommonAuthProtocol

        func getUser() -> AuthorizationResponseModel?
        func signOut() throws
}
```
set delegates inside the AppDelegate so everything will be handled by the FireFast:

```ruby
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FireFast.UseCaseProvider.application(application: application, didFinishLaunchingWithOptions: launchOptions)
    return true
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    return FireFast.UseCaseProvider.application(application: app, open: url, options: options)
  }
}

```

There is a complete example in this repo so you can download the project and check it, BUT if your busy or lazy like me, check this:
```ruby
    let authenticator = FireFast.UseCaseProvider.makeAuthUseCases()
    
    //Sign-in with email and  
    authenticator.getPasswordSignInMethods().signInWith(email: email, password: password) { [unowned self](loginInfo) -> (Void) in
      print("success")
    } onError: { [unowned self](error) -> (Void) in
      print("\(error.localizedDescription)")
    }

    authenticator.getSignInMethod(forType: .apple).presentSignIn(on: self) { [unowned self](loginInfo) -> (Void) in
      print("success \(loginInfo.email), \(loginInfo.name)")
    } onError: { [unowned self](error) -> (Void) in
      print("\(error.localizedDescription)")
    }
```
##### Sign-In Configurations

You don't need to write codes for each sign-in methods but you must do some configurations in the project to work fine.
before continue enable each sign-in method from the firebase console then follow these steps:

- For Google sign-in you need to download 'GoogleService-Info.plist' from the Firebase console and create a url scheme in your project configurations [More](https://firebase.google.com/docs/auth/ios/google-signin#2_implement_google_sign-in).
- For Apple sign-in you need to add a capability of Apple sign to your project [More](https://medium.com/@priya_talreja/sign-in-with-apple-using-swift-5cd8695a46b6)
- For Facebook sign-in you need to go to the Developers.Facebook.com and create an app then fill required informations [More](https://developers.facebook.com/docs/facebook-login/ios).
  
### Cloud functions

FireFast support calling Cloud Functions with a super easy use-case inside `FireFast.UseCaseProvider.makeCloudFunctionUseCases()`
You can send a dictionary and receive a generic codable. no more extra code!

```ruby
public protocol FunctionUseCasesProtocol {
  
  func call<T: Codable>(name: String, parameters: [String: Any]?, onSuccess: @escaping (T) -> Void, onError: ((Error) -> Void)?)
}
``` 
 
### Firestore

There is an amazing structure of GenericCollection which accepts a codable inside `FireFast.UseCaseProvider.makeFirestoreUseCases()` and provides complete use-cases for quering firestore, or making an AutoPaginator to paginate a query automatically:

```ruby
public struct GenericCollection<T: Codable> {
     public func paginate() -> AutoPaginator<T>
     public func get(documentId id: String, onSuccess: @escaping ((T?) -> Void), onError: ((Error) -> Void)?)
     public func getAll( onSuccess: @escaping (([T]) -> Void), onError: ((Error) -> Void)?)
     public func find(query: @escaping (CollectionReference) -> Query, onSuccess: @escaping (([T]) -> Void), onError: ((Error) -> Void)?)
     public func upsert(dictionary: [String: Any], withId id: String? = nil, completionHandler: ((Error?) -> Void)?)
     public func upsert(document: T, withId id: String? = nil, completionHandler: ((Error?) -> Void)?)
     public func update(document: T, forDocumentId id: String, completionHandler: ((Error?) -> Void)?)
     public func update(fields: [String: Any], forDocumentId id: String, completionHandler: ((Error?) -> Void)?)
     public func delete(fieldNames: [String], fromDocumentWithId id: String, completionHandler: ((Error?) -> Void)?)
     public func delete(documentId id: String, completionHandler: ((Error?) -> Void)?)
}
```

### Cloud Storage
Working with cloud storage is pretty fun with the FireFast. you can access to the use cases inside `FireFast.UseCaseProvider.makeCloudFunctionUseCases()`.
You can upload, create url of the document or delete it easily:
```ruby
public protocol StorageUseCaseProtocol {
  
     func upload(data: Data, path: String, onSuccess: @escaping (UploadInfoModel) -> Void, onError: ((Error) -> Void)?)
     func makeURL(path: String, onSuccess: @escaping (URL) -> Void, onError: ((Error) -> Void)?)
     func delete(path: String, completion: ((Error?) -> Void)?)
}
```

### Remote Config
There are couple of function and a generic one to get data from remote config. all of the are accessible with `FireFast.UseCaseProvider.makeRemoteConfigUseCases()`.

```ruby 
public protocol RemoteConfigUseCasesProtocol {
  
  func get<T: Codable>(key: String, onSuccess: @escaping (T) -> Void, onError: ((Error) -> Void)?)
  func get(key: String, onSuccess: @escaping (Bool) -> Void, onError: ((Error) -> Void)?)
  func get(key: String, onSuccess: @escaping (String) -> Void, onError: ((Error) -> Void)?)
  func get(key: String, onSuccess: @escaping (NSNumber) -> Void, onError: ((Error) -> Void)?)
  func get(key: String, onSuccess: @escaping (Data) -> Void, onError: ((Error) -> Void)?)
}

```
## Note

If you think this repo need to have new usecase feel free to add an issue or send a pull request.

## Installation

FireFast is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'FireFast'
```

## Author

behrad-kzm, behrad.kzm@gmail.com

## License

FireFast is available under the MIT license. See the LICENSE file for more info.

<img src="https://github.com/behrad-kzm/BEKDesing/blob/master/Images/BEKHeader.png">
