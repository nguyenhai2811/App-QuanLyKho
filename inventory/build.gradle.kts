plugins {
    alias(libs.plugins.android.library)
}
android {
    namespace = "com.group14.expensemanager.inventory"
    compileSdk = 37
    defaultConfig { minSdk = 24 }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
}
dependencies {
    // Public repository/DAO APIs expose Room and LiveData types.
    api(libs.room.runtime)
    api("androidx.lifecycle:lifecycle-livedata:2.6.2")
    annotationProcessor(libs.room.compiler)
    testImplementation(libs.junit)
}