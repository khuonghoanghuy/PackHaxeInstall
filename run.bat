REM This Batch script is made by DeepSeek!
@echo off
REM Batch script to select and install Haxe libraries from .hxml files

REM Set the folder to search for .hxml files
set "target_folder=%~1"
if "%target_folder%"=="" set "target_folder=."

REM Check if the folder exists
if not exist "%target_folder%" (
    echo Folder "%target_folder%" does not exist!
    pause
    exit /b 1
)

echo Searching for .hxml files in "%target_folder%"...

REM Initialize variables
setlocal enabledelayedexpansion
set "count=0"

REM List all .hxml files in the folder
for %%f in ("%target_folder%\*.hxml") do (
    set /a count+=1
    set "file_!count!=%%f"
    echo [!count!] %%~nxf
)

REM Check if any .hxml files were found
if %count%==0 (
    echo No .hxml files found in "%target_folder%".
    pause
    exit /b 1
)

REM Prompt the user to select a file
echo.
set /p "selection=Enter the number of the .hxml file to process (1-%count%): "

REM Validate the user's input
if "%selection%"=="" (
    echo No selection made.
    pause
    exit /b 1
)

if %selection% lss 1 (
    echo Invalid selection: %selection%
    pause
    exit /b 1
)

if %selection% gtr %count% (
    echo Invalid selection: %selection%
    pause
    exit /b 1
)

REM Get the selected file
set "selected_file=!file_%selection%!"

echo You selected: %selected_file%
echo Installing libraries from %selected_file%...

REM Function to install libraries from an .hxml file
call :install_libraries "%selected_file%"

REM Execute the .hxml file
haxe "%selected_file%"

pause
exit /b 0

REM Function to install libraries from an .hxml file
:install_libraries
    setlocal
    set "hxml_file=%~1"

    REM Read each line in the .hxml file
    for /f "usebackq tokens=*" %%l in ("%hxml_file%") do (
        REM Check if the line starts with "-lib"
        echo %%l | findstr /r /c:"^-lib" >nul
        if not errorlevel 1 (
            REM Extract the library name
            for /f "tokens=2" %%a in ("%%l") do (
                echo Installing library: %%a
                haxelib install %%a
            )
        )
    )

    endlocal
    exit /b 0