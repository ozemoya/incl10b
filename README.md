# Orbit Guild Signup Demo

Orbit Guild is a Flutter signup-form demo for In-Class Activity 10b. It uses a dark navy and lime visual style instead of the supplied purple starter. The screen validates a name, email address, and password before showing a success SnackBar. It does not create an account or send data to a server.

## Team and scope

- Myles Miller — undergraduate track. The local form, tip feature, and tests in this repository were prepared for his submission.
- Eziz Bagshiyev — named partner. His own contribution and reflection have not been supplied or verified, so this README does not attribute implementation or test work to him.

The undergraduate scope is the core form plus Task A. There is no Task B or C extension.

## Local signup tip

The fixed category is `password_help`. Three short tips are stored directly in `lib/main.dart`. Tapping **Get a signup tip** shows a brief loading state and then the next preset tip. **Test error** simulates a local failure, and **Retry tip** recovers. The label says “Preset demo tip—not live AI.” No network or AI model is used.

The tip method never reads the name, email, or password controllers. Form validators still decide whether the demo signup passes; the tips cannot approve a form. This keeps personal input out of the tip feature.

## Widget tree and test sketch

`OrbitGuildApp → MaterialApp → SignupPage → Scaffold → SingleChildScrollView → Form → TextFormField` describes the main form branch. `SignupPage` is stateful because it owns controllers and the tip loading/result/error status. `OrbitGuildApp` is stateless because it only supplies the theme and home screen. Controllers are disposed when the page is removed.

Run `flutter analyze` and `flutter test` from this folder. The widget tests cover empty fields, malformed email, short password, valid demo submission, tip loading, tip result, local failure, and retry. For a manual check, run the app on an Android emulator, try the invalid and valid inputs, then turn off networking and repeat the tip flow.

## Myles reflection draft

**Question 1 — Trace the local tip feature.** Tapping the tip button changes `tipStatus` to loading, so the card shows a progress indicator. After the local delay, the page chooses one preset string and rebuilds with that text. The Test error action switches to an error message; Retry tip runs the same local method again and returns to a tip.

**Question 3 — Category and privacy.** The category is always `password_help`. The tip selector ignores the name, email, and password fields, so a tip never includes personal form data or changes validation. That also makes the behavior predictable while the device is offline.

## Eziz reflection and contribution

Eziz should add his own two undergraduate reflection answers and describe his actual contribution before treating this as a complete pair submission. No answer or contribution is attributed to him here without his input.
