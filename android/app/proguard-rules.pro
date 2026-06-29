# Flutter Wrapper
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Firebase Crashlytics
-keep class com.google.firebase.crashlytics.** { *; }
-dontwarn com.google.firebase.crashlytics.**

# Google Services / GMS
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Play Store Split Install / Deferred Components
# Flutter engine references these by default for deferred dynamic feature loading,
# but they are missing if the Play Core library is not explicitly included.
-dontwarn com.google.android.play.core.**

# Stripe — keep plugin + SDK classes so R8 doesn't strip them
-keep class com.stripe.android.** { *; }
-keep class com.reactnativestripesdk.** { *; }

# Stripe push provisioning (compileOnly dep — not in runtime APK, suppress warnings)
-dontwarn com.stripe.android.pushProvisioning.**
-dontwarn com.reactnativestripesdk.pushprovisioning.**
