import Flutter
import UIKit
import OTPublishersHeadlessSDK
import AppTrackingTransparency

public class SwiftOneTrustPublishersNativeCmpPlugin: NSObject, FlutterPlugin {
    var viewController:UIViewController?
    let OT = OTPublishersHeadlessSDK.shared
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "onetrust_publishers_native_cmp", binaryMessenger: registrar.messenger())
        let instance = SwiftOneTrustPublishersNativeCmpPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        let consentChangeStream = FlutterEventChannel(name: "OTPublishersChangeListener", binaryMessenger: registrar.messenger())
        consentChangeStream.setStreamHandler(OTPublishersChangeListener())
        
        let uiInteractionStream = FlutterEventChannel(name:"OTPublishersUIInteractionListener", binaryMessenger: registrar.messenger())
        uiInteractionStream.setStreamHandler(OTPublishersUIInteractionListener())
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController as? UIViewController {
            viewController = rootViewController
            OTPublishersHeadlessSDK.shared.setupUI(rootViewController, UIType: .none)
            OTPublishersHeadlessSDK.shared.addEventListener(rootViewController)
            
        }
        
        switch call.method{
        case "startSDK":
            startSDK(call: call, result: result)
        case "shouldShowBanner":
            result(OTPublishersHeadlessSDK.shared.shouldShowBanner())
        case "showBannerUI":
            OTPublishersHeadlessSDK.shared.showBannerUI()
        case "showPreferenceCenterUI":
            OTPublishersHeadlessSDK.shared.showPreferenceCenterUI()
        case "showConsentUI":
            guard let arguments = call.arguments else {return}
            if let permissionType = (arguments as? [String:Int])?["permissionType"]{
                showConsentUI(for: permissionType, result: result)
            }
        case "getATTrackingAuthorizationStatus":
            if #available(iOS 14, *){
                result(ATTrackingManager.trackingAuthorizationStatus.rawValue)
            }else{
                result(4) //if ATT not supported, pass back 4, which is platformNotSupported
            }
        case "getConsentStatusForCategory":
            guard let arguments = call.arguments else {return}
            if let args = arguments as? [String:String],
               let categoryId = args["forCategory"]{
                result(OTPublishersHeadlessSDK.shared.getConsentStatus(forCategory: categoryId))
            }
        case "showUCPurposesUI":
            guard let vc = viewController else {
                return
            }
            OTPublishersHeadlessSDK.shared.showConsentPurposesUI(vc)
        case "getUCPurposeConsent":
            guard let arguments = call.arguments else {return}
            if let args = arguments as? [String:String],
               let purposeId = args["forPurpose"]{
                result(OTPublishersHeadlessSDK.shared.getUCPurposeConsent(purposeID: purposeId))
            }
        case "getUCPurposeTopicConsent":
            guard let arguments = call.arguments else {return}
            if let args = arguments as? [String:String],
               let purposeId = args["forPurpose"], let topicId = args["forTopic"]{
                result(OTPublishersHeadlessSDK.shared.getUCPurposeConsent(topicID: topicId, purposeID: purposeId))
            }
        case "getUCPurposeCustomPreferenceOptionConsent":
            guard let arguments = call.arguments else {return}
            if let args = arguments as? [String:String],
               let cpOptionId = args["forCustomPreferenceOption"],
               let cpId = args["forCustomPreference"], let purposeId = args["forPurpose"] {
                result(OTPublishersHeadlessSDK.shared.getUCPurposeConsent(
                    customPreferenceOptionID: cpOptionId,
                    customPreferenceID: cpId,
                    purposeID: purposeId)
                )
            }
        case "updateUCPurposeConsent" :
            if let args = call.arguments as? [String:Any?],
               let purpose = args["forPurpose"] as? String,
               let consentValue = args["consentValue"] as? Bool{
                OT.updateUCPurposeConsent(purposeId: purpose, withConsent: consentValue)
            }
            
        case "updateUCPurposeTopicConsent" :
            if let args = call.arguments as? [String:Any?],
               let topic = args["forTopic"] as? String,
               let purpose = args["forPurpose"] as? String,
               let consentValue = args["consentValue"] as? Bool{
                OT.updateUCPurposeConsent(topicOptionId: topic, purposeId: purpose, withConsent: consentValue)
            }
        case "updateUCPurposeCutomPreferenceOptionConsent" :
            if let args = call.arguments as? [String:Any?],
               let cpOption = args["forCpOption"] as? String,
               let cp = args["forCp"] as? String,
               let purpose = args["forPurpose"] as? String,
               let consentValue = args["consentValue"] as? Bool{
                OT.updateUCPurposeConsent(cpOptionId: cpOption, cpId: cp, purposeId: purpose, withConsent: consentValue)
            }
        case "getAgeGatePromptValue":
            result(OTPublishersHeadlessSDK.shared.getAgeGatePromptValue())
        case "getOTConsentJSForWebView":
            result(OTPublishersHeadlessSDK.shared.getOTConsentJSForWebView())
        case "getCachedIdentifier":
            result(OTPublishersHeadlessSDK.shared.cache.dataSubjectIdentifier)
        case "getCurrentActiveProfile":
            result(OTPublishersHeadlessSDK.shared.currentActiveProfile)
        case "renameProfile":
            guard let arguments = call.arguments else {return}
            if let args = arguments as? [String:String?],
               let toIdentifier = args["toIdentifier"] as? String{
                //This identifier can be nil for renaming an unknown profile, don't include in if/let conditional
                let fromIdentifier = args["fromIdentifier"] as? String
                OT.renameProfile(from: fromIdentifier, to: toIdentifier) { success in
                    print("Rename profile from \(fromIdentifier ?? "<unknown profile>") to \(toIdentifier) = \(success)")
                    result(success ? success : FlutterError.init(code: "Profile Rename Error", message: "Error renaming profile", details: nil))
                }
            }

            
            /* The GET byoui methods return a dict which iOS can send over to Flutter, but on Android, they generate JSON, which can't be sent back to Flutter without conversion. So we send both platforms as JSON strings to avoid any Flutter-side encode/decode logic. 
             */
        case "getBannerData":
            result(String.JSONString(from:OT.getBannerData()))
        case "getDomainInfo":
            result(String.JSONString(from:OT.getDomainInfo()))
        case "getCommonData":
            result(String.JSONString(from:OT.getCommonData()))
        case "getDomainGroupData":
            result(String.JSONString(from:OT.getDomainGroupData()))
        case "getPreferenceCenterData":
            result(String.JSONString(from:OT.getDomainGroupData()))
        case "updatePurposeConsent":
            if let args = call.arguments as? [String:Any?],
               let group = args["group"] as? String,
               let consentValue = args["consentValue"] as? Bool{
                OT.updatePurposeConsent(forGroup: group, consentValue: consentValue)
            }
        case "resetUpdatedConsent":
            OT.resetUpdatedConsent()
        case "saveConsent":
            if let args = call.arguments as? [String:Int],
               let rawInteraction = args["interactionType"],
               let interactionEnum = ConsentInteractionType(rawValue: rawInteraction){
                OT.saveConsent(type: interactionEnum)
            }
        case "setLogLevel":
        if let args = call.arguments as? [String: String],
           let  logLevel =  args["logLevel"],
           let logLevelEnum = getSDKLogLevel(logLevel: logLevel) {
            OT.enableOTSDKLog(logLevelEnum)
           }

        case "getConsentStatusForSDK":
            guard let arguments = call.arguments else {return}
            if let args = arguments as? [String:String],
               let sdkId = args["forSdk"]{
                result(OTPublishersHeadlessSDK.shared.getConsentStatus(forSDKId: sdkId))
            }

        default:
            print("Invalid Method")
        }
    }

    private func startSDK(call:FlutterMethodCall, result: @escaping FlutterResult){
        guard let arguments = call.arguments else {return}
        if let args = arguments as? [String:Any],
           let storageLocation = args["storageLocation"] as? String,
           let domainIdentifier = args["domainIdentifier"] as? String,
           let languageCode = args["languageCode"] as? String{
            var params:OTSdkParams? = nil
            if let otParams = args["otInitParams"] as? [String:String]{
                params = OTSdkParams(countryCode: otParams["countryCode"], regionCode: otParams["regionCode"])
                
                if let versionOverride = otParams["setAPIVersion"]{
                    params?.setSDKVersion(versionOverride)
                }
            }
            
            OTPublishersHeadlessSDK.shared.startSDK(storageLocation: storageLocation,
                                                    domainIdentifier:domainIdentifier,
                                                    languageCode: languageCode,
                                                    params: params){(otResponse) in
                print("Status = \(otResponse.status) and error = \(String(describing: otResponse.error))")
                result(otResponse.status)
            }
        }
    }
    
    private func getSDKLogLevel(logLevel: String) -> OTLoggerConstant? {
        var sdkLogLevel = OTLoggerConstant.info
        switch logLevel.lowercased() {
        case "nologs":
            sdkLogLevel = .noLogs
        case "error":
            sdkLogLevel = .error
        case "warn":
            sdkLogLevel = .warning
        case "verbose":
            sdkLogLevel = .verbose
        case "info":
            sdkLogLevel = .info
        case "debug":
            sdkLogLevel = .debug
        default:
            print("Passed invalid log level")
        }
        
        return sdkLogLevel
    }
    
    private func showConsentUI(for permissionInt:Int, result: @escaping FlutterResult){

        
        var permissionType:AppPermissionType?
        
        //Create a map of permission types so we can easily adopt new permissions in the future
        switch permissionInt{
        case 0:
            permissionType = .idfa
        case 1:
            permissionType = .ageGate
        default:
            permissionType = nil
        }
        //Only proceed if we have a valid permissionType and the viewController is valid.
        
        guard let permissionType = permissionType,
              let vc = viewController else {
                  let error = FlutterError(code: "consentUI_err", message: "Invalid permissionType or ViewController was not able to be located for presentation.", details: "Pass a valid OTPermissionType")
                  result(error)
                  return
              }
        
        
        
        OTPublishersHeadlessSDK.shared.showConsentUI(for: permissionType, from: vc){
            /*after user dismisses the ATT prompt, pass back the rawValue of the type
             this is converted into an enum on the Flutter side */
            var resultValue:Int? = nil
            switch permissionType{
            case .ageGate:
                resultValue = OTPublishersHeadlessSDK.shared.getAgeGatePromptValue()
            case .idfa:
                if #available(iOS 14, *) {
                    resultValue = Int(ATTrackingManager.trackingAuthorizationStatus.rawValue)
                } else {
                    resultValue = 4 //result value for platformNotSupported, if iOS 14 is not available
                }
            default:
                resultValue = -1
            }
            result(resultValue)
        }
    }
}

