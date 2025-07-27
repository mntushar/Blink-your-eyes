@echo off
setlocal EnableDelayedExpansion

rem Get console width and height
for /f "tokens=2 delims=:" %%A in ('mode con ^| findstr Columns') do set "cols=%%A"
for /f "tokens=2 delims=:" %%A in ('mode con ^| findstr Lines') do set "lines=%%A"
set cols=%cols: =%
set lines=%lines: =%

rem Text to print
set "text=The program is starting..."

rem Count text length
set len=0
:countloop
if not "!text:~%len%,1!"=="" (
  set /a len+=1
  goto countloop
)

rem Calculate left padding (spaces)
set /a leftPad=(cols - len)/2

rem Calculate top padding (blank lines)
rem We put text roughly in vertical center (lines/2 - 1)
set /a topPad=(lines / 2) - 1

rem Print top blank lines
for /L %%i in (1,1,%topPad%) do echo.

rem Create spaces for left padding
set "spaces="
for /L %%i in (1,1,%leftPad%) do set "spaces=!spaces! "

rem Print centered text
echo !spaces!!text!

rem Optional: print bottom padding (blank lines)
rem Uncomment below if you want balanced padding

rem set /a bottomPad=lines - topPad - 1
rem for /L %%i in (1,1,%bottomPad%) do echo.




@echo off
:loop
start powershell -WindowStyle Normal -Command ^
"[console]::CursorVisible = $false; ^
cls; ^
$text = 'Blink your eyes.'; ^
$width = [console]::WindowWidth; ^
$height = [console]::WindowHeight; ^
$topPadding = [math]::Max(0, [int](($height / 2) - 2)); ^
$leftPadding = ' ' * [math]::Max(0, [int](($width - $text.Length) / 2)); ^
for ($i = 0; $i -lt $topPadding; $i++) { Write-Host '' }; ^
for ($sec = 20; $sec -ge 1; $sec--) { ^
    cls; ^
    for ($i = 0; $i -lt $topPadding; $i++) { Write-Host '' }; ^
    Write-Host $leftPadding$text -ForegroundColor Cyan; ^
    Write-Host ''; ^
    $countText = 'Closing in ' + $sec + ' seconds...'; ^
    $countPadding = ' ' * [math]::Max(0, [int](($width - $countText.Length) / 2)); ^
    Write-Host $countPadding$countText -ForegroundColor Yellow; ^
    Start-Sleep -Seconds 1 ^
}; ^
[console]::CursorVisible = $true"

timeout /t 1200 >nul
goto loop
