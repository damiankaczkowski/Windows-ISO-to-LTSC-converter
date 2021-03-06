@echo off
pushd %~dp0
if NOT "%cd%"=="%cd: =%" (
	call :SpaceTest
    goto :EOF
)
(cd /d "%~dp0")&&(NET FILE||(powershell -noprofile start-process -FilePath '%0' -verb runas)&&(exit /B)) >NUL 2>&1
setlocal EnableExtensions
setlocal EnableDelayedExpansion
:================================================================================================================
::===============================================================================================================
pushd %~dp0
::===============================================================================================================
::===============================================================================================================
for /f "tokens=2* delims= " %%a in ('reg query "HKLM\System\CurrentControlSet\Control\Session Manager\Environment" /v "PROCESSOR_ARCHITECTURE"') do if "%%b"=="AMD64" (set vera=x64) else (set vera=x86)
::===============================================================================================================
::===============================================================================================================
set "database1803_1=files\database.1803.1.smrt"
set "database1803_2=files\database.1803.2.smrt"
set "database1803_3=files\database.1803.3.smrt"
set "databasetb1803=files\database.tb.1803.smrt"
set "databasetb1809=files\database.tb.1809.smrt"
set "databasetb81=files\database.tb.81.smrt"
set "database1709_1=files\database.1709.1.smrt"
set "database1709_2=files\database.1709.2.smrt"
set "databaseLTSB=files\database.LTSB.smrt"
set "databaseLTSB2=files\database.LTSB2.smrt"
set "databaseServer16=files\database.Server2016.smrt"
set "aria2c=files\aria2c\aria2c.exe"
set "busybox=files\ISO\busybox.cmd"
set "busyboxtb=files\ISO\busybox.tb.cmd"
set "smv=files\ISO\smv.exe"
:================================================================================================================
::===============================================================================================================
:================================================================================================================
::===============================================================================================================
:SVFISOMainMenu
for /f %%I in ('powershell -noprofile ^(Get-Host^).UI.RawUI.WindowSize.width') do set "cw=%%I"
call :TITLE
cls
call :MenuHeader "[HEADER] MAIN MENU [SYSTEM: %vera%]"
echo:
echo:
call :MenuFooter
echo:
echo      [C] CREATE SVF/ISO
call :Footer
echo      [M] MY VISUAL STUDIO DOWNLOADS
call :Footer
echo      [T] TECHBENCH DOWNLOAD [Win 8.1/10]
call :Footer
echo      [D] DOWNLOAD/RESUME SOURCE ISO FILES
call :Footer
echo      [E] EXIT
echo:
call :MenuFooter
echo:
CHOICE /C CMTDE /N /M "[ USER ] YOUR CHOICE ?:"
if %errorlevel%==1 goto:SVFISOCreate
if %errorlevel%==2 goto:SVFISODownMenu
if %errorlevel%==3 goto:TBISODownload
if %errorlevel%==4 goto:SourceISODownload
if %errorlevel%==5 goto:EXIT
goto:SVFISOMainMenu
:================================================================================================================
::===============================================================================================================
:================================================================================================================
::===============================================================================================================
:SVFISODownMenu
call :TITLE
cls
call :MenuHeader "[HEADER] MVS DOWNLOAD MENU [SYSTEM: %vera%]"
echo:
echo:
call :MenuFooter
echo:
echo      [1] START 1803 PROCESS 1 [17134.1]
echo:
echo      [2] START 1803 PROCESS 2 [17134.228]
echo:
echo      [3] START 1803 PROCESS 3 [17134.285]
echo:
echo      [4] START 1709 PROCESS 1 [16299.15]
echo:
echo      [5] START 1709 PROCESS 2 [16299.125]
echo:
echo      [6] START LTSB 2016 PROCESS [14393.0]
echo:
echo      [7] START LTSB 2015 PROCESS [10240.0]
echo:
echo      [8] START SERVER 2016 PROCESS [14393.0]
call :Footer
echo      [B] BACK
echo:
call :MenuFooter
echo:
CHOICE /C 12345678B /N /M "[ USER ] YOUR CHOICE ?:"
if %errorlevel%==1 (
	set "show=1803"
	set "build=17134.1"
	goto:SVFISOProcess1803
)
if %errorlevel%==2 (
	set "show=1803"
	set "build=17134.228"
	goto:SVFISOProcess1803
)
if %errorlevel%==3 (
	set "show=1803"
	set "build=17134.285"
	goto:SVFISOProcess1803
)
if %errorlevel%==4 (
	set "show=1709"
	set "build=16299.15"
	goto:SVFISOProcess1803
)
if %errorlevel%==5 (
	set "show=1709"
	set "build=16299.125"
	goto:SVFISOProcess1803
)
if %errorlevel%==6 goto:SVFISOProcessLTSB16
if %errorlevel%==7 goto:SVFISOProcessLTSB15
if %errorlevel%==8 goto:SVFISOProcessServer16
if %errorlevel%==9 goto:SVFISOMainMenu
goto:SVFISODownMenu
:================================================================================================================
::===============================================================================================================
::1803 PROCESS
:SVFISOProcess1803
pushd %~dp0
::===============================================================================================================
cls
call :Header "[HEADER] %show% [%build%] SVF ISO CONVERSION"
CHOICE /C 68 /N /M "[ USER ] x[6]4 or x[8]6 architecture ?:"
if %errorlevel%==1 set "arch=x64"
if %errorlevel%==2 set "arch=x86"
call :Footer
CHOICE /C CB /N /M "[ USER ] [C]onsumer or [B]usiness (VL) ISO ?:"
if %errorlevel%==1 (
	if "%build%"=="17134.1" set "type=consumer"
	if "%build%"=="17134.228" set "type=consumer"
	if "%build%"=="17134.285" set "type=consumer"
	if "%build%"=="16299.15" set "type=edition_version"
	if "%build%"=="16299.125" set "type=edition_version"
)
if %errorlevel%==2 (
	if "%build%"=="17134.1" set "type=business"
	if "%build%"=="17134.228" set "type=business"
	if "%build%"=="17134.285" set "type=business"
	if "%build%"=="16299.15" set "type=edition_vl_version"
	if "%build%"=="16299.125" set "type=edition_vl_version"
)
call :Footer
call :LangChoice
::===============================================================================================================
cls
call :Header "[HEADER] %show% [%build%] SVF ISO CONVERSION"
if "%build%"=="17134.1" (
	for /f "tokens=1,2,3,4* delims=|" %%a in ('type "%database1803_1%" ^| findstr /i "%lang%" ^| findstr /i "%arch%" ^| findstr /i "%type%"') do (
		set "fshare=%%d"
		set "fhash=%%b"
		set "fname=%%c"
	)
	if "%type%"=="consumer" if "%arch%"=="x86" (
		set "siename=17134.1.180410-1804.rs4_release_CLIENTENTERPRISEEVAL_OEMRET_x86FRE_en-us"
		set "siehash=ddb496534203cb98284e5484e0ad60af3c0efce7"
		set "sielink=https://software-download.microsoft.com/download/pr/17134.1.180410-1804.rs4_release_CLIENTENTERPRISEEVAL_OEMRET_x86FRE_en-us.iso"
		set "siname=en_windows_10_consumer_editions_version_1803_updated_march_2018_x86_dvd_12063380"
		set "sihash=3f2063b7419675e98c8df82bc0607bbb1ce298bb"
		set "sishare=KtRGY6XX2kksnK6"
	)
	if "%type%"=="consumer" if "%arch%"=="x64" (
		set "siename=17134.1.180410-1804.rs4_release_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us"
		set "siehash=a4ea45ec1282e85fc84af49acf7a8d649c31ac5c"
		set "sielink=https://software-download.microsoft.com/download/pr/17134.1.180410-1804.rs4_release_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
		set "siname=en_windows_10_consumer_editions_version_1803_updated_march_2018_x64_dvd_12063379"
		set "sihash=08fbb24627fa768f869c09f44c5d6c1e53a57a6f"
		set "sishare=H0ckQ69wcsFlIud"
	)
	if "%type%"=="business" if "%arch%"=="x86" (
		set "siename=17134.1.180410-1804.rs4_release_CLIENTENTERPRISEEVAL_OEMRET_x86FRE_en-us"
		set "siehash=ddb496534203cb98284e5484e0ad60af3c0efce7"
		set "sielink=https://software-download.microsoft.com/download/pr/17134.1.180410-1804.rs4_release_CLIENTENTERPRISEEVAL_OEMRET_x86FRE_en-us.iso"
		set "siname=en_windows_10_business_editions_version_1803_updated_march_2018_x86_dvd_12063341"
		set "sihash=a3becd56ba0df0b023a13fe0b3e85f45461fa7ea"
		set "sishare=wAqHUcjE6v3OAbr"
	)
	if "%type%"=="business" if "%arch%"=="x64" (
		set "siename=17134.1.180410-1804.rs4_release_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us"
		set "siehash=a4ea45ec1282e85fc84af49acf7a8d649c31ac5c"
		set "sielink=https://software-download.microsoft.com/download/pr/17134.1.180410-1804.rs4_release_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
		set "siname=en_windows_10_business_editions_version_1803_updated_march_2018_x64_dvd_12063333"
		set "sihash=28681742fe850aa4bfc7075811c5244b61d462cf"
		set "sishare=iAmZu6da4sFmKP9"
))
if "%build%"=="17134.228" (
	for /f "tokens=1,2,3* delims=|" %%a in ('type "%database1803_2%" ^| findstr /i "%lang%" ^| findstr /i "%arch%" ^| findstr /i "%type%"') do (
		set "fshare=Xq6elBGSBdH9RQe"
		set "fhash=%%b"
		set "fname=%%c"
	)
	if "%type%"=="consumer" if "%arch%"=="x86" (
		set "siename=17134.1.180410-1804.rs4_release_CLIENTENTERPRISEEVAL_OEMRET_x86FRE_en-us"
		set "siehash=ddb496534203cb98284e5484e0ad60af3c0efce7"
		set "sielink=https://software-download.microsoft.com/download/pr/17134.1.180410-1804.rs4_release_CLIENTENTERPRISEEVAL_OEMRET_x86FRE_en-us.iso"
		set "siname=en_windows_10_consumer_edition_version_1803_updated_aug_2018_x86_dvd_454b0be7"
		set "sihash=ca7861c6a41c0f377f1d7c64eb6c59fded843d8a"
		set "sishare=Consumer_EN_2_XX_x86/!fname!.svf"
	)
	if "%type%"=="consumer" if "%arch%"=="x64" (
		set "siename=17134.1.180410-1804.rs4_release_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us"
		set "siehash=a4ea45ec1282e85fc84af49acf7a8d649c31ac5c"
		set "sielink=https://software-download.microsoft.com/download/pr/17134.1.180410-1804.rs4_release_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
		set "siname=en_windows_10_consumer_edition_version_1803_updated_aug_2018_x64_dvd_f2764cf8"
		set "sihash=349c43fc744ef45d2cf85e7bef4131373216525d"
		set "sishare=Consumer_EN_2_XX_x64/!fname!.svf"
	)
	if "%type%"=="business" if "%arch%"=="x86" (
		set "siename=17134.1.180410-1804.rs4_release_CLIENTENTERPRISEEVAL_OEMRET_x86FRE_en-us"
		set "siehash=ddb496534203cb98284e5484e0ad60af3c0efce7"
		set "sielink=https://software-download.microsoft.com/download/pr/17134.1.180410-1804.rs4_release_CLIENTENTERPRISEEVAL_OEMRET_x86FRE_en-us.iso"
		set "siname=en_windows_10_business_edition_version_1803_updated_aug_2018_x86_dvd_69a0bb10"
		set "sihash=533545aa095aa18824a9d1f81a95d8db3e23e154"
		set "sishare=Business_EN_2_XX_x86/!fname!.svf"
	)
	if "%type%"=="business" if "%arch%"=="x64" (
		set "siename=17134.1.180410-1804.rs4_release_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us"
		set "siehash=a4ea45ec1282e85fc84af49acf7a8d649c31ac5c"
		set "sielink=https://software-download.microsoft.com/download/pr/17134.1.180410-1804.rs4_release_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
		set "siname=en_windows_10_business_edition_version_1803_updated_aug_2018_x64_dvd_5d7e729e"
		set "sihash=2b15efd7926ab9db9181cd7b599452cccc3774de"
		set "sishare=Business_EN_2_XX_x64/!fname!.svf"
))
if "%build%"=="17134.285" (
	for /f "tokens=1,2,3,4* delims=|" %%a in ('type "%database1803_3%" ^| findstr /i "%lang%" ^| findstr /i "%arch%" ^| findstr /i "%type%"') do (
		set "fshare=%%d"
		set "fhash=%%b"
		set "fname=%%c"
	)
	if "%type%"=="consumer" if "%arch%"=="x86" (
		set "siename=17134.1.180410-1804.rs4_release_CLIENTENTERPRISEEVAL_OEMRET_x86FRE_en-us"
		set "siehash=ddb496534203cb98284e5484e0ad60af3c0efce7"
		set "sielink=https://software-download.microsoft.com/download/pr/17134.1.180410-1804.rs4_release_CLIENTENTERPRISEEVAL_OEMRET_x86FRE_en-us.iso"
		set "siname=en_windows_10_consumer_edition_version_1803_updated_sep_2018_x86_dvd_f5ff2c32"
		set "sihash=4c019f93732aaf9ab4e4d74bec3287b949c1aadf"
		set "sishare=fPAmBlUVTfdDsER
	)
	if "%type%"=="consumer" if "%arch%"=="x64" (
		set "siename=17134.1.180410-1804.rs4_release_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us"
		set "siehash=a4ea45ec1282e85fc84af49acf7a8d649c31ac5c"
		set "sielink=https://software-download.microsoft.com/download/pr/17134.1.180410-1804.rs4_release_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
		set "siname=en_windows_10_consumer_edition_version_1803_updated_sep_2018_x64_dvd_69339216"
		set "sihash=0208398915c08fe03f6c63faea9dcc9bbbd00532"
		set "sishare=fPAmBlUVTfdDsER"
	)
	if "%type%"=="business" if "%arch%"=="x86" (
		set "siename=17134.1.180410-1804.rs4_release_CLIENTENTERPRISEEVAL_OEMRET_x86FRE_en-us"
		set "siehash=ddb496534203cb98284e5484e0ad60af3c0efce7"
		set "sielink=https://software-download.microsoft.com/download/pr/17134.1.180410-1804.rs4_release_CLIENTENTERPRISEEVAL_OEMRET_x86FRE_en-us.iso"
		set "siname=en_windows_10_business_edition_version_1803_updated_sep_2018_x86_dvd_fb8c8fd4"
		set "sihash=e0fc7ab79c7e9ec7971fe3a9fd302531564e6dcb"
		set "sishare=fPAmBlUVTfdDsER"
	)
	if "%type%"=="business" if "%arch%"=="x64" (
		set "siename=17134.1.180410-1804.rs4_release_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us"
		set "siehash=a4ea45ec1282e85fc84af49acf7a8d649c31ac5c"
		set "sielink=https://software-download.microsoft.com/download/pr/17134.1.180410-1804.rs4_release_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
		set "siname=en_windows_10_business_edition_version_1803_updated_sep_2018_x64_dvd_37051f54"
		set "sihash=d302d2e752c01e53996ae292a8dd4cdf49916bad"
		set "sishare=fPAmBlUVTfdDsER"
))
if "%build%"=="16299.15" (
	for /f "tokens=1,2,3* delims=|" %%a in ('type "%database1709_1%" ^| findstr /i "%lang%" ^| findstr /i "%arch%" ^| findstr /i "%type%"') do (
		set "fshare=Sc8UaS9CXJDKtXr"
		set "fhash=%%b"
		set "fname=%%c"
	)
	if "%type%"=="edition_version" if "%arch%"=="x86" (
		set "siename=16299.15.170928-1534.rs3_release_CLIENTENTERPRISEEVAL_OEMRET_x86FRE_en-us"
		set "siehash=4a75747a47eb689497fe57d64cec375c7949aa97"
		set "sielink=https://download.microsoft.com/download/6/5/D/65D18931-F626-4A35-AD5B-F5DA41FE6B76/16299.15.170928-1534.rs3_release_CLIENTENTERPRISEEVAL_OEMRET_x86FRE_en-us.iso"
		set "siname=en_windows_10_multi-edition_version_1709_updated_sept_2017_x86_dvd_100090818"
		set "sihash=93b317c82b69252027e57aa2d18b50825cdf443e"
		set "sishare=SbZp6LdwkWOwp3v"
	)
	if "%type%"=="edition_version" if "%arch%"=="x64" (
		set "siename=16299.15.170928-1534.rs3_release_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us"
		set "siehash=3b5f9494d870726d6d8a833aaf6169a964b8a9be"
		set "sielink=https://download.microsoft.com/download/6/5/D/65D18931-F626-4A35-AD5B-F5DA41FE6B76/16299.15.170928-1534.rs3_release_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
		set "siname=en_windows_10_multi-edition_version_1709_updated_sept_2017_x64_dvd_100090817"
		set "sihash=1ad928cfef439f6aa4044ddc3a96b0b6830bdd0f"
		set "sishare=SbZp6LdwkWOwp3v"
	)
	if "%type%"=="edition_vl_version" if "%arch%"=="x86" (
		set "siename=16299.15.170928-1534.rs3_release_CLIENTENTERPRISEEVAL_OEMRET_x86FRE_en-us"
		set "siehash=4a75747a47eb689497fe57d64cec375c7949aa97"
		set "sielink=https://download.microsoft.com/download/6/5/D/65D18931-F626-4A35-AD5B-F5DA41FE6B76/16299.15.170928-1534.rs3_release_CLIENTENTERPRISEEVAL_OEMRET_x86FRE_en-us.iso"
		set "siname=en_windows_10_multi-edition_vl_version_1709_updated_sept_2017_x86_dvd_100090759"
		set "sihash=8c274ce27b49d43216dfef115b811936880e6e06"
		set "sishare=SbZp6LdwkWOwp3v"
	)
	if "%type%"=="edition_vl_version" if "%arch%"=="x64" (
		set "siename=16299.15.170928-1534.rs3_release_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us"
		set "siehash=3b5f9494d870726d6d8a833aaf6169a964b8a9be"
		set "sielink=https://download.microsoft.com/download/6/5/D/65D18931-F626-4A35-AD5B-F5DA41FE6B76/16299.15.170928-1534.rs3_release_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
		set "siname=en_windows_10_multi-edition_vl_version_1709_updated_sept_2017_x64_dvd_100090741"
		set "sihash=1bbf886697a485c18d70ad294a09c08cb3c064ac"
		set "sishare=SbZp6LdwkWOwp3v"
))
::===============================================================================================================
::set "sielink=http://care.dlservice.microsoft.com/dl/download/6/5/D/65D18931-F626-4A35-AD5B-F5DA41FE6B76/16299.15.170928-1534.rs3_release_CLIENTENTERPRISEEVAL_OEMRET_x86FRE_en-us.iso"
::set "sielink=http://care.dlservice.microsoft.com/dl/download/6/5/D/65D18931-F626-4A35-AD5B-F5DA41FE6B76/16299.15.170928-1534.rs3_release_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
::===============================================================================================================
if "%build%"=="16299.125" (
	for /f "tokens=1,2,3* delims=|" %%a in ('type "%database1709_2%" ^| findstr /i "%lang%" ^| findstr /i "%arch%" ^| findstr /i "%type%"') do (
		set "fshare=MLATBBhtSajfaLz"
		set "fhash=%%b"
		set "fname=%%c"
	)
	if "%type%"=="edition_version" if "%arch%"=="x86" (
		set "siename=16299.15.170928-1534.rs3_release_CLIENTENTERPRISEEVAL_OEMRET_x86FRE_en-us"
		set "siehash=4a75747a47eb689497fe57d64cec375c7949aa97"
		set "sielink=https://download.microsoft.com/download/6/5/D/65D18931-F626-4A35-AD5B-F5DA41FE6B76/16299.15.170928-1534.rs3_release_CLIENTENTERPRISEEVAL_OEMRET_x86FRE_en-us.iso"
		set "siname=en_windows_10_multi-edition_version_1709_updated_dec_2017_x86_dvd_100406359"
		set "sihash=36005d054f732119bbb00fd9a0e141d54712d751"
		set "sishare=9JpXNkAkwCUsqcy"
	)
	if "%type%"=="edition_version" if "%arch%"=="x64" (
		set "siename=16299.15.170928-1534.rs3_release_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us"
		set "siehash=3b5f9494d870726d6d8a833aaf6169a964b8a9be"
		set "sielink=https://download.microsoft.com/download/6/5/D/65D18931-F626-4A35-AD5B-F5DA41FE6B76/16299.15.170928-1534.rs3_release_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
		set "siname=en_windows_10_multi-edition_version_1709_updated_dec_2017_x64_dvd_100406711"
		set "sihash=ea214ee684a5bb8230707104c54a3b74d92f1d69"
		set "sishare=Mfxoh7M2KNorBaE"
	)
	if "%type%"=="edition_vl_version" if "%arch%"=="x86" (
		set "siename=16299.15.170928-1534.rs3_release_CLIENTENTERPRISEEVAL_OEMRET_x86FRE_en-us"
		set "siehash=4a75747a47eb689497fe57d64cec375c7949aa97"
		set "sielink=https://download.microsoft.com/download/6/5/D/65D18931-F626-4A35-AD5B-F5DA41FE6B76/16299.15.170928-1534.rs3_release_CLIENTENTERPRISEEVAL_OEMRET_x86FRE_en-us.iso"
		set "siname=en_windows_10_multi-edition_vl_version_1709_updated_dec_2017_x86_dvd_100406182"
		set "sihash=6eeff9574366042ed5ad50c48f406ce10ef20e10"
		set "sishare=VRdCKPETWzFHOGH"
	)
	if "%type%"=="edition_vl_version" if "%arch%"=="x64" (
		set "siename=16299.15.170928-1534.rs3_release_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us"
		set "siehash=3b5f9494d870726d6d8a833aaf6169a964b8a9be"
		set "sielink=https://download.microsoft.com/download/6/5/D/65D18931-F626-4A35-AD5B-F5DA41FE6B76/16299.15.170928-1534.rs3_release_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
		set "siname=en_windows_10_multi-edition_vl_version_1709_updated_dec_2017_x64_dvd_100406172"
		set "sihash=1851a0007321fa084145ea24b8d30bf7a72bf1c6"
		set "sishare=SB0WYFMT6ZItmmc"
))
echo [ INFO ] Source: %siename%
echo [ INFO ] Hash  : %siehash%
echo [  TO  ]
echo [ INFO ] Source: %siname%
echo [ INFO ] Hash  : %sihash%
call :Footer
echo [ INFO ] Target: %fname%
echo [ INFO ] Hash  : %fhash%
call :Footer
CHOICE /C SB /N /M "[ USER ] [S]tart or [B]ack ?:"
if %errorlevel%==2 goto:SVFISODownMenu
::===============================================================================================================
cls
call :Header "[HEADER] %show% [%build%] SVF ISO CONVERSION"
echo [ INFO ] Source: %siname%
echo [ INFO ] Hash  : %sihash%
call :Footer
echo [ INFO ] Downloading Source ISO ^(if not already pesent^).
call :Footer
set "dhash="
if not exist "%siname%.iso" (
	if not exist "%siename%.iso" (
		echo [ INFO ] Downloading Eval ISO.
		call :Footer
		"%aria2c%" -x16 -s16 -d"%cd%" -o"%siename%.iso" --checksum=sha-1=%siehash% "%sielink%" -R -c --file-allocation=none --check-certificate=false
		if !errorlevel!==0 set "dhash=%siehash%"
		if not !errorlevel!==0 (
			files\ISO\busybox echo -e "\033[31;1m[ WARN ] Hash Mismatch!\033[0m"
			echo [ INFO ] Hash  : !dhash!
			call :Footer
			pause
			goto:SVFISODownMenu
		)
		call :Footer
	)
	if exist "%siename%.iso" if not defined dhash (
		echo [ INFO ] Source Eval ISO present.
		echo [ INFO ] Checking Eval ISO Hash.
		echo [ INFO ] Hash  : %siehash%
		call :Footer
		xcopy "files\ISO\busybox.exe" /s ".\" /Q /Y >nul 2>&1
		for /f "tokens=1 delims= " %%a in ('busybox.exe sha1sum %siename%.iso') do set "dhash=%%a"
		if exist "busybox.exe" del /f /q "busybox.exe" >nul 2>&1
		if not !dhash! equ %siehash% (
			files\ISO\busybox echo -e "\033[31;1m[ WARN ] Hash Mismatch!\033[0m"
			echo [ INFO ] Hash  : !dhash!
			call :Footer
			pause
			goto:SVFISODownMenu
		)
		if !dhash! equ %siehash% (
			files\ISO\busybox echo -e "\033[32;1m[ INFO ] ISO Hash matching.\033[0m"
			echo [ INFO ] Hash  : !dhash!
			call :Footer
		)
	)
	if not exist "%siname%.svf" (
		echo [ INFO ] Downloading Source ISO SVF.
		echo [ INFO ] Name  : %siname%
		call :Footer
		if "%build%"=="17134.1" call %busybox% "%sishare%", ""
		if "%build%"=="17134.228" call %busybox% "%fshare%", "%siname%.svf"
		if "%build%"=="17134.285" call %busybox% "%sishare%", "%siname%.svf"
		if "%build%"=="16299.15" call %busybox% "%sishare%", "%siname%.svf"
		if "%build%"=="16299.125" call %busybox% "%sishare%", ""
		call :Footer
		pushd "%~dp0"
		move "files\ISO\%siname%.svf" ".\" >nul 2>&1
	)
	echo [ INFO ] Creating Source ISO.
	echo [ INFO ] Name  : %siname%
	call :Footer
::===============================================================================================================
	xcopy "%smv%" /s ".\" /Q /Y >nul 2>&1
	smv x %siname%.svf -br .
	if exist "smv.exe" del /f /q "smv.exe" >nul 2>&1
::===============================================================================================================
	call :Footer
)
echo [ INFO ] Checking Source ISO Hash.
echo [ INFO ] Hash  : %sihash%
call :Footer
xcopy "files\ISO\busybox.exe" /s ".\" /Q /Y >nul 2>&1
for /f "tokens=1 delims= " %%a in ('busybox.exe sha1sum %siname%.iso') do set "dhash=%%a"
if exist "busybox.exe" del /f /q "busybox.exe" >nul 2>&1
if not %dhash% equ %sihash% (
	files\ISO\busybox echo -e "\033[31;1m[ WARN ] Hash Mismatch!\033[0m"
	echo [ INFO ] Hash  : %dhash%
	call :Footer
	pause
	goto:SVFISODownMenu
)
if %dhash% equ %sihash% (
	files\ISO\busybox echo -e "\033[32;1m[ INFO ] ISO Hash matching.\033[0m"
	echo [ INFO ] Hash  : %dhash%
	call :Footer
)
if "%lang%"=="en-us" goto:SourceChoiceOTHER
echo [ INFO ] Downloading SVF ^(if not already pesent^).
echo [ INFO ] Name  : %fname%
call :Footer
if not exist "%fname%.iso" (
	if not exist "%fname%.svf" (
		if "%build%"=="17134.1" call %busybox% "%fshare%", "%fname%.svf"
		if "%build%"=="17134.228" call %busybox% "%fshare%", "%sishare%"
		if "%build%"=="17134.285" call %busybox% "%fshare%", "%fname%.svf"
		if "%build%"=="16299.15" call %busybox% "%fshare%", "%fname%.svf", "%arch%", "%type%", "%build%"
		if "%build%"=="16299.125" call %busybox% "%fshare%", "%fname%.svf", "%arch%", "%type%"
		call :Footer
		pushd "%~dp0"
		move "files\ISO\%fname%.svf" ".\" >nul 2>&1
	)
	echo [ INFO ] Creating Target ISO.
	echo [ INFO ] Target: %fname%
	echo [ INFO ] Hash  : %fhash%
	call :Footer
::===============================================================================================================
	xcopy "%smv%" /s ".\" /Q /Y >nul 2>&1
	smv x %fname%.svf -br .
	if exist "smv.exe" del /f /q "smv.exe" >nul 2>&1
::===============================================================================================================
	call :Footer
)
echo [ INFO ] Checking Target ISO Hash.
echo [ INFO ] Hash  : %fhash%
call :Footer
xcopy "files\ISO\busybox.exe" /s ".\" /Q /Y >nul 2>&1
for /f "tokens=1 delims= " %%a in ('busybox.exe sha1sum %fname%.iso') do set "dhash=%%a"
if exist "busybox.exe" del /f /q "busybox.exe" >nul 2>&1
if not %dhash% equ %fhash% (
	files\ISO\busybox echo -e "\033[31;1m[ WARN ] Hash Mismatch!\033[0m"
	echo [ INFO ] Hash  : %dhash%
	call :Footer
	pause
	goto:SVFISODownMenu
)
if %dhash% equ %fhash% (
	files\ISO\busybox echo -e "\033[32;1m[ INFO ] ISO Hash matching.\033[0m"
	echo [ INFO ] Hash  : %dhash%
	call :Footer
)
:SourceChoiceOTHER
pause
goto:SVFISODownMenu
:================================================================================================================
::===============================================================================================================
::LTSB 2016 PROCESS
:SVFISOProcessLTSB16
pushd %~dp0
::===============================================================================================================
cls
call :Header "[HEADER] LTSB 2016 SVF ISO CONVERSION"
CHOICE /C 68 /N /M "[ USER ] x[6]4 or x[8]6 architecture ?:"
if %errorlevel%==1 set "arch=x64"
if %errorlevel%==2 set "arch=x86"
call :Footer
CHOICE /C SN /N /M "[ USER ] [S]tandard or [N] Version ISO ?:"
if %errorlevel%==1 set "type=_ltsb_x"
if %errorlevel%==2 set "type=_ltsb_n"
call :Footer
if "%type%"=="_ltsb_x" call :LangChoice
if "%type%"=="_ltsb_n" call :LangChoiceN
::===============================================================================================================
cls
call :Header "[HEADER] LTSB 2016 SVF ISO CONVERSION"
for /f "tokens=1,2,3,4* delims=|" %%a in ('type "%databaseLTSB%" ^| findstr /i "%lang%" ^| findstr /i "%arch%" ^| findstr /i "%type%"') do (
	set "fshare=%%d"
	set "fhash=%%b"
	set "fname=%%c"
)
if "%type%"=="_ltsb_x" if "%arch%"=="x86" (
	set "siename=14393.0.160715-1616.RS1_RELEASE_CLIENTENTERPRISE_S_EVAL_X86FRE_EN-US"
	set "siehash=fd65bfe31af5fd59d8537210cd829fe3e83feeb2"
	set "sielink=http://download.microsoft.com/download/1/B/F/1BFE5194-5951-452C-B62C-B2F667F9B86D/14393.0.160715-1616.RS1_RELEASE_CLIENTENTERPRISE_S_EVAL_X86FRE_EN-US.ISO"
	set "siname=en_windows_10_enterprise_2016_ltsb_x86_dvd_9060010"
	set "sihash=45e72d02ff17125c699558719eb946d8e140c9cc"
	set "siphash=f60802ce368c3e1ce29fa81630af1cb82f579ace"
	set "sipname=2016_LTSB_SVF/%arch%/%fname%.svf"
	set "silink=EVAL_LTSB_2_2016_LTSB/%arch%/!siname!.svf"
)
if "%type%"=="_ltsb_x" if "%arch%"=="x64" (
	set "siename=14393.0.160715-1616.RS1_RELEASE_CLIENTENTERPRISE_S_EVAL_X64FRE_EN-US"
	set "siehash=ed6e357cba8d716a6187095e3abd016564670d5b"
	set "sielink=http://download.microsoft.com/download/1/B/F/1BFE5194-5951-452C-B62C-B2F667F9B86D/14393.0.160715-1616.RS1_RELEASE_CLIENTENTERPRISE_S_EVAL_X64FRE_EN-US.ISO"
	set "siname=en_windows_10_enterprise_2016_ltsb_x64_dvd_9059483"
	set "sihash=031ed6acdc47b8f582c781b039f501d83997a1cf"
	set "siphash=f60802ce368c3e1ce29fa81630af1cb82f579ace"
	set "sipname=2016_LTSB_SVF/%arch%/%fname%.svf"
	set "silink=EVAL_LTSB_2_2016_LTSB/%arch%/!siname!.svf"
)
if "%type%"=="_ltsb_n" if "%arch%"=="x86" (
	set "siename=14393.0.160715-1616.RS1_RELEASE_CLIENTENTERPRISE_S_EVAL_X86FRE_EN-US"
	set "siehash=fd65bfe31af5fd59d8537210cd829fe3e83feeb2"
	set "sielink=http://download.microsoft.com/download/1/B/F/1BFE5194-5951-452C-B62C-B2F667F9B86D/14393.0.160715-1616.RS1_RELEASE_CLIENTENTERPRISE_S_EVAL_X86FRE_EN-US.ISO"
	set "siname=en_windows_10_enterprise_2016_ltsb_n_x86_dvd_9058202"
	set "sihash=3f8f9811a7e72adf88215060e38ba81340dfb0c0"
	set "siphash=e3067f61491a87a8cf2d0873e43d340e24dcdc6e"
	set "sipname=2016_LTSB_N_SVF/%arch%/%fname%.svf"
	set "silink=EVAL_LTSB_2_2016_LTSB/%arch%/!siname!.svf"
)
if "%type%"=="_ltsb_n" if "%arch%"=="x64" (
	set "siename=14393.0.160715-1616.RS1_RELEASE_CLIENTENTERPRISE_S_EVAL_X64FRE_EN-US"
	set "siehash=ed6e357cba8d716a6187095e3abd016564670d5b"
	set "sielink=http://download.microsoft.com/download/1/B/F/1BFE5194-5951-452C-B62C-B2F667F9B86D/14393.0.160715-1616.RS1_RELEASE_CLIENTENTERPRISE_S_EVAL_X64FRE_EN-US.ISO"
	set "siname=en_windows_10_enterprise_2016_ltsb_n_x64_dvd_9057894"
	set "sihash=b5d4911bd53ec5029781ade0937dad43c4ed90f6"
	set "siphash=c093f60e8d50794460f3ec5789f4e65e477fc047"
	set "sipname=2016_LTSB_N_SVF/%arch%/%fname%.svf"
	set "silink=EVAL_LTSB_2_2016_LTSB/%arch%/!siname!.svf"
)
echo [ INFO ] Source: %siename%
echo [ INFO ] Hash  : %siehash%
echo [  TO  ]
echo [ INFO ] Source: %siname%
echo [ INFO ] Hash  : %sihash%
call :Footer
echo [ INFO ] Target: %fname%
echo [ INFO ] Hash  : %fhash%
call :Footer
CHOICE /C SB /N /M "[ USER ] [S]tart or [B]ack ?:"
if %errorlevel%==2 goto:SVFISODownMenu
::===============================================================================================================
cls
call :Header "[HEADER] LTSB 2016 SVF ISO CONVERSION"
echo [ INFO ] Source: %siename%
echo [ INFO ] Hash  : %siehash%
call :Footer
echo [ INFO ] Downloading Source ISO ^(if not already pesent^).
call :Footer
set "dhash="
if not exist "%siname%.iso" (
	if not exist "%siename%.iso" (
		echo [ INFO ] Downloading Eval ISO.
		call :Footer
		"%aria2c%" -x16 -s16 -d"%cd%" -o"%siename%.iso" --checksum=sha-1=%siehash% "%sielink%" -R -c --file-allocation=none --check-certificate=false
		if !errorlevel!==0 set "dhash=%siehash%"
		if not !errorlevel!==0 (
			files\ISO\busybox echo -e "\033[31;1m[ WARN ] Hash Mismatch!\033[0m"
			echo [ INFO ] Hash  : !dhash!
			call :Footer
			pause
			goto:SVFISODownMenu
		)
		call :Footer
	)
	if exist "%siename%.iso" if not defined dhash (
		echo [ INFO ] Source Eval ISO present.
		echo [ INFO ] Checking Eval ISO Hash.
		echo [ INFO ] Hash  : %siehash%
		call :Footer
		xcopy "files\ISO\busybox.exe" /s ".\" /Q /Y >nul 2>&1
		for /f "tokens=1 delims= " %%a in ('busybox.exe sha1sum %siename%.iso') do set "dhash=%%a"
		if exist "busybox.exe" del /f /q "busybox.exe" >nul 2>&1
		if not !dhash! equ %siehash% (
			files\ISO\busybox echo -e "\033[31;1m[ WARN ] Hash Mismatch!\033[0m"
			echo [ INFO ] Hash  : !dhash!
			call :Footer
			pause
			goto:SVFISODownMenu
		)
		if !dhash! equ %siehash% (
			files\ISO\busybox echo -e "\033[32;1m[ INFO ] ISO Hash matching.\033[0m"
			echo [ INFO ] Hash  : !dhash!
			call :Footer
		)
	)
	if not exist "%siname%.svf" (
		echo [ INFO ] Downloading Source ISO SVF.
		echo [ INFO ] Name  : %siname%
		call :Footer
		call %busybox% "vZysMUyuP9nbx0s", "%silink%"
		call :Footer
		pushd "%~dp0"
		move "files\ISO\%siname%.svf" ".\" >nul 2>&1
		pushd "%~dp0"
	)
	echo [ INFO ] Creating Source ISO.
	echo [ INFO ] Name  : %siname%
	call :Footer
::===============================================================================================================
	xcopy "%smv%" /s ".\" /Q /Y >nul 2>&1
	smv x %siname%.svf -br .
	if exist "smv.exe" del /f /q "smv.exe" >nul 2>&1
::===============================================================================================================
	call :Footer
)
echo [ INFO ] Checking Source ISO Hash.
echo [ INFO ] Hash  : %sihash%
call :Footer
xcopy "files\ISO\busybox.exe" /s ".\" /Q /Y >nul 2>&1
for /f "tokens=1 delims= " %%a in ('busybox.exe sha1sum %siname%.iso') do set "dhash=%%a"
if exist "busybox.exe" del /f /q "busybox.exe" >nul 2>&1
if not %dhash% equ %sihash% (
	files\ISO\busybox echo -e "\033[31;1m[ WARN ] Hash Mismatch!\033[0m"
	echo [ INFO ] Hash  : %dhash%
	call :Footer
	pause
	goto:SVFISODownMenu
)
if %dhash% equ %sihash% (
	files\ISO\busybox echo -e "\033[32;1m[ INFO ] ISO Hash matching.\033[0m"
	echo [ INFO ] Hash  : %dhash%
	call :Footer
)
if "%lang%"=="en-us" goto:SourceChoiceLTSB
echo [ INFO ] Downloading SVF ^(if not already pesent^).
echo [ INFO ] Name  : %fname%
call :Footer
if not exist "%fname%.iso" (
	if not exist "%fname%.svf" (
		call %busybox% "%fshare%", "%sipname%"
		call :Footer
		pushd "%~dp0"
		move "files\ISO\%fname%.svf" ".\" >nul 2>&1
	)
	echo [ INFO ] Creating Target ISO.
	echo [ INFO ] Target: %fname%
	echo [ INFO ] Hash  : %fhash%
	call :Footer
::===============================================================================================================
	xcopy "%smv%" /s ".\" /Q /Y >nul 2>&1
	smv x %fname%.svf -br .
	if exist "smv.exe" del /f /q "smv.exe" >nul 2>&1
::===============================================================================================================
	call :Footer
)
echo [ INFO ] Checking Target ISO Hash.
echo [ INFO ] Hash: %fhash%
call :Footer
xcopy "files\ISO\busybox.exe" /s ".\" /Q /Y >nul 2>&1
for /f "tokens=1 delims= " %%a in ('busybox.exe sha1sum %fname%.iso') do set "dhash=%%a"
if exist "busybox.exe" del /f /q "busybox.exe" >nul 2>&1
if not %dhash% equ %fhash% (
	files\ISO\busybox echo -e "\033[31;1m[ WARN ] Hash Mismatch!\033[0m"
	echo [ INFO ] Hash  : %dhash%
	call :Footer
	pause
	goto:SVFISODownMenu
)
if %dhash% equ %fhash% (
	files\ISO\busybox echo -e "\033[32;1m[ INFO ] ISO Hash matching.\033[0m"
	echo [ INFO ] Hash  : %dhash%
	call :Footer
)
:SourceChoiceLTSB
pause
goto:SVFISODownMenu
:================================================================================================================
::===============================================================================================================
::LTSB 2015 PROCESS
:SVFISOProcessLTSB15
pushd %~dp0
::===============================================================================================================
cls
call :Header "[HEADER] LTSB 2015 SVF ISO CONVERSION"
CHOICE /C 68 /N /M "[ USER ] x[6]4 or x[8]6 architecture ?:"
if %errorlevel%==1 set "arch=x64"
if %errorlevel%==2 set "arch=x86"
call :Footer
CHOICE /C SN /N /M "[ USER ] [S]tandard or [N] Version ISO ?:"
if %errorlevel%==1 set "type=_ltsb_x"
if %errorlevel%==2 set "type=_ltsb_n"
call :Footer
if "%type%"=="_ltsb_x" call :LangChoice
if "%type%"=="_ltsb_n" call :LangChoiceN
::===============================================================================================================
cls
call :Header "[HEADER] LTSB 2015 SVF ISO CONVERSION"
for /f "tokens=1,2,3,4* delims=|" %%a in ('type "%databaseLTSB2%" ^| findstr /i "%lang%" ^| findstr /i "%arch%" ^| findstr /i "%type%"') do (
	set "fshare=%%d"
	set "fhash=%%b"
	set "fname=%%c"
)
if "%type%"=="_ltsb_x" if "%arch%"=="x86" (
	set "siename=10240.16384.150709-1700.TH1_CLIENTENTERPRISE_S_EVAL_X86FRE_EN-US"
	set "siehash=aa8ce9cc9b660b31245622e49e0d183db355558f"
	set "sielink=https://download.microsoft.com/download/6/2/4/624ECF83-38A6-4D64-8758-FABC099503DC/10240.16384.150709-1700.TH1_CLIENTENTERPRISE_S_EVAL_X86FRE_EN-US.ISO"
	set "sipname=%arch%/%fname%.svf"
	set "silink=%arch%/!siname!.svf"
)
if "%type%"=="_ltsb_x" if "%arch%"=="x64" (
	set "siename=10240.16384.150709-1700.TH1_CLIENTENTERPRISE_S_EVAL_X64FRE_EN-US"
	set "siehash=90e1c5bada5b96ab05a9fe2035cb26f5cb3cd4d2"
	set "sielink=https://download.microsoft.com/download/6/2/4/624ECF83-38A6-4D64-8758-FABC099503DC/10240.16384.150709-1700.TH1_CLIENTENTERPRISE_S_EVAL_X64FRE_EN-US.ISO"
	set "sipname=%arch%/%fname%.svf"
	set "silink=%arch%/!siname!.svf"
)
if "%type%"=="_ltsb_n" if "%arch%"=="x86" (
	set "siename=10240.16384.150709-1700.TH1_CLIENTENTERPRISE_S_EVAL_X86FRE_EN-US"
	set "siehash=aa8ce9cc9b660b31245622e49e0d183db355558f"
	set "sielink=https://download.microsoft.com/download/6/2/4/624ECF83-38A6-4D64-8758-FABC099503DC/10240.16384.150709-1700.TH1_CLIENTENTERPRISE_S_EVAL_X86FRE_EN-US.ISO"
	set "sipname=%arch%/%fname%.svf"
	set "silink=%arch%/!siname!.svf"
)
if "%type%"=="_ltsb_n" if "%arch%"=="x64" (
	set "siename=10240.16384.150709-1700.TH1_CLIENTENTERPRISE_S_EVAL_X64FRE_EN-US"
	set "siehash=90e1c5bada5b96ab05a9fe2035cb26f5cb3cd4d2"
	set "sielink=https://download.microsoft.com/download/6/2/4/624ECF83-38A6-4D64-8758-FABC099503DC/10240.16384.150709-1700.TH1_CLIENTENTERPRISE_S_EVAL_X64FRE_EN-US.ISO"
	set "sipname=%arch%/%fname%.svf"
	set "silink=%arch%/!siname!.svf"
)

