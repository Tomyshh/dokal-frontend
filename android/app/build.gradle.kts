plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

import java.io.FileInputStream
import java.io.File
import java.util.Properties

android {
    namespace = "com.yapio.dokal"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.yapio.dokal"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    val keystoreProperties = Properties()
    val keystorePropertiesFile = rootProject.file("key.properties")
    if (keystorePropertiesFile.exists()) {
        keystoreProperties.load(FileInputStream(keystorePropertiesFile))

        signingConfigs {
            create("release") {
                keyAlias = (keystoreProperties["keyAlias"] as String?) ?: ""
                keyPassword = (keystoreProperties["keyPassword"] as String?) ?: ""
                storePassword = (keystoreProperties["storePassword"] as String?) ?: ""
                val storeFilePath = (keystoreProperties["storeFile"] as String?)?.trim().orEmpty()
                if (storeFilePath.isNotBlank()) {
                    val configured = File(storeFilePath)
                    val moduleRelative = project.file(storeFilePath) // android/app/...
                    val rootRelative = rootProject.file(storeFilePath) // android/...

                    storeFile =
                        when {
                            configured.isAbsolute -> configured
                            moduleRelative.exists() -> moduleRelative
                            rootRelative.exists() -> rootRelative
                            else -> moduleRelative
                        }
                }
            }
        }
    } else {
        println(
            "Warning: android/key.properties introuvable. " +
                "La signature release utilisera temporairement la config debug (non valide pour le Play Store).",
        )
    }

    buildTypes {
        release {
            signingConfig =
                if (keystorePropertiesFile.exists()) signingConfigs.getByName("release")
                else signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
