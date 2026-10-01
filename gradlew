#!/bin/sh
# JARVIS bootstrap Gradle Wrapper for Android/mobile IDEs.
APP_HOME=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd) || exit 1
WRAPPER_JAR="$APP_HOME/gradle/wrapper/gradle-wrapper.jar"
WRAPPER_URL="https://raw.githubusercontent.com/gradle/gradle/v8.13.0/gradle/wrapper/gradle-wrapper.jar"

if [ ! -f "$WRAPPER_JAR" ]; then
  mkdir -p "$(dirname "$WRAPPER_JAR")" || exit 1
  echo "JARVIS: downloading Gradle Wrapper..."
  if command -v curl >/dev/null 2>&1; then
    curl -L --fail --silent --show-error "$WRAPPER_URL" -o "$WRAPPER_JAR" || exit 1
  elif command -v wget >/dev/null 2>&1; then
    wget -O "$WRAPPER_JAR" "$WRAPPER_URL" || exit 1
  else
    echo "ERROR: curl or wget is required to bootstrap Gradle Wrapper." >&2
    exit 1
  fi
fi

exec java -Dorg.gradle.appname=gradlew -classpath "$WRAPPER_JAR" org.gradle.wrapper.GradleWrapperMain "$@"
