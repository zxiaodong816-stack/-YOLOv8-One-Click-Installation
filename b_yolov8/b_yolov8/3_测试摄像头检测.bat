@ECHO OFF
chcp 65001

SETLOCAL

set "pcefile=_utils\pce.txt"
set "pdir="
set "_conda="
set "ename="

:_GETPCE_CHECK
if not exist "%pcefile%" (
    ECHO [91m错误: pce.txt丢失，请确保安装成功后再进行测试[0m
    pause
    exit /b 1
)

:_GETPCE_LOAD
for /f "tokens=*" %%A in (%pcefile%) do (
    if not defined pdir (
        set "pdir=%%A"
    ) else if not defined _conda (
        set "_conda=%%A"
    ) else if not defined ename (
        set "ename=%%A"
    ) else (
        ECHO [91m错误: pce.txt有误，请确保安装成功后再进行测试[0m
        pause
        exit /b 1
    )
)

if not defined pdir (
    ECHO [91m错误: pdir未定义，请确保安装成功后再进行测试[0m
    pause
    exit /b 1
)
if not defined _conda (
    ECHO [91m错误: _conda未定义，请确保安装成功后再进行测试[0m
    pause
    exit /b 1
)
if not defined ename (
    ECHO [91m错误: ename未定义，请确保安装成功后再进行测试[0m
    pause
    exit /b 1
)

:_PCE_DONE
ECHO getpce done
ENDLOCAL & (
    SET "pdir=%pdir%"
    SET "_conda=%_conda%"
    SET "ename=%ename%"
)

pushd "%pdir%"
call "%_conda%" activate %ename%

python mycam.py

if %errorlevel% neq 0 (
    ECHO [91m测试错误：请确保已经成功配置环境，并且电脑带摄像头[0m
    exit /b 1
)

call "%_conda%" deactivate
popd