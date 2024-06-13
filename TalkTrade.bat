@echo off
setlocal enabledelayedexpansion

rem Generate a unique user code (for demonstration purposes, using a random number)
set "user_code="
set "characters=ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

for /l %%i in (1, 1, 8) do (
    set /a index=!random! %% 36
    for %%a in (!index!) do set "user_code=!user_code!!characters:~%%a,1!"
)

echo Your unique user code is: %user_code%
echo Save this code for trading and messaging.

pause

:mainLoop
cls
echo Messaging and Code Trading System - User: %user_code%
echo -------------------------------------------------

rem Display messages from shared file
echo Messages:
type messages.txt
echo.

rem Display codes available for trading
echo Your code: %user_code%
echo Enter a code to trade or type 'send' to send a message:
set /p trade_code="Trade code (or 'send' to send message): "

rem Check if user wants to send a message instead
if /i "%trade_code%"=="send" (
    call :sendMessage
    goto mainLoop
)

rem Validate the trade code format (starting with '2' and 8 characters long)
set "valid_format=2"
set "valid_characters=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

if "%trade_code:~0,1%" neq "2" (
    echo Invalid trade code format. Code must start with '2'.
    pause
    goto mainLoop
)

set "is_valid=yes"
for /l %%i in (1, 1, 7) do (
    set "char=!trade_code:~%%i,1!"
    if "!valid_characters!" equ "!valid_characters:!char!=!" (
        set "is_valid=no"
    )
)

if "!is_valid!" equ "no" (
    echo Invalid trade code format. Code must be alphanumeric.
    pause
    goto mainLoop
)

rem Append trade request to trade_requests.txt
echo [%user_code% -> %trade_code%] >> trade_requests.txt
echo Trade request sent: %user_code% -> %trade_code%
pause
goto mainLoop

:sendMessage
echo Enter your message (type 'exit' to quit):
set /p message="> "

if /i "%message%"=="exit" (
    echo Goodbye!
    pause
    exit /b
)

rem Append message to messages.txt
echo [%user_code%] %message% >> messages.txt
echo Message sent: [%user_code%] %message%
pause
exit /b