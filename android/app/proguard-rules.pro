# Razorpay Keep Rules
-keep class com.razorpay.** { *; }
-keep interface com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Annotations used by Razorpay
-keep class proguard.annotation.Keep { *; }
-keep class proguard.annotation.KeepClassMembers { *; }

#firebase messaging
-keep class com.google.firebase.messaging.** { *; }
-keep class com.google.firebase.iid.** { *; }
-keepclassmembers class * {
    @com.google.firebase.messaging.FirebaseMessagingService *;
}
