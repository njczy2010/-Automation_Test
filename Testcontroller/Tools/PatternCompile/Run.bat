@echo Please make sure your settings in ProSetting.ini is OK.
@echo off

if {%1}=={} (
	echo Usage: Run.bat Version
	echo Example: Run.bat 1166
	goto END
)

cd /d %~d0%~p0
rem copy ..\Data\Proactive_original.ini .\

rem call GetPatternSource.bat

RuleEncrypter.exe

Tscconsoletest.exe TSCProactiveDCTTest

call buildVer.bat %1

REM copy tsc.ptn ..\Data\DCEBuilds\tsc.ptn

:END
