-keepattributes *Annotation*
-dontwarn com.razorpay.**
-keep class com.razorpay.** {*;}
-optimizations !method/inlining/
-keep class com.android.billingclient.** { *; }
-keepclassmembers class * {

    public void onPayment*(...);
}
