@ECHO OFF
set pname=ultralytics-8.2.103


SETLOCAL

FOR /F "tokens=* delims= " %%a in ('chcp.com') DO (
    FOR %%b in (%%a) DO set _old_cp=%%b
)
chcp.com 65001 >NUL

SET "rdir=%~dp0"
IF "%rdir:~-1%"=="\" SET "rdir=%rdir:~0,-1%"
SET "udir=%rdir%\_utils"
SET "bdir=%udir%\binaries"
SET "logger=%udir%\logger.bat"
SET "logfile=%udir%\logging.txt"
SET "pcfile=%udir%\pc.txt"
SET "tfile=%udir%\selected.txt"
set "_ginit_clean="
set "pcefile=%udir%\pce.txt"

IF NOT EXIST "%udir%\logger.bat" (
	ECHO "FATAL: %udir%\logger.bat lost"
	ECHO [91m错误: %udir%\logger.bat丢失, 请确保解压全部文件[0m
	GOTO :_GCLEAN
)

ECHO.                                                 	>>"%logfile%"
ECHO -------------------------------------------------	>>"%logfile%"

FOR %%i IN ("where.exe") DO SET "WHERE=%%~$PATH:i"
IF NOT EXIST "%WHERE%" (
	CALL "%logger%" "%~nx0" "ERROR: where.exe not found"
	ECHO [91m错误: where.exe丢失, 操作系统暂不支持脚本安装[0m
	GOTO :_GCLEAN
) ELSE (
	CALL "%logger%" "%~nx0" "%WHERE%"
)

FOR %%i IN ("findstr.exe") DO SET "FINDSTR=%%~$PATH:i"
IF NOT EXIST "%FINDSTR%" (
	CALL "%logger%" "%~nx0" "ERROR: findstr.exe not found"
	ECHO [91m错误: findstr.exe丢失, 操作系统暂不支持脚本安装[0m
	GOTO :_GCLEAN
) ELSE (
	CALL "%logger%" "%~nx0" "%FINDSTR%"
)

FOR %%i IN ("choice.exe") DO SET "CHOICE=%%~$PATH:i"
IF NOT EXIST "%CHOICE%" (
	CALL "%logger%" "%~nx0" "ERROR: choice.exe not found"
	ECHO [91m错误: choice.exe丢失, 操作系统暂不支持脚本安装[0m
	GOTO :_GCLEAN
) ELSE (
	CALL "%logger%" "%~nx0" "%CHOICE%"
)

FOR %%i IN ("reg.exe") DO SET "REG=%%~$PATH:i"
IF NOT EXIST "%REG%" (
	CALL "%logger%" "%~nx0" "ERROR: reg.exe not found"
	ECHO [91m错误: reg.exe丢失, 操作系统暂不支持脚本安装[0m
	GOTO :_GCLEAN
) ELSE (
	CALL "%logger%" "%~nx0" "%REG%"
)

FOR %%i IN ("certutil.exe") DO SET "CERTUTIL=%%~$PATH:i"
IF NOT EXIST "%CERTUTIL%" (
	CALL "%logger%" "%~nx0" "ERROR: certutil.exe not found"
	ECHO [91m错误: certutil.exe丢失, 操作系统暂不支持脚本安装[0m
	GOTO :_GCLEAN
) ELSE (
	CALL "%logger%" "%~nx0" "%CERTUTIL%"
)

FOR %%i IN ("cscript.exe") DO SET "CSCRIPT=%%~$PATH:i"
IF NOT EXIST "%CSCRIPT%" (
	CALL "%logger%" "%~nx0" "ERROR: cscript.exe not found"
	ECHO [91m错误: cscript.exe丢失, 操作系统暂不支持脚本安装[0m
	GOTO :_GCLEAN
) ELSE (
	CALL "%logger%" "%~nx0" "%CSCRIPT%"
)

FOR %%i IN ("curl.exe") DO SET "CURL=%%~$PATH:i"
IF NOT EXIST "%CURL%" (
	CALL "%logger%" "%~nx0" "ERROR: curl.exe not found"
	ECHO [91m错误: curl.exe丢失, 操作系统暂不支持脚本安装[0m
	GOTO :_GCLEAN
) ELSE (
	CALL "%logger%" "%~nx0" "%CURL%"
)

FOR %%i IN ("tar.exe") DO SET "TAR=%%~$PATH:i"
IF NOT EXIST "%TAR%" (
	CALL "%logger%" "%~nx0" "ERROR: tar.exe not found"
	ECHO [91m错误: tar.exe丢失, 操作系统暂不支持脚本安装[0m
	GOTO :_GCLEAN
) ELSE (
	CALL "%logger%" "%~nx0" "%TAR%"
)

FOR %%i IN ("timeout.exe") DO SET "TIMEOUT=%%~$PATH:i"
IF NOT EXIST "%TIMEOUT%" (
	CALL "%logger%" "%~nx0" "ERROR: timeout.exe not found"
	ECHO [91m错误: timeout.exe丢失, 操作系统暂不支持脚本安装[0m
	GOTO :_GCLEAN
) ELSE (
	CALL "%logger%" "%~nx0" "%TIMEOUT%"
)

ECHO %userprofile%>"%tmp%\_tmp_userprofile.txt"
chcp.com 936 >NUL
SET /P _userprofile_936=< "%tmp%\_tmp_userprofile.txt"
chcp.com 65001 >NUL
IF "%userprofile%"=="%_userprofile_936%" (
	CALL "%logger%" "%~nx0" "ascii userprofile %userprofile%"
	SET "_ascii_userprofile=true"
) ELSE (
	CALL "%logger%" "%~nx0" "chinese userprofile %userprofile%"
	SET "_ascii_userprofile=false"
)

IF EXIST "%tfile%" (
	CALL "%logger%" "%~nx0" "try old install location"
	GOTO :_GINIT_CHECK_INSTALL_DIR
)
CALL "%logger%" "%~nx0" "choosing install location..."
ECHO [92m请选择%pname%及miniconda的安装路径,请勿包含中文和空格[0m
ECHO [92m如果检测到可用的anaconda或miniconda,将会跳过miniconda的安装[0m

:_GINIT_SELECT_INSTALL_DIR
cscript //nologo "%udir%\directory_selector.vbs"
IF NOT EXIST "%tfile%" (
	CALL "%logger%" "%~nx0" "cancelled installation"
	ECHO [91m安装已取消[0m
	GOTO :_GCLEAN
)

:_GINIT_CHECK_INSTALL_DIR
chcp.com 936 >NUL
SET /P _tdir_936=< "%tfile%"
chcp.com 65001 >NUL
SET /P _tdir_65001=< "%tfile%"
IF "%_old_cp%"=="936" (
	SET "tdir=%_tdir_936%"
) ELSE (
	SET "tdir=%_tdir_65001%"
)

IF "%tdir:~-1%"=="\" (
	SET "tdir=%tdir:~0,-1%"
)

IF NOT "%_tdir_936%"=="%_tdir_65001%" (
	CALL "%logger%" "%~nx0" "%tdir% contains non-ascii"
	ECHO [91m错误: %tdir% 包含中文,请重新选择![0m
	DEL "%tfile%" 2>NUL
	timeout 3 >NUL
	GOTO :_GINIT_SELECT_INSTALL_DIR
)

IF NOT "%tdir: =%"=="%tdir%" (
	CALL "%logger%" "%~nx0" "%tdir% contains spaces"
	ECHO [91m错误: %tdir% 包含空格,请重新选择![0m
	DEL "%tfile%" 2>NUL
	timeout 3 >NUL
	GOTO :_GINIT_SELECT_INSTALL_DIR
)

IF NOT EXIST "%tdir%" (
	CALL "%logger%" "%~nx0" "%tdir% do not exist"
	ECHO [91m错误: %tdir% 不存在,请重新选择![0m
	DEL "%tfile%" 2>NUL
	timeout 3 >NUL
	GOTO :_GINIT_SELECT_INSTALL_DIR
)

SETLOCAL EnableDelayedExpansion
FOR /L %%I IN (1,1,100) DO (
	SET "_tmp_filename=_tmp_!random!"
	IF NOT EXIST "!tdir!\!_tmp_filename!" GOTO :_GINIT_NONEXIST_FILENAME_FOUND
)
CALL "%logger%" "%~nx0" "%tdir% failed to find nonexisting filename"
ECHO [91m错误: %tdir% 无法创建临时文件%[0m
GOTO :_GCLEAN

:_GINIT_NONEXIST_FILENAME_FOUND
CALL "%logger%" "%~nx0" "%tdir%\%_tmp_filename% selected"
copy NUL "%tdir%\%_tmp_filename%" >NUL 2>&1
IF %ERRORLEVEL% NEQ 0 (
	CALL "%logger%" "%~nx0" "%tdir% is not writable"
	ECHO [91m错误: %tdir% 无访问权限,请重新选择![0m
	DEL "%tfile%" 2>NUL
	timeout 3 >NUL
	GOTO :_GINIT_SELECT_INSTALL_DIR
)
del "%tdir%\%_tmp_filename%"
CALL "%logger%" "%~nx0" "%tdir%\%_tmp_filename% deleted"
ENDLOCAL

CALL "%logger%" "%~nx0" "%tdir% works"
ECHO [92m当前选择的安装位置是 %tdir%[0m

IF "%_ascii_userprofile%"=="true" GOTO :_GINIT_DONE
SETLOCAL EnableDelayedExpansion
FOR /L %%I IN (1,1,100) DO (
	SET "_tmp_dirname=_tmp_!random!"
	IF NOT EXIST "!tdir!\!_tmp_dirname!" GOTO :_NONEXIST_DIRNAME_FOUND
)
CALL "%logger%" "%~nx0" "%tdir% failed to find nonexisting dirname"
ECHO [91m错误: %tdir% 无法创建临时文件夹%[0m
GOTO :_GCLEAN

:_NONEXIST_DIRNAME_FOUND
CALL "%logger%" "%~nx0" "%tdir%\%_tmp_dirname% selected"
mkdir "%tdir%\%_tmp_dirname%" >NUL 2>&1
IF %ERRORLEVEL% NEQ 0 (
	CALL "%logger%" "%~nx0" "%tdir%\%_tmp_dirname% failed to mkdir"
	ECHO [91m错误: %tdir% 无法创建临时文件夹%[0m
	GOTO :_GCLEAN
)
IF NOT EXIST "%tdir%\%_tmp_dirname%" (
	CALL "%logger%" "%~nx0" "%tdir%\%_tmp_dirname% not found"
	ECHO [91m错误: %tdir% 无法创建临时文件夹%[0m
	GOTO :_GCLEAN
)
CALL "%logger%" "%~nx0" "%tdir%\%_tmp_dirname% is ready"
ENDLOCAL & SET "_tmp_dirname=%_tmp_dirname%"
SET "tmp=%tdir%\%_tmp_dirname%"
SET "temp=%tmp%"
SET "_ginit_clean=1"

:_GINIT_DONE
CALL "%logger%" "%~nx0" "ginit done"
ENDLOCAL & (
	SET "_old_cp=%_old_cp%"
	SET "rdir=%rdir%"
	SET "udir=%udir%"
	SET "bdir=%bdir%"
	SET "logger=%logger%"
	SET "logfile=%logfile%"
	SET "pcfile=%pcfile%"
	SET "tmp=%tmp%"
	SET "temp=%temp%"
	SET "tdir=%tdir%"
	SET "_ginit_clean=%_ginit_clean%"
	SET "pcefile=%pcefile%"
)


SETLOCAL

SET _miniconda_urls=https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda^
 https://repo.anaconda.com/miniconda
SET "_miniconda_installer=Miniconda3-py311_24.7.1-0-Windows-x86_64.exe"
SET "_miniconda_install_location=%tdir%\Miniconda3"
SET "_miniconda_sha256=305d1c57ece6a6405663a0fb493e2581cd14c30382a5f49fd44110be30ad49c9"
SET "_condarc_sha256=49b984f7689be97d91f49d35265d964eb20dbabef729a893bf243f0945975871"

:_MINICONDA_SEARCH_EXISTING
FOR %%i in ("conda.bat") DO SET "_conda=%%~$PATH:i"
IF EXIST "%_conda%" (
	CALL "%logger%" "%~nx0" "found existing %_conda%"
	ECHO [92m检测到可用%_conda%,将跳过miniconda的安装[0m
	GOTO :_MINICONDA_CHECK_CONDARC
)
SET "_conda="
CALL "%logger%" "%~nx0" "conda not available in path"

CALL "%logger%" "%~nx0" "detecting miniconda3 in registry..."
CALL "%udir%\search_uninstaller" miniconda3
IF %ERRORLEVEL% EQU 0 GOTO :_MINICONDA_CHECK_SEARCH_OUT

CALL "%logger%" "%~nx0" "detecting anaconda3 in registry..."
CALL "%udir%\search_uninstaller" anaconda3
IF %ERRORLEVEL% EQU 0 GOTO :_MINICONDA_CHECK_SEARCH_OUT

GOTO :_MINICONDA_CHECK_INSTALLER

:_MINICONDA_CHECK_SEARCH_OUT
IF NOT EXIST "%tmp%\_search_out.txt" (
	CALL "%logger%" "%~nx0" "ERROR: %tmp%\_search_out.txt not found"
	GOTO :_GCLEAN
)
findstr /I "\<UninstallString\>" "%tmp%\_search_out.txt" ^
  >"%tmp%\_detect_miniconda_tmp.txt" 2>>"%logfile%"
IF %ERRORLEVEL% NEQ 0 (
	CALL "%logger%" "%~nx0" "ERROR: UninstallString not available"
	GOTO :_GCLEAN
)
FOR /F "usebackq tokens=2,*" %%i IN ("%tmp%\_detect_miniconda_tmp.txt") DO (
	SET "MINICONDA_DIR=%%~dpj"
)
IF "%MINICONDA_DIR:~-1%"=="\" (
	SET "MINICONDA_DIR=%MINICONDA_DIR:~0,-1%"
)
CALL "%logger%" "%~nx0" "miniconda_dir %MINICONDA_DIR%"

findstr /I "\<DisplayName\>" "%tmp%\_search_out.txt" ^
  >"%tmp%\_detect_miniconda_tmp.txt" 2>>"%logfile%"
IF %ERRORLEVEL% NEQ 0 (
	CALL "%logger%" "%~nx0" "ERROR: DisplayName not available"
	GOTO :_GCLEAN
)
FOR /F "usebackq tokens=2,*" %%i IN ("%tmp%\_detect_miniconda_tmp.txt") DO (
	SET "MINICONDA_VERSION=%%j"
)
CALL "%logger%" "%~nx0" "conda version %MINICONDA_VERSION%"

IF NOT EXIST "%MINICONDA_DIR%\condabin\conda.bat" (
	CALL "%logger%" "%~nx0" "ERROR: conda.bat not found"
	ECHO [91m提示: 检测到现有anaconda/miniconda存在问题, 将重新安装miniconda[0m
	GOTO :_MINICONDA_CHECK_INSTALLER
)
SET "_conda=%MINICONDA_DIR%\condabin\conda.bat"
CALL "%logger%" "%~nx0" "_conda %_conda%"
ECHO [92m检测到已安装%MINICONDA_VERSION%[0m
GOTO :_MINICONDA_INIT_CONDA

:_MINICONDA_CHECK_INSTALLER
IF NOT EXIST "%bdir%\%_miniconda_installer%" GOTO :_MINICONDA_DOWNLOAD
CALL "%logger%" "%~nx0" "%_miniconda_installer% found"

CALL "%udir%\compare_sha256" "%bdir%\%_miniconda_installer%" "%_miniconda_sha256%"
IF %ERRORLEVEL% NEQ 0 (
	DEL "%bdir%\%_miniconda_installer%" 2>NUL
	CALL "%logger%" "%~nx0" "broken miniconda installer deleted"
	GOTO :_MINICONDA_DOWNLOAD
)
CALL "%logger%" "%~nx0" "skip download"
ECHO [92m检测到已下载的miniconda安装包[0m
GOTO :_MINICONDA_PRE_INSTALL

:_MINICONDA_DOWNLOAD
IF NOT EXIST "%bdir%\" mkdir "%bdir%"
ECHO [92m正在为您下载miniconda安装包至%bdir%\文件夹...[0m
SETLOCAL ENABLEDELAYEDEXPANSION
FOR %%u IN (%_miniconda_urls%) DO (
	CALL "%logger%" "%~nx0" "downloading miniconda from %%u/%_miniconda_installer%..."
	curl -L -o "%bdir%\%_miniconda_installer%" "%%u/%_miniconda_installer%"
	IF !ERRORLEVEL! EQU 0 (
		CALL "%udir%\compare_sha256" "%bdir%\%_miniconda_installer%" "%_miniconda_sha256%"
		IF !ERRORLEVEL! EQU 0 (
			CALL "%logger%" "%~nx0" "done"
			ECHO [92mminiconda安装包下载成功！[0m
			ENDLOCAL & GOTO :_MINICONDA_PRE_INSTALL
		) ELSE (
			DEL "%bdir%\%_miniconda_installer%" 2>NUL
			CALL "%logger%" "%~nx0" "broken miniconda installer deleted"
		)
	) ELSE (
		CALL "%logger%" "%~nx0" "%%u failed with !ERRORLEVEL!"
		DEL "%bdir%\%_miniconda_installer%" 2>NUL
		CALL "%logger%" "%~nx0" "broken miniconda installer deleted"
	)
)

CALL "%logger%" "%~nx0" "ERROR: miniconda download failed!"
ECHO [91m错误: miniconda安装包下载失败,请检查网络是否正常[0m
GOTO :_GCLEAN

:_MINICONDA_PRE_INSTALL
IF NOT EXIST "%userprofile%\.condarc" GOTO :_MINICONDA_INSTALL
CALL "%udir%\compare_sha256" "%userprofile%\.condarc" "%_condarc_sha256%"
IF %ERRORLEVEL% EQU 0 (
	CALL "%logger%" "%~nx0" "valid existing .condarc"
	GOTO :_MINICONDA_INSTALL
)
CALL "%logger%" "%~nx0" "invalid existing .condarc"

COPY /Y "%udir%\.condarc" "%userprofile%\.condarc" >>"%logfile%" 2>&1
IF %ERRORLEVEL% NEQ 0 (
	CALL "%logger%" "%~nx0" "ERROR: .condarc copy failed"
	ECHO [91m错误: .condarc复制失败[0m
	GOTO :_GCLEAN
)
CALL "%logger%" "%~nx0" ".condarc just created"

:_MINICONDA_INSTALL
CALL "%logger%" "%~nx0" "installing miniconda into %_miniconda_install_location%..."
ECHO [92m正在为您安装miniconda至%_miniconda_install_location%...[0m

start "" /wait "%bdir%\%_miniconda_installer%" ^
  /InstallationType=JustMe /RegisterPython=0 /S ^
  /D=%_miniconda_install_location%

IF %ERRORLEVEL% NEQ 0 (
	CALL "%logger%" "%~nx0" "ERROR: install failed with %ERRORLEVEL%"
	ECHO [91m错误: miniconda安装失败[0m
	GOTO :_GCLEAN
)
CALL "%logger%" "%~nx0" "done"
SET "_conda=%_miniconda_install_location%\condabin\conda.bat"
ECHO [92mminiconda安装成功！[0m

:_MINICONDA_INIT_CONDA
CALL "%_conda%" init >>"%logfile%" 2>&1
IF %ERRORLEVEL% NEQ 0 (
	CALL "%logger%" "%~nx0" "ERROR: conda init failed with %ERRORLEVEL%"
	ECHO [91m错误: conda初始化失败[0m
	GOTO :_GCLEAN
)
CALL "%logger%" "%~nx0" "conda just inited"

:_MINICONDA_CHECK_CONDARC
IF NOT EXIST "%userprofile%\.condarc" GOTO :_MINICONDA_COPY_CONDARC
CALL "%udir%\compare_sha256" "%userprofile%\.condarc" "%_condarc_sha256%"
IF %ERRORLEVEL% EQU 0 (
	CALL "%logger%" "%~nx0" "valid existing .condarc"
	ECHO [92m检测到可用%userprofile%\.condarc[0m
	GOTO :_MINICONDA_DONE
)
CALL "%logger%" "%~nx0" "invalid existing .condarc"

:_MINICONDA_COPY_CONDARC
COPY /Y "%udir%\.condarc" "%userprofile%\.condarc" >>"%logfile%" 2>&1
IF %ERRORLEVEL% NEQ 0 (
	CALL "%logger%" "%~nx0" "ERROR: .condarc copy failed"
	ECHO [91m错误: .condarc复制失败[0m
	GOTO :_GCLEAN
)
CALL "%logger%" "%~nx0" ".condarc just created"
ECHO [92m已成功创建%userprofile%\.condarc[0m

:_MINICONDA_DONE
CALL "%logger%" "%~nx0" "conda is ready"
ECHO [92mconda已就绪[0m
ENDLOCAL & (
    SET "_conda=%_conda%"
)


set purl=https://github.com/ultralytics/ultralytics/archive/refs/tags/v8.2.103.zip
set psha256=d1fe2fdbcf7de1d76eeeaa98d2ee34a65984d9d79952002bd08256a813aab754

SETLOCAL

SET _purls=https://ghfast.top/%purl%^
 %purl%
SET "pzip=%pname%.zip"
SET "pdir=%tdir%\%pname%"
SET "common_validators=LICENSE README.md"

:_GITHUBPROJECT_CHECK_EXISTING
IF NOT EXIST "%pdir%" (
    GOTO :_GITHUBPROJECT_CHECK_INSTALLER
)
IF NOT EXIST "%pdir%\" (
    CALL "%logger%" "%~nx0" "ERROR: existing file named %pdir%"
    GOTO :_GCLEAN
)
FOR %%f in (%common_validators%) DO (
    IF EXIST "%pdir%\%%f" (
        CALL "%logger%" "%~nx0" "found %%f in existing %pdir%"
        GOTO :_GITHUBPROJECT_DONE
    )
)

ECHO [91m检测到现有%pdir%并非可用%pname%[0m
ECHO [91m是否需要删除现有%pdir%,请谨慎选择:[0m
choice /M "确认删除请按Y,不删除且退出请按N"
IF %ERRORLEVEL% EQU 2 (
    CALL "%logger%" "%~nx0" "user needs the invalid %pdir%"
    ECHO [92m可以尝试移动或重命名现有%pdir%后再运行安装脚本[0m
    GOTO :_GCLEAN
)
rmdir /s /q "%pdir%" 2>NUL || (
    CALL "%logger%" "%~nx0" "ERROR: rmdir %pdir% failed"
    ECHO [91m错误: %pdir%删除失败[0m
    GOTO :_GCLEAN
)

:_GITHUBPROJECT_CHECK_INSTALLER
IF NOT EXIST "%bdir%\%pzip%" GOTO :_GITHUBPROJECT_DOWNLOAD
CALL "%logger%" "%~nx0" "%pzip% found"

CALL "%udir%\compare_sha256" "%bdir%\%pzip%" "%psha256%"
IF %ERRORLEVEL% NEQ 0 (
	DEL "%bdir%\%pzip%" 2>NUL
	CALL "%logger%" "%~nx0" "broken project zip deleted"
	GOTO :_GITHUBPROJECT_DOWNLOAD
)
CALL "%logger%" "%~nx0" "skip download"
ECHO [92m检测到已下载的%pzip%压缩包[0m
GOTO :_GITHUBPROJECT_UNZIP

:_GITHUBPROJECT_DOWNLOAD
IF NOT EXIST "%bdir%\" mkdir "%bdir%"
ECHO [92m正在为您下载%pzip%至%bdir%\文件夹...[0m
SETLOCAL ENABLEDELAYEDEXPANSION
FOR %%u IN (%_purls%) DO (
	CALL "%logger%" "%~nx0" "downloading %pzip% from %%u..."
	curl -L -o "%bdir%\%pzip%" "%%u"
	IF !ERRORLEVEL! EQU 0 (
		CALL "%udir%\compare_sha256" "%bdir%\%pzip%" "%psha256%"
		IF !ERRORLEVEL! EQU 0 (
			CALL "%logger%" "%~nx0" "done"
			ECHO [92m%pzip%下载成功！[0m
			ENDLOCAL & GOTO :_GITHUBPROJECT_UNZIP
		) ELSE (
			DEL "%bdir%\%pzip%" 2>NUL
			CALL "%logger%" "%~nx0" "broken %pzip% deleted"
		)
	) ELSE (
		CALL "%logger%" "%~nx0" "%%u failed with !ERRORLEVEL!"
		DEL "%bdir%\%pzip%" 2>NUL
		CALL "%logger%" "%~nx0" "broken %pzip% deleted"
	)
)

CALL "%logger%" "%~nx0" "ERROR: %pzip% download failed!"
ECHO [91m错误: %pzip%下载失败,请检查网络是否正常[0m
GOTO :_GCLEAN

:_GITHUBPROJECT_UNZIP
CALL "%logger%" "%~nx0" "unzipping %pzip% into %pdir%"
ECHO [92m正在为您解压%pzip%至%pdir%...[0m

IF "%tdir:~-1%"==":" (
	tar -xf "%bdir%\%pzip%" -C "%tdir%\\" 2>>"%logfile%"
) ELSE (
	tar -xf "%bdir%\%pzip%" -C "%tdir%" 2>>"%logfile%"
)
IF %ERRORLEVEL% NEQ 0 (
	CALL "%logger%" "%~nx0" "ERROR: unzip failed with %ERRORLEVEL%"
	ECHO [91m错误: %pzip%解压失败[0m
	GOTO :_GCLEAN
)
CALL "%logger%" "%~nx0" "done"
ECHO [92m%pzip%解压成功！[0m

:_GITHUBPROJECT_DONE
CALL "%logger%" "%~nx0" "%pname% is ready"
ECHO [92m%pname%已就绪[0m
ENDLOCAL & (
    SET "pdir=%pdir%"
)


set adir=%pdir%

set aname=yolov8n.pt
set aurl=https://github.com/ultralytics/assets/releases/download/v8.2.0/yolov8n.pt
set asha256=f59b3d833e2ff32e194b5bb8e08d211dc7c5bdf144b90d2c8412c47ccfc83b36

SETLOCAL

SET _aurls=https://ghfast.top/%aurl%^
 %aurl%

:_GITHUBASSET_CHECK_EXISTING
IF NOT EXIST "%adir%\%aname%" (
    GOTO :_GITHUBASSET_CHECK_BINS
)
CALL "%udir%\compare_sha256" "%adir%\%aname%" "%asha256%"

IF %ERRORLEVEL% EQU 0 (
	CALL "%logger%" "%~nx0" "found valid %aname%"
    GOTO :_GITHUBASSET_DONE
)

ECHO [91m检测到现有%adir%\%aname%并非原版%aname%[0m
ECHO [91m是否需要删除现有%aname%,请谨慎选择:[0m
choice /M "确认删除请按Y,不删除且退出请按N"
IF %ERRORLEVEL% EQU 2 (
    CALL "%logger%" "%~nx0" "user needs the invalid %aname%"
    ECHO [92m可以尝试移动或重命名现有%aname%后再运行安装脚本[0m
    GOTO :_GCLEAN
)
del "%adir%\%aname%" 2>NUL

:_GITHUBASSET_CHECK_BINS
IF NOT EXIST "%bdir%\%aname%" GOTO :_GITHUBASSET_DOWNLOAD
CALL "%logger%" "%~nx0" "%aname% found"

CALL "%udir%\compare_sha256" "%bdir%\%aname%" "%asha256%"
IF %ERRORLEVEL% NEQ 0 (
	DEL "%bdir%\%aname%" 2>NUL
	CALL "%logger%" "%~nx0" "broken project asset deleted"
	GOTO :_GITHUBASSET_DOWNLOAD
)
CALL "%logger%" "%~nx0" "skip download"
ECHO [92m检测到已下载的%aname%[0m
GOTO :_GITHUBASSET_COPY

:_GITHUBASSET_DOWNLOAD
IF NOT EXIST "%bdir%\" mkdir "%bdir%"
ECHO [92m正在为您下载%aname%至%bdir%\文件夹...[0m
SETLOCAL ENABLEDELAYEDEXPANSION
FOR %%u IN (%_aurls%) DO (
	CALL "%logger%" "%~nx0" "downloading %aname% from %%u..."
	curl -L -o "%bdir%\%aname%" "%%u"
	IF !ERRORLEVEL! EQU 0 (
		CALL "%udir%\compare_sha256" "%bdir%\%aname%" "%asha256%"
		IF !ERRORLEVEL! EQU 0 (
			CALL "%logger%" "%~nx0" "done"
			ECHO [92m%aname%下载成功！[0m
			ENDLOCAL & GOTO :_GITHUBASSET_COPY
		) ELSE (
			DEL "%bdir%\%aname%" 2>NUL
			CALL "%logger%" "%~nx0" "broken %aname% deleted"
		)
	) ELSE (
		CALL "%logger%" "%~nx0" "%%u failed with !ERRORLEVEL!"
		DEL "%bdir%\%aname%" 2>NUL
		CALL "%logger%" "%~nx0" "broken %aname% deleted"
	)
)

CALL "%logger%" "%~nx0" "ERROR: %aname% download failed!"
ECHO [91m错误: %aname%下载失败,请检查网络是否正常[0m
GOTO :_GCLEAN

:_GITHUBASSET_COPY
CALL "%logger%" "%~nx0" "copying %aname% into %adir%"
ECHO [92m正在为您复制%aname%至%adir%...[0m
copy /Y "%bdir%\%aname%" "%adir%" >NUL 2>NUL
IF %ERRORLEVEL% NEQ 0 (
	CALL "%logger%" "%~nx0" "ERROR: failed with %ERRORLEVEL%"
	ECHO [91m错误: %aname%复制失败[0m
	GOTO :_GCLEAN
)
CALL "%logger%" "%~nx0" "done"
ECHO [92m%aname%复制成功！[0m

:_GITHUBASSET_DONE
CALL "%logger%" "%~nx0" "%aname% is ready"
ECHO [92m%aname%已就绪[0m
ENDLOCAL

set aname=yolov8n-seg.pt
set aurl=https://github.com/ultralytics/assets/releases/download/v8.2.0/yolov8n-seg.pt
set asha256=a7cd8f929e1903d78a12a48efecab430209f18dc46cb96c3599a5980c63c423c

SETLOCAL

SET _aurls=https://ghfast.top/%aurl%^
 %aurl%

:_GITHUBASSET_CHECK_EXISTING
IF NOT EXIST "%adir%\%aname%" (
    GOTO :_GITHUBASSET_CHECK_BINS
)
CALL "%udir%\compare_sha256" "%adir%\%aname%" "%asha256%"

IF %ERRORLEVEL% EQU 0 (
	CALL "%logger%" "%~nx0" "found valid %aname%"
    GOTO :_GITHUBASSET_DONE
)

ECHO [91m检测到现有%adir%\%aname%并非原版%aname%[0m
ECHO [91m是否需要删除现有%aname%,请谨慎选择:[0m
choice /M "确认删除请按Y,不删除且退出请按N"
IF %ERRORLEVEL% EQU 2 (
    CALL "%logger%" "%~nx0" "user needs the invalid %aname%"
    ECHO [92m可以尝试移动或重命名现有%aname%后再运行安装脚本[0m
    GOTO :_GCLEAN
)
del "%adir%\%aname%" 2>NUL

:_GITHUBASSET_CHECK_BINS
IF NOT EXIST "%bdir%\%aname%" GOTO :_GITHUBASSET_DOWNLOAD
CALL "%logger%" "%~nx0" "%aname% found"

CALL "%udir%\compare_sha256" "%bdir%\%aname%" "%asha256%"
IF %ERRORLEVEL% NEQ 0 (
	DEL "%bdir%\%aname%" 2>NUL
	CALL "%logger%" "%~nx0" "broken project asset deleted"
	GOTO :_GITHUBASSET_DOWNLOAD
)
CALL "%logger%" "%~nx0" "skip download"
ECHO [92m检测到已下载的%aname%[0m
GOTO :_GITHUBASSET_COPY

:_GITHUBASSET_DOWNLOAD
IF NOT EXIST "%bdir%\" mkdir "%bdir%"
ECHO [92m正在为您下载%aname%至%bdir%\文件夹...[0m
SETLOCAL ENABLEDELAYEDEXPANSION
FOR %%u IN (%_aurls%) DO (
	CALL "%logger%" "%~nx0" "downloading %aname% from %%u..."
	curl -L -o "%bdir%\%aname%" "%%u"
	IF !ERRORLEVEL! EQU 0 (
		CALL "%udir%\compare_sha256" "%bdir%\%aname%" "%asha256%"
		IF !ERRORLEVEL! EQU 0 (
			CALL "%logger%" "%~nx0" "done"
			ECHO [92m%aname%下载成功！[0m
			ENDLOCAL & GOTO :_GITHUBASSET_COPY
		) ELSE (
			DEL "%bdir%\%aname%" 2>NUL
			CALL "%logger%" "%~nx0" "broken %aname% deleted"
		)
	) ELSE (
		CALL "%logger%" "%~nx0" "%%u failed with !ERRORLEVEL!"
		DEL "%bdir%\%aname%" 2>NUL
		CALL "%logger%" "%~nx0" "broken %aname% deleted"
	)
)

CALL "%logger%" "%~nx0" "ERROR: %aname% download failed!"
ECHO [91m错误: %aname%下载失败,请检查网络是否正常[0m
GOTO :_GCLEAN

:_GITHUBASSET_COPY
CALL "%logger%" "%~nx0" "copying %aname% into %adir%"
ECHO [92m正在为您复制%aname%至%adir%...[0m
copy /Y "%bdir%\%aname%" "%adir%" >NUL 2>NUL
IF %ERRORLEVEL% NEQ 0 (
	CALL "%logger%" "%~nx0" "ERROR: failed with %ERRORLEVEL%"
	ECHO [91m错误: %aname%复制失败[0m
	GOTO :_GCLEAN
)
CALL "%logger%" "%~nx0" "done"
ECHO [92m%aname%复制成功！[0m

:_GITHUBASSET_DONE
CALL "%logger%" "%~nx0" "%aname% is ready"
ECHO [92m%aname%已就绪[0m
ENDLOCAL

set aname=yolov8n-pose.pt
set aurl=https://github.com/ultralytics/assets/releases/download/v8.2.0/yolov8n-pose.pt
set asha256=c6fa93dd1ee4a2c18c900a45c1d864a1c6f7aba75d84f91648a30b7fb641d212

SETLOCAL

SET _aurls=https://ghfast.top/%aurl%^
 %aurl%

:_GITHUBASSET_CHECK_EXISTING
IF NOT EXIST "%adir%\%aname%" (
    GOTO :_GITHUBASSET_CHECK_BINS
)
CALL "%udir%\compare_sha256" "%adir%\%aname%" "%asha256%"

IF %ERRORLEVEL% EQU 0 (
	CALL "%logger%" "%~nx0" "found valid %aname%"
    GOTO :_GITHUBASSET_DONE
)

ECHO [91m检测到现有%adir%\%aname%并非原版%aname%[0m
ECHO [91m是否需要删除现有%aname%,请谨慎选择:[0m
choice /M "确认删除请按Y,不删除且退出请按N"
IF %ERRORLEVEL% EQU 2 (
    CALL "%logger%" "%~nx0" "user needs the invalid %aname%"
    ECHO [92m可以尝试移动或重命名现有%aname%后再运行安装脚本[0m
    GOTO :_GCLEAN
)
del "%adir%\%aname%" 2>NUL

:_GITHUBASSET_CHECK_BINS
IF NOT EXIST "%bdir%\%aname%" GOTO :_GITHUBASSET_DOWNLOAD
CALL "%logger%" "%~nx0" "%aname% found"

CALL "%udir%\compare_sha256" "%bdir%\%aname%" "%asha256%"
IF %ERRORLEVEL% NEQ 0 (
	DEL "%bdir%\%aname%" 2>NUL
	CALL "%logger%" "%~nx0" "broken project asset deleted"
	GOTO :_GITHUBASSET_DOWNLOAD
)
CALL "%logger%" "%~nx0" "skip download"
ECHO [92m检测到已下载的%aname%[0m
GOTO :_GITHUBASSET_COPY

:_GITHUBASSET_DOWNLOAD
IF NOT EXIST "%bdir%\" mkdir "%bdir%"
ECHO [92m正在为您下载%aname%至%bdir%\文件夹...[0m
SETLOCAL ENABLEDELAYEDEXPANSION
FOR %%u IN (%_aurls%) DO (
	CALL "%logger%" "%~nx0" "downloading %aname% from %%u..."
	curl -L -o "%bdir%\%aname%" "%%u"
	IF !ERRORLEVEL! EQU 0 (
		CALL "%udir%\compare_sha256" "%bdir%\%aname%" "%asha256%"
		IF !ERRORLEVEL! EQU 0 (
			CALL "%logger%" "%~nx0" "done"
			ECHO [92m%aname%下载成功！[0m
			ENDLOCAL & GOTO :_GITHUBASSET_COPY
		) ELSE (
			DEL "%bdir%\%aname%" 2>NUL
			CALL "%logger%" "%~nx0" "broken %aname% deleted"
		)
	) ELSE (
		CALL "%logger%" "%~nx0" "%%u failed with !ERRORLEVEL!"
		DEL "%bdir%\%aname%" 2>NUL
		CALL "%logger%" "%~nx0" "broken %aname% deleted"
	)
)

CALL "%logger%" "%~nx0" "ERROR: %aname% download failed!"
ECHO [91m错误: %aname%下载失败,请检查网络是否正常[0m
GOTO :_GCLEAN

:_GITHUBASSET_COPY
CALL "%logger%" "%~nx0" "copying %aname% into %adir%"
ECHO [92m正在为您复制%aname%至%adir%...[0m
copy /Y "%bdir%\%aname%" "%adir%" >NUL 2>NUL
IF %ERRORLEVEL% NEQ 0 (
	CALL "%logger%" "%~nx0" "ERROR: failed with %ERRORLEVEL%"
	ECHO [91m错误: %aname%复制失败[0m
	GOTO :_GCLEAN
)
CALL "%logger%" "%~nx0" "done"
ECHO [92m%aname%复制成功！[0m

:_GITHUBASSET_DONE
CALL "%logger%" "%~nx0" "%aname% is ready"
ECHO [92m%aname%已就绪[0m
ENDLOCAL

set aname=yolov8n-cls.pt
set aurl=https://github.com/ultralytics/assets/releases/download/v8.2.0/yolov8n-cls.pt
set asha256=11fa19f2aea79bc960d680a13f82f22105982b325eb9e17a4a5e1a9f8245980a

SETLOCAL

SET _aurls=https://ghfast.top/%aurl%^
 %aurl%

:_GITHUBASSET_CHECK_EXISTING
IF NOT EXIST "%adir%\%aname%" (
    GOTO :_GITHUBASSET_CHECK_BINS
)
CALL "%udir%\compare_sha256" "%adir%\%aname%" "%asha256%"

IF %ERRORLEVEL% EQU 0 (
	CALL "%logger%" "%~nx0" "found valid %aname%"
    GOTO :_GITHUBASSET_DONE
)

ECHO [91m检测到现有%adir%\%aname%并非原版%aname%[0m
ECHO [91m是否需要删除现有%aname%,请谨慎选择:[0m
choice /M "确认删除请按Y,不删除且退出请按N"
IF %ERRORLEVEL% EQU 2 (
    CALL "%logger%" "%~nx0" "user needs the invalid %aname%"
    ECHO [92m可以尝试移动或重命名现有%aname%后再运行安装脚本[0m
    GOTO :_GCLEAN
)
del "%adir%\%aname%" 2>NUL

:_GITHUBASSET_CHECK_BINS
IF NOT EXIST "%bdir%\%aname%" GOTO :_GITHUBASSET_DOWNLOAD
CALL "%logger%" "%~nx0" "%aname% found"

CALL "%udir%\compare_sha256" "%bdir%\%aname%" "%asha256%"
IF %ERRORLEVEL% NEQ 0 (
	DEL "%bdir%\%aname%" 2>NUL
	CALL "%logger%" "%~nx0" "broken project asset deleted"
	GOTO :_GITHUBASSET_DOWNLOAD
)
CALL "%logger%" "%~nx0" "skip download"
ECHO [92m检测到已下载的%aname%[0m
GOTO :_GITHUBASSET_COPY

:_GITHUBASSET_DOWNLOAD
IF NOT EXIST "%bdir%\" mkdir "%bdir%"
ECHO [92m正在为您下载%aname%至%bdir%\文件夹...[0m
SETLOCAL ENABLEDELAYEDEXPANSION
FOR %%u IN (%_aurls%) DO (
	CALL "%logger%" "%~nx0" "downloading %aname% from %%u..."
	curl -L -o "%bdir%\%aname%" "%%u"
	IF !ERRORLEVEL! EQU 0 (
		CALL "%udir%\compare_sha256" "%bdir%\%aname%" "%asha256%"
		IF !ERRORLEVEL! EQU 0 (
			CALL "%logger%" "%~nx0" "done"
			ECHO [92m%aname%下载成功！[0m
			ENDLOCAL & GOTO :_GITHUBASSET_COPY
		) ELSE (
			DEL "%bdir%\%aname%" 2>NUL
			CALL "%logger%" "%~nx0" "broken %aname% deleted"
		)
	) ELSE (
		CALL "%logger%" "%~nx0" "%%u failed with !ERRORLEVEL!"
		DEL "%bdir%\%aname%" 2>NUL
		CALL "%logger%" "%~nx0" "broken %aname% deleted"
	)
)

CALL "%logger%" "%~nx0" "ERROR: %aname% download failed!"
ECHO [91m错误: %aname%下载失败,请检查网络是否正常[0m
GOTO :_GCLEAN

:_GITHUBASSET_COPY
CALL "%logger%" "%~nx0" "copying %aname% into %adir%"
ECHO [92m正在为您复制%aname%至%adir%...[0m
copy /Y "%bdir%\%aname%" "%adir%" >NUL 2>NUL
IF %ERRORLEVEL% NEQ 0 (
	CALL "%logger%" "%~nx0" "ERROR: failed with %ERRORLEVEL%"
	ECHO [91m错误: %aname%复制失败[0m
	GOTO :_GCLEAN
)
CALL "%logger%" "%~nx0" "done"
ECHO [92m%aname%复制成功！[0m

:_GITHUBASSET_DONE
CALL "%logger%" "%~nx0" "%aname% is ready"
ECHO [92m%aname%已就绪[0m
ENDLOCAL

set aname=yolov8n-obb.pt
set aurl=https://github.com/ultralytics/assets/releases/download/v8.2.0/yolov8n-obb.pt
set asha256=fa6e4cd2691f132875c143135affaa66b5d89394ebb1d07d19770a9b6382c1b8

SETLOCAL

SET _aurls=https://ghfast.top/%aurl%^
 %aurl%

:_GITHUBASSET_CHECK_EXISTING
IF NOT EXIST "%adir%\%aname%" (
    GOTO :_GITHUBASSET_CHECK_BINS
)
CALL "%udir%\compare_sha256" "%adir%\%aname%" "%asha256%"

IF %ERRORLEVEL% EQU 0 (
	CALL "%logger%" "%~nx0" "found valid %aname%"
    GOTO :_GITHUBASSET_DONE
)

ECHO [91m检测到现有%adir%\%aname%并非原版%aname%[0m
ECHO [91m是否需要删除现有%aname%,请谨慎选择:[0m
choice /M "确认删除请按Y,不删除且退出请按N"
IF %ERRORLEVEL% EQU 2 (
    CALL "%logger%" "%~nx0" "user needs the invalid %aname%"
    ECHO [92m可以尝试移动或重命名现有%aname%后再运行安装脚本[0m
    GOTO :_GCLEAN
)
del "%adir%\%aname%" 2>NUL

:_GITHUBASSET_CHECK_BINS
IF NOT EXIST "%bdir%\%aname%" GOTO :_GITHUBASSET_DOWNLOAD
CALL "%logger%" "%~nx0" "%aname% found"

CALL "%udir%\compare_sha256" "%bdir%\%aname%" "%asha256%"
IF %ERRORLEVEL% NEQ 0 (
	DEL "%bdir%\%aname%" 2>NUL
	CALL "%logger%" "%~nx0" "broken project asset deleted"
	GOTO :_GITHUBASSET_DOWNLOAD
)
CALL "%logger%" "%~nx0" "skip download"
ECHO [92m检测到已下载的%aname%[0m
GOTO :_GITHUBASSET_COPY

:_GITHUBASSET_DOWNLOAD
IF NOT EXIST "%bdir%\" mkdir "%bdir%"
ECHO [92m正在为您下载%aname%至%bdir%\文件夹...[0m
SETLOCAL ENABLEDELAYEDEXPANSION
FOR %%u IN (%_aurls%) DO (
	CALL "%logger%" "%~nx0" "downloading %aname% from %%u..."
	curl -L -o "%bdir%\%aname%" "%%u"
	IF !ERRORLEVEL! EQU 0 (
		CALL "%udir%\compare_sha256" "%bdir%\%aname%" "%asha256%"
		IF !ERRORLEVEL! EQU 0 (
			CALL "%logger%" "%~nx0" "done"
			ECHO [92m%aname%下载成功！[0m
			ENDLOCAL & GOTO :_GITHUBASSET_COPY
		) ELSE (
			DEL "%bdir%\%aname%" 2>NUL
			CALL "%logger%" "%~nx0" "broken %aname% deleted"
		)
	) ELSE (
		CALL "%logger%" "%~nx0" "%%u failed with !ERRORLEVEL!"
		DEL "%bdir%\%aname%" 2>NUL
		CALL "%logger%" "%~nx0" "broken %aname% deleted"
	)
)

CALL "%logger%" "%~nx0" "ERROR: %aname% download failed!"
ECHO [91m错误: %aname%下载失败,请检查网络是否正常[0m
GOTO :_GCLEAN

:_GITHUBASSET_COPY
CALL "%logger%" "%~nx0" "copying %aname% into %adir%"
ECHO [92m正在为您复制%aname%至%adir%...[0m
copy /Y "%bdir%\%aname%" "%adir%" >NUL 2>NUL
IF %ERRORLEVEL% NEQ 0 (
	CALL "%logger%" "%~nx0" "ERROR: failed with %ERRORLEVEL%"
	ECHO [91m错误: %aname%复制失败[0m
	GOTO :_GCLEAN
)
CALL "%logger%" "%~nx0" "done"
ECHO [92m%aname%复制成功！[0m

:_GITHUBASSET_DONE
CALL "%logger%" "%~nx0" "%aname% is ready"
ECHO [92m%aname%已就绪[0m
ENDLOCAL


xcopy %rdir%\samples %pdir% /E /H /I /Y
echo [92m测试脚本已拷贝至%pdir%[0m

set ename=yolov8
set pversion=3.11

SETLOCAL

SET "_pip_tsinghua_index_url=https://pypi.tuna.tsinghua.edu.cn/simple"

:_CONDAENV_CHECK_EXISTING
CALL "%_conda%" activate %ename% 2>>"%logfile%"
IF %ERRORLEVEL% NEQ 0 (
	CALL "%logger%" "%~nx0" "env %ename% not found"
	GOTO :_CONDAENV_CREATE_NEW
)
CALL "%logger%" "%~nx0" "env %ename% found"

where python >"%tmp%\_%ename%_tmp.txt" 2>>"%logfile%"
IF %ERRORLEVEL% NEQ 0 (
	CALL "%logger%" "%~nx0" "python not found in %ename% env"
	ECHO [91m检测到现有%ename%环境并未安装有效python[0m
	GOTO :_CONDAENV_DELETE_OLD
)
SET /P _python_location=< "%tmp%\_%ename%_tmp.txt"
DEL "%tmp%\_%ename%_tmp.txt" 2>NUL
ECHO %_python_location% | findstr "%ename%" >NUL
IF %ERRORLEVEL% NEQ 0 (
 	CALL "%logger%" "%~nx0" "python not found in %ename% env"
	ECHO [91m检测到现有%ename%环境并未安装有效python[0m
 	GOTO :_CONDAENV_DELETE_OLD
)

for /f "tokens=2" %%i in ('python --version') do set _current_pv=%%i
for /f "tokens=1-2 delims=." %%a in ("%_current_pv%") do set _current_mm=%%a.%%b
if "%_current_mm%"=="%pversion%" (
    CALL "%logger%" "%~nx0" "current python %_current_pv% matches %pversion%"
    ECHO [92m检测到现有%ename%环境python版本%_current_pv%[0m
    CALL "%_conda%" deactivate & GOTO :_CONDAENV_CONFIG_PIP
)
CALL "%logger%" "%~nx0" "current python %_current_pv% do not matches %pversion%"
ECHO [91m检测到现有%ename%环境使用python版本%_current_pv%,,不符合目标%pversion%[0m

:_CONDAENV_DELETE_OLD
CALL "%_conda%" deactivate
ECHO [91m是否需要删除旧的%ename%环境,请谨慎选择:[0m
choice /M "确认删除请按Y,不删除且退出请按N"
IF %ERRORLEVEL% EQU 2 (
    CALL "%logger%" "%~nx0" "user needs the old env %ename%"
    ECHO [92m可以尝试重命名或手动删除现有%ename%环境后再运行安装脚本[0m
    GOTO :_GCLEAN
)

CALL "%_conda%" remove -n %ename% --all --yes
IF %ERRORLEVEL% NEQ 0 (
	CALL "%logger%" "%~nx0" "ERROR: cannot remove invalid env %ename%"
    GOTO :_GCLEAN
)
CALL "%logger%" "%~nx0" "invalid env %ename% removed"
ECHO [92m原有%ename%环境已删除[0m

:_CONDAENV_CREATE_NEW
CALL "%logger%" "%~nx0" "creating new env %ename%..."
ECHO [92m正在创建使用python%pversion%的%ename%环境...[0m
CALL "%_conda%" create -n %ename% python=%pversion% --yes
IF %ERRORLEVEL% NEQ 0 (
	CALL "%logger%" "%~nx0" "ERROR: cannot create new env %ename%"
    GOTO :_GCLEAN
)
CALL "%logger%" "%~nx0" "new env %ename% created"
ECHO [92m%ename%环境创建成功！[0m

:_CONDAENV_CONFIG_PIP
CALL "%_conda%" activate %ename%
IF %ERRORLEVEL% NEQ 0 (
	CALL "%logger%" "%~nx0" "ERROR: %ename% activation failed"
    GOTO :_GCLEAN
)

python -m pip install -i "%_pip_tsinghua_index_url%" --upgrade pip
IF %ERRORLEVEL% NEQ 0 (
	CALL "%logger%" "%~nx0" "ERROR: pip upgrade failed"
	ECHO [91m错误: pip更新失败,请检查网络是否正常[0m
	GOTO :_GCLEAN
)
CALL "%logger%" "%~nx0" "pip upgraded"
ECHO [92mpip已更新[0m

pip config set global.index-url "%_pip_tsinghua_index_url%"
IF %ERRORLEVEL% NEQ 0 (
	CALL "%logger%" "%~nx0" "ERROR: tsinghua index-url configuration failed"
	ECHO [91m错误: pip清华镜像设置失败[0m
	GOTO :_GCLEAN
)
CALL "%logger%" "%~nx0" "tsinghua index-url configured"
ECHO [92mpip清华镜像已设置[0m

CALL "%_conda%" deactivate
IF %ERRORLEVEL% NEQ 0 (
	CALL "%logger%" "%~nx0" "ERROR: %ename% deactivation failed"
    GOTO :_GCLEAN
)

:_CONDAENV_DONE
CALL "%logger%" "%~nx0" "env %ename% is ready"
ECHO [92m%ename%环境已就绪[0m
ENDLOCAL


set min_cuda=11.8

SETLOCAL

SET "tdevice=cpu"

:_CHECKCUDA_SEARCH_SMI
IF EXIST "C:\Windows\System32\nvidia-smi.exe" (
	SET "NVSMI_PATH=C:\Windows\System32\nvidia-smi.exe"
) ELSE IF EXIST "C:\Program Files\NVIDIA Corporation\NVSMI\nvidia-smi.exe" (
	SET "NVSMI_PATH=C:\Program Files\NVIDIA Corporation\NVSMI\nvidia-smi.exe"
) ELSE (
	CALL "%logger%" "%~nx0" "WARNING: nvidia-smi not available"
    ECHO [91m无法获取英伟达显卡相关信息,将为您安装CPU版本的pytorch[0m
    ECHO [91m若确有英伟达显卡,请手动安装英伟达显卡驱动后重试[0m
    timeout 3 >NUL
	GOTO :_CHECKCUDA_DONE
)
CALL "%logger%" "%~nx0" "nvsmi_path %NVSMI_PATH%"

:_CHECKCUDA_QUERY_NAME
"%NVSMI_PATH%" --format=csv,noheader --query-gpu=name ^
  >"%tmp%\_detect_driver_tmp.txt" 2>>"%logfile%"
IF %ERRORLEVEL% NEQ 0 (
	CALL "%logger%" "%~nx0" "WARNING: gpu query failed"
    ECHO [91m无法获取英伟达显卡型号信息,将为您安装CPU版本的pytorch[0m
    ECHO [91m若需要安装GPU版本的pytorch,请手动更新英伟达显卡驱动后重试[0m
    timeout 3 >NUL
	GOTO :_CHECKCUDA_DONE
)
SET /P GPU_INFO=< "%tmp%\_detect_driver_tmp.txt"
DEL "%tmp%\_detect_driver_tmp.txt" 2>NUL
CALL "%logger%" "%~nx0" "gpu_info %GPU_INFO%"
ECHO [92m英伟达显卡型号:%GPU_INFO%[0m

:_CHECKCUDA_QUERY_DRIVER
"%NVSMI_PATH%" --format=csv,noheader --query-gpu=driver_version ^
  >"%tmp%\_detect_driver_tmp.txt" 2>>"%logfile%"
IF %ERRORLEVEL% NEQ 0 (
	CALL "%logger%" "%~nx0" "WARNING: driver query failed"
    ECHO [91m无法获取英伟达显卡驱动信息,将为您安装CPU版本的pytorch[0m
    ECHO [91m若需要安装GPU版本的pytorch,请手动更新英伟达显卡驱动后重试[0m
    timeout 3 >NUL
	GOTO :_CHECKCUDA_DONE
)
SET /P DRIVER_VERSION=< "%tmp%\_detect_driver_tmp.txt"
DEL "%tmp%\_detect_driver_tmp.txt" 2>NUL
CALL "%logger%" "%~nx0" "driver_version %DRIVER_VERSION%"
ECHO [92m英伟达显卡驱动版本:%DRIVER_VERSION%[0m

:_CHECKCUDA_QUERY_CUDA
for /f "tokens=9" %%a in ('%NVSMI_PATH% ^| findstr /i "CUDA"') do (
    set DRIVER_MAX_CUDA=%%a
)
IF "%DRIVER_MAX_CUDA%"=="%DRIVER_MAX_CUDA:.=%" (
    CALL "%logger%" "%~nx0" "WARNING: cuda query failed"
    ECHO [91m无法获取cuda相关信息,将为您安装CPU版本的pytorch[0m
    ECHO [91m若需要安装GPU版本的pytorch,请手动更新英伟达显卡驱动后重试[0m
    timeout 3 >NUL
	GOTO :_CHECKCUDA_DONE
)
CALL "%logger%" "%~nx0" "driver_max_cuda %DRIVER_MAX_CUDA%"
ECHO [92m驱动支持最高CUDA版本:%DRIVER_MAX_CUDA%[0m

for /f "tokens=1-2 delims=." %%a in ("%min_cuda%") do (
    set TARGET_MAJOR=%%a
    set TARGET_MINOR=%%b
)
SET /a t1=%TARGET_MAJOR% >NUL
SET /a t2=%TARGET_MINOR% >NUL
IF NOT "%t1%%t2%"=="%TARGET_MAJOR%%TARGET_MINOR%" (
    CALL "%logger%" "%~nx0" "ERROR: cuda split failed on script, %min_cuda%"
    GOTO :_GCLEAN
)

for /f "tokens=1-2 delims=." %%a in ("%DRIVER_MAX_CUDA%") do (
    set MAJOR=%%a
    set MINOR=%%b
)
SET /a t1=%MAJOR% >NUL
SET /a t2=%MINOR% >NUL
IF NOT "%t1%%t2%"=="%MAJOR%%MINOR%" (
    CALL "%logger%" "%~nx0" "ERROR: cuda split failed on host, %DRIVER_MAX_CUDA%"
    GOTO :_GCLEAN
)

IF %MAJOR% gtr %TARGET_MAJOR% (
    SET "tdevice=gpu"
) ELSE (
    IF %MAJOR% equ %TARGET_MAJOR% (
        IF %MINOR% geq %TARGET_MINOR% (
            SET "tdevice=gpu"
        )
    )
)

CALL "%logger%" "%~nx0" "tdevice %tdevice%"
IF "%tdevice%"=="gpu" (
    CALL "%logger%" "%~nx0" "%DRIVER_MAX_CUDA% works on %min_cuda%"
    ECHO [92m%DRIVER_MAX_CUDA%^>=%min_cuda%,将为您安装GPU版本的PyTorch[0m
) ELSE (
    CALL "%logger%" "%~nx0" "%DRIVER_MAX_CUDA% do not works on %min_cuda%"
    ECHO [91m%DRIVER_MAX_CUDA%^<=%min_cuda%,将为您安装CPU版本的PyTorch[0m
    ECHO [91m若需要安装GPU版本的pytorch,请手动更新英伟达显卡驱动后重试[0m
    timeout 3 >NUL
)

:_CHECKCUDA_QUERY_CAP
"%NVSMI_PATH%" --format=csv,noheader --query-gpu=compute_cap ^
  >"%tmp%\_detect_driver_tmp.txt" 2>>"%logfile%"
IF %ERRORLEVEL% NEQ 0 (
	SET "GPU_COMPUTE_CAP=?"
) ELSE (
	SET /P GPU_COMPUTE_CAP=< "%tmp%\_detect_driver_tmp.txt"
    DEL "%tmp%\_detect_driver_tmp.txt" 2>NUL
)
CALL "%logger%" "%~nx0" "gpu_compute_cap %GPU_COMPUTE_CAP%"
ECHO [92m当前显卡算力:%GPU_COMPUTE_CAP%[0m

:_CHECKCUDA_DONE
ENDLOCAL & (
    SET "tdevice=%tdevice%"
)


pushd "%pdir%"
call %_conda% activate %ename%

pip install numpy==1.26 || (
    echo [91mnumpy 1.26安装失败,请检查网络后重试[0m
    goto :_GCLEAN
)


SETLOCAL

SET "pytorch_status="

:_PYTORCH_CHECK
CALL "%logger%" "%~nx0" "checking if torch and cuda available..."
python -c "import torch; print(torch.cuda.is_available())" ^
  >"%tmp%\_pytorch_tmp.txt" 2>NUL
IF %ERRORLEVEL% NEQ 0 (
	CALL "%logger%" "%~nx0" "torch not available"
	GOTO :_PYTORCH_PREINSTALL
)
CALL "%logger%" "%~nx0" "torch import succeeded"

SET /P _cuda_available=< "%tmp%\_pytorch_tmp.txt"
DEL "%tmp%\_pytorch_tmp.txt" 2>NUL
IF NOT "%_cuda_available%"=="True" (
	CALL "%logger%" "%~nx0" "cuda is not available"
	SET "pytorch_status=cpu"
) ELSE (
    CALL "%logger%" "%~nx0" "cuda is available"
    SET "pytorch_status=gpu"
)

if not "%pytorch_status%"=="" (
    if not "%pytorch_status%"=="%tdevice%" (
        pip uninstall torch torchvision torchaudio --yes || (
            CALL "%logger%" "%~nx0" "pytorch uninstall failed"
            GOTO :_GCLEAN
        )
    )
)

:_PYTORCH_PREINSTALL
if "%tdevice%"=="gpu" (
    goto :_PYTORCH_INSTALL_GPU
) else (
    goto :_PYTORCH_INSTALL_CPU
)

:_PYTORCH_INSTALL_CPU
echo [92m正在安装PyTorch2.0.0-CPU...[0m
pip install torch==2.0.0 torchvision==0.15.1 torchaudio==2.0.1 || (
    echo [91mPyTorch2.0.0-CPU安装失败,请检查网络后重试[0m
    goto :_GCLEAN
)
echo [92mPyTorch2.0.0-CPU安装成功！[0m
goto :_PYTORCH_DONE

:_PYTORCH_INSTALL_GPU
echo [92m正在安装PyTorch2.0.0-GPU...[0m
pip install torch==2.0.0 torchvision==0.15.1 torchaudio==2.0.1 ^
    -f https://mirrors.aliyun.com/pytorch-wheels/cu118 || (
    echo [91mPyTorch2.0.0-GPU安装失败,请检查网络后重试[0m
    goto :_GCLEAN
)
echo [92mPyTorch2.0.0-GPU安装成功！[0m
goto :_PYTORCH_DONE

:_PYTORCH_DONE
ENDLOCAL


echo [92m正在安装requirements.txt...[0m
pip install -e . || (
    echo [91mrequirements.txt安装失败,请检查网络后重试[0m
    goto :_GCLEAN
)
echo [92mrequirements.txt安装成功！[0m

popd
call %_conda% deactivate


SETLOCAL

:_PYCHARMTUT_GENERATE
call %_conda% activate %ename%

python "%udir%\pycharmtut.py"
IF %ERRORLEVEL% NEQ 0 (
    CALL "%logger%" "%~nx0" "ERROR: pycharmtut generation failed"
    GOTO :_GCLEAN
)

call %_conda% deactivate

:_PYCHARMTUT_DONE
CALL "%logger%" "%~nx0" "pycharmtut is ready"
ECHO [92mPyCharm配置教程已就绪[0m
ENDLOCAL


echo [92m%pname%环境安装成功！🎉🎉🎉[0m


SETLOCAL

:_SETPCE_WRITE
(
    echo %pdir%
    echo %_conda%
    echo %ename%
) > "%pcefile%"

:_SETPCE_DONE
CALL "%logger%" "%~nx0" "setpce done"
ENDLOCAL

:_GCLEAN
pause
chcp %_old_cp%