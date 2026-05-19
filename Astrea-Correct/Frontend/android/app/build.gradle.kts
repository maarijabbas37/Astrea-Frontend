// Import statements must be at the top for Kotlin
import java.util.Properties
import java.io.FileInputStream

// --- This is the Kotlin version of the properties loader ---
// It should only be declared ONCE at the top.
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.grammar_genie_app"
    compileSdk = flutter.compileSdkVersion.toInt() // It's safer to cast this to Int
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8 // Changed to 1_8 for broader compatibility
        targetCompatibility = JavaVersion.VERSION_1_8 // Changed to 1_8 for broader compatibility
    }

    kotlinOptions {
        jvmTarget = "1.8" // Changed to "1.8" for broader compatibility
    }

    // --- This is the correct signing configuration block ---
    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    defaultConfig {
        applicationId = "com.example.grammar_genie_app"
        minSdk = flutter.minSdkVersion.toInt() // It's safer to cast this to Int
        targetSdk = flutter.targetSdkVersion.toInt() // It's safer to cast this to Int
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        getByName("release") {
            // This tells the release build to use the signing configuration we created above.
            // The old line signingConfig = signingConfigs.getByName("debug") has been removed.
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}