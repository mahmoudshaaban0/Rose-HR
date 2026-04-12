# Rose HR - Android Upload Keystore Setup

## ✅ Keystore Generated Successfully!

This document contains all the information about your production upload keystore for Google Play Store.

---

## 📁 Files Created

### 1. Upload Keystore
- **Location**: `/Users/mahmoud/Desktop/Rose HR/rose_hr/android/upload-keystore.jks`
- **Type**: PKCS12 (Modern Standard)
- **Algorithm**: RSA
- **Key Size**: 4096 bits (Maximum Security)
- **Validity**: 10,000 days (~27 years, until Aug 28, 2053)

### 2. Key Properties File
- **Location**: `/Users/mahmoud/Desktop/Rose HR/rose_hr/android/key.properties`
- **Status**: ✅ Created and configured
- **Security**: ⚠️ Added to `.gitignore` - NEVER commit this file!

### 3. Credentials Backup
- **Location**: `/Users/mahmoud/Desktop/Rose HR/rose_hr/android/KEYSTORE_CREDENTIALS_BACKUP.txt`
- **Contains**: Full keystore details and passwords
- **Action Required**: Read, backup to secure location, then DELETE

---

## 🔐 Keystore Details

### Distinguished Name
```
Common Name (CN):        Rose Holding HR
Organizational Unit (OU): Mobile Development
Organization (O):        Rose Holding
Locality (L):           Cairo
State (ST):             Cairo
Country (C):            EG
```

### Key Information
- **Alias**: `upload`
- **Store Password**: (See key.properties or backup file)
- **Key Password**: (See key.properties or backup file)

### Certificate Fingerprints
- **SHA1**: `B4:4B:0B:2C:1E:BE:26:F3:C9:F3:E4:D7:89:B5:13:F4:BE:63:B9:D1`
- **SHA256**: `16:56:01:B9:3E:B3:4D:67:7F:B7:64:52:B6:F4:DD:DA:C5:EC:43:43:09:05:1D:37:37:84:44:ED:DD:12:F1:09`

---

## 🔧 Build Configuration

### Updated Files

#### `android/app/build.gradle.kts`
- ✅ Namespace updated to `com.roseholding.hr`
- ✅ Version set to 1.0.0 (versionCode: 1)
- ✅ Target SDK: 35 (Android 14)
- ✅ Min SDK: 21 (Android 5.0)
- ✅ Release signing configured with upload keystore
- ✅ Keystore properties loader added

---

## 📱 Building Release APK/AAB

### Build Release APK
```bash
cd "/Users/mahmoud/Desktop/Rose HR/rose_hr"
flutter build apk --release
```

### Build Release App Bundle (Recommended for Play Store)
```bash
cd "/Users/mahmoud/Desktop/Rose HR/rose_hr"
flutter build appbundle --release
```

### Output Locations
- **APK**: `build/app/outputs/flutter-apk/app-release.apk`
- **AAB**: `build/app/outputs/bundle/release/app-release.aab`

---

## 🛡️ Security Best Practices Implemented

### ✅ What We Did Right

