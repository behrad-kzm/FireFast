# FireFast

[![CI Status](https://img.shields.io/travis/behrad-kzm/FireFast.svg?style=flat)](https://travis-ci.org/behrad-kzm/FireFast)
[![Version](https://img.shields.io/cocoapods/v/FireFast.svg?style=flat)](https://cocoapods.org/pods/FireFast)
[![License](https://img.shields.io/cocoapods/l/FireFast.svg?style=flat)](https://cocoapods.org/pods/FireFast)
[![Platform](https://img.shields.io/cocoapods/p/FireFast.svg?style=flat)](https://cocoapods.org/pods/FireFast)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Authentications

There is a complete example in this repo so you can download the project and check it, BUT if your busy or lazy AF check this:

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

## Note

If you think this repo need to have new usecase feel free to add an issue or send a pull request.


### Sign-In Configurations

You don't need to write codes for each sign-in methods but you must do some configurations in the project to work fine.
before continue enable each sign-in method from the firebase console then follow these steps:

- For Google sign-in you need to download 'GoogleService-Info.plist' from the Firebase console and create a url scheme in your project configurations [More](https://firebase.google.com/docs/auth/ios/google-signin#2_implement_google_sign-in).
- For Apple sign-in you need to add a capability of Apple sign to your project [More](https://medium.com/@priya_talreja/sign-in-with-apple-using-swift-5cd8695a46b6)
- For Facebook sign-in you need to go to the Developers.Facebook.com and create an app then fill required informations [More](https://developers.facebook.com/docs/facebook-login/ios).
  

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
