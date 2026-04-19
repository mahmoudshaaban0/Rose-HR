# Rose HR - App Store Submission Checklist
## Location Privacy Requirements

---

## ✅ **GOOGLE PLAY STORE REQUIREMENTS**

### 1. Privacy Policy (MANDATORY)
- [ ] Create a publicly accessible privacy policy URL
- [ ] Host it on your website (e.g., https://roseholding.com/privacy-policy)
- [ ] Include ALL location data usage details (see PRIVACY_POLICY_LOCATION.md)
- [ ] Add privacy policy URL to Play Console > App Content > Privacy Policy

### 2. Data Safety Section (MANDATORY)
In Google Play Console, you must complete the Data Safety form:

#### Location Data Declaration:
- [ ] Check "Yes" to "Does your app collect location data?"
- [ ] Select "Precise location" (you use ACCESS_FINE_LOCATION)
- [ ] Select "Approximate location" (you use ACCESS_COARSE_LOCATION)
- [ ] Check "Yes" to "Can this data be used to track users?"

#### Purpose of Collection:
- [ ] Select "App functionality" as the purpose
- [ ] Add description: "To verify employee attendance at work locations"

#### Data Sharing:
- [ ] Specify if data is shared with third parties
- [ ] List your cloud provider if applicable
- [ ] Specify if shared with parent company (Rose Holding)

#### Data Security:
- [ ] Check "Data is encrypted in transit" (you use HTTPS)
- [ ] Check "Data is encrypted at rest" (if your servers encrypt data)
- [ ] Check "Users can request data deletion"

#### Data Retention:
- [ ] Specify retention period (e.g., "Duration of employment + 5 years")

### 3. Sensitive Permissions Declaration
- [ ] Justify ACCESS_BACKGROUND_LOCATION permission
- [ ] Explain why background location is necessary
- [ ] Provide video demonstration of location usage (may be required)

### 4. App Content Rating
- [ ] Complete questionnaire (location tracking may affect rating)
- [ ] Declare that app collects location data

### 5. Target Audience
- [ ] Set minimum age to 18+ (workplace app)
- [ ] Confirm app is not directed at children

---

## 🍎 **APPLE APP STORE REQUIREMENTS**

### 1. Privacy Policy (MANDATORY)
- [ ] Same as Google Play - publicly accessible URL
- [ ] Add URL in App Store Connect > App Privacy > Privacy Policy URL

### 2. App Privacy Details (MANDATORY)
In App Store Connect, you must answer detailed questions:

#### Location Data Collection:
- [ ] Check "Precise Location"
- [ ] Purpose: "App Functionality" → "Customer Support"
- [ ] Check "Location data is linked to user identity"
- [ ] Check "Location data is used for tracking"

#### Other Data:
- [ ] Declare any other data you collect (user ID, name, email, etc.)

### 3. Info.plist Location Descriptions (MANDATORY)
You **MUST** add these keys to your iOS Info.plist:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Rose HR needs your location to verify your attendance when you clock in or out at your work location.</string>

<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Rose HR needs access to your location even when the app is closed to accurately track your attendance during your work shift.</string>

<key>NSLocationAlwaysUsageDescription</key>
<string>Rose HR needs continuous location access to verify you are at your assigned work location throughout your shift.</string>
```

**Action Required**: Add these to `ios/Runner/Info.plist`

### 4. Privacy Manifest (iOS 17+ REQUIRED)
Create `ios/Runner/PrivacyInfo.xcprivacy`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>NSPrivacyTracking</key>
    <false/>
    <key>NSPrivacyCollectedDataTypes</key>
    <array>
        <dict>
            <key>NSPrivacyCollectedDataType</key>
            <string>NSPrivacyCollectedDataTypePreciseLocation</string>
            <key>NSPrivacyCollectedDataTypeLinked</key>
            <true/>
            <key>NSPrivacyCollectedDataTypeTracking</key>
            <true/>
            <key>NSPrivacyCollectedDataTypePurposes</key>
            <array>
                <string>NSPrivacyCollectedDataTypePurposeAppFunctionality</string>
            </array>
        </dict>
    </array>
    <key>NSPrivacyAccessedAPITypes</key>
    <array>
        <dict>
            <key>NSPrivacyAccessedAPIType</key>
            <string>NSPrivacyAccessedAPICategoryLocation</string>
            <key>NSPrivacyAccessedAPITypeReasons</key>
            <array>
                <string>8ffb.1</string>
            </array>
        </dict>
    </array>
</dict>
</plist>
```

### 5. App Review Information
- [ ] Explain location usage in "Notes for Reviewer"
- [ ] Provide demo account credentials
- [ ] Explain that location is for employee attendance (workplace app)

---

## 🔐 **ADDITIONAL RECOMMENDATIONS**

### 1. In-App Privacy Notice
- [ ] Show privacy notice before requesting location permission
- [ ] Explain exactly why location is needed
- [ ] Link to full privacy policy

### 2. User Consent
- [ ] Get explicit consent before accessing location
- [ ] Allow users to review privacy policy before accepting
- [ ] Log consent acceptance with timestamp

### 3. Location Permission Best Practices
- [ ] Request location permission only when needed (at first check-in)
- [ ] Don't request on app launch
- [ ] Explain benefit to user: "Verify your attendance automatically"

### 4. Settings & Controls
- [ ] Provide in-app settings to view what data is collected
- [ ] Allow users to view their location history
- [ ] Provide option to export their data
- [ ] Show when location is being accessed (indicator)

### 5. Minimize Data Collection
- [ ] Only collect location during check-in/check-out (not continuously)
- [ ] Set appropriate location update intervals
- [ ] Stop location updates when not needed
- [ ] Use battery-efficient location settings

---

## 📋 **SUBMISSION CHECKLIST**

### Before Submitting to Play Store:
- [ ] Privacy policy hosted and publicly accessible
- [ ] Data Safety section completed accurately
- [ ] App tested with location permissions on/off
- [ ] Screenshots don't show fake location data
- [ ] Background location usage justified in console

### Before Submitting to App Store:
- [ ] Privacy policy URL added to App Store Connect
- [ ] App Privacy details completed
- [ ] Info.plist has all location usage descriptions
- [ ] PrivacyInfo.xcprivacy file added
- [ ] Tested on iOS device with location permission flows
- [ ] Reviewer notes explain location usage clearly

---

## ⚠️ **COMMON REJECTION REASONS**

### Why Apps Get Rejected:
1. ❌ No privacy policy URL
2. ❌ Privacy policy doesn't mention location data
3. ❌ Missing Info.plist descriptions (iOS)
4. ❌ Data Safety section incomplete or inaccurate
5. ❌ Background location not properly justified
6. ❌ Requesting location permission on app launch without explanation
7. ❌ Privacy policy contradicts app behavior
8. ❌ No way for users to control/delete their data

### How to Avoid Rejection:
✅ Be transparent about ALL data collection
✅ Privacy policy matches app behavior exactly
✅ Justify every permission clearly
✅ Provide user controls for data
✅ Test permission flows thoroughly
✅ Respond quickly to reviewer questions

---

## 📞 **NEED HELP?**

### Resources:
- **Google Play**: https://support.google.com/googleplay/android-developer/answer/10787469
- **Apple App Store**: https://developer.apple.com/app-store/user-privacy-and-data-use/
- **GDPR Compliance**: https://gdpr.eu/

### Legal Review:
⚠️ **IMPORTANT**: Have your privacy policy reviewed by a lawyer before publishing!
- Compliance with local laws (Egypt)
- GDPR compliance (if operating in EU)
- Labor law compliance
- Employee consent requirements

---

## 🎯 **QUICK ACTION ITEMS FOR ROSE HR**

### Immediate Actions:
1. [ ] Review and customize PRIVACY_POLICY_LOCATION.md
2. [ ] Host privacy policy on Rose Holding website
3. [ ] Add iOS location permission descriptions to Info.plist
4. [ ] Create PrivacyInfo.xcprivacy for iOS
5. [ ] Test location permission flows

### Before Submission:
6. [ ] Complete Play Console Data Safety form
7. [ ] Complete App Store Connect Privacy Details
8. [ ] Get legal review of privacy policy
9. [ ] Update employee handbook to mention app tracking
10. [ ] Train HR staff on privacy inquiries

### After Launch:
11. [ ] Monitor for privacy-related user complaints
12. [ ] Update privacy policy if features change
13. [ ] Maintain records of consent
14. [ ] Respond to data deletion requests within required timeframe

---

**Remember**: Privacy compliance is MANDATORY, not optional!
Failure to comply can result in:
- App rejection
- Account suspension
- Legal penalties (GDPR fines up to 4% of revenue)
- Reputational damage

Take privacy seriously! 🔒