1. **PKCS12 Format**: Modern standard (JKS is deprecated)
2. **4096-bit RSA**: Maximum security key size
3. **Strong Random Passwords**: 24-character alphanumeric passwords
4. **Long Validity**: 10,000 days (you won't need to renew for 27 years)
5. **Clear Naming**: `upload-keystore.jks` distinguishes from other keystores
6. **Git Protection**: Added to `.gitignore` immediately
7. **Automated Generation**: Reproducible script for future keystores
8. **Comprehensive Documentation**: All details documented

### ⚠️ Security Warnings

**CRITICAL: If you lose this keystore, you CANNOT update your app!**

- You'll need to publish as a completely new app
- All existing users will be lost
- You'll need a new package name

---

## 💾 Backup Instructions

### Immediate Actions Required

1. **Read the Backup File**:
   ```bash
   cat "/Users/mahmoud/Desktop/Rose HR/rose_hr/android/KEYSTORE_CREDENTIALS_BACKUP.txt"
   ```

2. **Store in Password Manager**:
   - Use 1Password, LastPass, Bitwarden, or similar
   - Create entry: "Rose HR - Upload Keystore"
   - Include all passwords and file location

3. **Backup the Keystore File**:
   ```bash
   # Copy to multiple secure locations
   cp "/Users/mahmoud/Desktop/Rose HR/rose_hr/android/upload-keystore.jks" ~/Documents/Secure/
   ```

4. **Cloud Backup** (Encrypted):
   - Upload to encrypted cloud storage (iCloud, Google Drive private folder)
   - Consider encrypted USB drive backup

5. **Delete the Backup Text File**:
   ```bash
   rm "/Users/mahmoud/Desktop/Rose HR/rose_hr/android/KEYSTORE_CREDENTIALS_BACKUP.txt"
   ```

---

## 🎯 Play Store Upload Checklist

### Before First Upload

- [x] Keystore generated with strong security
- [x] Build configuration updated
- [x] Version code and name set (1.0.0)
- [x] Package name finalized (com.roseholding.hr)
- [ ] Backup keystore to secure locations
- [ ] Test release build completes successfully
- [ ] Store credentials in password manager
- [ ] Delete plaintext backup file

### For Play Store Console

When uploading to Google Play Console, you'll need:

1. **Signed AAB file** (recommended) or APK
2. **SHA-1 Certificate Fingerprint**: `B4:4B:0B:2C:1E:BE:26:F3:C9:F3:E4:D7:89:B5:13:F4:BE:63:B9:D1`
3. **SHA-256 Certificate Fingerprint**: `16:56:01:B9:3E:B3:4D:67:7F:B7:64:52:B6:F4:DD:DA:C5:EC:43:43:09:05:1D:37:37:84:44:ED:DD:12:F1:09`

---

## 🔍 Verify Keystore

### Check Keystore Information
```bash
keytool -list -v -keystore "/Users/mahmoud/Desktop/Rose HR/rose_hr/android/upload-keystore.jks"
# Enter password from key.properties
```

### Verify Signing in APK
```bash
# After building
keytool -printcert -jarfile build/app/outputs/flutter-apk/app-release.apk
```

---

## 🚀 Next Steps

1. **Backup Everything** (Most Important!)
   - Keystore file
   - Credentials to password manager
   - SHA fingerprints

2. **Test Build**
   - Build release APK: `flutter build apk --release`
   - Verify signing: Check the keystore alias appears in build output

3. **Build for Play Store**
   - Build AAB: `flutter build appbundle --release`
   - File will be at: `build/app/outputs/bundle/release/app-release.aab`

4. **Upload to Play Store**
   - Go to Google Play Console
   - Create new app or version
   - Upload the AAB file
   - Complete store listing

5. **Secure the Credentials**
   - Delete plaintext backup file after securing
   - Keep multiple encrypted backups
   - Share with team leads securely if needed

---

## 📝 Additional Notes

### Multiple Keystores Management

Since you mentioned having multiple keystores, here's how this one is organized:

- **File Name**: `upload-keystore.jks` (clearly indicates purpose)
- **Alias**: `upload` (distinguishes from other keys)
- **Location**: In android/ folder (standard location)
- **Config**: Via `key.properties` (standard Flutter pattern)

### Regenerating for Other Apps

If you need to generate keystores for other apps, you can reuse the script:

```bash
cd "/Users/mahmoud/Desktop/Rose HR/rose_hr/android"
./generate-upload-keystore.sh
```

Modify the script's `KEYSTORE_NAME` and `KEY_ALIAS` variables for different apps.

---

## 📞 Support

### Useful Commands

**List all keystores info**:
```bash
keytool -list -v -keystore <path-to-keystore>
```

**Export certificate for verification**:
```bash
keytool -export -alias upload -keystore upload-keystore.jks -file certificate.der
```

**Check APK signature**:
```bash
keytool -printcert -jarfile app-release.apk
```

---

**Generated**: April 12, 2026  
**Keystore Validity**: Until August 28, 2053  
**Version**: 1.0.0  

---

**⚠️ REMEMBER: BACKUP THE KEYSTORE AND CREDENTIALS IMMEDIATELY!**
