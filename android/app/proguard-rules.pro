-keep class com.kakao.sdk.**.model.* { <fields>; }

# https://github.com/square/okhttp/pull/6792
-dontwarn org.bouncycastle.jsse.**
-dontwarn org.conscrypt.*
-dontwarn org.openjsse.**

# refrofit2 (with r8 full mode)
-if interface * { @retrofit2.http.* <methods>; }
-keep,allowobfuscation interface <1>
-keep,allowobfuscation,allowshrinking class kotlin.coroutines.Continuation
-if interface * { @retrofit2.http.* public *** *(...); }
-keep,allowoptimization,allowshrinking,allowobfuscation class <3>
-keep,allowobfuscation,allowshrinking class retrofit2.Response


# naver login SDK 5.1.1
-keep public class com.nhn.android.naverlogin.** {
public protected *;
}
-keep public class com.navercorp.nid.** {
public *;
}

# JSON Serializable (json_serializable, json_annotation)
-keep class com.example.**.model.** { *; }
-keep class your.package.name.** { *; }


# DateTime 직렬화 관련
-keep class java.time.** { *; }
-keep class org.joda.time.** { *; }

# OkHttp가 참조만 하는 선택적 SSL provider 경고 무시
-dontwarn org.conscrypt.**
-dontwarn org.openjsse.**

-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-dontwarn io.flutter.embedding.**

-keep class com.google.firebase.** { *; }