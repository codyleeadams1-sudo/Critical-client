#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"
echo "=== Critical Client build ==="

if ! command -v java >/dev/null 2>&1; then
  echo "[ERROR] Java not found. Install JDK 25 (https://adoptium.net)."; exit 1
fi
if ! java -version 2>&1 | grep -Eq "\"25[.\"]"; then
  echo "[ERROR] JDK 25 is required. Current:"; java -version; exit 1
fi

GRADLE_VER=9.5.0
LOCAL=".gradle-local/gradle-$GRADLE_VER"
if [ -x ./gradlew ]; then CMD=./gradlew
elif command -v gradle >/dev/null 2>&1; then CMD=gradle
else
  if [ ! -x "$LOCAL/bin/gradle" ]; then
    echo "Downloading Gradle $GRADLE_VER ..."
    mkdir -p .gradle-local
    curl -fL "https://services.gradle.org/distributions/gradle-$GRADLE_VER-bin.zip" -o .gradle-local/gradle.zip
    unzip -q -o .gradle-local/gradle.zip -d .gradle-local
  fi
  CMD="$LOCAL/bin/gradle"
fi

$CMD build --no-daemon

mkdir -p dist
for f in build/libs/*.jar; do case "$f" in *sources*) ;; *) cp "$f" dist/ ;; esac; done
echo "=== DONE === Your mod jar is in ./dist  (put it in .minecraft/mods)"
