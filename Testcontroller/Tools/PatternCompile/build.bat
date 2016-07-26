@if exist %1 del %1
@sbc.exe -vertsc=%2 -gs -attach=FakeAV_configure.ini;GENSRULE.ini;Proactive.ini
@if not exist sbptn.001 goto ERROR

pause
@AddHeader.pl %2

@authmd5.exe sbptn.001 %1

@if not exist %1 goto ERROR
@rem del sbptn.001 >nul

@echo Build %1 (pattern version %2) success!
@goto END

:ERROR
@echo Build tsc.ptn (pattern version %2) failed!

:END