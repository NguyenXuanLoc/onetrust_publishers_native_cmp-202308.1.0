## 202308.1.0
* Adds support for OneTrust 202308.1.0

## 202307.1.0
* Adds support for OneTrust 202307.1.0

## 202306.2.0
* Adds support for OneTrust 202306.2.0

## 202306.1.0
* Adds support for OneTrust 202306.1.0

## 202305.1.4
* Adds support for OneTrust 202305.1.4

## 202305.1.0
* Adds support for OneTrust 202305.1.0

## 202304.1.0
* Adds support for OneTrust 202304.1.0

## 202303.2.0
* Adds support for OneTrust 202303.2.0

## 202303.1.0
* Adds support for OneTrust 202303.1.0

## 202302.1.0
* Adds support for OneTrust 202302.1.0

## 202301.2.0
* Adds support for OneTrust 202301.2.0

## 202301.1.0
* Adds support for OneTrust 202301.1.0

## 202212.1.0
* Adds support for OneTrust 202212.1.0

## 202211.2.0
* Adds support for OneTrust 202211.2.0
* Exposed `getConsentStatusForSDK` to get the status of given SDK ID.

## 202211.1.0
* Adds support for OneTrust 202211.1.0

## 202210.1.0
* Adds support for OneTrust 202210.1.0
* Exposed renameProfile.
* Exposed `setLogLevel`, we have various log levels - noLogs, error, warn, info, debug, verbose. 

## 202209.2.0
* Adds support for OneTrust 202209.2.0

## 202209.1.0
* Adds support for OneTrust 202209.1.0

## 202208.1.0
* Adds support for OneTrust 202208.1.0

## 6.39.0
* Adds support for OneTrust 6.39.0
* Exposed all the UCP methods.
* Exposed methods to get uc puprpose, topics and custompreference option statuses.
* Exposed Methods to set status of purpose, topic and custompreference option consent.

## 6.38.0
* Adds support for OneTrust 6.38.0

## 6.37.0
* Adds support for OneTrust 6.37.0

## 6.36.0
* Adds support for OneTrust 6.36.0
* Deprecates `getCachedIdentifier` in favor of `getCurrentActiveProfile`

## 6.35.0
* Adds support for OneTrust 6.35.0

## 6.34.1
* Adds Support for OneTrust 6.34.1
* Enables Age Gate prompt
* **Breaking Change** showConsentUI(.idfa) no longer returns the enum for ATTrackingAuthorizationStatus -- use OTATTrackingAuthorizationStatus.values[status] to decode the integer return.
* Exposes many BYOUI methods to Flutter

## 6.33.0
* Added support for OneTrust 6.33.0

## 6.32.0
* Added support for OneTrust 6.32.0
* Adds ability to suppress all transitive dependencies in Android

## 6.31.0
* Added support for OneTrust 6.31.0

## 6.30.0
* Added support for OneTrust 6.30.0
* Updated example app to Gradle 7.2
* **Note:** Dependency updates - Android must now use `targetSdkVersion 31` or higher

## 6.29.0
* Added support for OneTrust 6.29.0

## 6.28.0
* Added support for OneTrust 6.28.0

## 6.27.0
* Added support for OneTrust 6.27.0

## 6.26.0
* Added support for OneTrust 6.26.0

## 6.25.0
* Added support for iOS 6.25.1
* Added support for Android 6.25.0

## 6.24.0
* Added support for OneTrust 6.24.0

## 6.23.0
* Added support for OneTrust 6.23.0

## 6.22.0
* Added support for OneTrust 6.22.0
* Exposed `showConsentUI` method to render App Tracking Transparency pre-prompts on iOS

## 6.21.0
* Added support for OneTrust 6.21.0
* Exposed UXParams methods to pass in custom JSON for Android
* Added ability to override the OneTrust geolocation service with app-supplied location values
* Updated ReadMe to specify requirement for FragmentActivity

## 6.20.0
* Added support for OneTrust 6.20.0
* Exposed `getCachedIdentifier` method
* Published to Pub.dev

## 6.19.0
* Added support for OneTrust 6.19.0

## 6.18.0
* Added support for OneTrust 6.18.0

## 6.16.0
* Added `getOTConsentJSForWebView` function to return JS to inject into a WebView

## 6.15.0
* Replaced `initOTSDKData` with `startSDK` method
* Fixed force casting issue on Android

## 6.14.0
* Updated OTSDK version
* Added allSDKViewsDismissed event for Android

## 6.13.0
* Update versioning code
* Fixed crash when moving toggles on Android
* Updated to 6.13.0 SDK
* Added example of how to call different IDs for Android and iOS

## 6.12.0
Initial release is of version 6.13.0 to match the OneTrust SDK versioning. Exposes methods of the OTPublishersSDK to:
* Generate a UI
* Prompt users for consent
* Query saved consent status
* Subscribe to consent changes

