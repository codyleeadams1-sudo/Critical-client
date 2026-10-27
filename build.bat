@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"
echo === Critical Client build ===

where java >nul 2>nul
if errorlevel 1 (
  echo [ERROR] Java not found. Install JDK 25 from https://adoptium.net and reopen this window.
  pause & exit /b 1
)
java -version 2>&1 | findstr /c:"version \"25" >nul
if errorlevel 1 (
  echo [ERROR] JDK 25 is required. Your Java version is:
  java -version
  echo Install JDK 25 from https://adoptium.net and make sure it is first on PATH / JAVA_HOME.
  pause & exit /b 1
)

set GRADLE_VER=9.5.0
set GRADLE_HOME_LOCAL=%CD%\.gradle-local\gradle-%GRADLE_VER%

if exist gradlew.bat (
  set GRADLE_CMD=gradlew.bat
) else (
  where gradle >nul 2>nul
  if not errorlevel 1 (
    set GRADLE_CMD=gradle
  ) else (
    if not exist "%GRADLE_HOME_LOCAL%\bin\gradle.bat" (
      echo Downloading Gradle %GRADLE_VER% ...
      mkdir .gradle-local 2>nul
      powershell -NoProfile -Command "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; Invoke-WebRequest https://services.gradle.org/distributions/gradle-%GRADLE_VER%-bin.zip -OutFile .gradle-local\gradle.zip; Expand-Archive -Force .gradle-local\gradle.zip .gradle-local"
      if errorlevel 1 ( echo [ERROR] Gradle download failed. & pause & exit /b 1 )
    )
    set GRADLE_CMD="%GRADLE_HOME_LOCAL%\bin\gradle.bat"
  )
)

call %GRADLE_CMD% build --no-daemon
if errorlevel 1 ( echo [ERROR] Build failed. Copy the error above and send it to me. & pause & exit /b 1 )

mkdir dist 2>nul
for %%f in (build\libs\*.jar) do (
  echo %%f | findstr /i "sources" >nul
  if errorlevel 1 copy /y "%%f" dist\ >nul
)
echo.
echo === DONE === Your mod jar is in the "dist" folder. Put it in .minecraft\mods
pause