class OTPublishersChangeListener:NSObject, FlutterStreamHandler{
    var emit:FlutterEventSink?
    var error = FlutterError(code: "OneTrustInvalidArgs", message: "Unable to add/remove event listener; invalid parameter passed.", details: "You must listen for specific categories. Eg, pass C0002 to listen for changes to that category")
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        emit = events
        guard let args = arguments as? [String:[String]] else{
            return error
        }
        if let categories = args["categoryIds"]{
            categories.forEach{(catId) in
                NotificationCenter.default.addObserver(self, selector: #selector(listenForChanges(_:)), name: Notification.Name(catId as String), object: nil)
            }
            
        }
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        guard let args = arguments as? [String:[String]] else {
            return error
        }
        if let category = args["categoryId"]{
            category.forEach{
                NotificationCenter.default.removeObserver(Notification.Name($0 as String))
            }
            
        }
        return nil
    }
    
    @objc func listenForChanges(_ notification:Notification){
        if let consentStatus = notification.object as? Int{
            emit?(["categoryId":notification.name, "consentStatus": consentStatus])
        }
    }
    
}

class OTPublishersUIInteractionListener:NSObject, FlutterStreamHandler{
    
    static var emit:FlutterEventSink?
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        FlutterViewController.emit.event = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        FlutterViewController.emit.event = nil
        return nil
    }
    
}



