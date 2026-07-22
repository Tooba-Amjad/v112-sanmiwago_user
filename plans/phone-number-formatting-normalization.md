# Phone Number Formatting & Normalization Plan

## Overview
Ensure phone numbers are consistently:
- **Formatted for display** when loaded from DB/API into controllers (e.g., `(123) 456-7890`)
- **Normalized (digits only)** when sent to API/database (e.g., `1234567890`)

## Problem Statement

Currently, the `UsNumberTextInputFormatter` only formats phone numbers as users type. When phone numbers are:
1. **Loaded from database/API** → They appear unformatted in text fields
2. **Sent to API** → Some places send formatted numbers, some send normalized (inconsistent)

## Issues Found

### 1. Missing Formatting Function
- No helper function to format phone numbers for display when setting controller text programmatically
- `UsNumberTextInputFormatter` only works on user input, not when setting `controller.text = value`

### 2. API Calls Not Normalizing (Sending Formatted Instead of Normalized)
All these places send formatted phone numbers to API instead of normalized:

| Location | File | Line | Issue |
|----------|------|------|-------|
| Update Profile | `lib/controllers/api_controller.dart` | 1552 | `'phone': profileController.phoneController.text.trim()` |
| Register | `lib/controllers/api_controller.dart` | 1470 | `'phone': authController.signupPhoneNumController.text.trim()` |
| Checkout Order | `lib/controllers/api_controller.dart` | 909 | `"phone": checkoutController.phoneController.text.trim()` |
| Gift Card Buy (sender) | `lib/controllers/api_controller.dart` | 2042, 2052 | `'sender_phone': giftCardController.buyGiftCardSenderPhoneController.text.trim()` |
| Gift Card Buy (recipient) | `lib/controllers/api_controller.dart` | 2055 | `'recipient_phone': giftCardController.buyGiftCardRecipientPhoneController.text.trim()` |
| Gift Card Recover | `lib/controllers/api_controller.dart` | 2251, 2313, 2377 | `'phone': giftCardController.recoverGiftCardPhoneController.text.trim()` |
| Membership Buy | `lib/controllers/api_controller.dart` | 3647 | `'phone': membershipController.buyMembershipPhoneNumController.text.trim()` |
| Contact Form | `lib/controllers/api_controller.dart` | 3870 | `'phone': phone` (parameter passed from view) |
| Forgot Username | `lib/controllers/auth_controller.dart` | 272 | `'phone_no': forgotUsernamePhoneNumCont.text.trim()` |

**Note:** Signup OTP endpoints (sendOTP, verifyOTP) already normalize correctly ✅

### 3. Controller Initialization Not Formatting (Setting Unformatted from DB)
All these places set unformatted phone numbers from database:

| Location | File | Line | Issue |
|----------|------|------|-------|
| Profile Init | `lib/controllers/profile_controllers/profile_controller.dart` | 32 | `phoneController.text = removeDirectionalFormatting(authController.userData.value.phone)` |
| Checkout Init | `lib/controllers/order_controllers/checkout_controller.dart` | 233 | `phoneController.text = checkoutUserInfo.value.phoneNumber` |
| Contact Us Init | `lib/views/pages/contact/contact_us.dart` | 60 | `phoneCon.text = authController.userData.value.phone` |
| Buy Gift Card Init | `lib/views/pages/giftcard/buy_gift_card_page.dart` | 60 | `giftCardController.buyGiftCardSenderPhoneController.text = authController.userData.value.phone` |

## Solution Approach

### 1. Add Formatting Helper Function
Create `formatUsPhoneNumber()` in `us_phone_number_formatter.dart`:
```dart
String? formatUsPhoneNumber(String input) {
  final digits = input.replaceAll(RegExp(r'\D'), '');
  if (digits.length != 10) return input; // Return as-is if not 10 digits
  return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
}
```

