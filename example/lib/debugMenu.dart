import 'package:flutter/material.dart';
import 'package:onetrust_publishers_native_cmp/onetrust_publishers_native_cmp.dart';

class EvenMore extends StatelessWidget {
  const EvenMore({Key? key}) : super(key: key);

  void getJSForWebview() async {
    String? js = await OTPublishersNativeSDK.getOTConsentJSForWebView();
    print("JavaScript is $js");
  }

  void getConsentForC2() async {
    int? cat2Status =
        await OTPublishersNativeSDK.getConsentStatusForCategory("C0002");
    print("Status for C0002 = $cat2Status");
  }

  void getConsentForSDK() async {
    int? sdkStatus = await OTPublishersNativeSDK.getConsentStatusForSDK(
        "dae3a2fc-4961-4cfc-9484-63bb9ec51e80");
    print("Status for SDK: dae3a2fc-4961-4cfc-9484-63bb9ec51e80  = $sdkStatus");
  }

  void getConsentForUCP() async {
    int? cat2Status = await OTPublishersNativeSDK.getUCPurposeConsent(
        "338573fc-f6f7-48d6-93b5-332240edec20");
    print(
        "Status for purpose 338573fc-f6f7-48d6-93b5-332240edec20 = $cat2Status");
  }

  void getConsentForUCPTopic() async {
    int? cat2Status = await OTPublishersNativeSDK.getUCPurposeTopicConsent(
        "743cc056-f15b-4128-affd-3c0f84bbbd6f",
        "338573fc-f6f7-48d6-93b5-332240edec20");
    print(
        "Status for topic 743cc056-f15b-4128-affd-3c0f84bbbd6f under purpose 338573fc-f6f7-48d6-93b5-332240edec20  = $cat2Status");
  }

  void getConsentForUCPCustomPrefOption() async {
    int? cat2Status =
        await OTPublishersNativeSDK.getUCPurposeCustomPreferenceOptionConsent(
            "5775aa2e-7a48-40d2-b919-8c4da06204c7",
            "dfbd2ff8-c2f2-433b-8e54-ac0433a39112",
            "338573fc-f6f7-48d6-93b5-332240edec20");
    print(
        "Status for CustomPref Option 5775aa2e-7a48-40d2-b919-8c4da06204c7 under cp dfbd2ff8-c2f2-433b-8e54-ac0433a39112 under purpose 338573fc-f6f7-48d6-93b5-332240edec20  = $cat2Status");
  }

  void updateConsentForUCP(String purpose, bool consent) async {
    OTPublishersNativeSDK.updateUCPurposeConsent(purpose, consent);
    print("Remember to save the consent!");
  }

  void updateConsentForC2(bool consent) async {
    OTPublishersNativeSDK.updatePurposeConsent("C0002", consent);
    print("Remember to save the consent!");
  }

  void saveConsent() async {
    OTPublishersNativeSDK.saveConsent(
        OTInteractionType.preferenceCenterConfirm);
  }

  void saveUCConsent() {
    OTPublishersNativeSDK.saveConsent(
        OTInteractionType.ucPreferenceCenterConfirm);
  }

  void renameProfile() async {
    bool status = await OTPublishersNativeSDK.renameProfile("", "testNew");
    print("renaming Profile status is - $status");
  }

  void setlogLevel() {
    OTPublishersNativeSDK.setLogLevel(OTLogLevel.error);
  }

  void discardStagedConsent() async {
    OTPublishersNativeSDK.resetUpdatedConsent();
  }

  void getBannerData() async {
    Map<String, dynamic>? data = await OTPublishersNativeSDK.getBannerData();
    print(data);
  }

  void getDomainGroupData() async {
    Map<String, dynamic>? data =
        await OTPublishersNativeSDK.getDomainGroupData();
    print(data);
  }

  void getPreferenceCenterData() async {
    Map<String, dynamic>? data =
        await OTPublishersNativeSDK.getPreferenceCenterData();
    print(data);
  }

  void getCommonData() async {
    Map<String, dynamic>? data = await OTPublishersNativeSDK.getCommonData();
    print(data);
  }

  void getDomainInfo() async {
    Map<String, dynamic>? data = await OTPublishersNativeSDK.getDomainInfo();
    print(data);
  }

  void getAgeGateValue() async {
    int? ageGateValue = await OTPublishersNativeSDK.getAgeGatePromptValue();
    print("Age Gate Value is $ageGateValue");
  }

  ElevatedButton buttonBuilder(String text, void Function() func) {
    return ElevatedButton(onPressed: func, child: Text(text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Menu'),
      ),
      body: Center(
          child: ListView(
        padding: EdgeInsets.all(12.0),
        children: <Widget>[
          Text('Most of these functions simply print a value to the console.'),
          buttonBuilder("Get JS For Webview", getJSForWebview),
          buttonBuilder("Query Category C0002", getConsentForC2),
          buttonBuilder("Get Banner Data", getBannerData),
          buttonBuilder("Get Domain Groups", getDomainGroupData),
          buttonBuilder("Get Domain Info", getDomainInfo),
          buttonBuilder("Get Preference Center Data", getPreferenceCenterData),
          buttonBuilder("Get Common Data", getCommonData),
          buttonBuilder("Grant Consent for C0002", () {
            updateConsentForC2(true);
          }),
          buttonBuilder("Revoke Consent for C0002", () {
            updateConsentForC2(false);
          }),
          buttonBuilder("Save Updated Consent", saveConsent),
          buttonBuilder("Discard Staged Consent", discardStagedConsent),
          buttonBuilder("Age Gate Value", getAgeGateValue),
          buttonBuilder("Get Consent for UC Purpose", getConsentForUCP),
          buttonBuilder("Get Consent for UCP Topic", getConsentForUCPTopic),
          buttonBuilder("Get Consent for UCP Custom Preference Option",
              getConsentForUCPCustomPrefOption),
          buttonBuilder("Update UC Purpose Consent", () {
            updateConsentForUCP("338573fc-f6f7-48d6-93b5-332240edec20", true);
            OTPublishersNativeSDK.saveConsent(
                OTInteractionType.ucPreferenceCenterConfirm);
          }),
          buttonBuilder("Save UC Consent", saveUCConsent),
          buttonBuilder("Rename Profile", renameProfile),
          buttonBuilder("Set log level to error", setlogLevel),
          buttonBuilder("Get SDK Consent", getConsentForSDK),
          buttonBuilder("Go Home", () {
            Navigator.pop(context);
          })
        ],
      )),
    );
  }
}
