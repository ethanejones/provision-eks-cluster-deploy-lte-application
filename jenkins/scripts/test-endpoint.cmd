@echo off

:: Allow variables to be expanded at execution time rather than at parse time
setlocal enabledelayedexpansion

:: Get load balancer IP address from terraform output
FOR /f "delims=" %%i IN ('terraform output -raw lb_ip') DO set LB_IP=%%i
echo Load Balancer IP: '%LB_IP%'

:: Setup URL that we will test
set URL=http://%LB_IP%:8080/message
echo URL: '%URL%'

:: Ensure HTTP_STATUS is set so that we are not affected by outside variables
set HTTP_STATUS=NULL

:: Loop 60 times (if needed) and call a subroutine each time so we have proper
:: variable access. Works in conjunction with 'setlocal enabledelayedexpansion'.
:: For more info see https://ss64.com/nt/delayedexpansion.html
FOR /l %%G IN (1,1,60) DO (
    IF NOT '!HTTP_STATUS!' == '200' (
        call :check_status %%G
    )
)

echo EXIT_CODE: %EXIT_CODE%
exit /b %EXIT_CODE%

:: Subroutine that checks the status of our URL using curl
:check_status
echo Checking HTTP status... [Attempt: %1]

:: Use Curl to check the http code of our endpoint
FOR /f "tokens=2 delims=:" %%i IN ('curl -s %URL% -w \nHTTP_CODE:%%{HTTP_CODE} ^|find "HTTP_CODE"') DO (set HTTP_STATUS=%%i)

:: Check HTTP_STATUS
:: If it is 200 (success) we are done
:: Else if we have looped 60 times we can exit
:: Else wait 5 seconds so we can try again
IF %HTTP_STATUS% EQU 200 (
    set EXIT_CODE=0
    echo HTTP status: %HTTP_STATUS%
    exit /b %EXIT_CODE%
) ELSE IF %1 EQU 60 (
    set EXIT_CODE=1
    echo ERROR: Could not get status [200] from URL in alloted time. Last status obtained: %HTTP_STATUS%
    exit /b !EXIT_CODE!
) ELSE (
    timeout /t 5 > NUL
)