extension FlutterViewController:OTEventListener{
    public struct emit{
        static var event:FlutterEventSink?
    }
    
    private class eventData{
        let eventName:String
        let payload:[String:Any]?
        
        init(eventName:String, payload:[String:Any]?=nil) {
            self.eventName = eventName
            self.payload = payload
        }
        
        public func format() -> [String:Any]{
            return ["uiEvent":eventName, "payload":payload as Any]
        }
    }
    
    public func onHideBanner() {emit.event?(eventData(eventName: "onHideBanner").format())}
    public func onShowBanner() {emit.event?(eventData(eventName: "onShowBanner").format())}
    public func onBannerClickedRejectAll() {emit.event?(eventData(eventName: "onBannerClickedRejectAll").format())}
    public func onBannerClickedAcceptAll() {emit.event?(eventData(eventName: "onBannerClickedAcceptAll").format())}
    public func onShowPreferenceCenter() {emit.event?(eventData(eventName: "onShowPreferenceCenter").format())}
    public func onHidePreferenceCenter() {emit.event?(eventData(eventName: "onHidePreferenceCenter").format())}
    public func onPreferenceCenterRejectAll() {emit.event?(eventData(eventName: "onPreferenceCenterRejectAll").format())}
    public func onPreferenceCenterAcceptAll() {emit.event?(eventData(eventName: "onPreferenceCenterAcceptAll").format())}
    public func onPreferenceCenterConfirmChoices() {emit.event?(eventData(eventName: "onPreferenceCenterConfirmChoices").format())}
    public func onPreferenceCenterPurposeLegitimateInterestChanged(purposeId: String, legitInterest: Int8) {
        emit.event?(eventData(eventName: "onPreferenceCenterPurposeLegitimateInterestChanged", payload: ["purposeId":purposeId, "legitInterest":legitInterest]).format())
    }
    public func onPreferenceCenterPurposeConsentChanged(purposeId: String, consentStatus: Int8) {
        emit.event?(eventData(eventName: "onPreferenceCenterPurposeConsentChanged", payload: ["purposeId":purposeId, "consentStatus":consentStatus]).format())
    }
    public func onShowVendorList() {emit.event?(eventData(eventName: "onShowVendorList").format())}
    public func onHideVendorList() {emit.event?(eventData(eventName: "onHideVendorList").format())}
    public func onVendorListVendorConsentChanged(vendorId: String, consentStatus: Int8) {
        emit.event?(eventData(eventName: "onVendorListVendorConsentChanged", payload: ["vendorId":vendorId,"consentStatus":consentStatus]).format())
    }
    public func onVendorListVendorLegitimateInterestChanged(vendorId: String, legitInterest: Int8) {
        emit.event?(eventData(eventName: "onVendorListVendorLegitimateInterestChanged", payload: ["vendorId":vendorId,"legitInterest":legitInterest]).format())
    }
    public func onVendorConfirmChoices() {emit.event?(eventData(eventName: "onVendorConfirmChoices").format())}
    public func allSDKViewsDismissed(interactionType: ConsentInteractionType) {
        emit.event?(eventData(eventName: "allSDKViewsDismissed", payload: ["interactionType":interactionType.description as Any]).format() )
    }
    
}

extension String{
    static func JSONString(from dict:[String:Any]?) -> String?{
        if let dict = dict,
           let json = try? JSONSerialization.data(withJSONObject: dict, options: .fragmentsAllowed){
            return String(data: json, encoding: .utf8)
        }else{
            return nil
        }
    }
}