### 2. Normalize All Phone Numbers Before API Calls
Replace all instances of:
```dart
'phone': phoneController.text.trim()
```
With:
```dart
'phone': normalizeUsPhoneNumber(phoneController.text.trim()) ?? ""
```

### 3. Format All Phone Numbers When Initializing Controllers
Replace all instances of:
```dart
phoneController.text = valueFromDB
```
With:
```dart
phoneController.text = formatUsPhoneNumber(valueFromDB) ?? valueFromDB
```

## Implementation Checklist

### Phase 1: Add Helper Function
- [ ] Add `formatUsPhoneNumber()` function to `lib/utils/formatters/us_phone_number_formatter.dart`

### Phase 2: Fix Controller Initializations (Format on Load)
- [ ] Update `ProfileController.profileDataInitialization()` - format phone when setting from DB
- [ ] Update `CheckoutController` initialization (line 233) - format phone when setting from checkoutUserInfo
- [ ] Update `ContactUsPage` init (line 60) - format phone when setting from userData
- [ ] Update `BuyGiftCardPage` init (line 60) - format phone when setting from userData

### Phase 3: Fix API Calls (Normalize Before Send)
- [ ] Update `api_controller.updateProfile()` (line 1552) - normalize phone before sending
- [ ] Update `api_controller.registerEndpoint()` (line 1470) - normalize phone before sending
- [ ] Update checkout order creation (line 909) - normalize phone before sending
- [ ] Update gift card buy API calls (lines 2042, 2052, 2055) - normalize sender/recipient phones
- [ ] Update gift card recover API calls (lines 2251, 2313, 2377) - normalize phone before sending
- [ ] Update membership buy API call (line 3647) - normalize phone before sending
- [ ] Update contact form submission (line 3870) - normalize phone parameter before sending
- [ ] Update `auth_controller.forgotUserNameStep1()` (line 272) - normalize phone before sending

### Phase 4: Testing
- [ ] Test profile update with formatted phone number
- [ ] Test checkout with phone number from DB
- [ ] Test gift card purchase with phone numbers
- [ ] Test contact form submission
- [ ] Test membership purchase
- [ ] Test forgot username flow
- [ ] Verify all API calls receive normalized phone numbers
- [ ] Verify all UI displays formatted phone numbers

## Files to Modify

1. `lib/utils/formatters/us_phone_number_formatter.dart` - Add formatting function
2. `lib/controllers/profile_controllers/profile_controller.dart` - Format on init
3. `lib/controllers/api_controller.dart` - Normalize in all API calls
4. `lib/controllers/order_controllers/checkout_controller.dart` - Format on init
5. `lib/views/pages/contact/contact_us.dart` - Format on init, normalize on submit
6. `lib/views/pages/giftcard/buy_gift_card_page.dart` - Format on init
7. `lib/controllers/auth_controller.dart` - Normalize in forgot_username API call

## Expected Behavior After Implementation

### When Loading from Database:
- Phone number `"1234567890"` from DB → Displayed as `"(123) 456-7890"` in text field
- Phone number `"(123) 456-7890"` from DB → Displayed as `"(123) 456-7890"` in text field (already formatted)

### When Sending to API:
- User enters `"(123) 456-7890"` → Sent as `"1234567890"` (normalized)
- Controller has `"(123) 456-7890"` → Sent as `"1234567890"` (normalized)

### Consistency:
- All phone numbers displayed in UI: **Formatted** `(123) 456-7890`
- All phone numbers sent to API/DB: **Normalized** `1234567890`

## Notes

- The existing `normalizeUsPhoneNumber()` function already works correctly - it strips all non-digits
- The existing `UsNumberTextInputFormatter` works correctly for user input - no changes needed
- The `removeDirectionalFormatting()` function in `profile_controller.dart` only removes Unicode directional characters - we still need to format after that
- Some API calls already normalize correctly (signup OTP endpoints) - these should remain unchanged

