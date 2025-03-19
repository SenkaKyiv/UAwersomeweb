import org.gradle.api.file.Directory
import org.gradle.api.tasks.Delete

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.coachnewtool"
    compileSdk = 34  // Остання стабільна версія

    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.coachnewtool"
        minSdk = 23
        targetSdk = 34
        versionCode = 1
        versionName = "1.0.0"
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("androidx.window:window:1.1.0")
    implementation("androidx.window:window-java:1.1.0")
    implementation("org.jetbrains.kotlin:kotlin-stdlib:1.9.0")
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("androidx.core:core-ktx:1.9.0")
}

// Оновлене налаштування build directory
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ✅ **Перевіряємо, чи задача `clean` вже існує, перш ніж її створити**
if (!tasks.names.contains("clean")) {
    tasks.register<Delete>("clean") {
        delete(rootProject.buildDir)
    }
}
