@echo off
rem Put the DockWatch demo back to its original, vulnerable state, so it can be shown again.
rem
rem Double-click this file, or run it from a terminal (from any folder):
rem     dockertestfile\reset-demo.cmd
rem
rem Applying DockWatch fixes changes docker-compose.yml and creates files (app\Dockerfile.hardened,
rem secrets\, .gitignore, .dockwatch\). This copies the original files back from .original\ and
rem deletes only those generated files. No other program is needed.
setlocal
set "DEMO=%~dp0"
set "DEMO=%DEMO:~0,-1%"

if not exist "%DEMO%\.original\docker-compose.yml" (
    echo.
    echo Reset FAILED: the original demo files are missing from "%DEMO%\.original".
    echo Download DockWatch again to get a fresh copy of the demo.
    goto end
)
copy /y "%DEMO%\.original\docker-compose.yml" "%DEMO%\docker-compose.yml" >nul
robocopy "%DEMO%\.original\app" "%DEMO%\app" /mir /njh /njs /ndl /nfl /np >nul
if exist "%DEMO%\secrets\" rmdir /s /q "%DEMO%\secrets" && echo removed secrets
if exist "%DEMO%\.gitignore" del /f /q /a "%DEMO%\.gitignore" && echo removed .gitignore
if exist "%DEMO%\.dockwatch\" rmdir /s /q "%DEMO%\.dockwatch" && echo removed .dockwatch
rem restore the git timeline's working copy as well, when Git and the demo history are present
if exist "%DEMO%\.git\" git -C "%DEMO%" checkout -- . >nul 2>nul
echo Demo reset. Rescan it in DockWatch: it should show 100 / FAIL again.

:end
echo.
rem Keep the window open when double-clicked, so the result can be read.
echo %cmdcmdline% | find /i "/c" >nul && pause
endlocal
