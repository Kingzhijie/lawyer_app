
import com.android.build.api.dsl.ApplicationExtension
import com.android.build.api.dsl.ApkSigningConfig
import java.io.FileInputStream
import java.util.*

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.huawei.agconnect")
}

android {
    namespace = "com.fm.lawyer.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // Needed by flutter_local_notifications AAR metadata
        isCoreLibraryDesugaringEnabled = true
    }

    kotlin {
        compilerOptions {
            jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
        }
    }

    // 读取密钥属性
    val keystoreProperties = Properties()
    val keystorePropertiesFile = rootProject.file("key.properties")
    if (keystorePropertiesFile.exists()) {
        keystoreProperties.load(FileInputStream(keystorePropertiesFile))
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as? String ?: ""
            keyPassword = keystoreProperties["keyPassword"] as? String ?: ""
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as? String ?: ""
        }
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.fm.lawyer.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders += mapOf(
            "GETUI_APPID" to "3lKDEvjnKPAR0FVwW5dy4A",
            "XIAOMI_APP_ID" to "2882303761520359164",
            "XIAOMI_APP_KEY" to "5382035933164",
            "MEIZU_APP_ID" to "155168",
            "MEIZU_APP_KEY" to "495316053b3e4d29b370544a707a9e0a",
            "HUAWEI_APP_ID" to "112824233",
            "OPPO_APP_KEY" to "92723b1624db435fa360427b93bc373e",
            "OPPO_APP_SECRET" to "e5264d842dde41879e506f28ddda20f5",
            "VIVO_APP_ID" to "105814198",
            "VIVO_APP_KEY" to "20fe4f386b60fe1cbb248abf4a12c9ec",
            "HONOR_APP_ID" to "104475516"
        )
        ndk {
            //abiFilters += setOf("arm64-v8a", "armeabi-v7a", "x86_64")
            abiFilters += setOf("arm64-v8a")
        }
    }

    buildTypes {
//        getByName("debug") {
//            isMinifyEnabled = false
//            isShrinkResources = false
//            signingConfig = signingConfigs.getByName<ApkSigningConfig>("release")
////            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
//        }
//
//        getByName("release") {
//            isMinifyEnabled = false
//            isShrinkResources = false
//            signingConfig = signingConfigs.getByName<ApkSigningConfig>("release")
////            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
//        }
    }

    //xiaomi, huawei, vivo, oppo, honor, common, yyb, baidu
    flavorDimensions += listOf("default")
    productFlavors {
        create("huawei") {
            dimension = "default"
            manifestPlaceholders["CHANNEL"] = "huawei"
            // 可以添加渠道专属配置
        }
        create("xiaomi") {
            dimension = "default"
            manifestPlaceholders["CHANNEL"] = "xiaomi"
        }
        create("oppo") {
            dimension = "default"
            manifestPlaceholders["CHANNEL"] = "oppo"
        }
        create("vivo") {
            dimension = "default"
            manifestPlaceholders["CHANNEL"] = "vivo"
        }
        create("honor") {
            dimension = "default"
            manifestPlaceholders["CHANNEL"] = "honor"
        }
        create("meizu") {
            dimension = "default"
            manifestPlaceholders["CHANNEL"] = "meizu"
        }
        create("yyb") {
            dimension = "default"
            manifestPlaceholders["CHANNEL"] = "yyb"
        }
        create("baidu") {
            dimension = "default"
            manifestPlaceholders["CHANNEL"] = "baidu"
        }
        create("common") {
            dimension = "default"
            manifestPlaceholders["CHANNEL"] = "common"
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation(fileTree("libs") { include("*.jar") })

    // Core library desugaring (required by flutter_local_notifications)
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")

    //在官网查阅最新版本(https://docs.getui.com/getui/mobile/android/overview/)
    implementation("com.getui:gtsdk:3.3.13.0") //个推SDK
    implementation("com.getui:gtc:3.3.1.0") //个推核心组件

    // 根据所需厂商选择集成
    implementation("com.getui.opt:hwp:3.1.2") // 华为
    implementation("com.huawei.hms:push:6.12.0.300")

    implementation("com.getui.opt:xmp:3.3.3") // 小米
    implementation("com.assist-v3:vivo:3.2.0") // vivo
    implementation("com.getui.opt:mzp:3.3.0") // 魅族
    implementation("com.getui.opt:honor:3.6.0") // 荣耀
    // 添加荣耀 SDK
    implementation("com.hihonor.mcs:push:7.0.61.303")

    implementation("com.assist-v3:oppo:3.5.0") // oppo
    implementation("com.google.code.gson:gson:2.6.2")
    implementation("commons-codec:commons-codec:1.6")
    implementation("com.android.support:support-annotations:28.0.0")



}