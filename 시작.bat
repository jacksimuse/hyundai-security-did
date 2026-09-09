@echo off
rem ============================================================
rem  2026 Physical Security Campaign DID - Kiosk Launcher
rem  Runs index.html fullscreen in Chrome (or Edge) kiosk mode.
rem  Press Alt+F4 to quit.
rem ============================================================

setlocal

rem --- build a file:// URL from this folder ---
set "PAGE=%~dp0index.html"
set "PAGE=%PAGE:\=/%"
set "URL=file:///%PAGE%"

rem --- locate a browser ---
set "BROWSER="
if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" set "BROWSER=%ProgramFiles%\Google\Chrome\Application\chrome.exe"
if not defined BROWSER if exist "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" set "BROWSER=%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
if not defined BROWSER if exist "%LocalAppData%\Google\Chrome\Application\chrome.exe" set "BROWSER=%LocalAppData%\Google\Chrome\Application\chrome.exe"
if not defined BROWSER if exist "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" set "BROWSER=%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe"
if not defined BROWSER if exist "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe" set "BROWSER=%ProgramFiles%\Microsoft\Edge\Application\msedge.exe"

if not defined BROWSER (
  echo.
  echo   Chrome or Edge was not found on this PC.
  echo   Please install Google Chrome and run this file again.
  echo.
  pause
  exit /b 1
)

rem --- keep the display awake while the kiosk runs ---
powercfg /change monitor-timeout-ac 0 >nul 2>&1
powercfg /change standby-timeout-ac 0 >nul 2>&1

rem --- fresh profile so no restore prompts or leftover state appear ---
set "PROFILE=%TEMP%\did-kiosk-profile"

start "" "%BROWSER%" ^
 --kiosk ^
 --autoplay-policy=no-user-gesture-required ^
 --allow-file-access-from-files ^
 --user-data-dir="%PROFILE%" ^
 --no-first-run ^
 --no-default-browser-check ^
 --noerrdialogs ^
 --disable-infobars ^
 --disable-session-crashed-bubble ^
 --disable-features=TranslateUI,Translate ^
 --disable-pinch ^
 --overscroll-history-navigation=0 ^
 --check-for-update-interval=31536000 ^
 "%URL%"

endlocal
