import org.gradle.api.file.Directory
import org.gradle.api.tasks.Delete

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Оновлене налаштування build directory
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").getOrElse(rootProject.layout.buildDirectory.get())

// Уникаємо повторного виклику set()
if (rootProject.layout.buildDirectory.get().asFile != newBuildDir.asFile) {
    rootProject.layout.buildDirectory.set(newBuildDir)
}

// Видалено потенційний цикл залежностей у subprojects
subprojects {
    afterEvaluate {
        val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
        if (project.layout.buildDirectory.get().asFile != newSubprojectBuildDir.asFile) {
            project.layout.buildDirectory.set(newSubprojectBuildDir)
        }
    }
}

// Оновлено `clean`, щоб уникнути помилок доступу
tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}
