@echo off
setlocal EnableExtensions
cd /d "%~dp0"

echo ==================================================
echo JARVIS - Python 3.11 library installer for Windows
echo ==================================================
echo.

where py >nul 2>nul
if errorlevel 1 (
  echo ERROR: Python Launcher 'py' was not found.
  echo Install Python 3.11 from https://www.python.org/downloads/
  echo During installation, enable "Python Launcher".
  pause
  exit /b 1
)

py -3.11 --version
if errorlevel 1 (
  echo ERROR: Python 3.11 is not installed.
  echo Install Python 3.11, then run this file again.
  pause
  exit /b 1
)

if not exist ".venv\Scripts\python.exe" (
  echo Creating the project virtual environment...
  py -3.11 -m venv .venv
  if errorlevel 1 goto :failed
) else (
  echo Using existing .venv environment. It will NOT be deleted.
)

echo.
echo Updating pip and build tools...
".venv\Scripts\python.exe" -m pip install --upgrade pip wheel "setuptools<81"
if errorlevel 1 goto :failed

echo.
echo Installing all packages listed in requirements.txt...
".venv\Scripts\python.exe" -m pip install -r requirements.txt
if errorlevel 1 (
  echo.
  echo ERROR: One or more packages failed to install.
  echo Read the error above. Native packages such as dlib, PyAudio,
  echo and PyTorch may require compatible wheels or build tools.
  goto :failed
)

echo.
echo Checking installed dependency compatibility...
".venv\Scripts\python.exe" -m pip check
if errorlevel 1 (
  echo WARNING: pip reported dependency conflicts. Review the messages above.
  goto :failed
)

if not exist ".env" if exist ".env.template" (
  copy ".env.template" ".env" >nul
  echo Created .env from .env.template. Add your API key(s) to .env.
)

echo.
echo SUCCESS: requirements.txt packages installed and dependency check passed.
echo To start JARVIS, try:
echo   .venv\Scripts\python.exe -m src.jarvis_v2
echo.
echo Note: CMake and FFmpeg are separate Windows prerequisites for some
echo native/audio features; API keys and optional AI models are separate too.
pause
exit /b 0

:failed
echo.
echo INSTALLATION DID NOT COMPLETE. Keep this window open and share the
echo full error text so the exact failing package can be fixed.
pause
exit /b 1
