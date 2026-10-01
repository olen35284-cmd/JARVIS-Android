# JARVIS — Android project

## Сборка на Android-телефоне через AndroidIDE / A-IDE

1. Распакуйте архив.
2. В AndroidIDE выберите **Open project** и откройте корневую папку `JARVIS`.
3. Запустите сборку APK.
4. При первом запуске Gradle Wrapper скачает Gradle 8.13. Для этого нужен интернет.

В проект добавлен bootstrap `gradlew`, который при отсутствии `gradle/wrapper/gradle-wrapper.jar` скачивает официальный Wrapper из репозитория Gradle. Сам Gradle 8.13 берётся с `services.gradle.org` и проверяется по SHA-256.

Минимальная версия Android: 8.0 (API 26).
