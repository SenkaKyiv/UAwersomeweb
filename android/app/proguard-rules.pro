# Виправлення R8: збереження класів AndroidX Window
-keep class androidx.window.** { *; }
-keep class androidx.window.extensions.** { *; }
-keep class androidx.window.sidecar.** { *; }

# Виправлення для Flutter та Kotlin
-keep class kotlin.Metadata { *; }
-keep class org.jetbrains.kotlin.** { *; }

# Уникаємо видалення класів, необхідних для Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Дозволяємо відображення повідомлень про помилки R8
-dontwarn androidx.window.**
-dontwarn androidx.window.extensions.**
-dontwarn androidx.window.sidecar.**