echo [ INFO ] Source: %siename%
echo [ INFO ] Hash  : %siehash%
echo [  TO  ]
echo [ INFO ] Source: %siname%
echo [ INFO ] Hash  : %sihash%
call :Footer
echo [ INFO ] Target: %fname%
echo [ INFO ] Hash  : %fhash%
call :Footer
CHOICE /C SB /N /M "[ USER ] [S]tart or [B]ack ?:"
if %errorlevel%==2 goto:SVFISODownMenu
::===============================================================================================================
cls
call :Header "[HEADER] LTSB 2015 SVF ISO CONVERSION"
echo [ INFO ] Source: %siename%
echo [ INFO ] Hash  : %siehash%
call :Footer
echo [ INFO ] Downloading Source ISO ^(if not already pesent^).
call :Footer
set "dhash="
if not exist "%siname%.iso" (
	if not exist "%siename%.iso" (
		echo [ INFO ] Downloading Eval ISO.
		call :Footer
		"%aria2c%" -x16 -s16 -d"%cd%" -o"%siename%.iso" --checksum=sha-1=%siehash% "%sielink%" -R -c --file-allocation=none --check-certificate=false
		if !errorlevel!==0 set "dhash=%siehash%"
		if not !errorlevel!==0 (
			files\ISO\busybox echo -e "\033[31;1m[ WARN ] Hash Mismatch!\033[0m"
			echo [ INFO ] Hash  : !dhash!
			call :Footer
			pause
			goto:SVFISODownMenu
		)
		call :Footer
	)
	if exist "%siename%.iso" if not defined dhash (
		echo [ INFO ] Source Eval ISO present.
		echo [ INFO ] Checking Eval ISO Hash.
		echo [ INFO ] Hash  : %siehash%
		call :Footer
		xcopy "files\ISO\busybox.exe" /s ".\" /Q /Y >nul 2>&1
		for /f "tokens=1 delims= " %%a in ('busybox.exe sha1sum %siename%.iso') do set "dhash=%%a"
		if exist "busybox.exe" del /f /q "busybox.exe" >nul 2>&1
		if not !dhash! equ %siehash% (
			files\ISO\busybox echo -e "\033[31;1m[ WARN ] Hash Mismatch!\033[0m"
			echo [ INFO ] Hash  : !dhash!
			call :Footer
			pause
			goto:SVFISODownMenu
		)
		if !dhash! equ %siehash% (
			files\ISO\busybox echo -e "\033[32;1m[ INFO ] ISO Hash matching.\033[0m"
			echo [ INFO ] Hash  : !dhash!
			call :Footer
		)
	)
)
echo [ INFO ] Downloading SVF ^(if not already pesent^).
echo [ INFO ] Name  : %fname%
call :Footer
if not exist "%fname%.iso" (
	if not exist "%fname%.svf" (
		call %busybox% "%fshare%", "%sipname%"
		call :Footer
		pushd "%~dp0"
		move "files\ISO\%fname%.svf" ".\" >nul 2>&1
	)
	echo [ INFO ] Creating Target ISO.
	echo [ INFO ] Target: %fname%
	echo [ INFO ] Hash  : %fhash%
	call :Footer
::===============================================================================================================
	xcopy "%smv%" /s ".\" /Q /Y >nul 2>&1
	smv x %fname%.svf -br .
	if exist "smv.exe" del /f /q "smv.exe" >nul 2>&1
::===============================================================================================================
	call :Footer
)
echo [ INFO ] Checking Target ISO Hash.
echo [ INFO ] Hash: %fhash%
call :Footer
xcopy "files\ISO\busybox.exe" /s ".\" /Q /Y >nul 2>&1
for /f "tokens=1 delims= " %%a in ('busybox.exe sha1sum %fname%.iso') do set "dhash=%%a"
if exist "busybox.exe" del /f /q "busybox.exe" >nul 2>&1
if not %dhash% equ %fhash% (
	files\ISO\busybox echo -e "\033[31;1m[ WARN ] Hash Mismatch!\033[0m"
	echo [ INFO ] Hash  : %dhash%
	call :Footer
	pause
	goto:SVFISODownMenu
)
if %dhash% equ %fhash% (
	files\ISO\busybox echo -e "\033[32;1m[ INFO ] ISO Hash matching.\033[0m"
	echo [ INFO ] Hash  : %dhash%
	call :Footer
)
:SourceChoiceLTSB2
pause
goto:SVFISODownMenu
:================================================================================================================
::===============================================================================================================
::SERVER 2016 PROCESS
:SVFISOProcessServer16
pushd %~dp0
::===============================================================================================================
cls
call :Header "[HEADER] SERVER 2016 SVF ISO CONVERSION"
call :LangChoiceS
::===============================================================================================================
cls
call :Header "[HEADER] SERVER 2016 SVF ISO CONVERSION"
for /f "tokens=1,2,3* delims=|" %%a in ('type "%databaseServer16%" ^| findstr /i "%lang%"') do (
	set "fhash=%%b"
	set "fname=%%c"
)
set "siename=14393.0.161119-1705.RS1_REFRESH_SERVER_EVAL_X64FRE_EN-US"
set "siehash=772700802951b36c8cb26a61c040b9a8dc3816a3"
set "sielink=https://download.microsoft.com/download/1/4/9/149D5452-9B29-4274-B6B3-5361DBDA30BC/14393.0.161119-1705.RS1_REFRESH_SERVER_EVAL_X64FRE_EN-US.ISO"
set "fpshare=%fname%.svf"
set "fshare=394BiaxTUL50e0B"
echo [ INFO ] Source: %siename%
echo [ INFO ] Hash  : %siehash%
call :Footer
echo [ INFO ] Target: %fname%
echo [ INFO ] Hash  : %fhash%
call :Footer
CHOICE /C SB /N /M "[ USER ] [S]tart or [B]ack ?:"
if %errorlevel%==2 goto:SVFISODownMenu
::===============================================================================================================
cls
call :Header "[HEADER] SERVER 2016 SVF ISO CONVERSION"
echo [ INFO ] Source: %siename%
echo [ INFO ] Hash  : %siehash%
call :Footer
echo [ INFO ] Downloading Source ISO ^(if not already pesent^).
call :Footer
set "dhash="
if not exist "%fname%.iso" (
	if not exist "%siename%.iso" (
		echo [ INFO ] Downloading Eval ISO.
		call :Footer
		"%aria2c%" -x16 -s16 -d"%cd%" -o"%siename%.iso" --checksum=sha-1=%siehash% "%sielink%" -R -c --file-allocation=none --check-certificate=false
		if !errorlevel!==0 set "dhash=%fhash%"
		if not !errorlevel!==0 (
			files\ISO\busybox echo -e "\033[31;1m[ WARN ] Hash Mismatch!\033[0m"
			echo [ INFO ] Hash  : !dhash!
			call :Footer
			pause
			goto:SVFISODownMenu
		)
		call :Footer
	)
	if exist "%siename%.iso" if not defined dhash (
		echo [ INFO ] Source Eval ISO present.
		echo [ INFO ] Checking Eval ISO Hash.
		echo [ INFO ] Hash  : %siehash%
		call :Footer
		xcopy "files\ISO\busybox.exe" /s ".\" /Q /Y >nul 2>&1
		for /f "tokens=1 delims= " %%a in ('busybox.exe sha1sum %siename%.iso') do set "dhash=%%a"
		if exist "busybox.exe" del /f /q "busybox.exe" >nul 2>&1
		if not !dhash! equ %siehash% (
			files\ISO\busybox echo -e "\033[31;1m[ WARN ] Hash Mismatch!\033[0m"
			echo [ INFO ] Hash  : !dhash!
			call :Footer
			pause
			goto:SVFISODownMenu
		)
		if !dhash! equ %siehash% (
			files\ISO\busybox echo -e "\033[32;1m[ INFO ] ISO Hash matching.\033[0m"
			echo [ INFO ] Hash  : !dhash!
			call :Footer
		)
	)
	if not exist "%fname%.svf" (
		echo [ INFO ] Downloading Target ISO SVF.
		echo [ INFO ] Name  : %fname%
		call :Footer
		call %busybox% "%fshare%", "%fpshare%"
		call :Footer
		pushd "%~dp0"
		move "files\ISO\%fname%.svf" ".\" >nul 2>&1
		pushd "%~dp0"
	)
	echo [ INFO ] Creating Target ISO.
	echo [ INFO ] Name  : %fname%
	call :Footer
::===============================================================================================================
	xcopy "%smv%" /s ".\" /Q /Y >nul 2>&1
	smv x %fname%.svf -br .
	if exist "smv.exe" del /f /q "smv.exe" >nul 2>&1
::===============================================================================================================
	call :Footer
)
echo [ INFO ] Checking Target ISO Hash.
echo [ INFO ] Hash  : %fhash%
call :Footer
xcopy "files\ISO\busybox.exe" /s ".\" /Q /Y >nul 2>&1
for /f "tokens=1 delims= " %%a in ('busybox.exe sha1sum %fname%.iso') do set "dhash=%%a"
if exist "busybox.exe" del /f /q "busybox.exe" >nul 2>&1
if not %dhash% equ %fhash% (
	files\ISO\busybox echo -e "\033[31;1m[ WARN ] Hash Mismatch!\033[0m"
	echo [ INFO ] Hash  : %dhash%
	call :Footer
	pause
	goto:SVFISODownMenu
)
if %dhash% equ %fhash% (
	files\ISO\busybox echo -e "\033[32;1m[ INFO ] ISO Hash matching.\033[0m"
	echo [ INFO ] Hash  : %dhash%
	call :Footer
)
pause
goto:SVFISODownMenu
:================================================================================================================
::===============================================================================================================
::TECHBENCH DOWNLOAD
:TBISODownload
pushd %~dp0
::===============================================================================================================
cls
call :Header "[HEADER] TECHBENCH DOWNLOAD"
echo      [1] WINDOWS 8.1 ^(Update 3^)
echo:
echo      [2] WINDOWS 8.1 N ^(Update 3^)
echo:
echo      [3] WINDOWS 10 1803 ^(contains N versions^)
echo:
echo      [4] WINDOWS 10 1809 ^(contains N versions^)
echo:
call :Footer
echo      [B] BACK
call :Footer
CHOICE /C 1234B /N /M "[ USER ] YOUR CHOICE ?:"
if %errorlevel%==1 (
	set "tbwin=Win8.1_"
	set "tbid=52"
)
if %errorlevel%==2 (
	set "tbwin=Win8.1_Pro_N_"
	set "tbid=55"
)
if %errorlevel%==3 (
	set "tbwin=Win10_1803_"
	set "tbid=651"
)
if %errorlevel%==4 (
	set "tbwin=Win10_1809_"
	set "tbid=1019"
)
if %errorlevel%==5 goto:SVFISOMainMenu
call :Footer
CHOICE /C 68 /N /M "[ USER ] x[6]4 or x[8]6 architecture ?:"
if %errorlevel%==1 set "tbarch=x64"
if %errorlevel%==2 set "tbarch=x32"
if "%tbwin%"=="Win8.1_Pro_N_" call :LangChoice81N
if "%tbwin%"=="Win8.1_" call :LangChoice81
if "%tbwin%"=="Win10_1803_" call :LangChoiceTB
if "%tbwin%"=="Win10_1809_" call :LangChoiceTB
call :Footer
::===============================================================================================================
cls
call :Header "[HEADER] TECHBENCH DOWNLOAD"
if "%tbwin%"=="Win10_1809_" (
	if "%tbarch%"=="x64" set "stbarch=x64"
	if "%tbarch%"=="x32" set "stbarch=x86"
)
if "%tbwin%"=="Win10_1803_" (
	if "%tbarch%"=="x64" set "stbarch=x64"
	if "%tbarch%"=="x32" set "stbarch=x86"
)
if "%tblang%"=="Korean" if "%tbwin%"=="Win8.1_" (
	set "tbwin=Win8.1_K_"
	set "tbid=61"
)
if "%tblang%"=="Korean" if "%tbwin%"=="Win8.1_Pro_N_" (
	set "tbwin=Win8.1_Pro_KN_"
	set "tbid=62"
)
set "tbfilename=%tbwin%%tblang%_%tbarch%.iso"
if "%tbwin%"=="Win10_1803_" for /f "tokens=1,2,3* delims=|" %%a in ('type "%databasetb1803%" ^| findstr /i "%tblang%" ^| findstr /i "_%stbarch%_"') do set "tbhash=%%b"
if "%tbwin%"=="Win10_1809_" for /f "tokens=1,2,3* delims=|" %%a in ('type "%databasetb1809%" ^| findstr /i "%tblang%" ^| findstr /i "%stbarch%"') do (
	set "tbhash=%%b"
	set "tbsize=%%c"
)
if not "%tbwin%"=="Win10_1803_" if not "%tbwin%"=="Win10_1809_" for /f "tokens=1,2,3,4* delims=|" %%a in ('type "%databasetb81%" ^| findstr /i "%tbfilename%"') do (
	set "tbhash=%%b"
	set "tbsize=%%c"
)
for /f "tokens=*" %%a in ('call %busyboxtb% "%tbid%", "'%tbfilename%'"') do set "tblink=%%a"
echo [ INFO ] TB ISO: %tbfilename%
echo [ INFO ] Hash  : %tbhash%
if not "%tbwin%"=="Win10_1803_" echo [ INFO ] Size  : %tbsize% GB
call :Footer
CHOICE /C SB /N /M "[ USER ] [S]tart or [B]ack ?:"
if %errorlevel%==2 goto:TBISODownload
::===============================================================================================================
cls
call :Header "[HEADER] TECHBENCH DOWNLOAD"
echo [ INFO ] TB ISO: %tbfilename%
echo [ INFO ] Hash  : %tbhash%
if not "%tbwin%"=="Win10_1803_" echo [ INFO ] Size  : %tbsize% GB
call :Footer
if defined tbhash "%aria2c%" -x16 -s16 -d"%cd%" -o"%tbfilename%" --checksum=sha-1=%tbhash% "%tblink%" -R -c --file-allocation=none --check-certificate=false
if not defined tbhash "%aria2c%" -x16 -s16 -d"%cd%" -o"%tbfilename%" "%tblink%" -R -c --file-allocation=none --check-certificate=false
if not !errorlevel!==0 (
	call :Footer
	files\ISO\busybox echo -e "\033[31;1m[ WARN ] Something went wrong!\033[0m"
	call :Footer
	pause
	goto:TBISODownload
)
call :Footer
pause
goto:TBISODownload
:================================================================================================================
::===============================================================================================================
:: SVF/ISO CREATION
:SVFISOCreate
pushd %~dp0
::===============================================================================================================
cls
call :MenuHeader "[HEADER] SVF/ISO CREATION"
echo      [S] CREATE SVF
echo:
echo      [I] CREATE ISO
echo:
call :Footer
echo      [B] BACK
call :Footer
CHOICE /C SIB /N /M "[ USER ] YOUR CHOICE ?:"
if %errorlevel%==1 goto:CreateSVF
if %errorlevel%==2 goto:CreateISO
if %errorlevel%==3 goto:SVFISOMainMenu
goto:SVFISOCreate
::===============================================================================================================
:CreateSVF
cls
call :Header "[HEADER] SVF CREATION"
echo Enter Source ISO name ^(no extension^)
echo Default: %siname%
call :Footer
set /p siname=Source ISO name ^>
call :Footer
echo Enter Target ISO name ^(no extension^)
echo Default: %tname%
call :Footer
set /p tname=Target ISO name ^>
call :Footer
cls
call :Header "[HEADER] SVF CREATION"
echo [ INFO ] Source: %siname%
echo [  TO  ]
echo [ INFO ] Target: %tname%
call :Footer
CHOICE /C SB /N /M "[ USER ] [S]tart or [B]ack ?:"
if %errorlevel%==2 goto:SVFISOCreate
call :Footer
xcopy "%smv%" /s ".\" /Q /Y >nul 2>&1
smv BuildPatch "%tname%" "%siname%.iso" "%tname%.iso" -nbhashbits 24 -compressratio 49 -sha1 -sha25
if exist "smv.exe" del /f /q "smv.exe" >nul 2>&1
call :Footer
pause
goto:SVFISOCreate
::===============================================================================================================
:CreateISO
cls
call :Header "[HEADER] ISO CREATION"
echo Enter SVF name ^(no extension^)
echo Default: %sname%
call :Footer
set /p sname=SVF name ^>
call :Footer
cls
call :Header "[HEADER] ISO CREATION"
echo [ INFO ] Target: %sname%
call :Footer
CHOICE /C SB /N /M "[ USER ] [S]tart or [B]ack ?:"
if %errorlevel%==2 goto:SVFISOCreate
call :Footer
xcopy "%smv%" /s ".\" /Q /Y >nul 2>&1
smv x %sname%.svf -br .
if exist "smv.exe" del /f /q "smv.exe" >nul 2>&1
call :Footer
pause
goto:SVFISOCreate
:================================================================================================================
::===============================================================================================================
::SOURCE ISO DOWNLOAD
:SourceISODownload
pushd %~dp0
::===============================================================================================================
cls
call :MenuHeader "[HEADER] SOURCE ISO DOWNLOAD"
echo      [1] 1803
echo:
echo      [2] 1709
echo:
echo      [3] LTSB 2016
echo:
echo      [4] LTSB 2015
echo:
echo      [5] SERVER 2016
call :Footer
echo      [B] BACK
call :Footer
CHOICE /C 12345B /N /M "[ USER ] YOUR CHOICE ?:"
if %errorlevel%==1 set "build=1803"
if %errorlevel%==2 set "build=1709"
if %errorlevel%==3 set "build=1607"
if %errorlevel%==4 set "build=LTSB15"
if %errorlevel%==5 set "build=Server2016"
if %errorlevel%==6 goto:SVFISOMainMenu
cls
call :Header "[HEADER] SOURCE ISO DOWNLOAD"
if "%build%"=="Server2016" goto:SourceServer2016
CHOICE /C 68 /N /M "[ USER ] x[6]4 or x[8]6 architecture ?:"
if %errorlevel%==1 set "arch=x64"
if %errorlevel%==2 set "arch=x86"
call :Footer
if "%build%"=="1803" if "%arch%"=="x86" (
	set "siname=17134.1.180410-1804.rs4_release_CLIENTENTERPRISEEVAL_OEMRET_x86FRE_en-us"
	set "sihash=ddb496534203cb98284e5484e0ad60af3c0efce7"
	set "silink=https://software-download.microsoft.com/download/pr/17134.1.180410-1804.rs4_release_CLIENTENTERPRISEEVAL_OEMRET_x86FRE_en-us.iso"
)
if "%build%"=="1803" if "%arch%"=="x64" (
	set "siname=17134.1.180410-1804.rs4_release_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us"
	set "sihash=a4ea45ec1282e85fc84af49acf7a8d649c31ac5c"
	set "silink=https://software-download.microsoft.com/download/pr/17134.1.180410-1804.rs4_release_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
)
if "%build%"=="1709" if "%arch%"=="x86" (
	set "siname=16299.15.170928-1534.rs3_release_CLIENTENTERPRISEEVAL_OEMRET_x86FRE_en-us"
	set "sihash=4a75747a47eb689497fe57d64cec375c7949aa97"
	set "silink=https://download.microsoft.com/download/6/5/D/65D18931-F626-4A35-AD5B-F5DA41FE6B76/16299.15.170928-1534.rs3_release_CLIENTENTERPRISEEVAL_OEMRET_x86FRE_en-us.iso"
)
if "%build%"=="1709" if "%arch%"=="x64" (
	set "siname=16299.15.170928-1534.rs3_release_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us"
	set "sihash=3b5f9494d870726d6d8a833aaf6169a964b8a9be"
	set "silink=https://download.microsoft.com/download/6/5/D/65D18931-F626-4A35-AD5B-F5DA41FE6B76/16299.15.170928-1534.rs3_release_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
)
if "%build%"=="1607" if "%arch%"=="x86" (
	set "siname=14393.0.160715-1616.RS1_RELEASE_CLIENTENTERPRISE_S_EVAL_X86FRE_EN-US"
	set "sihash=fd65bfe31af5fd59d8537210cd829fe3e83feeb2"
	set "silink=http://download.microsoft.com/download/1/B/F/1BFE5194-5951-452C-B62C-B2F667F9B86D/14393.0.160715-1616.RS1_RELEASE_CLIENTENTERPRISE_S_EVAL_X86FRE_EN-US.ISO"
)
if "%build%"=="1607" if "%arch%"=="x64" (
	set "siname=14393.0.160715-1616.RS1_RELEASE_CLIENTENTERPRISE_S_EVAL_X64FRE_EN-US"
	set "sihash=ed6e357cba8d716a6187095e3abd016564670d5b"
	set "silink=http://download.microsoft.com/download/1/B/F/1BFE5194-5951-452C-B62C-B2F667F9B86D/14393.0.160715-1616.RS1_RELEASE_CLIENTENTERPRISE_S_EVAL_X64FRE_EN-US.ISO"
)
if "%build%"=="LTSB15" if "%arch%"=="x86" (
	set "siname=10240.16384.150709-1700.TH1_CLIENTENTERPRISE_S_EVAL_X86FRE_EN-US"
	set "sihash=aa8ce9cc9b660b31245622e49e0d183db355558f"
	set "silink=https://download.microsoft.com/download/6/2/4/624ECF83-38A6-4D64-8758-FABC099503DC/10240.16384.150709-1700.TH1_CLIENTENTERPRISE_S_EVAL_X86FRE_EN-US.ISO"
)
if "%build%"=="LTSB15" if "%arch%"=="x64" (
	set "siname=10240.16384.150709-1700.TH1_CLIENTENTERPRISE_S_EVAL_X64FRE_EN-US"
	set "sihash=90e1c5bada5b96ab05a9fe2035cb26f5cb3cd4d2"
	set "silink=https://download.microsoft.com/download/6/2/4/624ECF83-38A6-4D64-8758-FABC099503DC/10240.16384.150709-1700.TH1_CLIENTENTERPRISE_S_EVAL_X64FRE_EN-US.ISO"
)
:SourceServer2016
if "%build%"=="Server2016" (
	set "siname=14393.0.161119-1705.RS1_REFRESH_SERVER_EVAL_X64FRE_EN-US"
	set "sihash=772700802951b36c8cb26a61c040b9a8dc3816a3"
	set "silink=https://download.microsoft.com/download/1/4/9/149D5452-9B29-4274-B6B3-5361DBDA30BC/14393.0.161119-1705.RS1_REFRESH_SERVER_EVAL_X64FRE_EN-US.ISO"
)
cls
call :Header "[HEADER] SOURCE ISO DOWNLOAD"
echo [ INFO ] Source: %siname%
echo [ INFO ] Hash  : %sihash%
call :Footer
CHOICE /C SB /N /M "[ USER ] [S]tart or [B]ack ?:"
if %errorlevel%==2 goto:SourceISODownload
call :Footer
echo [ INFO ] Downloading.
call :Footer
"%aria2c%" -x16 -s16 -d"%cd%" -o"%siname%.iso" --checksum=sha-1=%sihash% "%silink%" -R -c --file-allocation=none --check-certificate=false
call :Footer
pause
goto:SourceISODownload
::===============================================================================================================
:================================================================================================================
::===============================================================================================================
::===============================================================================================================
:================================================================================================================
::===============================================================================================================
::EXIT
:EXIT
ENDLOCAL
exit
:================================================================================================================
::===============================================================================================================
::TITLE
:TITLE
title s1ave77s  S-M-R-T SVF ISO CONVERTER  v0.09.08
goto:eof
::===============================================================================================================
::VERSION
:VERSION
set "svfisoconverter=v0.09.08"
goto:eof
:================================================================================================================
::===============================================================================================================
::MENU HEADER
:MenuHeader
call :Graphics
echo:%~1
call :Graphics
goto:eof
:================================================================================================================
::===============================================================================================================
:: HEADER
:Header
call :Graphics
echo:%~1
call :Graphics
echo:
goto:eof
:================================================================================================================
::===============================================================================================================
::MENU FOOTER
:MenuFooter
call :Graphics
goto:eof
:================================================================================================================
::===============================================================================================================
:: FOOTER
:Footer
echo:
call :Graphics
echo:
goto:eof
:================================================================================================================
::===============================================================================================================
:: GRAPHICS
:Graphics
if %cw% geq 150 echo.
if %cw% geq 145 if %cw% lss 150 echo.
if %cw% geq 140 if %cw% lss 145 echo.
if %cw% geq 135 if %cw% lss 140 echo.
if %cw% geq 130 if %cw% lss 135 echo.
if %cw% geq 125 if %cw% lss 130 echo.
if %cw% geq 120 if %cw% lss 125 echo.
if %cw% geq 115 if %cw% lss 120 echo.
if %cw% geq 110 if %cw% lss 115 echo.
if %cw% geq 105 if %cw% lss 110 echo.
if %cw% geq 100 if %cw% lss 105 echo.
if %cw% geq 95 if %cw% lss 100 echo.
if %cw% geq 90 if %cw% lss 95 echo.
if %cw% geq 85 if %cw% lss 90 echo.
if %cw% geq 80 if %cw% lss 85 echo.
if %cw% lss 80 echo.
goto:eof
:================================================================================================================
::===============================================================================================================
:: ARIA SCRIPT
:AriaWrite
>> "aria.txt" (
	echo %~1
	echo 	out=%~2
	echo 	checksum=sha-1=%~3
	echo:
)
goto:eof
:================================================================================================================
::===============================================================================================================
:: LANGUAGE CHOICE NON-N
:LangChoice
echo Enter chosen language Number.
echo:
echo Available:
echo:
echo [01] ar-sa = Arabic [Saudi Arabia]
echo [02] bg-bg = Bulgarian [Bulgaria]
echo [03] cs-cz = Czech [Czech Republic]
echo [04] da-dk = Danish [Denmark]
echo [05] de-de = German [Germany]
echo [06] el-gr = Greek [Greece]
echo [07] en-gb = English [United Kingdom]
echo [08] en-us = English [United States]
echo [09] es-es = Spanish [Spain]
echo [10] es-mx = Spanish [Mexico]
echo [11] et-ee = Estonian [Estonia]
echo [12] fi-fi = Finnish [Finland]
echo [13] fr-ca = French [Canada]
echo [14] fr-fr = French [France]
echo [15] he-il = Hebrew [Israel]
echo [16] hr-hr = Croatian [Croatia]
echo [17] hu-hu = Hungarian [Hungary]
echo [18] it-it = Italian [Italy]
echo [19] ja-jp = Japanese [Japan]
echo [20] ko-kr = Korean [Korea]
echo [21] lt-lt = Lithuanian [Lithuania]
echo [22] lv-lv = Latvian [Latvia]
echo [23] nb-no = Norwegian [Norway]
echo [24] nl-nl = Dutch [Netherlands]
echo [25] pl-pl = Polish [Poland]
echo [26] pt-br = Portuguese [Brazil]
echo [27] pt-pt = Portuguese [Portugal]
echo [28] ro-ro = Romanian [Romania]
echo [29] ru-ru = Russian [Russia]
echo [30] sr-latn-rs = Serbian [Serbia]
echo [31] sk-sk = Slovak [Slovakia]
echo [32] sl-si = Slovenian [Slovenia]
echo [33] sv-se = Swedish [Sweden]
echo [34] th-th = Thai [Thailand]
echo [35] tr-tr = Turkish [Turkey]
echo [36] uk-ua = Ukrainian [Ukraine]
echo [37] zh-cn = Chinese [PRC]
echo [38] zh-tw = Chinese [Taiwan]
call :Footer
CHOICE /C 0123 /N /M "[ USER ] Enter Digit One:"
if %errorlevel%==1 set "number=0"
if %errorlevel%==2 set "number=10"
if %errorlevel%==3 set "number=20"
if %errorlevel%==4 set "number=30"
call :Footer
CHOICE /C 1234567890 /N /M "[ USER ] Enter Digit Two:"
if %errorlevel%==1 set /a number+=1
if %errorlevel%==2 set /a number+=2
if %errorlevel%==3 set /a number+=3
if %errorlevel%==4 set /a number+=4
if %errorlevel%==5 set /a number+=5
if %errorlevel%==6 set /a number+=6
if %errorlevel%==7 set /a number+=7
if %errorlevel%==8 set /a number+=8
if %errorlevel%==9 set /a number+=9
if %errorlevel%==10 set /a number+=0
if %number%==1 set "lang=ar-sa"
if %number%==2 set "lang=bg-bg"
if %number%==3 set "lang=cs-cz"
if %number%==4 set "lang=da-dk"
if %number%==5 set "lang=de-de"
if %number%==6 set "lang=el-gr"
if %number%==7 set "lang=en-gb"
if %number%==8 set "lang=en-us"
if %number%==9 set "lang=es-es"
if %number%==10 set "lang=es-mx"
if %number%==11 set "lang=et-ee"
if %number%==12 set "lang=fi-fi"
if %number%==13 set "lang=fr-ca"
if %number%==14 set "lang=fr-fr"
if %number%==15 set "lang=he-il"
if %number%==16 set "lang=hr-hr"
if %number%==17 set "lang=hu-hu"
if %number%==18 set "lang=it-it"
if %number%==19 set "lang=ja-jp"
if %number%==20 set "lang=ko-kr"
if %number%==21 set "lang=lt-lt"
if %number%==22 set "lang=lv-lv"
if %number%==23 set "lang=nb-no"
if %number%==24 set "lang=nl-nl"
if %number%==25 set "lang=pl-pl"
if %number%==26 set "lang=pt-br"
if %number%==27 set "lang=pt-pt"
if %number%==28 set "lang=ro-ro"
if %number%==29 set "lang=ru-ru"
if %number%==30 set "lang=sr-latn-rs"
if %number%==31 set "lang=sk-sk"
if %number%==32 set "lang=sl-si"
if %number%==33 set "lang=sv-se"
if %number%==34 set "lang=th-th"
if %number%==35 set "lang=tr-tr"
if %number%==36 set "lang=uk-ua"
if %number%==37 set "lang=zh-cn"
if %number%==38 set "lang=zh-tw"
goto:eof
:================================================================================================================
::===============================================================================================================
:: LANGUAGE CHOICE TECHBENCH 10
:LangChoiceTB
echo Enter chosen language Number.
echo:
echo Available:
echo:
echo [01] ar-sa = Arabic [Saudi Arabia]
echo [02] bg-bg = Bulgarian [Bulgaria]
echo [03] cs-cz = Czech [Czech Republic]
echo [04] da-dk = Danish [Denmark]
echo [05] de-de = German [Germany]
echo [06] el-gr = Greek [Greece]
echo [07] en-gb = English [United Kingdom]
echo [08] en-us = English [United States]
echo [09] es-es = Spanish [Spain]
echo [10] es-mx = Spanish [Mexico]
echo [11] et-ee = Estonian [Estonia]
echo [12] fi-fi = Finnish [Finland]
echo [13] fr-ca = French [Canada]
echo [14] fr-fr = French [France]
echo [15] he-il = Hebrew [Israel]
echo [16] hr-hr = Croatian [Croatia]
echo [17] hu-hu = Hungarian [Hungary]
echo [18] it-it = Italian [Italy]
echo [19] ja-jp = Japanese [Japan]
echo [20] ko-kr = Korean [Korea]
echo [21] lt-lt = Lithuanian [Lithuania]
echo [22] lv-lv = Latvian [Latvia]
echo [23] nb-no = Norwegian [Norway]
echo [24] nl-nl = Dutch [Netherlands]
echo [25] pl-pl = Polish [Poland]
echo [26] pt-br = Portuguese [Brazil]
echo [27] pt-pt = Portuguese [Portugal]
echo [28] ro-ro = Romanian [Romania]
echo [29] ru-ru = Russian [Russia]
echo [30] sr-latn-rs = Serbian [Serbia]
echo [31] sk-sk = Slovak [Slovakia]
echo [32] sl-si = Slovenian [Slovenia]
echo [33] sv-se = Swedish [Sweden]
echo [34] th-th = Thai [Thailand]
echo [35] tr-tr = Turkish [Turkey]
echo [36] uk-ua = Ukrainian [Ukraine]
echo [37] zh-cn = Chinese [PRC]
echo [38] zh-tw = Chinese [Taiwan]
call :Footer
CHOICE /C 0123 /N /M "[ USER ] Enter Digit One:"
if %errorlevel%==1 set "number=0"
if %errorlevel%==2 set "number=10"
if %errorlevel%==3 set "number=20"
if %errorlevel%==4 set "number=30"
call :Footer
CHOICE /C 1234567890 /N /M "[ USER ] Enter Digit Two:"
if %errorlevel%==1 set /a number+=1
if %errorlevel%==2 set /a number+=2
if %errorlevel%==3 set /a number+=3
if %errorlevel%==4 set /a number+=4
if %errorlevel%==5 set /a number+=5
if %errorlevel%==6 set /a number+=6
if %errorlevel%==7 set /a number+=7
if %errorlevel%==8 set /a number+=8
if %errorlevel%==9 set /a number+=9
if %errorlevel%==10 set /a number+=0
if %number%==1 set "tblang=Arabic"
if %number%==2 set "tblang=Bulgarian"
if %number%==3 set "tblang=Czech"
if %number%==4 set "tblang=Danish"
if %number%==5 set "tblang=German"
if %number%==6 set "tblang=Greek"
if %number%==7 set "tblang=EnglishInternational"
if %number%==8 set "tblang=English"
if %number%==9 set "tblang=Spanish"
if %number%==10 set "tblang=Spanish(Mexico)"
if %number%==11 set "tblang=Estonian"
if %number%==12 set "tblang=Finnish"
if %number%==13 set "tblang=FrenchCanadian"
if %number%==14 set "tblang=French"
if %number%==15 set "tblang=Hebrew"
if %number%==16 set "tblang=Croatian"
if %number%==17 set "tblang=Hungarian"
if %number%==18 set "tblang=Italian"
if %number%==19 set "tblang=Japanese"
if %number%==20 set "tblang=Korean"
if %number%==21 set "tblang=Lithuanian"
if %number%==22 set "tblang=Latvian"
if %number%==23 set "tblang=Norwegian"
if %number%==24 set "tblang=Dutch"
if %number%==25 set "tblang=Polish"
if %number%==26 set "tblang=BrazilianPortuguese"
if %number%==27 set "tblang=Portuguese"
if %number%==28 set "tblang=Romanian"
if %number%==29 set "tblang=Russian"
if %number%==30 set "tblang=SerbianLatin"
if %number%==31 set "tblang=Slovak"
if %number%==32 set "tblang=Slovenian"
if %number%==33 set "tblang=Swedish"
if %number%==34 set "tblang=Thai"
if %number%==35 set "tblang=Turkish"
if %number%==36 set "tblang=Ukrainian"
if %number%==37 set "tblang=Chinese(Simplified)"
if %number%==38 set "tblang=Chinese(Traditional)"
goto:eof
:================================================================================================================
::===============================================================================================================
:: LANGUAGE CHOICE TB 8.1
:LangChoice81
echo Enter chosen language Number.
echo:
echo Available:
echo:
echo [01] ar-sa = Arabic [Saudi Arabia]
echo [02] bg-bg = Bulgarian [Bulgaria]
echo [03] cs-cz = Czech [Czech Republic]
echo [04] da-dk = Danish [Denmark]
echo [05] de-de = German [Germany]
echo [06] el-gr = Greek [Greece]
echo [07] en-gb = English [United Kingdom]
echo [08] en-us = English [United States]
echo [09] es-es = Spanish [Spain]
echo [10] et-ee = Estonian [Estonia]
echo [11] fi-fi = Finnish [Finland]
echo [12] fr-fr = French [France]
echo [13] he-il = Hebrew [Israel]
echo [14] hr-hr = Croatian [Croatia]
echo [15] hu-hu = Hungarian [Hungary]
echo [16] it-it = Italian [Italy]
echo [17] ja-jp = Japanese [Japan]
echo [18] ko-kr = Korean [Korea]
echo [19] lt-lt = Lithuanian [Lithuania]
echo [20] lv-lv = Latvian [Latvia]
echo [21] nb-no = Norwegian [Norway]
echo [22] nl-nl = Dutch [Netherlands]
echo [23] pl-pl = Polish [Poland]
echo [24] pt-br = Portuguese [Brazil]
echo [25] pt-pt = Portuguese [Portugal]
echo [26] ro-ro = Romanian [Romania]
echo [27] ru-ru = Russian [Russia]
echo [28] sr-latn-rs = Serbian [Serbia]
echo [29] sk-sk = Slovak [Slovakia]
echo [30] sl-si = Slovenian [Slovenia]
echo [31] sv-se = Swedish [Sweden]
echo [32] th-th = Thai [Thailand]
echo [33] tr-tr = Turkish [Turkey]
echo [34] uk-ua = Ukrainian [Ukraine]
echo [35] zh-cn = Chinese [PRC]
echo [36] zh-tw = Chinese [Taiwan]
echo [37] zh-hk = Chinese [Hong Kong]
call :Footer
CHOICE /C 0123 /N /M "[ USER ] Enter Digit One:"
if %errorlevel%==1 set "number=0"
if %errorlevel%==2 set "number=10"
if %errorlevel%==3 set "number=20"
if %errorlevel%==4 set "number=30"
call :Footer
CHOICE /C 1234567890 /N /M "[ USER ] Enter Digit Two:"
if %errorlevel%==1 set /a number+=1
if %errorlevel%==2 set /a number+=2
if %errorlevel%==3 set /a number+=3
if %errorlevel%==4 set /a number+=4
if %errorlevel%==5 set /a number+=5
if %errorlevel%==6 set /a number+=6
if %errorlevel%==7 set /a number+=7
if %errorlevel%==8 set /a number+=8
if %errorlevel%==9 set /a number+=9
if %errorlevel%==10 set /a number+=0
if %number%==1 set "tblang=Arabic"
if %number%==2 set "tblang=Bulgarian"
if %number%==3 set "tblang=Czech"
if %number%==4 set "tblang=Danish"
if %number%==5 set "tblang=German"
if %number%==6 set "tblang=Greek"
if %number%==7 set "tblang=EnglishInternational"
if %number%==8 set "tblang=English"
if %number%==9 set "tblang=Spanish"
if %number%==10 set "tblang=Estonian"
if %number%==11 set "tblang=Finnish"
if %number%==12 set "tblang=French"
if %number%==13 set "tblang=Hebrew"
if %number%==14 set "tblang=Croatian"
if %number%==15 set "tblang=Hungarian"
if %number%==16 set "tblang=Italian"
if %number%==17 set "tblang=Japanese"
if %number%==18 set "tblang=Korean"
if %number%==19 set "tblang=Lithuanian"
if %number%==20 set "tblang=Latvian"
if %number%==21 set "tblang=Norwegian"
if %number%==22 set "tblang=Dutch"
if %number%==23 set "tblang=Polish"
if %number%==24 set "tblang=BrazilianPortuguese"
if %number%==25 set "tblang=Portuguese"
if %number%==26 set "tblang=Romanian"
if %number%==27 set "tblang=Russian"
if %number%==28 set "tblang=SerbianLatin"
if %number%==29 set "tblang=Slovak"
if %number%==30 set "tblang=Slovenian"
if %number%==31 set "tblang=Swedish"
if %number%==32 set "tblang=Thai"
if %number%==33 set "tblang=Turkish"
if %number%==34 set "tblang=Ukrainian"
if %number%==35 set "tblang=Chinese(Simplified)"
if %number%==36 set "tblang=Chinese(Traditional)"
if %number%==37 set "tblang=Chinese(TraditionalHongKong)"
goto:eof
:================================================================================================================
::===============================================================================================================
:: LANGUAGE CHOICE TB 8.1 N
:LangChoice81N
echo Enter chosen language Number.
echo:
echo Available:
echo:
echo [01] bg-bg = Bulgarian [Bulgaria]
echo [02] cs-cz = Czech [Czech Republic]
echo [03] da-dk = Danish [Denmark]
echo [04] de-de = German [Germany]
echo [05] el-gr = Greek [Greece]
echo [06] en-gb = English [United Kingdom]
echo [07] en-us = English [United States]
echo [08] es-es = Spanish [Spain]
echo [09] et-ee = Estonian [Estonia]
echo [10] fi-fi = Finnish [Finland]
echo [11] fr-fr = French [France]
echo [12] hr-hr = Croatian [Croatia]
echo [13] hu-hu = Hungarian [Hungary]
echo [14] it-it = Italian [Italy]
echo [15] ko-kr = Korean [Korea]
echo [16] lt-lt = Lithuanian [Lithuania]
echo [17] lv-lv = Latvian [Latvia]
echo [18] nb-no = Norwegian [Norway]
echo [19] nl-nl = Dutch [Netherlands]
echo [20] pl-pl = Polish [Poland]
echo [21] pt-pt = Portuguese [Portugal]
echo [22] ro-ro = Romanian [Romania]
echo [23] sk-sk = Slovak [Slovakia]
echo [24] sl-si = Slovenian [Slovenia]
echo [25] sv-se = Swedish [Sweden]
call :Footer
CHOICE /C 012 /N /M "[ USER ] Enter Digit One:"
if %errorlevel%==1 set "number=0"
if %errorlevel%==2 set "number=10"
if %errorlevel%==3 set "number=20"
call :Footer
CHOICE /C 1234567890 /N /M "[ USER ] Enter Digit Two:"
if %errorlevel%==1 set /a number+=1
if %errorlevel%==2 set /a number+=2
if %errorlevel%==3 set /a number+=3
if %errorlevel%==4 set /a number+=4
if %errorlevel%==5 set /a number+=5
if %errorlevel%==6 set /a number+=6
if %errorlevel%==7 set /a number+=7
if %errorlevel%==8 set /a number+=8
if %errorlevel%==9 set /a number+=9
if %errorlevel%==10 set /a number+=0
if %number%==1 set "tblang=Bulgarian"
if %number%==2 set "tblang=Czech"
if %number%==3 set "tblang=Danish"
if %number%==4 set "tblang=German"
if %number%==5 set "tblang=Greek"
if %number%==6 set "tblang=EnglishInternational"
if %number%==7 set "tblang=English"
if %number%==8 set "tblang=Spanish"
if %number%==9 set "tblang=Estonian"
if %number%==10 set "tblang=Finnish"
if %number%==11 set "tblang=French"
if %number%==12 set "tblang=Croatian"
if %number%==13 set "tblang=Hungarian"
if %number%==14 set "tblang=Italian"
if %number%==15 set "tblang=Korean"
if %number%==16 set "tblang=Lithuanian"
if %number%==17 set "tblang=Latvian"
if %number%==18 set "tblang=Norwegian"
if %number%==19 set "tblang=Dutch"
if %number%==20 set "tblang=Polish"
if %number%==21 set "tblang=Portuguese"
if %number%==22 set "tblang=Romanian"
if %number%==23 set "tblang=Slovak"
if %number%==24 set "tblang=Slovenian"
if %number%==25 set "tblang=Swedish"
goto:eof
:================================================================================================================
::===============================================================================================================
:: LANGUAGE CHOICE SERVER 2016
:LangChoiceS
echo Enter chosen language Number.
echo:
echo Available:
echo:
echo [01] cs-cz = Czech [Czech Republic]
echo [02] de-de = German [Germany]
echo [03] en-us = English [United States]
echo [04] es-es = Spanish [Spain]
echo [05] fr-fr = French [France]
echo [06] hu-hu = Hungarian [Hungary]
echo [07] it-it = Italian [Italy]
echo [08] ja-jp = Japanese [Japan]
echo [09] ko-kr = Korean [Korea]
echo [10] nl-nl = Dutch [Netherlands]
echo [11] pl-pl = Polish [Poland]
echo [12] pt-br = Portuguese [Brazil]
echo [13] pt-pt = Portuguese [Portugal]
echo [14] ru-ru = Russian [Russia]
echo [15] sv-se = Swedish [Sweden]
echo [16] tr-tr = Turkish [Turkey]
echo [17] zh-cn = Chinese [PRC]
echo [18] zh-tw = Chinese [Taiwan]
call :Footer
CHOICE /C 01 /N /M "[ USER ] Enter Digit One:"
if %errorlevel%==1 set "number=0"
if %errorlevel%==2 set "number=10"
call :Footer
CHOICE /C 1234567890 /N /M "[ USER ] Enter Digit Two:"
if %errorlevel%==1 set /a number+=1
if %errorlevel%==2 set /a number+=2
if %errorlevel%==3 set /a number+=3
if %errorlevel%==4 set /a number+=4
if %errorlevel%==5 set /a number+=5
if %errorlevel%==6 set /a number+=6
if %errorlevel%==7 set /a number+=7
if %errorlevel%==8 set /a number+=8
if %errorlevel%==9 set /a number+=9
if %errorlevel%==10 set /a number+=0
if %number%==1 set "lang=cs-cz"
if %number%==2 set "lang=de-de"
if %number%==3 set "lang=en-us"
if %number%==4 set "lang=es-es"
if %number%==5 set "lang=fr-fr"
if %number%==6 set "lang=hu-hu"
if %number%==7 set "lang=it-it"
if %number%==8 set "lang=ja-jp"
if %number%==9 set "lang=ko-kr"
if %number%==10 set "lang=nl-nl"
if %number%==11 set "lang=pl-pl"
if %number%==12 set "lang=pt-br"
if %number%==13 set "lang=pt-pt"
if %number%==14 set "lang=ru-ru"
if %number%==15 set "lang=sv-se"
if %number%==16 set "lang=tr-tr"
if %number%==17 set "lang=zh-cn"
if %number%==18 set "lang=zh-tw"
goto:eof
:================================================================================================================
::===============================================================================================================
:: LANGUAGE CHOICE N
:LangChoiceN
echo Enter chosen language Number.
echo:
echo Available:
echo:
echo [01] bg-bg = Bulgarian [Bulgaria]
echo [02] cs-cz = Czech [Czech Republic]
echo [03] da-dk = Danish [Denmark]
echo [04] de-de = German [Germany]
echo [05] el-gr = Greek [Greece]
echo [06] en-gb = English [United Kingdom]
echo [07] en-us = English [United States]
echo [08] es-es = Spanish [Spain]
echo [09] et-ee = Estonian [Estonia]
echo [10] fi-fi = Finnish [Finland]
echo [11] fr-fr = French [France]
echo [12] hr-hr = Croatian [Croatia]
echo [13] hu-hu = Hungarian [Hungary]
echo [14] it-it = Italian [Italy]
echo [15] lt-lt = Lithuanian [Lithuania]
echo [16] lv-lv = Latvian [Latvia]
echo [17] nb-no = Norwegian [Norway]
echo [18] nl-nl = Dutch [Netherlands]
echo [19] pl-pl = Polish [Poland]
echo [20] pt-pt = Portuguese [Portugal]
echo [21] ro-ro = Romanian [Romania]
echo [22] sk-sk = Slovak [Slovakia]
echo [23] sl-si = Slovenian [Slovenia]
echo [24] sv-se = Swedish [Sweden]
call :Footer
CHOICE /C 012 /N /M "[ USER ] Enter Digit One:"
if %errorlevel%==1 set "number=0"
if %errorlevel%==2 set "number=10"
if %errorlevel%==3 set "number=20"
call :Footer
CHOICE /C 1234567890 /N /M "[ USER ] Enter Digit Two:"
if %errorlevel%==1 set /a number+=1
if %errorlevel%==2 set /a number+=2
if %errorlevel%==3 set /a number+=3
if %errorlevel%==4 set /a number+=4
if %errorlevel%==5 set /a number+=5
if %errorlevel%==6 set /a number+=6
if %errorlevel%==7 set /a number+=7
if %errorlevel%==8 set /a number+=8
if %errorlevel%==9 set /a number+=9
if %errorlevel%==10 set /a number+=0
if %number%==1 set "lang=bg-bg"
if %number%==2 set "lang=cs-cz"
if %number%==3 set "lang=da-dk"
if %number%==4 set "lang=de-de"
if %number%==5 set "lang=el-gr"
if %number%==6 set "lang=en-gb"
if %number%==7 set "lang=en-us"
if %number%==8 set "lang=es-es"
if %number%==9 set "lang=et-ee"
if %number%==10 set "lang=fi-fi"
if %number%==11 set "lang=fr-fr"
if %number%==12 set "lang=hr-hr"
if %number%==13 set "lang=hu-hu"
if %number%==14 set "lang=it-it"
if %number%==15 set "lang=lt-lt"
if %number%==16 set "lang=lv-lv"
if %number%==17 set "lang=nb-no"
if %number%==18 set "lang=nl-nl"
if %number%==19 set "lang=pl-pl"
if %number%==20 set "lang=pt-pt"
if %number%==21 set "lang=ro-ro"
if %number%==22 set "lang=sk-sk"
if %number%==23 set "lang=sl-si"
if %number%==24 set "lang=sv-se"
goto:eof
:================================================================================================================
::===============================================================================================================
:SpaceTest
	echo:
	echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	echo:
    echo Current directory contains spaces in its path.
	echo:
    echo Please move or rename the directory to one not containing spaces.
	echo:
	echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	echo:
    pause
goto:eof
