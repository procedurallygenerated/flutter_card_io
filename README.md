# CardIO plugin for flutter

A Flutter plugin for iOS and Android for scanning credit cards using the camera. This uses the [CardIO](https://www.card.io/) library for [iOS](https://github.com/card-io/card.io-iOS-SDK) and [Android](https://github.com/card-io/card.io-Android-SDK)

Note: This plugin is still under development, and some APIs might not be available yet. Feedback and pull requests are welcome!

## Installation

First, add `flutter_card_io` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

### iOS

Add the following key to your _Info.plist_ file, located in `<project root>/ios/Runner/Info.plist`:

* `NSCameraUsageDescription` - Set the value to be a string describing why your app needs to use the camera (e.g. "To scan credit cards."). This string will be displayed when the app initially requests permission to access the camera.

### Android

Add the following permission to your Android Manifest, located in `<project root>/android/app/src/main/AndroidManifest.xml:

```xml
<uses-permission android:name="android.permission.CAMERA"/>
```

Add [card.io's open source license acknowledgments](acknowledgments.md) to
[your app's acknowledgments](http://stackoverflow.com/questions/3966116/where-to-put-open-source-credit-information-for-an-iphone-app).

### Example

``` dart
  Map<String, dynamic> details = await FlutterCardIo.scanCard({
    "requireExpiry": true,
    "scanExpiry": true,
    "requireCVV": true,
    "requirePostalCode": true,
    "restrictPostalCodeToNumericOnly": true,
    "requireCardHolderName": true,
    "scanInstructions": "Hola! Fit the card within the box",
  });
```
### Response

```dart
{
    "cardholderName": "John doe",
    "cardNumber": "1234 5678 9876 1236",
    "redactedCardNumber": "**** **** **** 1236",
    "expiryMonth": 12,
    "expiryYear": 2022,
    "cvv": 123,
    "postalCode": "93748"
}
```
