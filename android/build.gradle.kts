allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    val configureSubproject = {
        if (project.plugins.hasPlugin("com.android.library") || project.plugins.hasPlugin("com.android.application")) {
            val android = project.extensions.findByName("android")
            if (android != null) {
                // 1. Force compileSdkVersion to 36
                try {
                    val setCompileSdk = android.javaClass.getMethod("setCompileSdkVersion", Int::class.java)
                    setCompileSdk.invoke(android, 36)
                } catch (e: Exception) {
                    try {
                        val compileSdk = android.javaClass.getMethod("compileSdk", java.lang.Integer::class.java)
                        compileSdk.invoke(android, 36)
                    } catch (e2: Exception) {
                        // Ignore
                    }
                }

                // 2. Set targetSdkVersion to 34
                try {
                    val getDefaultConfig = android.javaClass.getMethod("getDefaultConfig")
                    val defaultConfig = getDefaultConfig.invoke(android)
                    if (defaultConfig != null) {
                        try {
                            val setTargetSdk = defaultConfig.javaClass.getMethod("setTargetSdkVersion", Int::class.java)
                            setTargetSdk.invoke(defaultConfig, 34)
                        } catch (e3: Exception) {
                            val targetSdk = defaultConfig.javaClass.getMethod("targetSdk", java.lang.Integer::class.java)
                            targetSdk.invoke(defaultConfig, 34)
                        }
                    }
                } catch (e: Exception) {
                    // Ignore
                }

                // 3. Set namespace if missing
                try {
                    val getNamespace = android.javaClass.getMethod("getNamespace")
                    val currentNamespace = getNamespace.invoke(android)
                    if (currentNamespace == null) {
                        val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                        val fallback = "com.waslaq.fallback.${project.name.replace(Regex("[^a-zA-Z0-9_]"), "_")}"
                        setNamespace.invoke(android, fallback)
                    }
                } catch (e: Exception) {
                    // Ignore
                }
            }
        }
    }

    if (project.state.executed) {
        configureSubproject()
    } else {
        project.afterEvaluate {
            configureSubproject()
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
