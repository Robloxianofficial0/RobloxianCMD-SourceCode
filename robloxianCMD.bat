@echo off
Title Robloxian CMD (IN BETA)
color 0a
cls

echo Robloxian CMD (Ver 1.2)
echo (c) Robloxian Corporation. All rights reserved.
echo.

:Main
:loop
set /p cmd="Robloxian CMD> "

if /i "%cmd%"=="cls" goto cls_command
if /i "%cmd:~0,5%"=="echo " goto echo_command
if /i "%cmd:~0,3%"=="cd " goto cd_command
if /i "%cmd%"=="cd.." goto cd_dot_dot_command
if /i "%cmd%"=="dir" goto dir_command
if /i "%cmd:~0,6%"=="mkdir " goto mkdir_command
if /i "%cmd:~0,6%"=="rmdir " goto rmdir_command
if /i "%cmd:~0,4%"=="del " goto del_command
if /i "%cmd:~0,4%"=="set " goto set_command
if /i "%cmd%"=="pause" goto pause_command
if /i "%cmd%"=="exit" goto exit_command
if /i "%cmd%"=="help" goto help_command
if /i "%cmd:~0,11%"=="createfile " goto createfile_command
if /i "%cmd:~0,9%"=="editfile " goto editfile_command
if /i "%cmd%"=="checkmodules" goto checkmodules_command
if /i "%cmd:~0,4%"=="run " goto run_command
if /i "%cmd%"=="top" goto top_command
if /i "%cmd:~0,9%"=="robloxian" goto robloxian_command
if /i "%cmd%"=="q" goto exit_command

if /i "%cmd:~0,7%"=="openrbn" goto openrbn_command

echo '%cmd%' is not recognized as a valid command.
pause
goto loop

:cls_command
cls
goto loop

:cd_command
set dir="%cmd:~3%"
if "%dir%"==".." (
    echo "Use 'cd..' to go up one directory."
) else (
    if exist %dir% (
        cd /d %dir%
        echo Changed to directory: %dir%
    ) else (
        echo The directory "%dir%" does not exist.
    )
)
goto loop

:cd_dot_dot_command
cd ..
echo Moved to the parent directory.
goto loop

:run_command
set filename="%cmd:~4%"
if exist %filename% (
    echo Running "%filename%"...
    start "" %filename%
) else (
    echo File "%filename%" not found!
)
goto loop

:checkmodules_command
echo Checking required modules...

where python >nul 2>&1
if errorlevel 1 (
    echo Python is not installed on this system.
    echo Please install Python to use certain features.
) else (
    echo Python is already installed.
)
goto loop

:top_command
cls
echo Top-like Command - Running Processes:
echo.

:: Show the list of processes with memory usage
tasklist /fo table /nh

:: Display CPU usage using WMIC
echo.
echo CPU Usage:
wmic cpu get loadpercentage

:: Display Memory Usage
echo.
echo Memory Usage:
wmic OS get FreePhysicalMemory,TotalVisibleMemorySize /format:list

:: Wait for a key press to refresh
echo.
echo Press any key to refresh or 'back' to quit.
set /p user_input="> "

if /i "%user_input%"=="back"
    goto Main

goto top_command

:dir_command
dir
goto loop

:mkdir_command
set dir_name="%cmd:~6%"
mkdir %dir_name%
goto loop

:rmdir_command
set dir_name="%cmd:~6%"
rmdir %dir_name%
goto loop

:del_command
set file_name="%cmd:~4%"
del %file_name%
goto loop

:createfile_command
set filename="%cmd:~11%"
echo. > %filename%
echo File "%filename%" created successfully.
goto loop

:editfile_command
set filename="%cmd:~9%"
if exist %filename% (
    echo Editing "%filename%"...
    call :edit_in_cmd %filename%
) else (
    echo File "%filename%" not found!
)
goto loop

:edit_in_cmd
:: Open a file for editing within CMD
echo Type the new content for "%~1". End with a single ":" on a new line.
setlocal enabledelayedexpansion
set content=
:edit_loop
set /p line=""
if "!line!"==":" goto write_file
set content=!content!!line!^

goto edit_loop
:write_file
echo !content! > "%~1"
endlocal
goto loop

:robloxian_command
set action=%cmd:~9,7%
set module=%cmd:~17%

if /i "%action%"=="install" goto robloxian_install
if /i "%action%"=="uninsta" goto robloxian_uninstall

echo Invalid action. Use "robloxian install <module>" or "robloxian uninstall <module>".
goto loop

:robloxian_install
echo Installation is not handled by this script. Run 'robloxian_setup.bat' to set up modules.
goto loop

:robloxian_uninstall
echo Uninstallation is not implemented yet.
goto loop

:openrbn_command
set filename="%cmd:~8%"
if not exist %filename% (
    echo File "%filename%" not found.
    goto loop
)

type %filename%

echo.
echo Execution of .rbn file completed.
goto loop

:help_command
echo.
echo Help - Available Commands:
echo   - cls        : Clears the screen
echo   - cd [dir]   : Changes the current directory to a subfolder
echo   - cd..       : Moves up one directory
echo   - dir        : Lists files and directories
echo   - mkdir [dir]: Creates a new directory
echo   - rmdir [dir]: Removes a directory
echo   - del [file] : Deletes a file
echo   - exit       : Exits the shell
echo   - createfile [file]: Create a new file
echo   - editfile [file]  : Edit an existing file
echo   - checkmodules: Check for Python installation
echo   - run [file] : Run an executable or batch file
echo   - robloxian install/uninstall [module]: Install or uninstall a module
echo   - q          : Quit the command prompt
echo   - top        : Show top-like command for processes, CPU, and memory
echo.
goto loop

:exit_command
echo Exiting Custom Command Prompt. Goodbye!
pause
exit
